
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
    FKeys: array [TRIGGER_KEYBOARD_KEY_FIXED_FIRST .. TRIGGER_KEYBOARD_KEY_FIXED_LAST] of TSwitch;
  private
    function GetKey(AKeyID: Integer): TSwitch;
  public
    constructor Create();
    destructor  Destroy(); override;
  public
    procedure Reset();
    procedure Update(AKeyboard: TKeyboard);
  public
    procedure Validate();
    procedure Invalidate();
  public
    property Up:     TSwitch index TRIGGER_KEYBOARD_KEY_FIXED_UP       read GetKey;
    property Down:   TSwitch index TRIGGER_KEYBOARD_KEY_FIXED_DOWN     read GetKey;
    property Left:   TSwitch index TRIGGER_KEYBOARD_KEY_FIXED_LEFT     read GetKey;
    property Right:  TSwitch index TRIGGER_KEYBOARD_KEY_FIXED_RIGHT    read GetKey;
    property Accept: TSwitch index TRIGGER_KEYBOARD_KEY_FIXED_ACCEPT   read GetKey;
    property Cancel: TSwitch index TRIGGER_KEYBOARD_KEY_FIXED_CANCEL   read GetKey;
    property Clear:  TSwitch index TRIGGER_KEYBOARD_KEY_FIXED_CLEAR    read GetKey;
    property Help:   TSwitch index TRIGGER_KEYBOARD_KEY_FIXED_HELP     read GetKey;
    property Video:  TSwitch index TRIGGER_KEYBOARD_KEY_FIXED_VIDEO    read GetKey;
    property Enlarge: TSwitch index TRIGGER_KEYBOARD_KEY_FIXED_ENLARGE read GetKey;
    property Reduce:  TSwitch index TRIGGER_KEYBOARD_KEY_FIXED_REDUCE  read GetKey;
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
  FKeys[TRIGGER_KEYBOARD_KEY_FIXED_UP].Down      := AKeyboard.Device[KEYBOARD_SCANCODE_KEY_FIXED_UP].Down;
  FKeys[TRIGGER_KEYBOARD_KEY_FIXED_DOWN].Down    := AKeyboard.Device[KEYBOARD_SCANCODE_KEY_FIXED_DOWN].Down;
  FKeys[TRIGGER_KEYBOARD_KEY_FIXED_LEFT].Down    := AKeyboard.Device[KEYBOARD_SCANCODE_KEY_FIXED_LEFT].Down;
  FKeys[TRIGGER_KEYBOARD_KEY_FIXED_RIGHT].Down   := AKeyboard.Device[KEYBOARD_SCANCODE_KEY_FIXED_RIGHT].Down;
  FKeys[TRIGGER_KEYBOARD_KEY_FIXED_ACCEPT].Down  := AKeyboard.Device[KEYBOARD_SCANCODE_KEY_FIXED_ACCEPT].Down;
  FKeys[TRIGGER_KEYBOARD_KEY_FIXED_CANCEL].Down  := AKeyboard.Device[KEYBOARD_SCANCODE_KEY_FIXED_CANCEL].Down;
  FKeys[TRIGGER_KEYBOARD_KEY_FIXED_CLEAR].Down   := AKeyboard.Device[KEYBOARD_SCANCODE_KEY_FIXED_CLEAR].Down;
  FKeys[TRIGGER_KEYBOARD_KEY_FIXED_HELP].Down    := AKeyboard.Device[KEYBOARD_SCANCODE_KEY_FIXED_HELP].Down;
  FKeys[TRIGGER_KEYBOARD_KEY_FIXED_VIDEO].Down   := AKeyboard.Device[KEYBOARD_SCANCODE_KEY_FIXED_VIDEO].Down;
  FKeys[TRIGGER_KEYBOARD_KEY_FIXED_ENLARGE].Down := AKeyboard.Device[KEYBOARD_SCANCODE_KEY_FIXED_ENLARGE].Down;
  FKeys[TRIGGER_KEYBOARD_KEY_FIXED_REDUCE].Down  := AKeyboard.Device[KEYBOARD_SCANCODE_KEY_FIXED_REDUCE].Down;
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

