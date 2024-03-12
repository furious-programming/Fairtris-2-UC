
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

unit Fairtris.Keyboard;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  Fairtris.Interfaces,
  Fairtris.Classes,
  Fairtris.Constants;


type
  TDevice = class(TObject)
  private type
    TKeyboard = array [UInt8] of UInt8;
    PKeyboard = ^TKeyboard;
  private
    FKeyboard:  PKeyboard;
    FKeys:      array [UInt8] of TSwitch;
    FConnected: Boolean;
  private
    function GetKey(AKeyID: UInt8): TSwitch;
  public
    constructor Create();
    destructor  Destroy(); override;
  public
    procedure Reset();
    procedure Update();
  public
    procedure Validate();
    procedure Invalidate();
  public
    property Key[AKeyID: UInt8]: TSwitch read GetKey; default;
    property Connected: Boolean read FConnected;
  end;


type
  TKeyboard = class(TInterfacedObject, IControllable)
  private
    FDevice:           TDevice;
    FScanCodesDefault: array [TRIGGER_KEYBOARD_KEY_FIRST .. TRIGGER_KEYBOARD_KEY_LAST] of UInt8;
    FScanCodesCurrent: array [TRIGGER_KEYBOARD_KEY_FIRST .. TRIGGER_KEYBOARD_KEY_LAST] of UInt8;
  private
    procedure InitDevice();
    procedure InitScanCodesDefault();
    procedure InitScanCodesCurrent();
  private
    procedure DoneDevice();
  private
    function GetSwitch(AKeyID: Integer): TSwitch;
    function GetScanCode(AKeyID: Integer): UInt8;
    function GetConnected(): Boolean;
  public
    constructor Create();
    destructor  Destroy(); override;
  public
    procedure Initialize();
  public
    procedure Reset();
    procedure Update();
    procedure Restore();
    procedure Introduce();
  public
    procedure Validate();
    procedure Invalidate();
  public
    function CatchedOneKey(out AScanCode: UInt8): Boolean;
  public
    property Device:    TDevice read FDevice;
    property Connected: Boolean read GetConnected;
  public
    property Switch  [AKeyID: Integer]: TSwitch read GetSwitch;
    property ScanCode[AKeyID: Integer]: UInt8   read GetScanCode;
  public
    property Up:     TSwitch index TRIGGER_KEYBOARD_KEY_UP     read GetSwitch;
    property Down:   TSwitch index TRIGGER_KEYBOARD_KEY_DOWN   read GetSwitch;
    property Left:   TSwitch index TRIGGER_KEYBOARD_KEY_LEFT   read GetSwitch;
    property Right:  TSwitch index TRIGGER_KEYBOARD_KEY_RIGHT  read GetSwitch;
    property Select: TSwitch index TRIGGER_KEYBOARD_KEY_SELECT read GetSwitch;
    property Start:  TSwitch index TRIGGER_KEYBOARD_KEY_START  read GetSwitch;
    property B:      TSwitch index TRIGGER_KEYBOARD_KEY_B      read GetSwitch;
    property A:      TSwitch index TRIGGER_KEYBOARD_KEY_A      read GetSwitch;
  end;


implementation

uses
  SDL2,
  Fairtris.Memory,
  Fairtris.Settings,
  Fairtris.Arrays;


constructor TDevice.Create();
var
  Index: Integer;
begin
  FKeyboard  := PKeyboard(SDL_GetKeyboardState(nil));
  FConnected := True;

  for Index := Low(FKeys) to High(FKeys) do
    FKeys[Index] := TSwitch.Create(False);
end;


destructor TDevice.Destroy();
var
  Index: Integer;
begin
  for Index := Low(FKeys) to High(FKeys) do
    FKeys[Index].Free();

  inherited Destroy();
end;


function TDevice.GetKey(AKeyID: UInt8): TSwitch;
begin
  Result := FKeys[AKeyID];
end;


procedure TDevice.Reset();
var
  Index: Integer;
begin
  for Index := Low(FKeys) to High(FKeys) do
    FKeys[Index].Reset();
end;


procedure TDevice.Update();
var
  Index: Integer;
begin
  for Index := Low(FKeys) to High(FKeys) do
    FKeys[Index].Down := FKeyboard^[Index] = 1;
end;


procedure TDevice.Validate();
var
  Index: Integer;
begin
  for Index := Low(FKeys) to High(FKeys) do
    FKeys[Index].Validate();
end;


procedure TDevice.Invalidate();
var
  Index: Integer;
begin
  for Index := Low(FKeys) to High(FKeys) do
    FKeys[Index].Invalidate();
end;


constructor TKeyboard.Create();
begin
  InitDevice();
  InitScanCodesDefault();
  InitScanCodesCurrent();
end;


destructor TKeyboard.Destroy();
begin
  DoneDevice();
  inherited Destroy();
end;


procedure TKeyboard.InitDevice();
begin
  FDevice := TDevice.Create();
end;


procedure TKeyboard.InitScanCodesDefault();
var
  Index: Integer;
begin
  for Index := TRIGGER_KEYBOARD_KEY_FIRST to TRIGGER_KEYBOARD_KEY_LAST do
    FScanCodesDefault[Index] := MAPPING_DEFAULT_KEYBOARD[Index];
end;


procedure TKeyboard.InitScanCodesCurrent();
begin
  Restore();
end;


procedure TKeyboard.DoneDevice();
begin
  FDevice.Free();
end;


function TKeyboard.GetSwitch(AKeyID: Integer): TSwitch;
begin
  Result := FDevice[FScanCodesCurrent[AKeyID]];
end;


function TKeyboard.GetScanCode(AKeyID: Integer): UInt8;
begin
  Result := FScanCodesCurrent[AKeyID];
end;


function TKeyboard.GetConnected(): Boolean;
begin
  Result := FDevice.Connected;
end;


procedure TKeyboard.Initialize();
begin
  FScanCodesCurrent := Settings.Keyboard.ScanCodes;
end;


procedure TKeyboard.Reset();
begin
  FDevice.Reset();
end;


procedure TKeyboard.Update();
begin
  FDevice.Update();
end;


procedure TKeyboard.Restore();
begin
  FScanCodesCurrent := FScanCodesDefault;
end;


procedure TKeyboard.Introduce();
begin
  FScanCodesCurrent := Memory.Keyboard.ScanCodes;
end;


procedure TKeyboard.Validate();
begin
  FDevice.Validate();
end;


procedure TKeyboard.Invalidate();
begin
  FDevice.Invalidate();
end;


function TKeyboard.CatchedOneKey(out AScanCode: UInt8): Boolean;
var
  Index:           Integer;
  CatchedScanCode: Integer = KEYBOARD_SCANCODE_KEY_NOT_MAPPED;
  Catched:         Boolean = False;
begin
  Result := False;

  for Index := KEYBOARD_SCANCODE_KEY_FIRST to KEYBOARD_SCANCODE_KEY_LAST do
    if not (Index in KEYBOARD_KEY_RESERVED) then
      if FDevice[Index].Pressed then
        if not Catched then
        begin
          Catched         := True;
          CatchedScanCode := Index;
        end
        else
          Exit;

  if Catched then
  begin
    Result    := True;
    AScanCode := CatchedScanCode;
  end;
end;


end.

