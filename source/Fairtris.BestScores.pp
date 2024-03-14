
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

unit Fairtris.BestScores;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  FGL,
  IniFiles,
  Fairtris.Constants;


type
  TScoreEntry = class(TObject)
  private
    FRegionID:     Integer;
    FLinesCleared: Integer;
    FLevelBegin:   Integer;
    FLevelEnd:     Integer;
    FTetrisRate:   Integer;
    FTotalScore:   Integer;
  private
    FValid: Boolean;
  private
    procedure Validate();
  public
    constructor Create(ARegionID: Integer; AValid: Boolean = False);
  public
    procedure Load(AFile: TIniFile; const ASection: String);
    procedure Save(AFile: TIniFile; const ASection: String);
  public
    property LinesCleared: Integer read FLinesCleared write FLinesCleared;
    property LevelBegin:   Integer read FLevelBegin   write FLevelBegin;
    property LevelEnd:     Integer read FLevelEnd     write FLevelEnd;
    property TetrisRate:   Integer read FTetrisRate   write FTetrisRate;
    property TotalScore:   Integer read FTotalScore   write FTotalScore;
  public
    property Valid: Boolean read FValid;
  end;

type
  TScoreEntries = specialize TFPGObjectList<TScoreEntry>;


type
  TGeneratorEntries = class(TObject)
  private
    FScoresFile: TMemIniFile;
    FEntries:    TScoreEntries;
    FRegion:     Integer;
  private
    function GetEntry(AIndex: Integer): TScoreEntry;
    function GetCount(): Integer;
    function GetBestResult(): Integer;
  public
    constructor Create(const AFileName: String; ARegionID: Integer);
    destructor  Destroy(); override;
  public
    procedure Load();
    procedure Save();
  public
    procedure Add(AEntry: TScoreEntry);
    procedure Clear();
  public
    property Entry[AIndex: Integer]: TScoreEntry read GetEntry; default;
  public
    property Count:      Integer read GetCount;
    property BestResult: Integer read GetBestResult;
  end;


type
  TRegionEntries = class(TObject)
  private
    FGenerators: array [GENERATOR_FIRST .. GENERATOR_LAST] of TGeneratorEntries;
  private
    function GetGenerator(AGeneratorID: Integer): TGeneratorEntries;
  public
    constructor Create(const APath: String; ARegionID: Integer);
    destructor  Destroy(); override;
  public
    procedure Load();
    procedure Save();
  public
    procedure Clear();
  public
    property Generator[AGeneratorID: Integer]: TGeneratorEntries read GetGenerator; default;
  end;


type
  TBestScores = class(TObject)
  private
    FRegions: array [REGION_FIRST .. REGION_LAST] of TRegionEntries;
  private
    function GetRegion(ARegionID: Integer): TRegionEntries;
  public
    constructor Create();
    destructor  Destroy(); override;
  public
    procedure Load();
    procedure Save();
  public
    procedure Clear();
  public
    property Region[ARegionID: Integer]: TRegionEntries read GetRegion; default;
  end;


var
  BestScores: TBestScores;


implementation

uses
  Math,
  SysUtils,
  Fairtris.Arrays;


procedure TScoreEntry.Validate();
begin
  FValid := InRange(FLinesCleared, 0, 9999);

  FValid := FValid and InRange(FLevelBegin, LEVEL_FIRST, LEVEL_LAST);
  FValid := FValid and InRange(FLevelEnd,   LEVEL_FIRST, LEVEL_BSOD);

  FValid := FValid and (FLevelBegin <= FLevelEnd);

  FValid := FValid and InRange(FTetrisRate, 0, 100);
  FValid := FValid and InRange(FTotalScore, 0, 99999999);
end;


constructor TScoreEntry.Create(ARegionID: Integer; AValid: Boolean);
begin
  FRegionID := ARegionID;
  FValid    := AValid;
end;


procedure TScoreEntry.Load(AFile: TIniFile; const ASection: String);
begin
  FLinesCleared := AFile.ReadInteger(ASection, BEST_SCORES_KEY_SCORE_LINES_CLEARED, -1);
  FLevelBegin   := AFile.ReadInteger(ASection, BEST_SCORES_KEY_SCORE_LEVEL_BEGIN,   -1);
  FLevelEnd     := AFile.ReadInteger(ASection, BEST_SCORES_KEY_SCORE_LEVEL_END,     -1);
  FTetrisRate   := AFile.ReadInteger(ASection, BEST_SCORES_KEY_SCORE_TETRIS_RATE,   -1);
  FTotalScore   := AFile.ReadInteger(ASection, BEST_SCORES_KEY_SCORE_TOTAL_SCORE,   -1);

  Validate();
end;


procedure TScoreEntry.Save(AFile: TIniFile; const ASection: String);
begin
  AFile.WriteInteger(ASection, BEST_SCORES_KEY_SCORE_LINES_CLEARED, FLinesCleared);
  AFile.WriteInteger(ASection, BEST_SCORES_KEY_SCORE_LEVEL_BEGIN,   FLevelBegin);
  AFile.WriteInteger(ASection, BEST_SCORES_KEY_SCORE_LEVEL_END,     FLevelEnd);
  AFile.WriteInteger(ASection, BEST_SCORES_KEY_SCORE_TETRIS_RATE,   FTetrisRate);
  AFile.WriteInteger(ASection, BEST_SCORES_KEY_SCORE_TOTAL_SCORE,   FTotalScore);
