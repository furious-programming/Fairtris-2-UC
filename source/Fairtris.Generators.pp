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

unit Fairtris.Generators;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  FGL,
  Fairtris.Interfaces,
  Fairtris.Constants;


type
  TShiftRegister = class(TObject)
  private
    FSeed: UInt16;
  public
    procedure Initialize();
    procedure Step();
  public
    property Seed: UInt16 read FSeed write FSeed;
  end;


type
  TBag = class(TObject)
  private type
    TItems = specialize TFPGList<Integer>;
  private
    FCurrentItems: TItems;
    FDefaultItems: TItems;
  private
    function GetItem(AIndex: Integer): Integer;
    function GetSize(): Integer;
  public
    constructor Create(const ACount: Integer);
    constructor Create(const AItems: array of Integer);
    destructor Destroy(); override;
  public
    procedure Reset();
  public
    procedure Swap(ASeed: UInt16);
    procedure SwapFirst();
  public
    property Item[AIndex: Integer]: Integer read GetItem; default;
    property Size: Integer read GetSize;
  end;


type
  TPool = class(TBag)
  private
    procedure SetItem(AIndex, AItem: Integer);
    function GetEmpty(): Boolean;
  public
    procedure Append(AItem: Integer);
    procedure Remove(AItem: Integer);
    procedure Push(AItem: Integer);
  public
    procedure Clear();
  public
    function Contains(AItem: Integer): Boolean;
  public
    property Item[AIndex: Integer]: Integer read GetItem write SetItem; default;
    property Empty: Boolean read GetEmpty;
  end;


type
  TCustomGenerator = class(TInterfacedObject, IGenerable)
  protected
    FRegister: TShiftRegister;
  protected
    FCustomSeed: Boolean;
  protected
    procedure PerformStep(); virtual; abstract;
    procedure PerformFixedSteps(); virtual; abstract;
  public
    constructor Create(); virtual;
    destructor Destroy(); override;
  public
    procedure Initialize(); virtual;
    procedure UnlockRandomness();
  public
    procedure Prepare(ASeed: Integer = SEED_USE_RANDOM); virtual;
    procedure Shuffle(APreShuffling: Boolean = False); virtual; abstract;
    procedure Step(APicking: Boolean = False); virtual;
  public
    function Pick(): Integer; virtual; abstract;
  end;


type
  T7BagGenerator = class(TCustomGenerator)
  private
    FBags: array [0 .. 1] of TBag;
  private
    FBagPick: Integer;
    FBagSwap: Integer;
    FBagPiece: Integer;
  private
    procedure PreShuffle();
  protected
    procedure PerformStep(); override;
    procedure PerformFixedSteps(); override;
  public
    constructor Create(); override;
    destructor Destroy(); override;
  public
    procedure Initialize(); override;
  public
    procedure Prepare(ASeed: Integer = SEED_USE_RANDOM); override;
    procedure Shuffle(APreShuffling: Boolean = False); override;
  public
    function Pick(): Integer; override;
  end;


type
  TMultiBagGenerator = class(TCustomGenerator)
  private
    FIndexBags: array [0 .. 1] of TBag;
    FPieceBags: array [MULTIBAG_BAG_FIRST .. MULTIBAG_BAG_LAST] of TBag;
  private
    FIndexPick: Integer;
  private
    FBagPick: Integer;
    FBagSwap: Integer;
    FBagPiece: Integer;
  private
    procedure PreShuffle();
  protected
    procedure PerformStep(); override;
    procedure PerformFixedSteps(); override;
  public
    constructor Create(); override;
    destructor Destroy(); override;
  public
    procedure Initialize(); override;
  public
    procedure Prepare(ASeed: Integer = SEED_USE_RANDOM); override;
    procedure Shuffle(APreShuffling: Boolean = False); override;
  public
    function Pick(): Integer; override;
  end;


