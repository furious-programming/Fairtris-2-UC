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

unit Fairtris.Core;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  Fairtris.Memory;


type
  TCore = class(TObject)
  private
    function CanPlacePiece(): Boolean;
    function CanDropPiece(): Boolean;
    function CanShiftPiece(ADirection: Integer): Boolean;
    function CanRotatePiece(ADirection: Integer): Boolean;
  private
    function CanClearLine(AIndex: Integer): Boolean;
    function CanLowerStack(AIndex: Integer): Boolean;
  private
    procedure SpawnPiece();
    procedure PlacePiece();
    procedure DropPiece();
    procedure ShiftPiece(ADirection: Integer);
    procedure RotatePiece(ADirection: Integer);
  private
    procedure ClearLine(AIndex: Integer);
    procedure LowerStack(AIndex: Integer);
  private
    procedure UpdatePieceControlDropControl();
    procedure UpdatePieceControlDropAutorepeat();
    procedure UpdatePieceControlDropUpPressed();
    procedure UpdatePieceControlDropDownPressed();
    procedure UpdatePieceControlDropMove();
    procedure UpdatePieceControlDropLookupSpeed();
  private
    procedure UpdatePieceControlRotateModern();
    procedure UpdatePieceControlRotateClassic();
  private
    procedure UpdatePieceControlShift();
    procedure UpdatePieceControlRotate();
    procedure UpdatePieceControlDrop();
  private
    procedure UpdateCommonGain();
    procedure UpdateCommonNext();
    procedure UpdateCommonSpeedrun();
  private
    procedure UpdateCommon();
    procedure UpdatePieceControl();
    procedure UpdatePieceLock();
    procedure UpdatePieceSpawn();
    procedure UpdateLinesCheck();
    procedure UpdateLinesClear();
    procedure UpdateStackLower();
    procedure UpdateCounters();
    procedure UpdateTopOut();
  public
    procedure Reset();
    procedure Update();
  end;


var
  Core: TCore;


implementation

uses
  Math,
  Fairtris.Clock,
  Fairtris.Input,
  Fairtris.Sounds,
  Fairtris.BestScores,
  Fairtris.Generators,
  Fairtris.Converter,
  Fairtris.Utils,
  Fairtris.Arrays,
  Fairtris.Constants;


function TCore.CanPlacePiece(): Boolean;
var
  LayoutX, LayoutY: Integer;
begin
  for LayoutY := -2 to 2 do
  begin
    if Memory.Game.PieceY + LayoutY < -2 then Continue;
    if Memory.Game.PieceY + LayoutY > 19 then Continue;

    for LayoutX := -2 to 2 do
    begin
      if Memory.Game.PieceX + LayoutX < 0 then Continue;
      if Memory.Game.PieceX + LayoutX > 9 then Continue;

      if PIECE_LAYOUT[Memory.Game.PieceID, Memory.Game.PieceOrientation, LayoutY, LayoutX] <> BRICK_EMPTY then
        if Memory.Game.Stack[Memory.Game.PieceX + LayoutX, Memory.Game.PieceY + LayoutY] <> BRICK_EMPTY then
          Exit(False);
    end;
  end;

  Result := True;
end;


function TCore.CanDropPiece(): Boolean;
begin
  Result := Memory.Game.PieceY < PIECE_DROP_Y_MAX[Memory.Game.PieceID, Memory.Game.PieceOrientation];

  if Result then
  begin
    Memory.Game.PieceY += 1;
    Result := CanPlacePiece();
    Memory.Game.PieceY -= 1;
  end;
end;


function TCore.CanShiftPiece(ADirection: Integer): Boolean;
begin
  Result := False;

  case ADirection of
    PIECE_SHIFT_LEFT:  Result := Memory.Game.PieceX > PIECE_SHIFT_X_MIN[Memory.Game.PieceID, Memory.Game.PieceOrientation];
    PIECE_SHIFT_RIGHT: Result := Memory.Game.PieceX < PIECE_SHIFT_X_MAX[Memory.Game.PieceID, Memory.Game.PieceOrientation];
  end;

  if Result then
  begin
    Memory.Game.PieceX += ADirection;
    Result := CanPlacePiece();
    Memory.Game.PieceX -= ADirection;
  end;
end;


