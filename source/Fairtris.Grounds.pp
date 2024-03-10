
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

unit Fairtris.Grounds;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  SDL2,
  Fairtris.Constants;


type
  TGrounds = class(TObject)
  private
    FGrounds: array [SCENE_FIRST .. SCENE_LAST] of PSDL_Texture;
  private
    function GetGround(ASceneID: Integer): PSDL_Texture;
  public
    destructor Destroy(); override;
  public
    procedure Load();
  public
    property Ground[ASceneID: Integer]: PSDL_Texture read GetGround; default;
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


destructor TGrounds.Destroy();
var
  Index: Integer;
begin
  for Index := Low(FGrounds) to High(FGrounds) do
    SDL_DestroyTexture(FGrounds[Index]);

  inherited Destroy();
end;


function TGrounds.GetGround(ASceneID: Integer): PSDL_Texture;
begin
  Result := FGrounds[ASceneID];
end;


procedure TGrounds.Load();
var
  Index: Integer;
begin
  for Index := Low(FGrounds) to High(FGrounds) do
  begin
    FGrounds[Index] := Img_LoadTexture(Window.Renderer, PChar(GROUND_PATH + GROUND_FILENAME[Index]));

    if FGrounds[Index] = nil then
      raise SDLException.CreateFmt(
        ERROR_MESSAGE_SDL,
        [
          ERROR_MESSAGE[ERROR_SDL_LOAD_GROUND].Format([GROUND_PATH + GROUND_FILENAME[Index]]),
          Img_GetError()
        ]
      );
  end;
end;


end.