type
  TClassicGenerator = class(TCustomGenerator)
  private
    FSpawnID: UInt8;
    FSpawnCount: UInt8;
  private
    function IndexToSpawnID(AIndex: UInt8): UInt8;
    function SpawnIDToPieceID(ASpawnID: UInt8): Integer;
  protected
    procedure PerformStep(); override;
    procedure PerformFixedSteps(); override;
  public
    procedure Prepare(ASeed: Integer = SEED_USE_RANDOM); override;
    procedure Shuffle(APreShuffling: Boolean = False); override;
  public
    function Pick(): Integer; override;
  end;


type
  TBalancedGenerator = class(TCustomGenerator)
  private
    FSpawnID: UInt8;
    FSpawnCount: UInt8;
  private
    FHistoryIndex: Integer;
  private
    FHistory: array [BALANCED_HISTORY_PIECE_FIRST .. BALANCED_HISTORY_PIECE_LAST] of Integer;
    FDrought: array [PIECE_FIRST .. PIECE_LAST] of Integer;
  private
    function DroughtedPiece(): Integer;
    function FloodedPiece(APiece: Integer): Boolean;
  private
    procedure UpdateHistory(APiece: Integer);
    procedure UpdateDrought(APiece: Integer);
  protected
    procedure PerformStep(); override;
    procedure PerformFixedSteps(); override;
  public
    procedure Prepare(ASeed: Integer = SEED_USE_RANDOM); override;
    procedure Shuffle(APreShuffling: Boolean = False); override;
  public
    function Pick(): Integer; override;
  end;


type
  TTGMGenerator = class(TCustomGenerator)
  private
    FPieces: TPool;
    FSpecial: TPool;
    FHistory: TPool;
  protected
    procedure PerformStep(); override;
    procedure PerformFixedSteps(); override;
  public
    constructor Create(); override;
    destructor Destroy(); override;
  public
    procedure Prepare(ASeed: Integer = SEED_USE_RANDOM); override;
    procedure Shuffle(APreShuffling: Boolean = False); override;
  public
    function Pick(): Integer; override;
  end;


type
  TTGM3Generator = class(TCustomGenerator)
  private
    FPieces: TPool;
    FSpecial: TPool;
  private
    FPool: TPool;
    FOrder: TPool;
    FHistory: TPool;
  protected
    procedure PerformStep(); override;
    procedure PerformFixedSteps(); override;
  public
    constructor Create(); override;
    destructor Destroy(); override;
  public
    procedure Prepare(ASeed: Integer = SEED_USE_RANDOM); override;
    procedure Shuffle(APreShuffling: Boolean = False); override;
  public
    function Pick(): Integer; override;
  end;


type
  TUnfairGenerator = class(TClassicGenerator)
  public
    function Pick(): Integer; override;
  end;


type
  TGenerators = class(TObject)
  private
    FGenerator: IGenerable;
    FGeneratorID: Integer;
  private
    FGenerators: array [GENERATOR_FIRST .. GENERATOR_LAST] of IGenerable;
  private
    function GetGenerator(AGeneratorID: Integer): IGenerable;
    procedure SetGeneratorID(AGeneratorID: Integer);
  public
    constructor Create();
  public
    procedure Initialize();
    procedure Shuffle();
  public
    property Generator: IGenerable read FGenerator;
    property Generators[AGeneratorID: Integer]: IGenerable read GetGenerator; default;
    property GeneratorID: Integer read FGeneratorID write SetGeneratorID;
  end;


var
  Generators: TGenerators;


implementation

uses
  Math,
  Fairtris.Settings,
  Fairtris.Arrays,
  Fairtris.Utils;


procedure TShiftRegister.Initialize();
begin
  FSeed := $8988;
end;


procedure TShiftRegister.Step();
begin
  FSeed := ((((FSeed shr 9) and 1) xor ((FSeed shr 1) and 1)) shl 15) or (FSeed shr 1);
end;


constructor TBag.Create(const ACount: Integer);
var
  Index: Integer;