function TCore.CanRotatePiece(ADirection: Integer): Boolean;
var
  OldPosition, OldOrientation: Integer;
begin
  if Memory.Game.PieceID = PIECE_O then Exit(False);

  OldPosition := Memory.Game.PieceX;
  OldOrientation := Memory.Game.PieceOrientation;

  Memory.Game.PieceOrientation := WrapAround(Memory.Game.PieceOrientation, PIECE_ORIENTATION_COUNT, ADirection);

  if Memory.Options.Controls = CONTROLS_CLASSIC then
  begin
    Result := (Memory.Game.PieceX >= PIECE_ROTATION_X_MIN[Memory.Game.PieceID, Memory.Game.PieceOrientation]) and
              (Memory.Game.PieceX <= PIECE_ROTATION_X_MAX[Memory.Game.PieceID, Memory.Game.PieceOrientation]) and
              (Memory.Game.PieceY <= PIECE_ROTATION_Y_MAX[Memory.Game.PieceID, Memory.Game.PieceOrientation]);

    if Result then
      Result := CanPlacePiece();
  end
  else
    if Memory.Game.PieceY <= PIECE_ROTATION_Y_MAX[Memory.Game.PieceID, Memory.Game.PieceOrientation] then
    begin
      Memory.Game.PieceX := Max(Memory.Game.PieceX, PIECE_ROTATION_X_MIN[Memory.Game.PieceID, Memory.Game.PieceOrientation]);
      Memory.Game.PieceX := Min(Memory.Game.PieceX, PIECE_ROTATION_X_MAX[Memory.Game.PieceID, Memory.Game.PieceOrientation]);

      Result := CanPlacePiece();
    end
    else
      Result := False;

  Memory.Game.PieceX := OldPosition;
  Memory.Game.PieceOrientation := OldOrientation;
end;


function TCore.CanClearLine(AIndex: Integer): Boolean;
var
  BrickX: Integer;
begin
  if AIndex <  0 then Exit(False);
  if AIndex > 19 then Exit(False);

  for BrickX := 0 to 9 do
    if Memory.Game.Stack[BrickX, AIndex] = BRICK_EMPTY then
      Exit(False);

  Result := True;
end;


function TCore.CanLowerStack(AIndex: Integer): Boolean;
begin
  Result := Memory.Game.ClearPermits[AIndex];
end;


procedure TCore.SpawnPiece();
begin
  Memory.Game.PieceID := Memory.Game.Next;
  Memory.Game.PieceOrientation := PIECE_ORIENTATION_SPAWN;

  Memory.Game.Next := Generators.Generator.Pick();
  Memory.Game.Stats[Memory.Game.PieceID] += 1;

  Memory.Game.PieceX := PIECE_SPAWN_X;
  Memory.Game.PieceY := PIECE_SPAWN_Y;

  Memory.Game.AutorepeatY := 0;
end;


procedure TCore.PlacePiece();
var
  LayoutX, LayoutY: Integer;
begin
  for LayoutY := -2 to 2 do
  begin
    if Memory.Game.PieceY + LayoutY < -2 then Continue;
    if Memory.Game.PieceY + LayoutY > 19 then Continue;

    for LayoutX := -2 to 2 do
    begin
      if Memory.Game.PieceX + LayoutX < 0 then Continue;
      if Memory.Game.PieceX + LayoutX > 9 then Continue;

      if PIECE_LAYOUT[Memory.Game.PieceID, Memory.Game.PieceOrientation, LayoutY, LayoutX] <> BRICK_EMPTY then
        Memory.Game.Stack[
          Memory.Game.PieceX + LayoutX,
          Memory.Game.PieceY + LayoutY
        ] := PIECE_LAYOUT[
          Memory.Game.PieceID,
          Memory.Game.PieceOrientation,
          LayoutY,
          LayoutX
        ];
    end;
  end;
end;


procedure TCore.DropPiece();
begin
  Memory.Game.PieceY += 1;
end;


procedure TCore.ShiftPiece(ADirection: Integer);
begin
  Memory.Game.PieceX += ADirection;
end;


