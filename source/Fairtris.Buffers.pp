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

unit Fairtris.Buffers;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  SDL2;


type
  TBuffers = class(TObject)
  private
    FNative: PSDL_Texture;
    FClient: TSDL_Rect;
  public
    constructor Create();
    destructor Destroy(); override;
  public
    property Native: PSDL_Texture read FNative;
    property Client: TSDL_Rect read FClient write FClient;
  end;


var
  Buffers: TBuffers;


implementation

uses
  SysUtils,
  Fairtris.Window,
  Fairtris.Classes,
  Fairtris.Arrays,
  Fairtris.Constants;


constructor TBuffers.Create();
begin
  FNative := SDL_CreateTexture(Window.Renderer, SDL_PIXELFORMAT_BGR24, SDL_TEXTUREACCESS_TARGET, BUFFER_WIDTH, BUFFER_HEIGHT);

  if FNative = nil then
    raise SDLException.CreateFmt(ERROR_MESSAGE_SDL, [ERROR_MESSAGE[ERROR_SDL_CREATE_BACK_BUFFER], SDL_GetError()]);
end;


destructor TBuffers.Destroy();
begin
  SDL_DestroyTexture(FNative);
  inherited Destroy();
end;


end.