begin
  FCurrentItems := TItems.Create();
  FDefaultItems := TItems.Create();

  for Index := 0 to ACount - 1 do
  begin
    FCurrentItems.Add(Index);
    FDefaultItems.Add(Index);
  end;
end;


constructor TBag.Create(const AItems: array of Integer);
var
  Index: Integer;
begin
  FCurrentItems := TItems.Create();
  FDefaultItems := TItems.Create();

  for Index := 0 to High(AItems) do
  begin
    FCurrentItems.Add(AItems[Index]);
    FDefaultItems.Add(AItems[Index]);
  end;
end;


destructor TBag.Destroy();
begin
  FCurrentItems.Free();
  FDefaultItems.Free();

  inherited Destroy();
end;


procedure TBag.Reset();
var
  DefaultItem: Integer;
begin
  FCurrentItems.Clear();

  for DefaultItem in FDefaultItems do
    FCurrentItems.Add(DefaultItem);
end;


function TBag.GetItem(AIndex: Integer): Integer;
begin
  Result := FCurrentItems[AIndex];
end;


function TBag.GetSize(): Integer;
begin
  Result := FCurrentItems.Count;
end;


procedure TBag.Swap(ASeed: UInt16);
var
  IndexA, IndexB: Integer;
begin
  IndexA := Hi(ASeed) mod FCurrentItems.Count;
  IndexB := Lo(ASeed) mod FCurrentItems.Count;

  if IndexA <> IndexB then
    FCurrentItems.Exchange(IndexA, IndexB);
end;


procedure TBag.SwapFirst();
begin
  FCurrentItems.Exchange(0, 1);
end;


procedure TPool.SetItem(AIndex, AItem: Integer);
begin
  FCurrentItems[AIndex] := AItem;
end;


function TPool.GetEmpty(): Boolean;
begin
  Result := FCurrentItems.Count = 0;
end;


procedure TPool.Append(AItem: Integer);
begin
  FCurrentItems.Add(AItem);
end;


procedure TPool.Remove(AItem: Integer);
begin
  FCurrentItems.Remove(AItem);
end;


procedure TPool.Push(AItem: Integer);
begin
  FCurrentItems.Delete(0);
  FCurrentItems.Add(AItem);
end;


procedure TPool.Clear();
begin
  FCurrentItems.Clear();
end;


function TPool.Contains(AItem: Integer): Boolean;
begin
  Result := FCurrentItems.IndexOf(AItem) <> -1;
end;


constructor TCustomGenerator.Create();
begin
  FRegister := TShiftRegister.Create();
end;


destructor TCustomGenerator.Destroy();
begin
  FRegister.Free();
  inherited Destroy();
end;


procedure TCustomGenerator.Initialize();
begin
  FRegister.Initialize();
end;


procedure TCustomGenerator.UnlockRandomness();
begin
  FCustomSeed := False;
end;


procedure TCustomGenerator.Prepare(ASeed: Integer);
begin
  FCustomSeed := ASeed <> SEED_USE_RANDOM;

  if FCustomSeed then
  begin
    FRegister.Seed := ASeed and SEED_MASK_REGISTER shr SEED_REGISTER_OFFSET;

    if FRegister.Seed = 0 then
      FRegister.Initialize();
  end;
end;


procedure TCustomGenerator.Step(APicking: Boolean);
begin
  if FCustomSeed and not APicking then Exit;

  if FCustomSeed then
    PerformFixedSteps()
  else
    PerformStep();
end;


constructor T7BagGenerator.Create();
begin
  inherited Create();

  FBags[0] := TBag.Create([PIECE_T, PIECE_J, PIECE_Z, PIECE_O, PIECE_S, PIECE_L, PIECE_I]);
  FBags[1] := TBag.Create([PIECE_T, PIECE_J, PIECE_Z, PIECE_O, PIECE_S, PIECE_L, PIECE_I]);
end;


destructor T7BagGenerator.Destroy();
begin
  FBags[0].Free();
  FBags[1].Free();

  inherited Destroy();
