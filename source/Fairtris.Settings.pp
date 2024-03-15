
{
  Fairtris 2: The Ultimate Challenge
  Copyleft (ɔ) furious programming 2024. All rights reversed.

  https://github.com/furious-programming/fairtris-2-uc


  This is free and unencumbered software released into the public domain.

  Anyone is free to copy, modify, publish, use, compile, sell, or
  distribute this software, either in source code form or as a compiled
  binary, for any purpose, commercial or non-commercial, and by any means.

  For more information, see "LICENSE" or "license.txt" file, which should
  be included with this distribution. If not, check the repository.
}

unit Fairtris.Settings;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  IniFiles,
  Fairtris.Constants;


type
  TCustomSettings = class(TObject)
  protected
    function CorrectRange(AValue, AFirst, ALast, ADefault: Integer): Integer;
  end;


type
  TVideoSettings = class(TCustomSettings)
  private
    FEnabled: Boolean;
  private
    procedure Collect();
  public
    procedure Load(AFile: TIniFile; const ASection: String);
    procedure Save(AFile: TIniFile; const ASection: String);
  public
    property Enabled: Boolean read FEnabled;
  end;


type
  TGeneralSettings = class(TCustomSettings)
  private
    FMonitor:   Integer;
    FLeft:      Integer;
    FTop:       Integer;
    FInput:     Integer;
    FShiftNTSC: Integer;
    FShiftPAL:  Integer;
    FSize:      Integer;
    FSounds:    Integer;
    FRegion:    Integer;
    FGenerator: Integer;
    FLevel:     Integer;
  private
    function CorrectMonitor(AValue: Integer): Integer;
    function CorrectLeft(AValue: Integer): Integer;
    function CorrectTop(AValue: Integer): Integer;
    function CorrectLevel(AValue: Integer): Integer;
  private
    function DetermineMonitor(): Integer;
  private
    procedure Correct();
    procedure Collect();
  public
    procedure Load(AFile: TIniFile; const ASection: String);
    procedure Save(AFile: TIniFile; const ASection: String);
  public
    property Monitor:   Integer read FMonitor;
    property Left:      Integer read FLeft;
    property Top:       Integer read FTop;
    property Input:     Integer read FInput;
    property ShiftNTSC: Integer read FShiftNTSC;
    property ShiftPAL:  Integer read FShiftPAL;
    property Size:      Integer read FSize;
    property Sounds:    Integer read FSounds;
    property Region:    Integer read FRegion;
    property Generator: Integer read FGenerator;
    property Level:     Integer read FLevel;
  end;


type
  TMappingSettings = class(TCustomSettings)
  private
    FDeviceID: Integer;
  private
    procedure Collect();
  public
    constructor Create(ADeviceID: Integer);
  public
    procedure Load(AFile: TIniFile; const ASection: String); virtual; abstract;
    procedure Save(AFile: TIniFile; const ASection: String);
  public
    ScanCodes: array [TRIGGER_DEVICE_FIRST .. TRIGGER_DEVICE_LAST] of UInt8;
  end;


type
  TKeyboardSettings = class(TMappingSettings)
  public
    procedure Load(AFile: TIniFile; const ASection: String); override;
  end;


type
  TControllerSettings = class(TMappingSettings)
  public
    procedure Load(AFile: TIniFile; const ASection: String); override;
  end;


type
  TSettings = class(TObject)
  private
    FSettingsFile: TMemIniFile;
  private
    FGeneral:    TGeneralSettings;
    FVideo:      TVideoSettings;
    FKeyboard:   TKeyboardSettings;
    FController: TControllerSettings;
  public
    constructor Create();
    destructor  Destroy(); override;
  public
    procedure Load();
    procedure Save();
  public
    property Video:      TVideoSettings      read FVideo;
    property General:    TGeneralSettings    read FGeneral;
    property Keyboard:   TKeyboardSettings   read FKeyboard;
    property Controller: TControllerSettings read FController;
  end;


var
  Settings: TSettings;


implementation

uses
  SDL2,
  Fairtris.Window,
  Fairtris.Input,
  Fairtris.Memory,
  Fairtris.Placement,
  Fairtris.Arrays;


