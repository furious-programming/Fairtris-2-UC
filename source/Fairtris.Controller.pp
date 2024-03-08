{
  Fairtris — a fair implementation of Classic Tetris®
  Copyleft (ɔ) furious programming 2021-2022. All rights reversed.

  https://github.com/furious-programming/fairtris


  This is free and unencumbered software released into the public domain.

  Anyone is free to copy, modify, publish, use, compile, sell, or
  distribute this software, either in source code form or as a compiled
  binary, for any purpose, commercial or non-commercial, and by any means.

  For more information, see "LICENSE" or "license.txt" file, which should
  be included with this distribution. If not, check the repository.
}

unit Fairtris.Controller;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  SDL2,
  Fairtris.Interfaces,
  Fairtris.Classes,
  Fairtris.Constants;


type
  TDevice = class(TObject)
  private type
    TButtons = array [CONTROLLER_SCANCODE_BUTTON_FIRST .. CONTROLLER_SCANCODE_BUTTON_LAST + 1] of TSwitch;
  private
    FJoystick: PSDL_Joystick;
  private
    FButtons: TButtons;
    FConnected: Boolean;
  private
    procedure UpdateButtons();
    procedure UpdateAxes();
    procedure UpdateHats();
  private
    function GetButton(AButtonID: Integer): TSwitch;
  public
    constructor Create();
    destructor Destroy(); override;
  public
    procedure Reset();
    procedure Update();
  public
    procedure Validate();
    procedure Invalidate();
  public
    procedure Attach();
    procedure Detach();
  public
    property Button[AButtonID: Integer]: TSwitch read GetButton; default;
    property Connected: Boolean read FConnected;
  end;


type
  TController = class(TInterfacedObject, IControllable)
  private type
    TScanCodes = array [CONTROLLER_BUTTON_FIRST .. CONTROLLER_BUTTON_LAST] of UInt8;
  private
    FDevice: TDevice;
    FScanCodesDefault: TScanCodes;
    FScanCodesCurrent: TScanCodes;
  private
    procedure InitDevice();
    procedure InitScanCodesDefault();
    procedure InitScanCodesCurrent();
  private
    procedure DoneDevice();
  private
    function GetSwitch(AButtonID: Integer): TSwitch;
    function GetScanCode(AButtonID: Integer): UInt8;
    function GetConnected(): Boolean;
  public
    constructor Create();
    destructor Destroy(); override;
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
    procedure Attach();
    procedure Detach();
  public
    function CatchedOneButton(out AScanCode: UInt8): Boolean;
  public
    property Device: TDevice read FDevice;
    property Connected: Boolean read GetConnected;
  public
    property Switch[AButtonID: Integer]: TSwitch read GetSwitch;
    property ScanCode[AButtonID: Integer]: UInt8 read GetScanCode;
  public
    property Up: TSwitch index CONTROLLER_BUTTON_UP read GetSwitch;
    property Down: TSwitch index CONTROLLER_BUTTON_DOWN read GetSwitch;
    property Left: TSwitch index CONTROLLER_BUTTON_LEFT read GetSwitch;
    property Right: TSwitch index CONTROLLER_BUTTON_RIGHT read GetSwitch;
    property Select: TSwitch index CONTROLLER_BUTTON_SELECT read GetSwitch;
    property Start: TSwitch index CONTROLLER_BUTTON_START read GetSwitch;
    property B: TSwitch index CONTROLLER_BUTTON_B read GetSwitch;
    property A: TSwitch index CONTROLLER_BUTTON_A read GetSwitch;
  end;


implementation

uses
  Math,
  Fairtris.Memory,
  Fairtris.Settings;


constructor TDevice.Create();
var
  Index: Integer;
begin
  for Index := Low(FButtons) to High(FButtons) do
    FButtons[Index] := TSwitch.Create(False);
end;


destructor TDevice.Destroy();
var
  Index: Integer;
begin
  for Index := Low(FButtons) to High(FButtons) do
    FButtons[Index].Free();

  inherited Destroy();
end;


procedure TDevice.UpdateButtons();
var
  ButtonsCount, ButtonIndex: Integer;
begin
  ButtonsCount := Min(SDL_JoystickNumButtons(FJoystick), CONTROLLER_COUNT_BUTTONS);

  for ButtonIndex := 0 to ButtonsCount - 1 do
    FButtons[ButtonIndex].Pressed := SDL_JoystickGetButton(FJoystick, ButtonIndex) = 1;
end;


procedure TDevice.UpdateAxes();
const
  JOYSTICK_AXIS_DEADZONE = 9999;
var
  AxesCount, AxisIndex, AxisValue, ButtonIndex: Integer;
begin
  AxesCount := Min(SDL_JoystickNumAxes(FJoystick), CONTROLLER_COUNT_AXES);

  for AxisIndex := 0 to AxesCount - 1 do
  begin
    AxisValue := SDL_JoystickGetAxis(FJoystick, AxisIndex);
    ButtonIndex := CONTROLLER_OFFSET_ARROWS + AxisIndex * CONTROLLER_COUNT_BUTTONS_PER_AXIS;

    FButtons[ButtonIndex + 0].Pressed := AxisValue < -JOYSTICK_AXIS_DEADZONE;
    FButtons[ButtonIndex + 1].Pressed := AxisValue > +JOYSTICK_AXIS_DEADZONE;
  end;
end;


procedure TDevice.UpdateHats();
var
  HatsCount, HatIndex, HatValue, ButtonIndex: Integer;