end;


procedure T7BagGenerator.PreShuffle();
var
  ShuffleCount: Integer;
begin
  ShuffleCount := Hi(FRegister.Seed);

  while ShuffleCount > 0 do
  begin
    Shuffle(True);
    ShuffleCount -= 1;
  end;
end;


procedure T7BagGenerator.PerformStep();
begin
  FRegister.Step();
  FBags[FBagSwap].Swap(FRegister.Seed);
end;


procedure T7BagGenerator.PerformFixedSteps();
var
  StepsCount: Integer;
begin
  StepsCount := EnsureRange(Hi(FRegister.Seed), SEED_CUSTOM_STEP_COUNT_MIN, SEED_CUSTOM_STEP_COUNT_MAX);

  while StepsCount > 0 do
  begin
    PerformStep();
    StepsCount -= 1;
  end;
end;


procedure T7BagGenerator.Initialize();
begin
  inherited Initialize();

  FBagPick := 0;
  FBagSwap := 1;

  FBagPiece := 0;
end;


procedure T7BagGenerator.Prepare(ASeed: Integer);
begin
  inherited Prepare(ASeed);

  if FCustomSeed then
  begin
    FBags[0].Reset();
    FBags[1].Reset();
  end;

  PreShuffle();

  if FCustomSeed then
  begin
    FBagPick := 0;
    FBagSwap := 1;
  end;

  FBagPiece := 0;
end;


procedure T7BagGenerator.Shuffle(APreShuffling: Boolean);
begin
  if FCustomSeed and not APreShuffling then Exit;

  FRegister.Step();
  FBags[0].Swap(FRegister.Seed);

  FRegister.Step();
  FBags[1].Swap(FRegister.Seed);

  FBagPick := FBagPick xor 1;
  FBagSwap := FBagSwap xor 1;

  FBagPiece := (FBagPiece + 1) mod FBags[0].Size;
end;


function T7BagGenerator.Pick(): Integer;
begin
  if FCustomSeed then Step(True);

  Result := FBags[FBagPick][FBagPiece];
  FBagPiece := (FBagPiece + 1) mod FBags[FBagPick].Size;

  if FBagPiece = 0 then
  begin
    FBagPick := FBagPick xor 1;
    FBagSwap := FBagSwap xor 1;
  end;
end;


constructor TMultiBagGenerator.Create();
var
  Index: Integer;
begin
  inherited Create();

  for Index := Low(FIndexBags) to High(FIndexBags) do FIndexBags[Index] := TBag.Create(MULTIBAG_BAGS_COUNT);
  for Index := Low(FPieceBags) to High(FPieceBags) do FPieceBags[Index] := TBag.Create(MULTIBAG_BAGS[Index]);
end;


destructor TMultiBagGenerator.Destroy();
var
  Index: Integer;
begin
  for Index := Low(FIndexBags) to High(FIndexBags) do FIndexBags[Index].Free();
  for Index := Low(FPieceBags) to High(FPieceBags) do FPieceBags[Index].Free();

  inherited Destroy();
end;


procedure TMultiBagGenerator.PreShuffle();
var
  ShuffleCount: Integer;
begin
  ShuffleCount := Hi(FRegister.Seed);
  ShuffleCount *= MULTIBAG_BAGS_COUNT;

  while ShuffleCount > 0 do
  begin
    Shuffle(True);
    ShuffleCount -= 1;
  end;
end;


procedure TMultiBagGenerator.PerformStep();
var
  Index: Integer;
begin
  FRegister.Step();
  FIndexBags[FBagSwap].Swap(FRegister.Seed);

  for Index := MULTIBAG_BAG_FIRST to MULTIBAG_BAG_LAST do
    if Index <> FIndexBags[FBagPick][FIndexPick] then
    begin
      FRegister.Step();
      FPieceBags[Index].Swap(FRegister.Seed);
    end;
end;


