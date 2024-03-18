
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

unit Fairtris.Window;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  SDL2,
  SysUtils;


type
  TWindow = class(TObject)
  private
    {$IFDEF WINDOWS}
    FHandle:   THandle;
    {$ENDIF}
    FWindow:   PSDL_Window;
    FRenderer: PSDL_Renderer;
  private
    function GetFocused(): Boolean;
  public
    constructor Create();
    destructor  Destroy(); override;
  public
    {$IFDEF WINDOWS}
    property Handle:   THandle       read FHandle;
    {$ENDIF}
    property Window:   PSDL_Window   read FWindow;
    property Renderer: PSDL_Renderer read FRenderer;
    property Focused:  Boolean       read GetFocused;
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
{$IFDEF WINDOWS}
var
  SysInfo: TSDL_SysWMInfo;
{$ENDIF}
begin
  FWindow := SDL_CreateWindow('Fairtris 2', SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, 0, 0, SDL_WINDOW_BORDERLESS);

  if FWindow = nil then
    raise SDLException.CreateFmt(ERROR_MESSAGE_SDL, [ERROR_MESSAGE[ERROR_SDL_CREATE_WINDOW], SDL_GetError()]);

  FRenderer := SDL_CreateRenderer(FWindow, -1, SDL_RENDERER_ACCELERATED or SDL_RENDERER_TARGETTEXTURE);

  if FRenderer = nil then
    raise SDLException.CreateFmt(ERROR_MESSAGE_SDL, [ERROR_MESSAGE[ERROR_SDL_CREATE_RENDERER], SDL_GetError()]);

  SDL_SetRenderDrawBlendMode(FRenderer, SDL_BLENDMODE_BLEND);
  SDL_Version(SysInfo.Version);

  {$IFDEF WINDOWS}
  if SDL_GetWindowWMInfo(FWindow, @SysInfo) = SDL_TRUE then
    FHandle := SysInfo.Win.Window
  else
    raise SDLException.CreateFmt(ERROR_MESSAGE_SDL, [ERROR_MESSAGE[ERROR_SDL_CREATE_HANDLE], SDL_GetError()]);
  {$ENDIF}
end;


destructor TWindow.Destroy();
begin
  SDL_DestroyWindow  (FWindow);
  SDL_DestroyRenderer(FRenderer);

  inherited Destroy();
end;


function TWindow.GetFocused(): Boolean;
begin
  Result := SDL_GetWindowFlags(Window) and SDL_WINDOW_INPUT_FOCUS = SDL_WINDOW_INPUT_FOCUS;
end;


end.