begin
  HatsCount := Min(SDL_JoystickNumHats(FJoystick), CONTROLLER_COUNT_HATS);

  for HatIndex := 0 to HatsCount - 1 do
  begin
    HatValue := SDL_JoystickGetHat(FJoystick, HatIndex);
    ButtonIndex := CONTROLLER_OFFSET_HATS + HatIndex * CONTROLLER_COUNT_BUTTONS_PER_HAT;

    FButtons[ButtonIndex + 0].Pressed := HatValue and SDL_HAT_LEFT  <> 0;
    FButtons[ButtonIndex + 1].Pressed := HatValue and SDL_HAT_RIGHT <> 0;
    FButtons[ButtonIndex + 2].Pressed := HatValue and SDL_HAT_UP    <> 0;
    FButtons[ButtonIndex + 3].Pressed := HatValue and SDL_HAT_DOWN  <> 0;
  end;
end;


function TDevice.GetButton(AButtonID: Integer): TSwitch;
begin
  Result := FButtons[AButtonID];
end;


procedure TDevice.Reset();
var
  Index: Integer;
begin
  for Index := Low(FButtons) to High(FButtons) do
    FButtons[Index].Reset();
end;


procedure TDevice.Update();
begin
  if FConnected then
  begin
    UpdateButtons();
    UpdateAxes();
    UpdateHats();
  end
  else
    Reset();
end;


procedure TDevice.Validate();
var
  Index: Integer;
begin
  for Index := Low(FButtons) to High(FButtons) do
    FButtons[Index].Validate();
end;


procedure TDevice.Invalidate();
var
  Index: Integer;
begin
  for Index := Low(FButtons) to High(FButtons) do
    FButtons[Index].Invalidate();
end;


procedure TDevice.Attach();
begin
  if not FConnected then
  begin
    FJoystick := SDL_JoystickOpen(0);
    FConnected := True;
  end;
end;


procedure TDevice.Detach();
begin
  if FConnected then
  begin
    SDL_JoystickClose(FJoystick);
    FConnected := False;
  end;
end;


constructor TController.Create();
begin
  InitDevice();
  InitScanCodesDefault();
  InitScanCodesCurrent();
end;


destructor TController.Destroy();
begin
  DoneDevice();
  inherited Destroy();
end;


procedure TController.InitDevice();
begin
  FDevice := TDevice.Create();
end;


procedure TController.InitScanCodesDefault();
begin
  FScanCodesDefault[CONTROLLER_BUTTON_UP]     := CONTROLLER_SCANCODE_BUTTON_UP;
  FScanCodesDefault[CONTROLLER_BUTTON_DOWN]   := CONTROLLER_SCANCODE_BUTTON_DOWN;
  FScanCodesDefault[CONTROLLER_BUTTON_LEFT]   := CONTROLLER_SCANCODE_BUTTON_LEFT;
  FScanCodesDefault[CONTROLLER_BUTTON_RIGHT]  := CONTROLLER_SCANCODE_BUTTON_RIGHT;

  FScanCodesDefault[CONTROLLER_BUTTON_SELECT] := CONTROLLER_SCANCODE_BUTTON_SELECT;
  FScanCodesDefault[CONTROLLER_BUTTON_START]  := CONTROLLER_SCANCODE_BUTTON_START;

  FScanCodesDefault[CONTROLLER_BUTTON_B]      := CONTROLLER_SCANCODE_BUTTON_B;
  FScanCodesDefault[CONTROLLER_BUTTON_A]      := CONTROLLER_SCANCODE_BUTTON_A;
end;


procedure TController.InitScanCodesCurrent();
begin
  Restore();
end;


procedure TController.DoneDevice();
begin
  FDevice.Free();
end;


function TController.GetSwitch(AButtonID: Integer): TSwitch;
begin
  Result := FDevice[FScanCodesCurrent[AButtonID]];
end;


function TController.GetScanCode(AButtonID: Integer): UInt8;
begin
  Result := FScanCodesCurrent[AButtonID];
end;


function TController.GetConnected(): Boolean;
begin
  Result := FDevice.Connected;
end;


procedure TController.Initialize();
begin
  FScanCodesCurrent := Settings.Controller.ScanCodes;
end;


procedure TController.Reset();
begin
  FDevice.Reset();
end;


procedure TController.Update();
begin
  FDevice.Update();
end;


procedure TController.Restore();
begin
  FScanCodesCurrent := FScanCodesDefault;
end;


procedure TController.Introduce();
begin
  FScanCodesCurrent := Memory.Controller.ScanCodes;
end;


procedure TController.Validate();
begin
  FDevice.Validate();
end;


procedure TController.Invalidate();
begin
  FDevice.Invalidate();
end;


procedure TController.Attach();
begin
  FDevice.Attach();
end;


procedure TController.Detach();
begin
  FDevice.Detach();
end;


function TController.CatchedOneButton(out AScanCode: UInt8): Boolean;
var
  Index, CatchedScanCode: Integer;
  Catched: Boolean = False;
begin
  Result := False;
  CatchedScanCode := CONTROLLER_SCANCODE_BUTTON_NOT_MAPPED;

  for Index := CONTROLLER_SCANCODE_BUTTON_FIRST to CONTROLLER_SCANCODE_BUTTON_LAST do
    if FDevice[Index].JustPressed then
      if not Catched then
      begin
        Catched := True;
        CatchedScanCode := Index;
      end
      else
        Exit;

  if Catched then
  begin
    Result := True;
    AScanCode := CatchedScanCode;
  end;
end;


end.