procedure TCore.RotatePiece(ADirection: Integer);
begin
  Memory.Game.PieceOrientation := WrapAround(Memory.Game.PieceOrientation, PIECE_ORIENTATION_COUNT, ADirection);

  if Memory.Options.Controls = CONTROLS_MODERN then
  begin
    Memory.Game.PieceX := Max(Memory.Game.PieceX, PIECE_ROTATION_X_MIN[Memory.Game.PieceID, Memory.Game.PieceOrientation]);
    Memory.Game.PieceX := Min(Memory.Game.PieceX, PIECE_ROTATION_X_MAX[Memory.Game.PieceID, Memory.Game.PieceOrientation]);
  end;
end;


procedure TCore.ClearLine(AIndex: Integer);
begin
  Memory.Game.Stack[Memory.Game.ClearColumn, AIndex] := BRICK_EMPTY;
  Memory.Game.Stack[9 - Memory.Game.ClearColumn, AIndex] := BRICK_EMPTY;
end;


procedure TCore.LowerStack(AIndex: Integer);
var
  BrickX, BrickY, LineIndex: Integer;
begin
  for BrickY := AIndex - 1 downto 0 do
    for BrickX := 0 to 9 do
      Memory.Game.Stack[BrickX, BrickY + 1] := Memory.Game.Stack[BrickX, BrickY];

  for BrickY := -2 to 0 do
    for BrickX := 0 to 9 do
      Memory.Game.Stack[BrickX, BrickY] := BRICK_EMPTY;

  for LineIndex := Memory.Game.LowerTimer - 1 downto -2 do
    if Memory.Game.ClearPermits[LineIndex] then
      Memory.Game.ClearIndexes[LineIndex] += 1;
end;


procedure TCore.UpdatePieceControlDropControl();
begin
  if Input.Device.Left.Pressed or Input.Device.Right.Pressed then
    UpdatePieceControlDropLookupSpeed()
  else
  begin
    case Memory.Options.Controls of
      CONTROLS_MODERN:  if Input.Device.Down.Pressed     then Memory.Game.AutorepeatY := 1;
      CONTROLS_CLASSIC: if Input.Device.Down.JustPressed then Memory.Game.AutorepeatY := 1;
    end;

    UpdatePieceControlDropLookupSpeed();
  end;
end;


procedure TCore.UpdatePieceControlDropAutorepeat();
begin
  if Input.Device.Down.Pressed and Input.Device.Left.Released and Input.Device.Right.Released then
    UpdatePieceControlDropDownPressed()
  else
  begin
    Memory.Game.AutorepeatY := 0;
    Memory.Game.FallPoints := 0;

    UpdatePieceControlDropLookupSpeed();
  end;
end;


procedure TCore.UpdatePieceControlDropUpPressed();
begin
  Memory.Game.AutorepeatY := 0;

  Memory.Game.FallTimer := 0;
  Memory.Game.FallPoints := 0;

  while CanDropPiece() do
  begin
    UpdatePieceControlDropMove();
    Memory.Game.FallPoints += 1;
  end;

  UpdatePieceControlDropMove();
  Memory.Game.FallSkipped := True;
end;


procedure TCore.UpdatePieceControlDropDownPressed();
begin
  Memory.Game.AutorepeatY += 1;

  if Memory.Game.AutorepeatY < 3 then
    UpdatePieceControlDropLookupSpeed()
  else
  begin
    Memory.Game.AutorepeatY := 1;
    Memory.Game.FallPoints += 1;

    UpdatePieceControlDropMove();
  end;
end;


procedure TCore.UpdatePieceControlDropMove();
begin
  Memory.Game.FallTimer := 0;

  if CanDropPiece() then
    DropPiece()
  else
  begin
    PlacePiece();

    Memory.Game.State := STATE_LINES_CHECK;
    Memory.Game.ClearCount := 0;
    Memory.Game.ClearTimer := 0;
    Memory.Game.ClearColumn := 4;
  end;
end;


procedure TCore.UpdatePieceControlDropLookupSpeed();
begin
  Memory.Game.FallTimer += 1;
  Memory.Game.FallSpeed := 1;

  if Memory.Game.Level < LEVEL_LAST_FREE_GAME then
    Memory.Game.FallSpeed := AUTOFALL_FRAMES[Memory.GameModes.Region, Memory.Game.Level];

  if Memory.Game.FallTimer >= Memory.Game.FallSpeed then
    UpdatePieceControlDropMove();
end;


