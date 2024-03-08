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
    FIsSpeedrun: Boolean;
    FRegionID: Integer;
  private
    FLinesCleared: Integer;
    FLevelBegin: Integer;
    FLevelEnd: Integer;
    FTetrisRate: Integer;
    FTotalScore: Integer;
    FTotalTime: Integer;
    FCompleted: Boolean;
  private
    FValid: Boolean;
  private
    procedure Validate();
  public
    constructor Create(AIsSpeedrun: Boolean; ARegionID: Integer; AValid: Boolean = False);
  public
    procedure Load(AFile: TIniFile; const ASection: String);
    procedure Save(AFile: TIniFile; const ASection: String);
  public
    function Clone(): TScoreEntry;
  public
    property LinesCleared: Integer read FLinesCleared write FLinesCleared;
    property LevelBegin: Integer read FLevelBegin write FLevelBegin;
    property LevelEnd: Integer read FLevelEnd write FLevelEnd;
    property TetrisRate: Integer read FTetrisRate write FTetrisRate;
    property TotalScore: Integer read FTotalScore write FTotalScore;
    property TotalTime: Integer read FTotalTime write FTotalTime;
    property Completed: Boolean read FCompleted write FCompleted;
  public
    property Valid: Boolean read FValid;
  end;

type
  TScoreEntries = specialize TFPGObjectList<TScoreEntry>;


type
  TGeneratorEntries = class(TObject)
  private
    FScoresFile: TMemIniFile;
    FEntries: TScoreEntries;
  private
    FIsSpeedrun: Boolean;
    FRegion: Integer;
  private
    function GetEntry(AIndex: Integer): TScoreEntry;
    function GetCount(): Integer;
    function GetBestResult(): Integer;
  private
    procedure AddMarathonEntry(AEntry: TScoreEntry);
    procedure AddSpeedrunEntry(AEntry: TScoreEntry);
  public
    constructor Create(const AFileName: String; AIsSpeedrun: Boolean; ARegionID: Integer);
    destructor Destroy(); override;
  public
    procedure Load();
    procedure Save();
  public
    procedure Add(AEntry: TScoreEntry);
    procedure Clear();
  public
    property Entry[AIndex: Integer]: TScoreEntry read GetEntry; default;
    property Count: Integer read GetCount;
  public
    property BestResult: Integer read GetBestResult;
  end;


type
  TRegionEntries = class(TObject)
  private
    FGenerators: array [GENERATOR_FIRST .. GENERATOR_LAST] of TGeneratorEntries;
    FIsSpeedrun: Boolean;
  private
    function GetGenerator(AGeneratorID: Integer): TGeneratorEntries;
  public
    constructor Create(const APath: String; AIsSpeedrun: Boolean; ARegionID: Integer);
    destructor Destroy(); override;
  public
    procedure Load();
    procedure Save();
  public
    procedure Clear();
  public
    property Generator[AGeneratorID: Integer]: TGeneratorEntries read GetGenerator; default;
  end;


type
  TModeEntries = class(TObject)
  private
    FRegions: array [REGION_FIRST .. REGION_LAST] of TRegionEntries;
    FIsSpeedrun: Boolean;
  private
    function GetRegion(ARegionID: Integer): TRegionEntries;
  public
    constructor Create(AIsSpeedrun: Boolean);
    destructor Destroy(); override;
  public
    procedure Load();
    procedure Save();
  public
    procedure Clear();
  public
    property Region[ARegionID: Integer]: TRegionEntries read GetRegion; default;
  end;


type
  TBestScores = class(TObject)
  private
    FStorable: array [Boolean] of TModeEntries;
  private
    FQuals: array [Boolean] of TModeEntries;
    FMatch: array [Boolean] of TModeEntries;
  private
    function GetStorableMode(AIsSpeedrun: Boolean): TModeEntries;
    function GetQualsMode(AIsSpeedrun: Boolean): TModeEntries;
    function GetMatchMode(AIsSpeedrun: Boolean): TModeEntries;
  public
    constructor Create();
    destructor Destroy(); override;
  public
    procedure Load();
    procedure Save();
  public
    property Storable[AIsSpeedrun: Boolean]: TModeEntries read GetStorableMode; default;
  public
    property Quals[AIsSpeedrun: Boolean]: TModeEntries read GetQualsMode;
    property Match[AIsSpeedrun: Boolean]: TModeEntries read GetMatchMode;
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
  FValid := InRange(FLinesCleared, 0, 999);

  FValid := FValid and InRange(FLevelBegin, LEVEL_FIRST, LEVEL_KILLSCREEN[FRegionID]);
  FValid := FValid and InRange(FLevelEnd,   LEVEL_FIRST, 99);

  FValid := FValid and (FLevelBegin <= FLevelEnd);

  FValid := FValid and InRange(FTetrisRate, 0, 100);
  FValid := FValid and InRange(FTotalScore, 0, 9999999);

  if FIsSpeedrun then
    FValid := FValid and InRange(FTotalTime, 0, 10 * 60 * CLOCK_FRAMERATE_LIMIT[FRegionID] - 1);
