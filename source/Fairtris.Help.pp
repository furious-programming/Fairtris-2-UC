
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

unit Fairtris.Help;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  Classes;


type
  THelpThread = class(TThread)
  public
    procedure Execute(); override;
  end;


implementation

uses
  Windows,
  Fairtris.Logic,
  Fairtris.Constants;


procedure THelpThread.Execute();
var
  Address: String = 'https://github.com/furious-programming/Fairtris-2-UC/wiki/';
begin
  case Logic.Scene.Current of
    SCENE_MENU:        Address += 'Main-menu';
    SCENE_LOBBY:       Address += 'Gameplay-setup';
    SCENE_GAME_NORMAL: Address += 'Gameplay';
    SCENE_GAME_FLASH:  Address += 'Gameplay';
    SCENE_PAUSE:       Address += 'Game-pause';
    SCENE_SUMMARY:     Address += 'Game-summary';
    SCENE_OPTIONS:     Address += 'Game-options';
    SCENE_KEYBOARD:    Address += 'Set-up-keyboard';
    SCENE_CONTROLLER:  Address += 'Set-up-controller';
    SCENE_BSOD:        Address += 'BSoD';
  end;

  ShellExecute(0, 'open', PChar(Address), nil, nil, SW_SHOWNORMAL);
  Terminate();
end;


end.

