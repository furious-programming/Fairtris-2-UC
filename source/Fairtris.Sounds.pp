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

unit Fairtris.Sounds;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  SDL2_Mixer,
  Fairtris.Constants;


type
  TRegionSounds = class(TObject)
  private type
    TSounds = array [SOUND_FIRST .. SOUND_LAST] of PMix_Chunk;
  private
    FSounds: TSounds;
    FSoundsPath: String;
  private
    function GetSound(ASoundID: Integer): PMix_Chunk;
  public
    constructor Create(const APath: String);
    destructor Destroy(); override;
  public
    procedure Load();
  public
    property Sound[ASoundID: Integer]: PMix_Chunk read GetSound; default;
  end;


type
  TSounds = class(TObject)
  private type
    TRegions = array [SOUND_REGION_FIRST .. SOUND_REGION_LAST] of TRegionSounds;
  private
    FRegions: TRegions;
    FEnabled: Integer;
  public
    constructor Create();
    destructor Destroy(); override;
  public
    procedure Initilize();
    procedure Load();
  public
    procedure PlaySound(ASoundID: Integer; ANeedAttention: Boolean = False);
  public
    property Enabled: Integer read FEnabled write FEnabled;
  end;


var
  Sounds: TSounds;


implementation

uses
  SysUtils,
  Fairtris.Classes,
  Fairtris.Memory,
  Fairtris.Settings,
  Fairtris.Arrays;


constructor TRegionSounds.Create(const APath: String);
begin
  FSoundsPath := APath;
end;


destructor TRegionSounds.Destroy();
var
  Index: Integer;
begin
  for Index := Low(FSounds) to High(FSounds) do
    Mix_FreeChunk(FSounds[Index]);

  inherited Destroy();
end;


function TRegionSounds.GetSound(ASoundID: Integer): PMix_Chunk;
begin
  Result := FSounds[ASoundID];
end;


procedure TRegionSounds.Load();
var
  Index: Integer;
begin
  for Index := Low(FSounds) to High(FSounds) do
  begin
    FSounds[Index] := Mix_LoadWAV(PChar(FSoundsPath + SOUND_FILENAME[Index]));

    if FSounds[Index] = nil then
      raise SDLException.CreateFmt(
        ERROR_MESSAGE_SDL,
        [
          ERROR_MESSAGE[ERROR_SDL_LOAD_SOUND].Format([FSoundsPath + SOUND_FILENAME[Index]]),
          Mix_GetError()
        ]
      );
  end;
end;


constructor TSounds.Create();
var
  Index: Integer;
begin
  for Index := Low(FRegions) to High(FRegions) do
    FRegions[Index] := TRegionSounds.Create(SOUND_PATH[Index]);
end;


destructor TSounds.Destroy();
var
  Index: Integer;
begin
  for Index := Low(FRegions) to High(FRegions) do
    FRegions[Index].Free();

  inherited Destroy();
end;


procedure TSounds.Initilize();
begin
  FEnabled := Settings.General.Sounds;
end;


procedure TSounds.Load();
var
  Index: Integer;
begin
  for Index := Low(FRegions) to High(FRegions) do
    FRegions[Index].Load();
end;


procedure TSounds.PlaySound(ASoundID: Integer; ANeedAttention: Boolean);
begin
  if ASoundID = SOUND_UNKNOWN then Exit;
  if FEnabled = SOUNDS_DISABLED then Exit;

  if ANeedAttention then
    Mix_HaltChannel(-1);

  Mix_PlayChannel(SOUND_CHANNEL[ASoundID], FRegions[SOUND_REGION[Memory.GameModes.Region]][ASoundID], 0);
end;


end.