procedure TMultiBagGenerator.PerformFixedSteps();
var
  StepsCount: Integer;
begin
  StepsCount := EnsureRange(Hi(FRegister.Seed), SEED_CUSTOM_STEP_COUNT_MIN, SEED_CUSTOM_STEP_COUNT_MAX);

  while StepsCount > 0 do
  begin
    PerformStep();
    StepsCount -= 1;
  end;
end;


procedure TMultiBagGenerator.Initialize();
begin
  inherited Initialize();

  FIndexPick := 0;

  FBagPick := MULTIBAG_BAG_FIRST;
  FBagSwap := MULTIBAG_BAG_FIRST + 1;

  FBagPiece := MULTIBAG_PIECE_FIRST;
end;


procedure TMultiBagGenerator.Prepare(ASeed: Integer);
var
  Index: Integer;
begin
  inherited Prepare(ASeed);

  if FCustomSeed then
  begin
    for Index := Low(FIndexBags) to High(FIndexBags) do FIndexBags[Index].Reset();
    for Index := Low(FPieceBags) to High(FPieceBags) do FPieceBags[Index].Reset();
  end;

  PreShuffle();

  if FCustomSeed then
  begin
    FBagPick := MULTIBAG_BAG_FIRST;
    FBagSwap := MULTIBAG_BAG_FIRST + 1;

    FBagPiece := MULTIBAG_PIECE_FIRST;
  end
  else
  begin
    FBagPick := FBagPick xor 1;
    FBagSwap := FBagSwap xor 1;
  end;

  FIndexPick := 0;
end;


procedure TMultiBagGenerator.Shuffle(APreShuffling: Boolean);
var
  Index: Integer;
begin
  if FCustomSeed and not APreShuffling then Exit;

  for Index := Low(FIndexBags) to High(FIndexBags) do
  begin
    FRegister.Step();
    FIndexBags[Index].Swap(FRegister.Seed);
  end;

  for Index := Low(FPieceBags) to High(FPieceBags) do
  begin
    FRegister.Step();
    FPieceBags[Index].Swap(FRegister.Seed);
  end;

  FIndexPick := (FIndexPick + 1) mod FIndexBags[0].Size;

  FBagPick := FBagPick xor 1;
  FBagSwap := FBagSwap xor 1;

  FBagPiece := (FBagPiece + 1) mod FPieceBags[0].Size;
end;


function TMultiBagGenerator.Pick(): Integer;
begin
  if FCustomSeed then Step(True);

  Result := FPieceBags[FIndexBags[FBagPick][FIndexPick]][FBagPiece];
  FBagPiece := (FBagPiece + 1) mod FPieceBags[0].Size;

  if FBagPiece = 0 then
  begin
    FIndexPick := (FIndexPick + 1) mod FIndexBags[0].Size;

    if FIndexPick = 0 then
    begin
      if FIndexBags[FBagPick][FIndexBags[FBagPick].Size - 1] = FIndexBags[FBagSwap][0] then
        FIndexBags[FBagSwap].SwapFirst();

      FBagPick := FBagPick xor 1;
      FBagSwap := FBagSwap xor 1;
    end;
  end;
end;


function TClassicGenerator.IndexToSpawnID(AIndex: UInt8): UInt8;
begin
  case AIndex of
    0: Result := $02;
    1: Result := $07;
    2: Result := $08;
    3: Result := $0A;
    4: Result := $0B;
    5: Result := $0E;
    6: Result := $12;
    7: Result := $02;
  otherwise
    Result := $02;
  end;
end;


function TClassicGenerator.SpawnIDToPieceID(ASpawnID: UInt8): Integer;
begin
  case ASpawnID of
    $02: Result := PIECE_T;
    $07: Result := PIECE_J;
    $08: Result := PIECE_Z;
    $0A: Result := PIECE_O;
    $0B: Result := PIECE_S;
    $0E: Result := PIECE_L;
    $12: Result := PIECE_I;
  otherwise
    Result := PIECE_T;
  end;