function TCustomSettings.CorrectRange(AValue, AFirst, ALast, ADefault: Integer): Integer;
begin
  if (AValue >= AFirst) and (AValue <= ALast) then
    Result := AValue
  else
    Result := ADefault;
end;


procedure TVideoSettings.Collect();
begin
  FEnabled := Placement.VideoEnabled;
end;


procedure TVideoSettings.Load(AFile: TIniFile; const ASection: String);
begin
  FEnabled := AFile.ReadBool(ASection, SETTINGS_KEY_VIDEO_ENABLED, SETTINGS_VALUE_VIDEO_ENABLED);
end;


procedure TVideoSettings.Save(AFile: TIniFile; const ASection: String);
begin
  AFile.WriteBool(ASection, SETTINGS_KEY_VIDEO_ENABLED, FEnabled);
end;


function TGeneralSettings.CorrectMonitor(AValue: Integer): Integer;
begin
  Result := AValue;

  if (Result < 0) or (Result > SDL_GetNumVideoDisplays() - 1) then
    Result := MONITOR_DEFAULT;
end;


function TGeneralSettings.CorrectLeft(AValue: Integer): Integer;
var
  MonitorBounds: TSDL_Rect;
begin
  Result := AValue;

  if SDL_GetDisplayBounds(FMonitor, @MonitorBounds) = 0 then
  begin
    if Result < MonitorBounds.X then Exit(0);
    if Result > MonitorBounds.X + MonitorBounds.W - BUFFER_WIDTH then Exit(0);
  end
  else
    Result := 0;
end;


function TGeneralSettings.CorrectTop(AValue: Integer): Integer;
var
  MonitorBounds: TSDL_Rect;
begin
  Result := AValue;

  if SDL_GetDisplayBounds(FMonitor, @MonitorBounds) = 0 then
  begin
    if Result < MonitorBounds.Y then Exit(0);
    if Result > MonitorBounds.Y + MonitorBounds.H - BUFFER_HEIGHT then Exit(0);
  end
  else
    Result := 0;
end;


function TGeneralSettings.CorrectLevel(AValue: Integer): Integer;
begin
  if AValue < LEVEL_FIRST then Exit(LEVEL_FIRST);
  if AValue > LEVEL_LAST  then Exit(LEVEL_LAST);

  Result := AValue;
end;


function TGeneralSettings.DetermineMonitor(): Integer;
begin
  Result := SDL_GetWindowDisplayIndex(Window.Window);
end;


procedure TGeneralSettings.Correct();
begin
  FMonitor   := CorrectMonitor(FMonitor);
  FLeft      := CorrectLeft(FLeft);
  FTop       := CorrectTop(FTop);
  FInput     := CorrectRange(FInput,     INPUT_FIRST,      INPUT_LAST,      INPUT_DEFAULT);
  FShiftNTSC := CorrectRange(FShiftNTSC, SHIFT_NTSC_FIRST, SHIFT_NTSC_LAST, SHIFT_NTSC_DEFAULT);
  FShiftPAL  := CorrectRange(FShiftPAL,  SHIFT_PAL_FIRST,  SHIFT_PAL_LAST,  SHIFT_PAL_DEFAULT);
  FSize      := CorrectRange(FSize,      SIZE_FIRST,       SIZE_LAST,       SIZE_DEFAULT);
  FSounds    := CorrectRange(FSounds,    SOUNDS_FIRST,     SOUNDS_LAST,     SOUNDS_DEFAULT);
  FRegion    := CorrectRange(FRegion,    REGION_FIRST,     REGION_LAST,     REGION_DEFAULT);
  FGenerator := CorrectRange(FGenerator, GENERATOR_FIRST,  GENERATOR_LAST,  GENERATOR_DEFAULT);
  FLevel     := CorrectLevel(FLevel);
end;


procedure TGeneralSettings.Collect();
begin
  FMonitor   := DetermineMonitor();
  FSize      := Placement.WindowSize;
  FLeft      := Placement.WindowBounds.X;
  FTop       := Placement.WindowBounds.Y;
  FInput     := Memory.Options.Input;
  FShiftNTSC := Memory.Options.ShiftNTSC;
  FShiftPAL  := Memory.Options.ShiftPAL;
  FSounds    := Memory.Options.Sounds;
  FRegion    := Memory.Setup.Region;
  FGenerator := Memory.Setup.Generator;
  FLevel     := Memory.Setup.Level;
