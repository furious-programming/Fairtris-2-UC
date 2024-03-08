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

program Fairtris.Main;

{$MODE OBJFPC}{$LONGSTRINGS ON}

{$RESOURCE Fairtris.Main.res}

uses
  SDL2,
  SysUtils,
  Fairtris.Window,
  Fairtris.Game,
  Fairtris.Classes,
  Fairtris.Constants;

  procedure HandleErrorSDL(const AMessage: String);
  begin
    SDL_ShowSimpleMessageBox(
      SDL_MESSAGEBOX_ERROR,
      PChar(ERROR_TITLE),
      PChar(AMessage),
      GetWindowInstance()
    );
    Halt;
  end;

  procedure HandleErrorUnknown(const AMessage: String);
  begin
    SDL_ShowSimpleMessageBox(
      SDL_MESSAGEBOX_ERROR,
      PChar(ERROR_TITLE),
      PChar(ERROR_MESSAGE_UNKNOWN.Format([AMessage])),
      GetWindowInstance()
    );
    Halt;
  end;

begin
  Randomize();

  try
    with TGame.Create() do
    begin
      Run();
      Free();
    end;
  except
    on Error: SDLException do HandleErrorSDL(Error.Message);
    on Error: Exception    do HandleErrorUnknown(Error.Message);
  end;
end.