end;


procedure TClassicGenerator.PerformStep();
begin
  FRegister.Step();
end;


procedure TClassicGenerator.PerformFixedSteps();
var
  StepsCount: Integer;
begin
  StepsCount := EnsureRange(Hi(FRegister.Seed), SEED_CUSTOM_STEP_COUNT_MIN, SEED_CUSTOM_STEP_COUNT_MAX);

  while StepsCount > 0 do
  begin
    PerformStep();
    StepsCount -= 1;
  end;
end;


procedure TClassicGenerator.Prepare(ASeed: Integer);
begin
  inherited Prepare(ASeed);

  if FCustomSeed then
    FSpawnCount := ASeed and SEED_MASK_SPAWN_COUNTER;
end;


procedure TClassicGenerator.Shuffle(APreShuffling: Boolean = False);
begin
  if FCustomSeed and not APreShuffling then Exit;

  FRegister.Step();
end;


function TClassicGenerator.Pick(): Integer;
var
  Index: UInt8;
begin
  if FCustomSeed then Step(True);

  {$PUSH}{$RANGECHECKS OFF}
  FSpawnCount += 1;
  Index := (Hi(FRegister.Seed) + FSpawnCount) and %111;
  {$POP}

  if (Index = 7) or (IndexToSpawnID(Index) = FSpawnID) then
  begin
    FRegister.Step();
    Index := ((Hi(FRegister.Seed) and %111) + FSpawnID) mod 7;
  end;

  FSpawnID := IndexToSpawnID(Index);
  Result := SpawnIDToPieceID(FSpawnID);
end;


function TBalancedGenerator.DroughtedPiece(): Integer;
begin
  if FDrought[PIECE_I] >= BALANCED_DROUGHT_COUNT then Exit(PIECE_I);
  if FDrought[PIECE_J] >= BALANCED_DROUGHT_COUNT then Exit(PIECE_J);
  if FDrought[PIECE_L] >= BALANCED_DROUGHT_COUNT then Exit(PIECE_L);
  if FDrought[PIECE_O] >= BALANCED_DROUGHT_COUNT then Exit(PIECE_O);
  if FDrought[PIECE_S] >= BALANCED_DROUGHT_COUNT then Exit(PIECE_S);
  if FDrought[PIECE_T] >= BALANCED_DROUGHT_COUNT then Exit(PIECE_T);
  if FDrought[PIECE_Z] >= BALANCED_DROUGHT_COUNT then Exit(PIECE_Z);

  Result := PIECE_UNKNOWN;
end;


function TBalancedGenerator.FloodedPiece(APiece: Integer): Boolean;
var
  Index: Integer;
  Count: Integer = 0;
begin
  for Index := Low(FHistory) to High(FHistory) do
    if FHistory[Index] = APiece then
      Count += 1;

  Result := Count >= BALANCED_FLOOD_COUNT;
end;


procedure TBalancedGenerator.UpdateHistory(APiece: Integer);
begin
  FHistory[FHistoryIndex] := APiece;
  FHistoryIndex := WrapAround(FHistoryIndex, BALANCED_HISTORY_PIECES_COUNT, 1);
end;


procedure TBalancedGenerator.UpdateDrought(APiece: Integer);
var
  Index: Integer;
begin
  FDrought[APiece] := 0;

  for Index := High(FDrought) downto Low(FDrought) do
    if Index <> APiece then
      FDrought[Index] += 1;
end;


procedure TBalancedGenerator.PerformStep();
begin
  FRegister.Step();
end;


procedure TBalancedGenerator.PerformFixedSteps();
var
  StepsCount: Integer;
begin
  StepsCount := EnsureRange(Hi(FRegister.Seed), SEED_CUSTOM_STEP_COUNT_MIN, SEED_CUSTOM_STEP_COUNT_MAX);

  while StepsCount > 0 do
  begin
    PerformStep();
    StepsCount -= 1;
  end;
