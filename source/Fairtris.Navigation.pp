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

unit Fairtris.Navigation;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  Fairtris.Classes,
  Fairtris.Keyboard,
  Fairtris.Constants;


type
  TNavigation = class(TObject)
  private
    FKeys: array [KEYBOARD_KEY_FIXED_FIRST .. KEYBOARD_KEY_FIXED_LAST] of TSwitch;
  private
    function GetKey(AKeyID: Integer): TSwitch;
  public
    constructor Create();
    destructor Destroy(); override;
  public
    procedure Reset();
    procedure Update(AKeyboard: TKeyboard);
  public
    procedure Validate();
    procedure Invalidate();
  public
    property Up: TSwitch index KEYBOARD_KEY_FIXED_UP read GetKey;
    property Down: TSwitch index KEYBOARD_KEY_FIXED_DOWN read GetKey;
    property Left: TSwitch index KEYBOARD_KEY_FIXED_LEFT read GetKey;
    property Right: TSwitch index KEYBOARD_KEY_FIXED_RIGHT read GetKey;
    property Accept: TSwitch index KEYBOARD_KEY_FIXED_ACCEPT read GetKey;
    property Cancel: TSwitch index KEYBOARD_KEY_FIXED_CANCEL read GetKey;
    property Clear: TSwitch index KEYBOARD_KEY_FIXED_CLEAR read GetKey;
  public
    property Help: TSwitch index KEYBOARD_KEY_FIXED_HELP read GetKey;
  public
    property ToggleVideo: TSwitch index KEYBOARD_KEY_FIXED_TOGGLE_VIDEO read GetKey;
    property ToggleTheme: TSwitch index KEYBOARD_KEY_FIXED_TOGGLE_THEME read GetKey;
  end;


implementation


constructor TNavigation.Create();
var
  Index: Integer;
begin
  for Index := Low(FKeys) to High(FKeys) do
    FKeys[Index] := TSwitch.Create(False);
end;


destructor TNavigation.Destroy();
var
  Index: Integer;
begin
  for Index := Low(FKeys) to High(FKeys) do
    FKeys[Index].Free();

  inherited Destroy();
end;


function TNavigation.GetKey(AKeyID: Integer): TSwitch;
begin
  Result := FKeys[AKeyID];
end;


procedure TNavigation.Reset();
var
  Index: Integer;
begin
  for Index := Low(FKeys) to High(FKeys) do
    FKeys[Index].Reset();
end;


procedure TNavigation.Update(AKeyboard: TKeyboard);
begin
  FKeys[KEYBOARD_KEY_FIXED_UP].Pressed    := AKeyboard.Device[KEYBOARD_SCANCODE_KEY_FIXED_UP].Pressed;
  FKeys[KEYBOARD_KEY_FIXED_DOWN].Pressed  := AKeyboard.Device[KEYBOARD_SCANCODE_KEY_FIXED_DOWN].Pressed;
  FKeys[KEYBOARD_KEY_FIXED_LEFT].Pressed  := AKeyboard.Device[KEYBOARD_SCANCODE_KEY_FIXED_LEFT].Pressed;
  FKeys[KEYBOARD_KEY_FIXED_RIGHT].Pressed := AKeyboard.Device[KEYBOARD_SCANCODE_KEY_FIXED_RIGHT].Pressed;

  FKeys[KEYBOARD_KEY_FIXED_ACCEPT].Pressed := AKeyboard.Device[KEYBOARD_SCANCODE_KEY_FIXED_ACCEPT].Pressed;
  FKeys[KEYBOARD_KEY_FIXED_CANCEL].Pressed := AKeyboard.Device[KEYBOARD_SCANCODE_KEY_FIXED_CANCEL].Pressed;
  FKeys[KEYBOARD_KEY_FIXED_CLEAR].Pressed  := AKeyboard.Device[KEYBOARD_SCANCODE_KEY_FIXED_CLEAR].Pressed;

  FKeys[KEYBOARD_KEY_FIXED_HELP].Pressed := AKeyboard.Device[KEYBOARD_SCANCODE_KEY_FIXED_HELP].Pressed;

  FKeys[KEYBOARD_KEY_FIXED_TOGGLE_VIDEO].Pressed := AKeyboard.Device[KEYBOARD_SCANCODE_KEY_FIXED_TOGGLE_VIDEO].Pressed;
  FKeys[KEYBOARD_KEY_FIXED_TOGGLE_THEME].Pressed := AKeyboard.Device[KEYBOARD_SCANCODE_KEY_FIXED_TOGGLE_THEME].Pressed;
end;


procedure TNavigation.Validate();
var
  Index: Integer;
begin
  for Index := Low(FKeys) to High(FKeys) do
    FKeys[Index].Validate();
end;


procedure TNavigation.Invalidate();
var
  Index: Integer;
begin
  for Index := Low(FKeys) to High(FKeys) do
    FKeys[Index].Invalidate();
end;


end.

