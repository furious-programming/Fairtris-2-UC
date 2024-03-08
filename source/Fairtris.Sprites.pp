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

unit Fairtris.Sprites;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  SDL2,
  Fairtris.Constants;


type
  TSprites = class(TObject)
  private type
    TCollections = array [SPRITE_FIRST .. SPRITE_LAST] of PSDL_Texture;
  private
    FCollections: TCollections;
  private
    function GetCollection(ACollectionID: Integer): PSDL_Texture;
  public
    destructor Destroy(); override;
  public
    procedure Load();
  public
    property Collection[ACollectionID: Integer]: PSDL_Texture read GetCollection; default;
  public
    property Charset: PSDL_Texture index SPRITE_CHARSET read GetCollection;
    property Bricks: PSDL_Texture index SPRITE_BRICKS read GetCollection;
    property Pieces: PSDL_Texture index SPRITE_PIECES read GetCollection;
    property Miniatures: PSDL_Texture index SPRITE_MINIATURES read GetCollection;
    property Controller: PSDL_Texture index SPRITE_CONTROLLER read GetCollection;
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
  for Index := Low(FCollections) to High(FCollections) do
    SDL_DestroyTexture(FCollections[Index]);

  inherited Destroy();
end;


function TSprites.GetCollection(ACollectionID: Integer): PSDL_Texture;
begin
  Result := FCollections[ACollectionID];
end;


procedure TSprites.Load();
var
  Index: Integer;
begin
  for Index := Low(FCollections) to High(FCollections) do
  begin
    FCollections[Index] := Img_LoadTexture(Window.Renderer, PChar(SPRITE_PATH + SPRITE_FILENAME[Index]));

    if FCollections[Index] = nil then
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