end;


procedure TBalancedGenerator.Prepare(ASeed: Integer);
begin
  inherited Prepare(ASeed);

  if FCustomSeed then
    FSpawnCount := ASeed and SEED_MASK_SPAWN_COUNTER;

  FHistory := BALANCED_HISTORY_PIECES;
  FDrought := BALANCED_DROUGHT_COUNTS;

  FHistoryIndex := 0;
end;


procedure TBalancedGenerator.Shuffle(APreShuffling: Boolean);
begin
  if FCustomSeed and not APreShuffling then Exit;

  FRegister.Step();
end;


function TBalancedGenerator.Pick(): Integer;
var
  Index: UInt8;
  Roll: Boolean;
begin
  if FCustomSeed then Step(True);

  {$PUSH}{$RANGECHECKS OFF}
  FSpawnCount += 1;
  {$POP}

  Index := DroughtedPiece();

  if Index = PIECE_UNKNOWN then
    for Roll in Boolean do
    begin
      repeat
        Index := (Hi(FRegister.Seed) + FSpawnCount) mod PIECE_LAST + PIECE_FIRST;
        FRegister.Step();
      until not FloodedPiece(Index);

      if Index <> FSpawnID then Break;
    end;

  UpdateHistory(Index);
  UpdateDrought(Index);

  FSpawnID := Index;
  Result := FSpawnID;
end;


procedure TTGMGenerator.PerformStep();
begin
  FRegister.Step();
end;


procedure TTGMGenerator.PerformFixedSteps();
var
  StepsCount: Integer;
begin
  StepsCount := EnsureRange(Hi(FRegister.Seed), SEED_CUSTOM_STEP_COUNT_MIN, SEED_CUSTOM_STEP_COUNT_MAX);

  while StepsCount > 0 do
  begin
    PerformStep();
    StepsCount -= 1;
  end;
end;


constructor TTGMGenerator.Create();
begin
  inherited Create();

  FPieces := TPool.Create(TGM_POOL_PIECES);
  FSpecial := TPool.Create(TGM_POOL_SPECIAL);
  FHistory := TPool.Create(TGM_POOL_HISTORY);
end;


destructor TTGMGenerator.Destroy();
begin
  FPieces.Free();
  FSpecial.Free();
  FHistory.Free();

  inherited Destroy();
end;


procedure TTGMGenerator.Prepare(ASeed: Integer);
begin
  inherited Prepare(ASeed);

  if FCustomSeed then
  begin
    FPieces.Reset();
    FSpecial.Reset();
  end;

  FHistory.Reset();
end;


procedure TTGMGenerator.Shuffle(APreShuffling: Boolean);
begin
  if FCustomSeed and not APreShuffling then Exit;

  FRegister.Step();
end;


function TTGMGenerator.Pick(): Integer;
var
  Roll: Integer;
begin
  if FCustomSeed then Step(True);

  if FHistory.Size = TGM_POOL_HISTORY_COUNT then
  begin
    Result := FSpecial[Hi(FRegister.Seed) mod FSpecial.Size];
    FHistory.Append(Result);
  end
  else
  begin
    for Roll := 0 to 3 do
    begin
      FRegister.Step();
      Result := FPieces[Hi(FRegister.Seed) mod FPieces.Size];

      if not FHistory.Contains(Result) then Break;
    end;

    FHistory.Push(Result);
  end;
end;


procedure TTGM3Generator.PerformStep();
begin
  FRegister.Step();
end;


procedure TTGM3Generator.PerformFixedSteps();
var
  StepsCount: Integer;
begin
  StepsCount := EnsureRange(Hi(FRegister.Seed), SEED_CUSTOM_STEP_COUNT_MIN, SEED_CUSTOM_STEP_COUNT_MAX);

  while StepsCount > 0 do
  begin
    PerformStep();
    StepsCount -= 1;
  end;
end;