end;


procedure TGeneralSettings.Load(AFile: TIniFile; const ASection: String);
begin
  FMonitor   := AFile.ReadInteger(ASection, SETTINGS_KEY_GENERAL_MONITOR,    SETTINGS_VALUE_GENERAL_MONITOR);
  FLeft      := AFile.ReadInteger(ASection, SETTINGS_KEY_GENERAL_LEFT,       SETTINGS_VALUE_GENERAL_LEFT);
  FTop       := AFile.ReadInteger(ASection, SETTINGS_KEY_GENERAL_TOP,        SETTINGS_VALUE_GENERAL_TOP);
  FInput     := AFile.ReadInteger(ASection, SETTINGS_KEY_GENERAL_INPUT,      SETTINGS_VALUE_GENERAL_INPUT);
  FShiftNTSC := AFile.ReadInteger(ASection, SETTINGS_KEY_GENERAL_SHIFT_NTSC, SETTINGS_VALUE_GENERAL_SHIFT_NTSC);
  FShiftPAL  := AFile.ReadInteger(ASection, SETTINGS_KEY_GENERAL_SHIFT_PAL,  SETTINGS_VALUE_GENERAL_SHIFT_PAL);
  FSize      := AFile.ReadInteger(ASection, SETTINGS_KEY_GENERAL_SIZE,       SETTINGS_VALUE_GENERAL_SIZE);
  FSounds    := AFile.ReadInteger(ASection, SETTINGS_KEY_GENERAL_SOUNDS,     SETTINGS_VALUE_GENERAL_SOUNDS);
  FRegion    := AFile.ReadInteger(ASection, SETTINGS_KEY_GENERAL_REGION,     SETTINGS_VALUE_GENERAL_REGION);
  FGenerator := AFile.ReadInteger(ASection, SETTINGS_KEY_GENERAL_GENERATOR,  SETTINGS_VALUE_GENERAL_GENERATOR);
  FLevel     := AFile.ReadInteger(ASection, SETTINGS_KEY_GENERAL_LEVEL,      SETTINGS_VALUE_GENERAL_LEVEL);

  Correct();
end;


procedure TGeneralSettings.Save(AFile: TIniFile; const ASection: String);
begin
  AFile.WriteInteger(ASection, SETTINGS_KEY_GENERAL_MONITOR,    FMonitor);
  AFile.WriteInteger(ASection, SETTINGS_KEY_GENERAL_LEFT,       FLeft);
  AFile.WriteInteger(ASection, SETTINGS_KEY_GENERAL_TOP,        FTop);
  AFile.WriteInteger(ASection, SETTINGS_KEY_GENERAL_INPUT,      FInput);
  AFile.WriteInteger(ASection, SETTINGS_KEY_GENERAL_SHIFT_NTSC, FShiftNTSC);
  AFile.WriteInteger(ASection, SETTINGS_KEY_GENERAL_SHIFT_PAL,  FShiftPAL);
  AFile.WriteInteger(ASection, SETTINGS_KEY_GENERAL_SIZE,       FSize);
  AFile.WriteInteger(ASection, SETTINGS_KEY_GENERAL_SOUNDS,     FSounds);
  AFile.WriteInteger(ASection, SETTINGS_KEY_GENERAL_REGION,     FRegion);
  AFile.WriteInteger(ASection, SETTINGS_KEY_GENERAL_GENERATOR,  FGenerator);
  AFile.WriteInteger(ASection, SETTINGS_KEY_GENERAL_LEVEL,      FLevel);
end;


constructor TMappingSettings.Create(ADeviceID: Integer);
begin
  FDeviceID := ADeviceID;
end;


procedure TMappingSettings.Collect();
var
  Index: Integer;
begin
  for Index := TRIGGER_DEVICE_FIRST to TRIGGER_DEVICE_LAST do
    ScanCodes[Index] := Input[FDeviceID].ScanCode[Index];
end;


procedure TMappingSettings.Save(AFile: TIniFile; const ASection: String);
var
  Index: Integer;
begin
  for Index := TRIGGER_DEVICE_FIRST to TRIGGER_DEVICE_LAST do
    AFile.WriteInteger(ASection, SETTINGS_KEY_MAPPING[Index], ScanCodes[Index]);
