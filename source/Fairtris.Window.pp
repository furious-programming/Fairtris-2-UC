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

unit Fairtris.Window;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  SDL2,
  SysUtils;


type
  TWindow = class(TObject)
  private
    FHandle: THandle;
    FWindow: PSDL_Window;
    FRenderer: PSDL_Renderer;
  private
    function GetFocused(): Boolean;
  public
    constructor Create();
    destructor Destroy(); override;
  public
    property Window: PSDL_Window read FWindow;
    property Renderer: PSDL_Renderer read FRenderer;
  public
    property Handle: THandle read FHandle;
    property Focused: Boolean read GetFocused;
  end;


function GetWindowInstance(): PSDL_Window;


var
  Window: TWindow;


implementation

uses
  Fairtris.Classes,
  Fairtris.Arrays,
  Fairtris.Constants;


function GetWindowInstance(): PSDL_Window;
begin
  if Assigned(Window) then
    Result := Window.Window
  else
    Result := nil;
end;


constructor TWindow.Create();
var
  SysInfo: TSDL_SysWMInfo;
begin
  FWindow := SDL_CreateWindow('Fairtris', SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, 0, 0, SDL_WINDOW_BORDERLESS);

  if FWindow = nil then
    raise SDLException.CreateFmt(ERROR_MESSAGE_SDL, [ERROR_MESSAGE[ERROR_SDL_CREATE_WINDOW], SDL_GetError()]);

  FRenderer := SDL_CreateRenderer(FWindow, -1, SDL_RENDERER_ACCELERATED or SDL_RENDERER_TARGETTEXTURE);

  if FRenderer = nil then
    raise SDLException.CreateFmt(ERROR_MESSAGE_SDL, [ERROR_MESSAGE[ERROR_SDL_CREATE_RENDERER], SDL_GetError()]);

  SDL_Version(SysInfo.Version);

  if SDL_GetWindowWMInfo(FWindow, @SysInfo) = SDL_TRUE then
    FHandle := SysInfo.Win.Window
  else
    raise SDLException.CreateFmt(ERROR_MESSAGE_SDL, [ERROR_MESSAGE[ERROR_SDL_CREATE_HANDLE], SDL_GetError()]);
end;


destructor TWindow.Destroy();
begin
  SDL_DestroyWindow(FWindow);
  SDL_DestroyRenderer(FRenderer);

  inherited Destroy();
end;


function TWindow.GetFocused(): Boolean;
begin
  Result := SDL_GetWindowFlags(Window) and SDL_WINDOW_INPUT_FOCUS = SDL_WINDOW_INPUT_FOCUS;
end;


end.