procedure TCore.UpdatePieceControlRotateModern();
var
  Rotation: Integer;
begin
  if Input.Device.B.JustPressed and Input.Device.A.JustPressed then Exit;

  if Input.Device.B.JustReleased or Input.Device.A.JustReleased then
    Memory.Game.AutospinCharged := False;

  if Input.Device.B.JustPressed or Memory.Game.AutospinCharged then
  begin
    Rotation := IfThen(Memory.Game.AutospinCharged, Memory.Game.AutospinRotation, PIECE_ROTATE_COUNTERCLOCKWISE);

    if CanRotatePiece(Rotation) then
    begin
      RotatePiece(Rotation);
      Sounds.PlaySound(SOUND_SPIN);

      Memory.Game.AutospinCharged := False;
    end
    else
    begin
      Memory.Game.AutospinCharged := True;
      Memory.Game.AutospinRotation := Rotation;
    end;
  end;

  if Input.Device.A.JustPressed or Memory.Game.AutospinCharged then
  begin
    Rotation := IfThen(Memory.Game.AutospinCharged, Memory.Game.AutospinRotation, PIECE_ROTATE_CLOCKWISE);

    if CanRotatePiece(Rotation) then
    begin
      RotatePiece(Rotation);
      Sounds.PlaySound(SOUND_SPIN);

      Memory.Game.AutospinCharged := False;
    end
    else
    begin
      Memory.Game.AutospinCharged := True;
      Memory.Game.AutospinRotation := Rotation;
    end;
  end;
end;


procedure TCore.UpdatePieceControlRotateClassic();
begin
  if Input.Device.B.JustPressed then
    if CanRotatePiece(PIECE_ROTATE_COUNTERCLOCKWISE) then
    begin
      RotatePiece(PIECE_ROTATE_COUNTERCLOCKWISE);
      Sounds.PlaySound(SOUND_SPIN);

      Exit;
    end;

  if Input.Device.A.JustPressed then
    if CanRotatePiece(PIECE_ROTATE_CLOCKWISE) then
    begin
      RotatePiece(PIECE_ROTATE_CLOCKWISE);
      Sounds.PlaySound(SOUND_SPIN);
    end;
end;


procedure TCore.UpdatePieceControlShift();
begin
  if Input.Device.Down.Pressed then Exit;

  if Input.Device.Left.Pressed and Input.Device.Right.Pressed then Exit;
  if Input.Device.Left.Released and Input.Device.Right.Released then Exit;

  if Input.Device.Left.JustPressed or Input.Device.Right.JustPressed then
    Memory.Game.AutorepeatX := 0
  else
  begin
    Memory.Game.AutorepeatX += 1;

    if Memory.Game.AutorepeatX < AUTOSHIFT_FRAMES_CHARGE[Memory.GameModes.Region] then
      Exit
    else
      Memory.Game.AutorepeatX := AUTOSHIFT_FRAMES_PRECHARGE[Memory.GameModes.Region];
  end;

  if Input.Device.Left.Pressed then
    if CanShiftPiece(PIECE_SHIFT_LEFT) then
    begin
      ShiftPiece(PIECE_SHIFT_LEFT);
      Sounds.PlaySound(SOUND_SHIFT);
    end
    else
      Memory.Game.AutorepeatX := AUTOSHIFT_FRAMES_CHARGE[Memory.GameModes.Region];

  if Input.Device.Right.Pressed then
    if CanShiftPiece(PIECE_SHIFT_RIGHT) then
    begin
      ShiftPiece(PIECE_SHIFT_RIGHT);
      Sounds.PlaySound(SOUND_SHIFT);
    end
    else
      Memory.Game.AutorepeatX := AUTOSHIFT_FRAMES_CHARGE[Memory.GameModes.Region];
end;


procedure TCore.UpdatePieceControlRotate();
begin
  if Memory.Options.Controls = CONTROLS_MODERN then
    UpdatePieceControlRotateModern()
  else
    UpdatePieceControlRotateClassic();
end;


