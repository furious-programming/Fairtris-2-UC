
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

unit Fairtris.Sprites;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  SDL2,
  Fairtris.Constants;


type
  TSprites = class(TObject)
  private
    FSprites: array [SPRITE_FIRST .. SPRITE_LAST] of PSDL_Texture;
  private
    function GetSprite(ACollectionID: Integer): PSDL_Texture;
  public
    destructor Destroy(); override;
  public
    procedure Load();
  public
    property Charset:        PSDL_Texture index SPRITE_CHARSET         read GetSprite;
    property Bricks:         PSDL_Texture index SPRITE_BRICKS          read GetSprite;
    property BricksGlitched: PSDL_Texture index SPRITE_BRICKS_GLITCHED read GetSprite;
    property Pieces:         PSDL_Texture index SPRITE_PIECES          read GetSprite;
    property PiecesGlitched: PSDL_Texture index SPRITE_PIECES_GLITCHED read GetSprite;
    property Controller:     PSDL_Texture index SPRITE_CONTROLLER      read GetSprite;
  end;


var
  Sprites: TSprites;


implementation

uses
  SDL2_Image,
  SysUtils,
  Fairtris.Window,
  Fairtris.Classes,
  Fairtris.Arrays;


destructor TSprites.Destroy();
var
  Index: Integer;
begin
  for Index := Low(FSprites) to High(FSprites) do
    SDL_DestroyTexture(FSprites[Index]);

  inherited Destroy();
end;


function TSprites.GetSprite(ACollectionID: Integer): PSDL_Texture;
begin
  Result := FSprites[ACollectionID];
end;


procedure TSprites.Load();
var
  Index: Integer;
begin
  for Index := Low(FSprites) to High(FSprites) do
  begin
    FSprites[Index] := Img_LoadTexture(Window.Renderer, PChar(SPRITE_PATH + SPRITE_FILENAME[Index]));

    if FSprites[Index] = nil then
      raise SDLException.CreateFmt(
        ERROR_MESSAGE_SDL,
        [
          ERROR_MESSAGE[ERROR_SDL_LOAD_SPRITE].Format([SPRITE_PATH + SPRITE_FILENAME[Index]]),
          Img_GetError()
        ]
      );
  end;
end;


end.

