
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

unit Fairtris.Taskbar;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  ShlObj;


type
  TTaskbar = class(TObject)
  private
    FButton:    ITaskBarList3;
    FSupported: Boolean;
  public
    procedure Initialize();
    procedure Update();
  end;


var
  Taskbar: TTaskbar;


implementation

uses
  SDL2,
  ComObj,
  Math,
  SysUtils,
  Fairtris.Window,
  Fairtris.Clock;


procedure TTaskbar.Initialize();
var
  Instance: IInterface;
begin
  Instance   := CreateComObject(CLSID_TASKBARLIST);
  FSupported := Supports(Instance, ITaskBarList3, FButton);
end;


procedure TTaskbar.Update();
var
  ButtonValue: Integer;
begin
  if Clock.FrameRate.Changed then
    SDL_SetWindowTitle(Window.Window, PChar('Fairtris 2 — %dfps'.Format([Clock.FrameRate.Current])));

  if FSupported and Clock.FrameLoad.Changed then
  begin
    ButtonValue := Max(1, Min(Clock.FrameLoad.Current, 100));

    FButton.SetProgressState(Window.Handle, TBPF_PAUSED);
    FButton.SetProgressValue(Window.Handle, ButtonValue, 100);
  end;
end;


end.