procedure TCore.UpdatePieceControlDrop();
begin
  if Memory.Options.Controls = CONTROLS_MODERN then
    if Input.Device.Left.Released and Input.Device.Right.Released then
      if Input.Device.Up.JustPressed or (Input.Device.Up.Pressed and (Input.Device.Left.JustReleased or Input.Device.Right.JustReleased)) then
      begin
        UpdatePieceControlDropUpPressed();
        Exit;
      end;

  if Memory.Game.AutorepeatY > 0 then
    UpdatePieceControlDropAutorepeat()
  else
    if Memory.Game.AutorepeatY = 0 then
      UpdatePieceControlDropControl()
    else
      if not Input.Device.Down.JustPressed then
        Memory.Game.AutorepeatY += 1
      else
      begin
        Memory.Game.AutorepeatY := 0;
        UpdatePieceControlDropControl();
      end;
end;


procedure TCore.UpdateCommonGain();
begin
  if Memory.Game.GainTimer > 0 then
    Memory.Game.GainTimer -= 1;
end;


procedure TCore.UpdateCommonNext();
begin
  if Input.Device.Select.JustPressed then
    if Memory.Game.State <> STATE_UPDATE_TOP_OUT then
      if Memory.GameModes.IsFreeGame then
      begin
        Memory.Game.NextVisible := not Memory.Game.NextVisible;
        Sounds.PlaySound(SOUND_COIN);
      end
      else
        Sounds.PlaySound(SOUND_HUM);
end;


procedure TCore.UpdateCommonSpeedrun();
begin
  if not Memory.GameModes.IsSpeedrun then Exit;

  if Memory.Game.State <> STATE_UPDATE_TOP_OUT then
  begin
    Memory.Game.SpeedrunTimer += 1;

    if Converter.IsTimeTooLong(Memory.Game.SpeedrunTimer) then
    begin
      Memory.Game.SpeedrunTimer -= 1;

      Memory.Game.State := STATE_UPDATE_TOP_OUT;
      Memory.Game.TopOutTimer := TOP_OUT_FRAMES[False, Memory.GameModes.Region];

      Sounds.PlaySound(SOUND_TOP_OUT, True);
    end;
  end;
end;


procedure TCore.UpdateCommon();
begin
  Generators.Generator.Step();

  UpdateCommonGain();
  UpdateCommonNext();
  UpdateCommonSpeedrun();
end;


procedure TCore.UpdatePieceControl();
begin
  UpdatePieceControlShift();
  UpdatePieceControlRotate();
  UpdatePieceControlDrop();
end;


procedure TCore.UpdatePieceLock();
begin
  Memory.Game.LockTimer -= 1;

  if Memory.Game.LockTimer = 0 then
  begin
    Memory.Game.State := STATE_UPDATE_COUNTERS;
    Memory.Game.ClearCount := 0;
    Memory.Game.ClearTimer := 0;

    Sounds.PlaySound(SOUND_DROP);
  end;
end;


procedure TCore.UpdatePieceSpawn();
begin
  SpawnPiece();

  Memory.Game.AutospinCharged := False;
  Memory.Game.FallPoints := 0;

  if Memory.Options.Controls = CONTROLS_MODERN then
    Memory.Game.AutorepeatX := AUTOSHIFT_FRAMES_CHARGE[Memory.GameModes.Region];

  if CanPlacePiece() then
    Memory.Game.State := STATE_PIECE_CONTROL
  else
  begin
    Memory.Game.State := STATE_UPDATE_TOP_OUT;
    Memory.Game.TopOutTimer := TOP_OUT_FRAMES[False, Memory.GameModes.Region];

    Sounds.PlaySound(SOUND_TOP_OUT, True);
  end;
end;


procedure TCore.UpdateLinesCheck();
var
  Index: Integer;
begin
  for Index := -2 to 1 do
  begin
    Memory.Game.ClearPermits[Index] := CanClearLine(Memory.Game.PieceY + Index);

    if Memory.Game.ClearPermits[Index] then
    begin
      Memory.Game.ClearIndexes[Index] := Memory.Game.PieceY + Index;
      Memory.Game.ClearCount += 1;
    end;
  end;

  if Memory.Game.ClearCount > 0 then
  begin
    Memory.Game.State := STATE_LINES_CLEAR;
    Memory.Game.PieceID := PIECE_UNKNOWN;
  end
  else
  begin
    Memory.Game.State := STATE_PIECE_LOCK;
    Memory.Game.LockRow := Memory.Game.PieceY;
    Memory.Game.LockTimer := PIECE_FRAMES_LOCK_DELAY[Memory.Game.LockRow];
  end;