end;


procedure TKeyboardSettings.Load(AFile: TIniFile; const ASection: String);
var
  Index:    Integer;
  ScanCode: Integer;
begin
  for Index := TRIGGER_KEYBOARD_KEY_FIRST to TRIGGER_KEYBOARD_KEY_LAST do
  begin
    ScanCode         := AFile.ReadInteger(ASection, SETTINGS_KEY_MAPPING[Index], KEYBOARD_SCANCODE_KEY_NOT_MAPPED);
    ScanCodes[Index] := CorrectRange(
      ScanCode,
      KEYBOARD_SCANCODE_KEY_FIRST,
      KEYBOARD_SCANCODE_KEY_LAST,
      KEYBOARD_SCANCODE_KEY_NOT_MAPPED
    );
  end;

  for Index := TRIGGER_KEYBOARD_KEY_FIRST to TRIGGER_KEYBOARD_KEY_LAST do
    if ScanCodes[Index] <> KEYBOARD_SCANCODE_KEY_NOT_MAPPED then
      Exit;

  for Index := TRIGGER_KEYBOARD_KEY_FIRST to TRIGGER_KEYBOARD_KEY_LAST do
    ScanCodes[Index] := MAPPING_DEFAULT_KEYBOARD[Index];
end;


procedure TControllerSettings.Load(AFile: TIniFile; const ASection: String);
var
  Index:    Integer;
  ScanCode: Integer;
begin
  for Index := TRIGGER_CONTROLLER_BUTTON_FIRST to TRIGGER_CONTROLLER_BUTTON_LAST do
  begin
    ScanCode         := AFile.ReadInteger(ASection, SETTINGS_KEY_MAPPING[Index], CONTROLLER_SCANCODE_BUTTON_NOT_MAPPED);
    ScanCodes[Index] := CorrectRange(
      ScanCode,
      CONTROLLER_SCANCODE_BUTTON_FIRST,
      CONTROLLER_SCANCODE_BUTTON_LAST,
      CONTROLLER_SCANCODE_BUTTON_NOT_MAPPED
    );
  end;

  for Index := TRIGGER_CONTROLLER_BUTTON_FIRST to TRIGGER_CONTROLLER_BUTTON_LAST do
    if ScanCodes[Index] <> CONTROLLER_SCANCODE_BUTTON_NOT_MAPPED then
      Exit;

  for Index := TRIGGER_CONTROLLER_BUTTON_FIRST to TRIGGER_CONTROLLER_BUTTON_LAST do
    ScanCodes[Index] := MAPPING_DEFAULT_CONTROLLER[Index];
end;


constructor TSettings.Create();
begin
  FSettingsFile := TMemIniFile.Create(SETTINGS_FILENAME);

  FVideo      := TVideoSettings.Create();
  FGeneral    := TGeneralSettings.Create();
  FKeyboard   := TKeyboardSettings.Create(INPUT_KEYBOARD);
  FController := TControllerSettings.Create(INPUT_CONTROLLER);
end;


destructor TSettings.Destroy();
begin
  FSettingsFile.Free();

  FVideo.Free();
  FGeneral.Free();
  FKeyboard.Free();
  FController.Free();

  inherited Destroy();
end;


procedure TSettings.Load();
begin
  FVideo.Load     (FSettingsFile, SETTINGS_SECTION_VIDEO);
  FGeneral.Load   (FSettingsFile, SETTINGS_SECTION_GENERAL);
  FKeyboard.Load  (FSettingsFile, SETTINGS_SECTION_KEYBOARD);
  FController.Load(FSettingsFile, SETTINGS_SECTION_CONTROLLER);
end;


procedure TSettings.Save();
begin
  FVideo.Collect();
  FGeneral.Collect();
  FKeyboard.Collect();
  FController.Collect();

  FVideo.Save     (FSettingsFile, SETTINGS_SECTION_VIDEO);
  FGeneral.Save   (FSettingsFile, SETTINGS_SECTION_GENERAL);
  FKeyboard.Save  (FSettingsFile, SETTINGS_SECTION_KEYBOARD);
  FController.Save(FSettingsFile, SETTINGS_SECTION_CONTROLLER);
end;


end.