constructor TTGM3Generator.Create();
begin
  inherited Create();

  FPieces := TPool.Create(TGM3_POOL_PIECES);
  FSpecial := TPool.Create(TGM3_POOL_SPECIAL);

  FPool := TPool.Create(TGM3_POOL_POOL);
  FHistory := TPool.Create(TGM3_POOL_HISTORY);

  FOrder := TPool.Create([]);
end;


destructor TTGM3Generator.Destroy();
begin
  FPieces.Free();
  FSpecial.Free();
  FPool.Free();
  FHistory.Free();
  FOrder.Free();

  inherited Destroy();
end;


procedure TTGM3Generator.Prepare(ASeed: Integer);
begin
  inherited Prepare(ASeed);

  if FCustomSeed then
  begin
    FPieces.Reset();
    FSpecial.Reset();
  end;

  FPool.Reset();
  FHistory.Reset();

  FOrder.Clear();
end;


procedure TTGM3Generator.Shuffle(APreShuffling: Boolean);
begin
  if FCustomSeed and not APreShuffling then Exit;

  FRegister.Step();
end;


function TTGM3Generator.Pick(): Integer;
var
  Roll, Index: Integer;
begin
  if FCustomSeed then Step(True);

  if FHistory.Size = TGM3_POOL_HISTORY_COUNT then
  begin
    Result := FSpecial[Hi(FRegister.Seed) mod FSpecial.Size];
    FHistory.Append(Result);
  end
  else
  begin
    for Roll := 0 to 5 do
    begin
      FRegister.Step();

      Index := Hi(FRegister.Seed) mod FPool.Size;
      Result := FPool[Index];

      if (not FHistory.Contains(Result)) or (Roll = 5) then Break;

      if not FOrder.Empty then
        FPool[Index] := FOrder[0];
    end;

    FOrder.Remove(Result);
    FOrder.Append(Result);

    FPool[Index] := FOrder[0];
    FHistory.Push(Result);
  end;
end;


function TUnfairGenerator.Pick(): Integer;
var
  Index: UInt8;
begin
  if FCustomSeed then Step(True);

  {$PUSH}{$RANGECHECKS OFF}
  FSpawnCount += 1;
  Index := (Hi(FRegister.Seed) + FSpawnCount) and %111;
  {$POP}

  if Index = 7 then
  begin
    FRegister.Step();
    Index := ((Hi(FRegister.Seed) and %111) + FSpawnID) mod 7;
  end;

  Result := SpawnIDToPieceID(IndexToSpawnID(Index));
end;


constructor TGenerators.Create();
begin
  FGenerators[GENERATOR_7_BAG]    := T7BagGenerator.Create();
  FGenerators[GENERATOR_MULTIBAG] := TMultiBagGenerator.Create();
  FGenerators[GENERATOR_CLASSIC]  := TClassicGenerator.Create();
  FGenerators[GENERATOR_BALANCED] := TBalancedGenerator.Create();
  FGenerators[GENERATOR_TGM]      := TTGMGenerator.Create();
  FGenerators[GENERATOR_TGM3]     := TTGM3Generator.Create();
  FGenerators[GENERATOR_UNFAIR]   := TUnfairGenerator.Create();
end;


function TGenerators.GetGenerator(AGeneratorID: Integer): IGenerable;
begin
  Result := FGenerators[AGeneratorID];
end;


procedure TGenerators.SetGeneratorID(AGeneratorID: Integer);
begin
  FGeneratorID := AGeneratorID;
  FGenerator := FGenerators[FGeneratorID];
end;


procedure TGenerators.Initialize();
var
  Index: Integer;
begin
  SetGeneratorID(Settings.General.Generator);

  for Index := Low(FGenerators) to High(FGenerators) do
    FGenerators[Index].Initialize();
end;


procedure TGenerators.Shuffle();
var
  Index: Integer;
begin
  for Index := Low(FGenerators) to High(FGenerators) do
    FGenerators[Index].Shuffle();
end;


end.

