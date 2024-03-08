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

unit Fairtris.Grounds;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  SDL2,
  Fairtris.Constants;


type
  TThemeGrounds = class(TObject)
  private type
    TGrounds = array [SCENE_FIRST .. SCENE_LAST] of PSDL_Texture;
  private
    FGrounds: TGrounds;
    FGroundsPath: String;
  private
    function GetGround(ASceneID: Integer): PSDL_Texture;
  public
    constructor Create(const APath: String);
    destructor Destroy(); override;
  public
    procedure Load();
  public
    property Ground[ASceneID: Integer]: PSDL_Texture read GetGround; default;
  end;


type
  TGrounds = class(TThemeGrounds)
  private type
    TThemes = array [THEME_FIRST .. THEME_LAST] of TThemeGrounds;
  private
    FThemes: TThemes;
  private
    function GetTheme(AThemeID: Integer): TThemeGrounds;
  public
    constructor Create();
    destructor Destroy(); override;
  public
    procedure Load();
  public
    property Theme[AThemeID: Integer]: TThemeGrounds read GetTheme; default;
  end;


var
  Grounds: TGrounds;


implementation

uses
  SDL2_Image,
  SysUtils,
  Fairtris.Window,
  Fairtris.Classes,
  Fairtris.Arrays;


constructor TThemeGrounds.Create(const APath: String);
begin
  FGroundsPath := APath;
end;


destructor TThemeGrounds.Destroy();
var
  Index: Integer;
begin
  for Index := Low(FGrounds) to High(FGrounds) do
    SDL_DestroyTexture(FGrounds[Index]);

  inherited Destroy();
end;


function TThemeGrounds.GetGround(ASceneID: Integer): PSDL_Texture;
begin
  Result := FGrounds[ASceneID];
end;


procedure TThemeGrounds.Load();
var
  Index: Integer;
begin
  for Index := Low(FGrounds) to High(FGrounds) do
  begin
    FGrounds[Index] := Img_LoadTexture(Window.Renderer, PChar(FGroundsPath + GROUND_FILENAME[Index]));

    if FGrounds[Index] = nil then
      raise SDLException.CreateFmt(
        ERROR_MESSAGE_SDL,
        [
          ERROR_MESSAGE[ERROR_SDL_LOAD_GROUND].Format([FGroundsPath + GROUND_FILENAME[Index]]),
          Img_GetError()
        ]
      );
  end;
end;


constructor TGrounds.Create();
var
  Index: Integer;
begin
  for Index := Low(FThemes) to High(FThemes) do
    FThemes[Index] := TThemeGrounds.Create(GROUND_PATH[Index]);
end;


destructor TGrounds.Destroy();
var
  Index: Integer;
begin
  for Index := Low(FThemes) to High(FThemes) do
    FThemes[Index].Free();

  inherited Destroy();
end;


function TGrounds.GetTheme(AThemeID: Integer): TThemeGrounds;
begin
  Result := FThemes[AThemeID];
end;


procedure TGrounds.Load();
var
  Index: Integer;
begin
  for Index := Low(FThemes) to High(FThemes) do
    FThemes[Index].Load();
end;


end.