end;


constructor TGeneratorEntries.Create(const AFileName: String; ARegionID: Integer);
begin
  FScoresFile := TMemIniFile.Create(AFileName);
  FEntries    := TScoreEntries.Create();
  FRegion     := ARegionID;
end;


destructor TGeneratorEntries.Destroy();
begin
  FScoresFile.Free();
  FEntries.Free();

  inherited Destroy();
end;


function TGeneratorEntries.GetEntry(AIndex: Integer): TScoreEntry;
begin
  Result := FEntries[AIndex];
end;


function TGeneratorEntries.GetCount(): Integer;
begin
  Result := FEntries.Count;
end;


function TGeneratorEntries.GetBestResult(): Integer;
begin
  if FEntries.Count = 0 then
    Result := 0
  else
    Result := FEntries.First.TotalScore;
end;


procedure TGeneratorEntries.Load();
var
  NewEntry:     TScoreEntry;
  EntriesCount: Integer;
  Index:        Integer;
begin
  FEntries.Clear();
  EntriesCount := FScoresFile.ReadInteger(BEST_SCORES_SECTION_GENERAL, BEST_SCORES_KEY_GENERAL_COUNT, 0);

  for Index := 0 to EntriesCount - 1 do
  begin
    NewEntry := TScoreEntry.Create(FRegion);
    NewEntry.Load(FScoresFile, BEST_SCORES_SECTION_SCORE.Format([Index]));

    if NewEntry.Valid then
      FEntries.Add(NewEntry)
    else
      NewEntry.Free();
  end;
end;


procedure TGeneratorEntries.Save();
var
  StoreCount: Integer;
  Index:      Integer;
begin
  StoreCount := Min(FEntries.Count, BEST_SCORES_COUNT);

  FScoresFile.Clear();
  FScoresFile.WriteInteger(BEST_SCORES_SECTION_GENERAL, BEST_SCORES_KEY_GENERAL_COUNT, StoreCount);

  for Index := 0 to StoreCount - 1 do
    FEntries[Index].Save(FScoresFile, BEST_SCORES_SECTION_SCORE.Format([Index]));
end;


procedure TGeneratorEntries.Add(AEntry: TScoreEntry);
var
  Index: Integer;
begin
  for Index := 0 to FEntries.Count - 1 do
    if AEntry.TotalScore > FEntries[Index].TotalScore then
    begin
      FEntries.Insert(Index, AEntry);
      Exit;
    end;

  FEntries.Add(AEntry);
end;


procedure TGeneratorEntries.Clear();
begin
  FEntries.Clear();
end;


constructor TRegionEntries.Create(const APath: String; ARegionID: Integer);
var
  Index: Integer;
begin
  for Index := Low(FGenerators) to High(FGenerators) do
    FGenerators[Index] := TGeneratorEntries.Create(APath + BEST_SCORES_FILENAME[Index], ARegionID);
end;


destructor TRegionEntries.Destroy();
var
  Index: Integer;
begin
  for Index := Low(FGenerators) to High(FGenerators) do
    FGenerators[Index].Free();

  inherited Destroy();
end;


procedure TRegionEntries.Load();
var
  Index: Integer;
begin
  for Index := Low(FGenerators) to High(FGenerators) do
    FGenerators[Index].Load();
end;


procedure TRegionEntries.Save();
var
  Index: Integer;
begin
  for Index := Low(FGenerators) to High(FGenerators) do
    FGenerators[Index].Save();
end;


procedure TRegionEntries.Clear();
var
  Index: Integer;
begin
  for Index := Low(FGenerators) to High(FGenerators) do
    FGenerators[Index].Clear();
end;


function TRegionEntries.GetGenerator(AGeneratorID: Integer): TGeneratorEntries;
begin
  Result := FGenerators[AGeneratorID];
end;


constructor TBestScores.Create();
var
  Index: Integer;
begin
  for Index := Low(FRegions) to High(FRegions) do
    FRegions[Index] := TRegionEntries.Create(BEST_SCORES_PATH[Index], Index);
end;


destructor TBestScores.Destroy();
var
  Index: Integer;
begin
  for Index := Low(FRegions) to High(FRegions) do
    FRegions[Index].Free();

  inherited Destroy();
end;


function TBestScores.GetRegion(ARegionID: Integer): TRegionEntries;
begin
  Result := FRegions[ARegionID];
end;


procedure TBestScores.Load();
var
  Index: Integer;
begin
  for Index := Low(FRegions) to High(FRegions) do
    FRegions[Index].Load();
end;


procedure TBestScores.Save();
var
  Index: Integer;
begin
  for Index := Low(FRegions) to High(FRegions) do
    FRegions[Index].Save();
end;


procedure TBestScores.Clear();
var
  Index: Integer;
begin
  for Index := Low(FRegions) to High(FRegions) do
    FRegions[Index].Clear();
end;


end.