end;


constructor TScoreEntry.Create(AIsSpeedrun: Boolean; ARegionID: Integer; AValid: Boolean);
begin
  FIsSpeedrun := AIsSpeedrun;
  FRegionID := ARegionID;

  FValid := AValid;
end;


procedure TScoreEntry.Load(AFile: TIniFile; const ASection: String);
begin
  FLinesCleared := AFile.ReadInteger(ASection, BEST_SCORES_KEY_SCORE_LINES_CLEARED, -1);

  FLevelBegin := AFile.ReadInteger(ASection, BEST_SCORES_KEY_SCORE_LEVEL_BEGIN, -1);
  FLevelEnd   := AFile.ReadInteger(ASection, BEST_SCORES_KEY_SCORE_LEVEL_END,   -1);

  FTetrisRate := AFile.ReadInteger(ASection, BEST_SCORES_KEY_SCORE_TETRIS_RATE, -1);
  FTotalScore := AFile.ReadInteger(ASection, BEST_SCORES_KEY_SCORE_TOTAL_SCORE, -1);

  if FIsSpeedrun then
    FTotalTime := AFile.ReadInteger(ASection, BEST_SCORES_KEY_SCORE_TOTAL_TIME, -1);

  Validate();
end;


procedure TScoreEntry.Save(AFile: TIniFile; const ASection: String);
begin
  AFile.WriteInteger(ASection, BEST_SCORES_KEY_SCORE_LINES_CLEARED, FLinesCleared);

  AFile.WriteInteger(ASection, BEST_SCORES_KEY_SCORE_LEVEL_BEGIN, FLevelBegin);
  AFile.WriteInteger(ASection, BEST_SCORES_KEY_SCORE_LEVEL_END,   FLevelEnd);

  AFile.WriteInteger(ASection, BEST_SCORES_KEY_SCORE_TETRIS_RATE, FTetrisRate);
  AFile.WriteInteger(ASection, BEST_SCORES_KEY_SCORE_TOTAL_SCORE, FTotalScore);

  if FIsSpeedrun then
    AFile.WriteInteger(ASection, BEST_SCORES_KEY_SCORE_TOTAL_TIME, FTotalTime);
end;


function TScoreEntry.Clone(): TScoreEntry;
begin
  Result := TScoreEntry.Create(FIsSpeedrun, FRegionID);

  Result.FIsSpeedrun := FIsSpeedrun;
  Result.FRegionID := FRegionID;

  Result.FLinesCleared := FLinesCleared;
  Result.FLevelBegin := FLevelBegin;
  Result.FLevelEnd := FLevelEnd;
  Result.FTetrisRate := FTetrisRate;
  Result.FTotalScore := FTotalScore;
  Result.FTotalTime := FTotalTime;
  Result.FCompleted := FCompleted;

  Result.FValid := FValid;
end;


constructor TGeneratorEntries.Create(const AFileName: String; AIsSpeedrun: Boolean; ARegionID: Integer);
begin
  FScoresFile := TMemIniFile.Create(AFileName);
  FEntries := TScoreEntries.Create();

  FIsSpeedrun := AIsSpeedrun;
  FRegion := ARegionID;
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
    if FIsSpeedrun then
      Result := FEntries.First.TotalTime
    else
      Result := FEntries.First.TotalScore;
end;


procedure TGeneratorEntries.AddMarathonEntry(AEntry: TScoreEntry);
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


procedure TGeneratorEntries.AddSpeedrunEntry(AEntry: TScoreEntry);
var
  Index: Integer;
begin
  if not AEntry.Completed then
    AEntry.Free()
  else
  begin
    for Index := 0 to FEntries.Count - 1 do
      if AEntry.TotalTime < FEntries[Index].TotalTime then
      begin
        FEntries.Insert(Index, AEntry);
        Exit;
      end;

    FEntries.Add(AEntry);
  end;
end;


procedure TGeneratorEntries.Load();
var
  NewEntry: TScoreEntry;
  EntriesCount, Index: Integer;