end;


procedure TCore.UpdateLinesClear();
var
  Index: Integer;
begin
  if Memory.Game.ClearCount = 4 then
    Memory.Game.Flashing := Memory.Game.ClearTimer mod 4 = 0;

  Memory.Game.ClearTimer += 1;

  if Memory.Game.ClearTimer = 8 then
    if Memory.Game.ClearCount = 4 then
      Sounds.PlaySound(SOUND_TETRIS)
    else
      Sounds.PlaySound(SOUND_BURN);

  if Memory.Game.ClearTimer mod 4 = 0 then
  begin
    for Index := -2 to 1 do
      if Memory.Game.ClearPermits[Index] then
        ClearLine(Memory.Game.ClearIndexes[Index]);

    Memory.Game.ClearColumn -= 1;

    if Memory.Game.ClearColumn < 0 then
    begin
      Memory.Game.State := STATE_UPDATE_COUNTERS;
      Memory.Game.Flashing := False;
    end;
  end;
end;


procedure TCore.UpdateStackLower();
begin
  if Memory.Game.LowerTimer >= -2 then
  begin
    if Memory.Game.ClearCount > 0 then
      if CanLowerStack(Memory.Game.LowerTimer) then
        LowerStack(Memory.Game.ClearIndexes[Memory.Game.LowerTimer]);

    Memory.Game.LowerTimer -= 1;
  end
  else
    if not Memory.GameModes.HasHardKillScreen or not Memory.Game.AfterHardKillScreen then
      Memory.Game.State := STATE_PIECE_SPAWN
    else
    begin
      Memory.Game.State := STATE_UPDATE_TOP_OUT;
      Memory.Game.TopOutTimer := TOP_OUT_FRAMES[True, Memory.GameModes.Region];
    end;
end;


procedure TCore.UpdateCounters();
var
  Gain: Integer;
var
  HappenedKillScreen: Boolean = False;
  HappenedLaterTransition: Boolean = False;
  HappenedFirstTransition: Boolean = False;
begin
  if Memory.Game.ClearCount > 0 then
  begin
    if not Memory.Game.AfterTransition then
      if Memory.Game.Lines + Memory.Game.ClearCount >= TRANSITION_LINES[Memory.GameModes.Region, Memory.GameModes.Level] then
        HappenedFirstTransition := True;

    if Memory.Game.AfterTransition then
    begin
      if (Memory.Game.Lines div 10) <> ((Memory.Game.Lines + Memory.Game.ClearCount) div 10) then
        HappenedLaterTransition := True;

      if HappenedLaterTransition then
      begin
        if Memory.Game.Lines + Memory.Game.ClearCount >= KILLSCREEN_LINES[Memory.GameModes.Region, Memory.GameModes.Level] then
          HappenedKillScreen := True;

        if Memory.GameModes.IsSpeedrun or (Memory.GameModes.IsMarathon and Memory.GameModes.IsMatch) then
        begin
          if Memory.GameModes.IsMarathon and Memory.GameModes.IsMatch then
            if Memory.Game.Lines + Memory.Game.ClearCount >= KILLSCREEN_LINES_MARATHON[Memory.GameModes.Region, Memory.GameModes.Level] then
              Memory.Game.AfterHardKillScreen := True;

          if Memory.GameModes.IsSpeedrun then
            if Memory.Game.Lines + Memory.Game.ClearCount >= KILLSCREEN_LINES_SPEEDRUN then
            begin
              Memory.Game.AfterHardKillScreen := True;
              Memory.Game.SpeedrunCompleted := True;
            end;
        end;
      end;
    end;

    if HappenedFirstTransition then
      Memory.Game.AfterTransition := True;

    if HappenedFirstTransition or HappenedLaterTransition then
    begin
      Memory.Game.Level += 1;

      if Memory.Game.AfterHardKillScreen then
        Sounds.PlaySound(SOUND_SUCCESS, True)
      else
        Sounds.PlaySound(SOUND_TRANSITION, True);
    end;

    Memory.Game.Lines += Memory.Game.ClearCount;
    Memory.Game.LinesCleared := Memory.Game.Lines;
    Memory.Game.LineClears[Memory.Game.ClearCount] += 1;

    if HappenedKillScreen then
      Memory.Game.AfterKillScreen := True;

    if Memory.Game.ClearCount = 4 then
      Memory.Game.Burned := 0
    else
    begin
      Memory.Game.Burned += Memory.Game.ClearCount;
      Memory.Game.LinesBurned += Memory.Game.ClearCount;
    end;

    if not Memory.Game.AfterKillScreen then
      Memory.Game.TetrisRate := Round((Memory.Game.LinesCleared - Memory.Game.LinesBurned) / Memory.Game.Lines * 100);
  end;

  Gain := Memory.Game.FallPoints;
  Gain += (Memory.Game.Level + 1) * LINECLEAR_VALUE[Memory.Game.ClearCount];

  Memory.Game.Score += Gain;

  if Gain > 0 then
  begin
    Memory.Game.Gain := Gain;
    Memory.Game.GainTimer := DURATION_GAIN_VISIBLE * Clock.FrameRateLimit;
  end;

  if HappenedFirstTransition or HappenedLaterTransition then
  begin
    if (Memory.GameModes.Level < 19) and (Memory.Game.Level = 19) then Memory.Game.Transition := Memory.Game.Score;
    if (Memory.GameModes.Level = 19) and (Memory.Game.Level = 20) then Memory.Game.Transition := Memory.Game.Score;
  end;

  if Memory.Game.FallSkipped then
  begin
    Memory.Game.FallPoints := 0;
    Memory.Game.FallSkipped := False;
  end;

  Memory.Game.State := STATE_STACK_LOWER;
  Memory.Game.LowerTimer := 1;
end;


procedure TCore.UpdateTopOut();
begin
  if Memory.Game.TopOutTimer > 0 then
    Memory.Game.TopOutTimer -= 1
  else
    if Input.Device.Start.JustPressed then
    begin
      Memory.Game.Ended := True;
      Sounds.PlaySound(SOUND_START);
    end;
end;


procedure TCore.Reset();
var
  InitialSeed: Integer = SEED_USE_RANDOM;
begin
  if Memory.GameModes.IsMatch then
    InitialSeed := Converter.StringToSeed(Memory.GameModes.SeedData);

  Memory.Game.Reset();
  Memory.Game.Started := True;
  Memory.Game.AutorepeatY := PIECE_FRAMES_HANG[Memory.GameModes.Region];

  Generators.Generator.Prepare(InitialSeed);
  Generators.Generator.Step();
  Memory.Game.PieceID := Generators.Generator.Pick();

  Generators.Generator.Step();
  Memory.Game.Next := Generators.Generator.Pick();

  if Memory.GameModes.IsSpeedrun then
    Memory.GameModes.Level := 0;

  Memory.Game.Level := Memory.GameModes.Level;
  Memory.Game.Stats[Memory.Game.PieceID] += 1;

  if Memory.GameModes.IsQuals then
    Memory.Game.Best := BestScores.Quals
      [Memory.GameModes.IsSpeedrun]
      [Memory.GameModes.Region]
      [Memory.GameModes.Generator].BestResult
  else
    if Memory.GameModes.IsMatch then
      Memory.Game.Best := BestScores.Match
        [Memory.GameModes.IsSpeedrun]
        [Memory.GameModes.Region]
        [Memory.GameModes.Generator].BestResult
    else
      Memory.Game.Best := BestScores
        [Memory.GameModes.IsSpeedrun]
        [Memory.GameModes.Region]
        [Memory.GameModes.Generator].BestResult;

  if not Memory.GameModes.IsFreeGame then
    Memory.Game.NextVisible := True;
end;


procedure TCore.Update();
begin
  UpdateCommon();

  case Memory.Game.State of
    STATE_PIECE_CONTROL:   UpdatePieceControl();
    STATE_PIECE_LOCK:      UpdatePieceLock();
    STATE_PIECE_SPAWN:     UpdatePieceSpawn();
    STATE_LINES_CHECK:     UpdateLinesCheck();
    STATE_LINES_CLEAR:     UpdateLinesClear();
    STATE_STACK_LOWER:     UpdateStackLower();
    STATE_UPDATE_COUNTERS: UpdateCounters();
    STATE_UPDATE_TOP_OUT:  UpdateTopOut();
  end;
end;


end.