begin
  FEntries.Clear();
  EntriesCount := FScoresFile.ReadInteger(BEST_SCORES_SECTION_GENERAL, BEST_SCORES_KEY_GENERAL_COUNT, 0);

  for Index := 0 to EntriesCount - 1 do
  begin
    NewEntry := TScoreEntry.Create(FIsSpeedrun, FRegion);
    NewEntry.Load(FScoresFile, BEST_SCORES_SECTION_SCORE.Format([Index]));

    if NewEntry.Valid then
      FEntries.Add(NewEntry);
  end;
end;


procedure TGeneratorEntries.Save();
var
  StoreCount, Index: Integer;
begin
  StoreCount := Min(FEntries.Count, BEST_SCORES_COUNT);

  FScoresFile.Clear();
  FScoresFile.WriteInteger(BEST_SCORES_SECTION_GENERAL, BEST_SCORES_KEY_GENERAL_COUNT, StoreCount);

  for Index := 0 to StoreCount - 1 do
    FEntries[Index].Save(FScoresFile, BEST_SCORES_SECTION_SCORE.Format([Index]));
end;


procedure TGeneratorEntries.Add(AEntry: TScoreEntry);
begin
  if FIsSpeedrun then
    AddSpeedrunEntry(AEntry)
  else
    AddMarathonEntry(AEntry);
end;


procedure TGeneratorEntries.Clear();
begin
  FEntries.Clear();
end;


constructor TRegionEntries.Create(const APath: String; AIsSpeedrun: Boolean; ARegionID: Integer);
var
  Index: Integer;
begin
  FIsSpeedrun := AIsSpeedrun;

  for Index := Low(FGenerators) to High(FGenerators) do
    FGenerators[Index] := TGeneratorEntries.Create(APath + BEST_SCORES_FILENAME[Index], FIsSpeedrun, ARegionID);
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


constructor TModeEntries.Create(AIsSpeedrun: Boolean);
var
  Index: Integer;
begin
  FIsSpeedrun := AIsSpeedrun;

  for Index := Low(FRegions) to High(FRegions) do
    FRegions[Index] := TRegionEntries.Create(BEST_SCORES_PATH[FIsSpeedrun, Index], FIsSpeedrun, Index);
end;


destructor TModeEntries.Destroy();
var
  Index: Integer;
begin
  for Index := Low(FRegions) to High(FRegions) do
    FRegions[Index].Free();

  inherited Destroy();
end;


function TModeEntries.GetRegion(ARegionID: Integer): TRegionEntries;
begin
  Result := FRegions[ARegionID];
end;


procedure TModeEntries.Load();
var
  Index: Integer;
begin
  for Index := Low(FRegions) to High(FRegions) do
    FRegions[Index].Load();
end;


procedure TModeEntries.Save();
var
  Index: Integer;
begin
  for Index := Low(FRegions) to High(FRegions) do
    FRegions[Index].Save();
end;


procedure TModeEntries.Clear();
var
  Index: Integer;
begin
  for Index := Low(FRegions) to High(FRegions) do
    FRegions[Index].Clear();
end;


constructor TBestScores.Create();
var
  Index: Boolean;
begin
  for Index := Low(FStorable) to High(FStorable) do
  begin
    FStorable[Index] := TModeEntries.Create(Index);

    FQuals[Index] := TModeEntries.Create(Index);
    FMatch[Index] := TModeEntries.Create(Index);
  end;
end;


destructor TBestScores.Destroy();
var
  Index: Boolean;
begin
  for Index := Low(FStorable) to High(FStorable) do
  begin
    FStorable[Index].Free();

    FQuals[Index].Free();
    FMatch[Index].Free();
  end;

  inherited Destroy();
end;


function TBestScores.GetStorableMode(AIsSpeedrun: Boolean): TModeEntries;
begin
  Result := FStorable[AIsSpeedrun];
end;


function TBestScores.GetQualsMode(AIsSpeedrun: Boolean): TModeEntries;
begin
  Result := FQuals[AIsSpeedrun];
end;


function TBestScores.GetMatchMode(AIsSpeedrun: Boolean): TModeEntries;
begin
  Result := FMatch[AIsSpeedrun];
end;


procedure TBestScores.Load();
var
  Index: Boolean;
begin
  for Index := Low(FStorable) to High(FStorable) do
    FStorable[Index].Load();
end;


procedure TBestScores.Save();
var
  Index: Boolean;
begin
  for Index := Low(FStorable) to High(FStorable) do
    FStorable[Index].Save();
end;


end.

