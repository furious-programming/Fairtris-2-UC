
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

unit Fairtris.Renderer;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  SDL2,
  Fairtris.Interfaces,
  Fairtris.BestScores,
  Fairtris.Constants;


type
  TRenderer = class(TObject)
  private
    function CharToIndex(AChar: Char): Integer;
  private
    function MarathonEntryToString(AEntry: TScoreEntry = nil): String;
  private
    procedure RenderSprite(ASprite: PSDL_Texture; ABufferRect, ASpriteRect: TSDL_Rect);
    procedure RenderText(AX, AY: Integer; const AText: String; AColor: Integer = COLOR_WHITE; AAlign: Integer = ALIGN_LEFT);
    procedure RenderNext(AX, AY, APiece, ALevel: Integer);
    procedure RenderBrick(AX, AY, ABrick, ALevel: Integer);
    procedure RenderButton(AX, AY, AButton: Integer);
  private
    procedure RenderGround();
  private
    procedure RenderMenuSelection();
  private
    procedure RenderLobbySelection();
    procedure RenderLobbyItems();
    procedure RenderLobbyParameters();
    procedure RenderLobbyBestScores();
  private
    procedure RenderGameTop();
    procedure RenderGameBurned();
    procedure RenderGameTetrises();
    procedure RenderGameGain();
    procedure RenderGameController();
    procedure RenderGameStack();
    procedure RenderGamePiece();
    procedure RenderGameScore();
    procedure RenderGameLines();
    procedure RenderGameLevel();
    procedure RenderGameNext();
  private
    procedure RenderPauseSelection();
    procedure RenderPauseItems();
  private
    procedure RenderTopOutResultScore();
    procedure RenderTopOutResultTransition();
    procedure RenderTopOutResultLinesCleared();
    procedure RenderTopOutResultLinesBurned();
    procedure RenderTopOutResultTetrisRate();
  private
    procedure RenderTopOutSelection();
    procedure RenderTopOutItems();
    procedure RenderTopOutResult();
  private
    procedure RenderOptionsSelection();
    procedure RenderOptionsItems();
    procedure RenderOptionsParameters();
  private
    procedure RenderKeyboardItemSelection();
    procedure RenderKeyboardItems();
    procedure RenderKeyboardKeySelection();
    procedure RenderKeyboardKeyScanCodes();
  private
    procedure RenderControllerItemSelection();
    procedure RenderControllerItems();
    procedure RenderControllerButtonSelection();
    procedure RenderControllerButtonScanCodes();
  private
    procedure RenderLegal();
    procedure RenderMenu();
    procedure RenderLobby();
    procedure RenderGame();
    procedure RenderPause();
    procedure RenderTopOut();
    procedure RenderOptions();
    procedure RenderKeyboard();
    procedure RenderController();
    procedure RenderBSoD();
    procedure RenderQuit();
  private
    procedure RenderBegin();
    procedure RenderEnd();
  public
    procedure RenderScene();
  end;


var
  Renderer: TRenderer;


implementation

uses
  Math,
  SysUtils,
  StrUtils,
  Fairtris.Window,
  Fairtris.Clock,
  Fairtris.Input,
  Fairtris.Buffers,
  Fairtris.Memory,
  Fairtris.Logic,
  Fairtris.Placement,
  Fairtris.Converter,
  Fairtris.Grounds,
  Fairtris.Sprites,
  Fairtris.Utils,
  Fairtris.Arrays;


function TRenderer.CharToIndex(AChar: Char): Integer;
begin
  case AChar of
    'A' .. 'Z': Result := Ord(AChar) - 64;
    '0' .. '9': Result := Ord(AChar) - 21;
    ',': Result := 37;
    '/': Result := 38;
    '(': Result := 39;
    ')': Result := 40;
    '"': Result := 41;
    '.': Result := 42;
    '-': Result := 43;
    '%': Result := 44;
    '>': Result := 45;
    ':': Result := 46;
    '_': Result := 47;
  otherwise
    Result := 0;
  end;
end;


function TRenderer.MarathonEntryToString(AEntry: TScoreEntry): String;
begin
  if AEntry <> nil then
  begin
    Result := '%.3d'.Format([AEntry.LinesCleared]);
    Result += '%.2d'.Format([AEntry.LevelBegin]).PadLeft(4) + '-' + '%.2d'.Format([AEntry.LevelEnd]);

    Result += Converter.TetrisesToString(AEntry.TetrisRate).PadLeft(5);
    Result += Converter.ScoreToString(AEntry.TotalScore).PadLeft(9);
  end
  else
    Result := '-    -        -        -';
end;


procedure TRenderer.RenderSprite(ASprite: PSDL_Texture; ABufferRect, ASpriteRect: TSDL_Rect);
begin
  SDL_RenderCopy(Window.Renderer, ASprite, @ASpriteRect, @ABufferRect);
end;


procedure TRenderer.RenderText(AX, AY: Integer; const AText: String; AColor: Integer; AAlign: Integer);
var
  Character: Char;
  CharIndex: Integer;
var
  BufferRect, CharRect: TSDL_Rect;
begin
  SDL_SetTextureColorMod(Sprites.Charset, GetR(AColor), GetG(AColor), GetB(AColor));

  CharRect := SDL_Rect(0, 0, CHAR_WIDTH, CHAR_HEIGHT);
  BufferRect := SDL_Rect(AX, AY, CHAR_WIDTH, CHAR_HEIGHT);

  if AAlign = ALIGN_RIGHT then
    BufferRect.X -= AText.Length * CHAR_WIDTH;

  for Character in AText do
  begin
    CharIndex := CharToIndex(UpCase(Character));
    CharRect.X := CharIndex * CHAR_WIDTH;

    SDL_RenderCopy(Window.Renderer, Sprites.Charset, @CharRect, @BufferRect);
    BufferRect.X += CHAR_WIDTH;
  end;

  SDL_SetTextureColorMod(Sprites.Charset, 255, 255, 255);
end;


procedure TRenderer.RenderNext(AX, AY, APiece, ALevel: Integer);
var
  Pieces: PSDL_Texture;
begin
  if APiece <> PIECE_UNKNOWN then
  begin
    ALevel := ALevel and $FF;

    if ALevel < LEVEL_GLITCHED then
    begin
      ALevel := ALevel mod 10;
      Pieces := Sprites.Pieces;
    end
    else
    begin
      ALevel -= LEVEL_GLITCHED;
      Pieces := Sprites.PiecesGlitched;
    end;

    RenderSprite(
      Pieces,
      SDL_Rect(
        AX,
        AY,
        PIECE_WIDTH,
        PIECE_HEIGHT
      ),
      SDL_Rect(
        APiece * PIECE_WIDTH,
        ALevel * PIECE_HEIGHT,
        PIECE_WIDTH,
        PIECE_HEIGHT
      )
    );
  end;
end;


procedure TRenderer.RenderBrick(AX, AY, ABrick, ALevel: Integer);
var
  Bricks: PSDL_Texture;
begin
  if ABrick = BRICK_EMPTY then Exit;
  begin
    ALevel := ALevel and $FF;

    if ALevel < LEVEL_GLITCHED then
    begin
      ALevel := ALevel mod 10;
      Bricks := Sprites.Bricks;
    end
    else
    begin
      ALevel -= LEVEL_GLITCHED;
      Bricks := Sprites.BricksGlitched;
    end;

    RenderSprite(
      Bricks,
      SDL_Rect(
        AX,
        AY,
        BRICK_WIDTH,
        BRICK_HEIGHT
      ),
      SDL_Rect(
        ABrick * BRICK_WIDTH,
        ALevel * BRICK_HEIGHT,
        BRICK_WIDTH,
        BRICK_HEIGHT
      )
    );
  end;
end;


procedure TRenderer.RenderButton(AX, AY, AButton: Integer);
begin
  RenderSprite(
    Sprites.Controller,
    SDL_Rect(
      AX,
      AY,
      THUMBNAIL_BUTTON_WIDTH[AButton],
      THUMBNAIL_BUTTON_HEIGHT[AButton]
    ),
    SDL_Rect(
      THUMBNAIL_BUTTON_X[AButton],
      THUMBNAIL_BUTTON_Y[AButton],
      THUMBNAIL_BUTTON_WIDTH[AButton],
      THUMBNAIL_BUTTON_HEIGHT[AButton]
    )
  );
end;


procedure TRenderer.RenderGround();
begin
  case Logic.Scene.Current of
    SCENE_BSOD:
      if Memory.BSoD.State in [BSOD_STATE_START, BSOD_STATE_CURTAIN] then
        SDL_RenderCopy(Window.Renderer, Memory.BSoD.Buffer, nil, nil)
      else
        SDL_RenderCopy(Window.Renderer, Grounds[SCENE_BSOD], nil, nil);

    SCENE_QUIT:
      SDL_RenderCopy(Window.Renderer, Memory.Quit.Buffer, nil, nil);
  otherwise
    SDL_RenderCopy(Window.Renderer, Grounds[Logic.Scene.Current], nil, nil);
  end;
end;


procedure TRenderer.RenderMenuSelection();
begin
  RenderText(
    ITEM_X_MENU[Memory.Menu.ItemIndex],
    ITEM_Y_MENU[Memory.Menu.ItemIndex],
    ITEM_TEXT_MENU[Memory.Menu.ItemIndex]
  );

  RenderText(
    ITEM_X_MENU[Memory.Menu.ItemIndex] - ITEM_X_MARKER,
    ITEM_Y_MENU[Memory.Menu.ItemIndex],
    ITEM_TEXT_MARKER
  );
end;


procedure TRenderer.RenderLobbySelection();
begin
  RenderText(
    ITEM_X_LOBBY[Memory.Lobby.ItemIndex],
    ITEM_Y_LOBBY[Memory.Lobby.ItemIndex],
    ITEM_TEXT_LOBBY[Memory.Lobby.ItemIndex]
  );

  RenderText(
    ITEM_X_LOBBY[Memory.Lobby.ItemIndex] - ITEM_X_MARKER,
    ITEM_Y_LOBBY[Memory.Lobby.ItemIndex],
    ITEM_TEXT_MARKER,
    IfThen(
      Memory.Lobby.ItemIndex = ITEM_LOBBY_START,
      IfThen(Input.Device.Connected, COLOR_WHITE, COLOR_DARK),
      COLOR_WHITE
    )
  );
end;


procedure TRenderer.RenderLobbyItems();
begin
  RenderText(
    ITEM_X_LOBBY_START,
    ITEM_Y_LOBBY_START,
    ITEM_TEXT_LOBBY_START,
    IfThen(
      Input.Device.Connected,
      IfThen(
        Memory.Lobby.ItemIndex = ITEM_LOBBY_START,
        COLOR_WHITE,
        COLOR_GRAY
      ),
      COLOR_DARK
    )
  );
end;


procedure TRenderer.RenderLobbyParameters();
begin
  RenderText(
    ITEM_X_LOBBY_PARAM,
    ITEM_Y_LOBBY_REGION,
    ITEM_TEXT_LOBBY_REGION[Memory.Lobby.Region],
    IfThen(
      Memory.Lobby.ItemIndex = ITEM_LOBBY_REGION,
      COLOR_WHITE,
      COLOR_GRAY
    )
  );

  RenderText(
    ITEM_X_LOBBY_PARAM,
    ITEM_Y_LOBBY_GENERATOR,
    ITEM_TEXT_LOBBY_GENERATOR[Memory.Lobby.Generator],
    IfThen(
      Memory.Lobby.ItemIndex = ITEM_LOBBY_GENERATOR,
      COLOR_WHITE,
      COLOR_GRAY
    )
  );

  RenderText(
    ITEM_X_LOBBY_PARAM,
    ITEM_Y_LOBBY_LEVEL,
    Memory.Lobby.Level.ToString(),
    IfThen(
      Memory.Lobby.ItemIndex = ITEM_LOBBY_LEVEL,
      COLOR_WHITE,
      COLOR_GRAY
    )
  );
end;


procedure TRenderer.RenderLobbyBestScores();
var
  Index: Integer;
begin
  for Index := BEST_SCORES_FIRST to BEST_SCORES_LAST do
    if Index < BestScores[Memory.Lobby.Region][Memory.Lobby.Generator].Count then
      RenderText(
        ITEM_X_LOBBY_BEST_SCORE,
        ITEM_Y_LOBBY_BEST_SCORES + Index * BEST_SCORES_SPACING_Y,
        MarathonEntryToString(
          BestScores
            [Memory.Lobby.Region]
            [Memory.Lobby.Generator].Entry[Index]
        ),
        COLOR_GRAY
      )
    else
      RenderText(
        ITEM_X_LOBBY_BEST_SCORE,
        ITEM_Y_LOBBY_BEST_SCORES + Index * BEST_SCORES_SPACING_Y,
        MarathonEntryToString(),
        COLOR_DARK
      );
end;


procedure TRenderer.RenderGameTop();
begin
  if Logic.Scene.Current = SCENE_GAME_NORMAL then
    RenderText(
      GAME_TOP_TITLE_X,
      GAME_TOP_TITLE_Y,
      GAME_TOP_TITLE,
      GAME_TITLE_COLOR[Memory.Game.Level and $FF]
    );

  RenderText(
    GAME_TOP_X,
    GAME_TOP_Y,
    Converter.ScoreToString(Memory.Game.Best),
    COLOR_WHITE
  );
end;


procedure TRenderer.RenderGameBurned();
begin
  if Logic.Scene.Current = SCENE_GAME_NORMAL then
    RenderText(
      GAME_BURNED_TITLE_X,
      GAME_BURNED_TITLE_Y,
      GAME_BURNED_TITLE,
      GAME_TITLE_COLOR[Memory.Game.Level and $FF]
    );

  RenderText(
    GAME_BURNED_X,
    GAME_BURNED_Y,
    Converter.BurnedToString(Memory.Game.Burned),
    COLOR_WHITE,
    ALIGN_RIGHT
  );
end;


procedure TRenderer.RenderGameTetrises();
begin
  if Logic.Scene.Current = SCENE_GAME_NORMAL then
    RenderText(
      GAME_TETRISES_TITLE_X,
      GAME_TETRISES_TITLE_Y,
      GAME_TETRISES_TITLE,
      GAME_TITLE_COLOR[Memory.Game.Level and $FF]
    );

  RenderText(
    GAME_TETRISES_X,
    GAME_TETRISES_Y,
    Converter.TetrisesToString(Memory.Game.TetrisRate),
    COLOR_WHITE,
    ALIGN_RIGHT
  );
end;


procedure TRenderer.RenderGameGain();
begin
  if Logic.Scene.Current = SCENE_GAME_NORMAL then
    RenderText(
      GAME_GAIN_TITLE_X,
      GAME_GAIN_TITLE_Y,
      GAME_GAIN_TITLE,
      GAME_TITLE_COLOR[Memory.Game.Level and $FF]
    );

  if Memory.Game.GainTimer > 0 then
    RenderText(
      GAME_GAIN_X,
      GAME_GAIN_Y,
      Converter.GainToString(Memory.Game.Gain),
      COLOR_WHITE,
      ALIGN_RIGHT
    );
end;


procedure TRenderer.RenderGameController();
var
  Index: Integer;
begin
  for Index := DEVICE_FIRST to DEVICE_LAST do
    if Input.Device.Switch[Index].Pressed then
      RenderButton(
        GAME_CONTROLLER_X + THUMBNAIL_BUTTON_X[Index],
        GAME_CONTROLLER_Y + THUMBNAIL_BUTTON_Y[Index],
        Index
      );
end;


procedure TRenderer.RenderGameStack();
var
  OffsetX, OffsetY, BrickX, BrickY: Integer;
begin
  OffsetY := GAME_STACK_Y;
  BrickY := 0;

  while BrickY <= 19 do
  begin
    OffsetX := GAME_STACK_X;
    BrickX := 0;

    while BrickX <= 9 do
    begin
      if Memory.Game.Stack[BrickX, BrickY] <> BRICK_EMPTY then
        RenderBrick(
          OffsetX,
          OffsetY,
          Memory.Game.Stack[BrickX, BrickY],
          Memory.Game.Level
        );

      OffsetX += BRICK_CELL_WIDTH;
      BrickX += 1;
    end;

    OffsetY += BRICK_CELL_HEIGHT;
    BrickY += 1;
  end;
end;


procedure TRenderer.RenderGamePiece();
var
  OffsetX, OffsetY, BrickX, BrickY, BrickXMin, BrickXMax, BrickYMin, BrickYMax: Integer;
begin
  if Memory.Game.PieceID  = PIECE_UNKNOWN            then Exit;
  if Memory.Game.State   <> GAME_STATE_PIECE_CONTROL then Exit;

  BrickXMin := Max(Memory.Game.PieceX - 2, 0);
  BrickXMax := Min(Memory.Game.PieceX + 2, 9);

  BrickYMin := Max(Memory.Game.PieceY - 2, 0);
  BrickYMax := Min(Memory.Game.PieceY + 2, 19);

  for BrickY := BrickYMin to BrickYMax do
  begin
    OffsetY := GAME_STACK_Y;
    OffsetY += BrickY * BRICK_CELL_HEIGHT;

    for BrickX := BrickXMin to BrickXMax do
    begin
      OffsetX := GAME_STACK_X;
      OffsetX += BrickX * BRICK_CELL_WIDTH;

      RenderBrick(
        OffsetX,
        OffsetY,
        PIECE_LAYOUT[
          Memory.Game.PieceID,
          Memory.Game.PieceOrientation,
          BrickY - Memory.Game.PieceY,
          BrickX - Memory.Game.PieceX
        ],
        Memory.Game.Level
      );
    end;
  end;
end;


procedure TRenderer.RenderGameScore();
begin
  if Logic.Scene.Current = SCENE_GAME_NORMAL then
    RenderText(
      GAME_SCORE_TITLE_X,
      GAME_SCORE_TITLE_Y,
      GAME_SCORE_TITLE,
      GAME_TITLE_COLOR[Memory.Game.Level and $FF]
    );

  RenderText(
    GAME_SCORE_X,
    GAME_SCORE_Y,
    Converter.ScoreToString(Memory.Game.Score)
  );
end;


procedure TRenderer.RenderGameLines();
begin
  if Logic.Scene.Current = SCENE_GAME_NORMAL then
    RenderText(
      GAME_LINES_TITLE_X,
      GAME_LINES_TITLE_Y,
      GAME_LINES_TITLE,
      GAME_TITLE_COLOR[Memory.Game.Level and $FF]
    );

  RenderText(
    GAME_LINES_X,
    GAME_LINES_Y,
    Converter.LinesToString(Memory.Game.Lines)
  );
end;


procedure TRenderer.RenderGameLevel();
begin
  if Logic.Scene.Current = SCENE_GAME_NORMAL then
    RenderText(
      GAME_LEVEL_TITLE_X,
      GAME_LEVEL_TITLE_Y,
      GAME_LEVEL_TITLE,
      GAME_TITLE_COLOR[Memory.Game.Level and $FF]
    );

  RenderText(
    GAME_LEVEL_X,
    GAME_LEVEL_Y,
    Converter.LevelToString(Memory.Game.Level)
  );
end;


procedure TRenderer.RenderGameNext();
begin
  if Memory.Game.NextVisible then
  begin
    if Logic.Scene.Current = SCENE_GAME_NORMAL then
      RenderText(
        GAME_NEXT_TITLE_X,
        GAME_NEXT_TITLE_Y,
        GAME_NEXT_TITLE,
        GAME_TITLE_COLOR[Memory.Game.Level and $FF]
      );

    RenderNext(
      GAME_NEXT_X,
      GAME_NEXT_Y,
      Memory.Game.Next,
      Memory.Game.Level
    );
  end;
end;


procedure TRenderer.RenderPauseSelection();
begin
  RenderText(
    ITEM_X_PAUSE[Memory.Pause.ItemIndex],
    ITEM_Y_PAUSE[Memory.Pause.ItemIndex],
    ITEM_TEXT_PAUSE[Memory.Pause.ItemIndex]
  );

  RenderText(
    ITEM_X_PAUSE[Memory.Pause.ItemIndex] - ITEM_X_MARKER,
    ITEM_Y_PAUSE[Memory.Pause.ItemIndex],
    ITEM_TEXT_MARKER,
    IfThen(
      Memory.Pause.ItemIndex in [ITEM_PAUSE_RESUME, ITEM_PAUSE_RESTART],
      IfThen(
        Input.Device.Connected,
        COLOR_WHITE,
        COLOR_DARK
      ),
      COLOR_WHITE
    )
  );
end;


procedure TRenderer.RenderPauseItems();
begin
  RenderText(
    ITEM_X_PAUSE_RESUME,
    ITEM_Y_PAUSE_RESUME,
    ITEM_TEXT_PAUSE_RESUME,
    IfThen(
      Input.Device.Connected,
      IfThen(
        Memory.Pause.ItemIndex = ITEM_PAUSE_RESUME,
        COLOR_WHITE,
        COLOR_GRAY
      ),
      COLOR_DARK
    )
  );

  RenderText(
    ITEM_X_PAUSE_RESTART,
    ITEM_Y_PAUSE_RESTART,
    ITEM_TEXT_PAUSE_RESTART,
    IfThen(
      Input.Device.Connected,
      IfThen(
        Memory.Pause.ItemIndex = ITEM_PAUSE_RESTART,
        COLOR_WHITE,
        COLOR_GRAY
      ),
      COLOR_DARK
    )
  );
end;


procedure TRenderer.RenderTopOutResultScore();
begin
  RenderText(
    ITEM_X_TOP_OUT_RESULT_TOTAL_SCORE,
    ITEM_Y_TOP_OUT_RESULT_TOTAL_SCORE,
    Converter.ScoreToString(Memory.TopOut.TotalScore),
    COLOR_WHITE,
    ALIGN_RIGHT
  );
end;


procedure TRenderer.RenderTopOutResultTransition();
begin
  if Memory.TopOut.Transition > 0 then
    RenderText(
      ITEM_X_TOP_OUT_RESULT_TRANSITION,
      ITEM_Y_TOP_OUT_RESULT_TRANSITION,
      Converter.ScoreToString(Memory.TopOut.Transition),
      COLOR_WHITE,
      ALIGN_RIGHT
    )
  else
    RenderText(
      ITEM_X_TOP_OUT_RESULT_TRANSITION,
      ITEM_Y_TOP_OUT_RESULT_TRANSITION,
      '-',
      COLOR_DARK,
      ALIGN_RIGHT
    );
end;


procedure TRenderer.RenderTopOutResultLinesCleared();
begin
  RenderText(
    ITEM_X_TOP_OUT_RESULT_LINES_CLEARED,
    ITEM_Y_TOP_OUT_RESULT_LINES_CLEARED,
    Converter.LinesToString(Memory.TopOut.LinesCleared),
    COLOR_WHITE,
    ALIGN_RIGHT
  );
end;


procedure TRenderer.RenderTopOutResultLinesBurned();
begin
  if Memory.TopOut.LinesBurned > 0 then
    RenderText(
      ITEM_X_TOP_OUT_RESULT_LINES_BURNED,
      ITEM_Y_TOP_OUT_RESULT_LINES_BURNED,
      Converter.LinesToString(Memory.TopOut.LinesBurned),
      COLOR_WHITE,
      ALIGN_RIGHT
    )
  else
    RenderText(
      ITEM_X_TOP_OUT_RESULT_LINES_BURNED,
      ITEM_Y_TOP_OUT_RESULT_LINES_BURNED,
      '-',
      COLOR_DARK,
      ALIGN_RIGHT
    );
end;


procedure TRenderer.RenderTopOutResultTetrisRate();
begin
  if Memory.TopOut.LinesCleared > 0 then
    RenderText(
      ITEM_X_TOP_OUT_RESULT_TETRIS_RATE,
      ITEM_Y_TOP_OUT_RESULT_TETRIS_RATE,
      Converter.TetrisesToString(Memory.TopOut.TetrisRate),
      COLOR_WHITE,
      ALIGN_RIGHT
    )
  else
    RenderText(
      ITEM_X_TOP_OUT_RESULT_TETRIS_RATE,
      ITEM_Y_TOP_OUT_RESULT_TETRIS_RATE,
      '-',
      COLOR_DARK,
      ALIGN_RIGHT
    );
end;


procedure TRenderer.RenderTopOutSelection();
begin
  RenderText(
    ITEM_X_TOP_OUT[Memory.TopOut.ItemIndex],
    ITEM_Y_TOP_OUT[Memory.TopOut.ItemIndex],
    ITEM_TEXT_TOP_OUT[Memory.TopOut.ItemIndex]
  );

  RenderText(
    ITEM_X_TOP_OUT[Memory.TopOut.ItemIndex] - ITEM_X_MARKER,
    ITEM_Y_TOP_OUT[Memory.TopOut.ItemIndex],
    ITEM_TEXT_MARKER,
    IfThen(
      Memory.TopOut.ItemIndex = ITEM_TOP_OUT_PLAY,
      IfThen(
        Input.Device.Connected,
        COLOR_WHITE,
        COLOR_DARK
      ),
      COLOR_WHITE
    )
  );
end;


procedure TRenderer.RenderTopOutItems();
begin
  RenderText(
    ITEM_X_TOP_OUT_PLAY,
    ITEM_Y_TOP_OUT_PLAY,
    ITEM_TEXT_TOP_OUT_PLAY,
    IfThen(
      Input.Device.Connected,
      IfThen(
        Memory.TopOut.ItemIndex = ITEM_TOP_OUT_PLAY,
        COLOR_WHITE,
        COLOR_GRAY
      ),
      COLOR_DARK
    )
  );
end;


procedure TRenderer.RenderTopOutResult();
begin
  RenderTopOutResultScore();
  RenderTopOutResultTransition();
  RenderTopOutResultLinesCleared();
  RenderTopOutResultLinesBurned();
  RenderTopOutResultTetrisRate();
end;


procedure TRenderer.RenderOptionsSelection();
begin
  RenderText(
    ITEM_X_OPTIONS[Memory.Options.ItemIndex],
    ITEM_Y_OPTIONS[Memory.Options.ItemIndex],
    ITEM_TEXT_OPTIONS[Memory.Options.ItemIndex],
    IfThen(
      Memory.Options.ItemIndex = ITEM_OPTIONS_SET_UP,
      IfThen(Input.Device.Connected, COLOR_WHITE, COLOR_DARK),
      IfThen(
        Memory.Options.ItemIndex = ITEM_OPTIONS_SIZE,
        IfThen(Placement.VideoEnabled, COLOR_DARK, COLOR_WHITE),
        COLOR_WHITE
      )
    )
  );

  RenderText(
    ITEM_X_OPTIONS[Memory.Options.ItemIndex] - ITEM_X_MARKER,
    ITEM_Y_OPTIONS[Memory.Options.ItemIndex],
    ITEM_TEXT_MARKER,
    IfThen(
      Memory.Options.ItemIndex in [ITEM_OPTIONS_SET_UP, ITEM_OPTIONS_BACK],
      IfThen(Input.Device.Connected, COLOR_WHITE, COLOR_DARK),
      IfThen(
        Memory.Options.ItemIndex = ITEM_OPTIONS_SIZE,
        IfThen(Placement.VideoEnabled, COLOR_DARK, COLOR_WHITE),
        COLOR_WHITE
      )
    )
  );
end;


procedure TRenderer.RenderOptionsItems();
begin
  RenderText(
    ITEM_X_OPTIONS_SET_UP,
    ITEM_Y_OPTIONS_SET_UP,
    ITEM_TEXT_OPTIONS_SET_UP,
    IfThen(
      Input.Device.Connected,
      IfThen(
        Memory.Options.ItemIndex = ITEM_OPTIONS_SET_UP,
        COLOR_WHITE,
        COLOR_GRAY
      ),
      COLOR_DARK
    )
  );

  RenderText(
    ITEM_X_OPTIONS_SIZE,
    ITEM_Y_OPTIONS_SIZE,
    ITEM_TEXT_OPTIONS_SIZE_TITLE,
    IfThen(
      Memory.Options.ItemIndex = ITEM_OPTIONS_SIZE,
      IfThen(Placement.VideoEnabled, COLOR_DARK, COLOR_WHITE),
      IfThen(
        Placement.VideoEnabled,
        COLOR_DARK,
        COLOR_GRAY
      )
    )
  );

  RenderText(
    ITEM_X_OPTIONS_BACK,
    ITEM_Y_OPTIONS_BACK,
    ITEM_TEXT_OPTIONS_BACK,
    IfThen(
      Input.Device.Connected,
      IfThen(
        Memory.Options.ItemIndex = ITEM_OPTIONS_BACK,
        COLOR_WHITE,
        COLOR_GRAY
      ),
      COLOR_DARK
    )
  );
end;


procedure TRenderer.RenderOptionsParameters();
begin
  RenderText(
    ITEM_X_OPTIONS_PARAM,
    ITEM_Y_OPTIONS_INPUT,
    ITEM_TEXT_OPTIONS_INPUT[Memory.Options.Input],
    IfThen(
      Input.Device.Connected,
      IfThen(
        Memory.Options.ItemIndex = ITEM_OPTIONS_INPUT,
        COLOR_WHITE,
        COLOR_GRAY
      ),
      COLOR_DARK
    )
  );

  RenderText(
    ITEM_X_OPTIONS_PARAM,
    ITEM_Y_OPTIONS_BOOST,
    ITEM_TEXT_OPTIONS_BOOST[Memory.Options.Boost],
    IfThen(
      Memory.Options.ItemIndex = ITEM_OPTIONS_BOOST,
      COLOR_WHITE,
      COLOR_GRAY
    )
  );

  RenderText(
    ITEM_X_OPTIONS_PARAM,
    ITEM_Y_OPTIONS_SIZE,
    IfThen(
      Placement.VideoEnabled,
      ITEM_TEXT_OPTIONS_SIZE_VIDEO_MODE,
      ITEM_TEXT_OPTIONS_SIZE[Memory.Options.Size]
    ),
    IfThen(
      Memory.Options.ItemIndex = ITEM_OPTIONS_SIZE,
      IfThen(Placement.VideoEnabled, COLOR_DARK, COLOR_WHITE),
      IfThen(
        Placement.VideoEnabled,
        COLOR_DARK,
        COLOR_GRAY
      )
    )
  );

  RenderText(
    ITEM_X_OPTIONS_PARAM,
    ITEM_Y_OPTIONS_SOUNDS,
    ITEM_TEXT_OPTIONS_SOUNDS[Memory.Options.Sounds],
    IfThen(
      Memory.Options.ItemIndex = ITEM_OPTIONS_SOUNDS,
      COLOR_WHITE,
      COLOR_GRAY
    )
  );
end;


procedure TRenderer.RenderKeyboardItemSelection();
begin
  if not Memory.Keyboard.Changing then
    RenderText(
      ITEM_X_KEYBOARD[Memory.Keyboard.ItemIndex],
      ITEM_Y_KEYBOARD[Memory.Keyboard.ItemIndex],
      ITEM_TEXT_KEYBOARD[Memory.Keyboard.ItemIndex]
    );

  RenderText(
    ITEM_X_KEYBOARD[Memory.Keyboard.ItemIndex] - ITEM_X_MARKER,
    ITEM_Y_KEYBOARD[Memory.Keyboard.ItemIndex],
    ITEM_TEXT_MARKER,
    IfThen(
      Memory.Keyboard.ItemIndex = ITEM_KEYBOARD_SAVE,
      IfThen(Memory.Keyboard.MappedCorrectly(), COLOR_WHITE, COLOR_DARK),
      IfThen(
        Memory.Keyboard.ItemIndex = ITEM_KEYBOARD_CHANGE,
        IfThen(
          Memory.Keyboard.Changing,
          COLOR_GRAY,
          COLOR_WHITE
        ),
        COLOR_WHITE
      )
    )
  );
end;


procedure TRenderer.RenderKeyboardItems();
begin
  RenderText(
    ITEM_X_KEYBOARD_SAVE,
    ITEM_Y_KEYBOARD_SAVE,
    ITEM_TEXT_KEYBOARD_SAVE,
    IfThen(
      Memory.Keyboard.MappedCorrectly(),
      IfThen(
        Memory.Keyboard.ItemIndex = ITEM_KEYBOARD_SAVE,
        COLOR_WHITE,
        COLOR_GRAY
      ),
      COLOR_DARK
    )
  );
end;


procedure TRenderer.RenderKeyboardKeySelection();
begin
  if not Memory.Keyboard.Changing then Exit;

  RenderText(
    ITEM_X_KEYBOARD_KEY[Memory.Keyboard.KeyIndex],
    ITEM_Y_KEYBOARD_KEY[Memory.Keyboard.KeyIndex],
    ITEM_TEXT_KEYBOARD_KEY[Memory.Keyboard.KeyIndex],
    IfThen(
      Memory.Keyboard.Mapping,
      IfThen(Clock.FrameIndexInHalf, COLOR_DARK, COLOR_WHITE),
      COLOR_WHITE
    )
  );

  RenderText(
    ITEM_X_KEYBOARD_KEY[Memory.Keyboard.KeyIndex] - ITEM_X_MARKER,
    ITEM_Y_KEYBOARD_KEY[Memory.Keyboard.KeyIndex],
    ITEM_TEXT_MARKER,
    IfThen(
      Memory.Keyboard.Mapping,
      IfThen(Clock.FrameIndexInHalf, COLOR_DARK, COLOR_WHITE),
      COLOR_WHITE
    )
  );
end;


procedure TRenderer.RenderKeyboardKeyScanCodes();
var
  Index: Integer;
begin
  for Index := ITEM_KEYBOARD_SCANCODE_FIRST to ITEM_KEYBOARD_SCANCODE_LAST do
    RenderText(
      ITEM_X_KEYBOARD_SCANCODE,
      ITEM_Y_KEYBOARD_KEY[Index],
      ITEM_TEXT_KEYBOARD_SCANCODE[Memory.Keyboard.ScanCodes[Index]],
      IfThen(
        Memory.Keyboard.Changing,
        IfThen(
          Memory.Keyboard.KeyIndex = Index,
          IfThen(
            Memory.Keyboard.Mapping,
            IfThen(Clock.FrameIndexInHalf, COLOR_DARK, COLOR_WHITE),
            COLOR_WHITE
          ),
          COLOR_GRAY
        ),
        COLOR_GRAY
      )
    );
end;


procedure TRenderer.RenderControllerItemSelection();
begin
  if not Memory.Controller.Changing then
    RenderText(
      ITEM_X_CONTROLLER[Memory.Controller.ItemIndex],
      ITEM_Y_CONTROLLER[Memory.Controller.ItemIndex],
      ITEM_TEXT_CONTROLLER[Memory.Controller.ItemIndex]
    );

  RenderText(
    ITEM_X_CONTROLLER[Memory.Controller.ItemIndex] - ITEM_X_MARKER,
    ITEM_Y_CONTROLLER[Memory.Controller.ItemIndex],
    ITEM_TEXT_MARKER,
    IfThen(
      Memory.Controller.ItemIndex = ITEM_CONTROLLER_SAVE,
      IfThen(Memory.Controller.MappedCorrectly(), COLOR_WHITE, COLOR_DARK),
      IfThen(
        Memory.Controller.ItemIndex = ITEM_CONTROLLER_CHANGE,
        IfThen(
          Memory.Controller.Changing,
          COLOR_GRAY,
          COLOR_WHITE
        ),
        COLOR_WHITE
      )
    )
  );
end;


procedure TRenderer.RenderControllerItems();
begin
  RenderText(
    ITEM_X_CONTROLLER_SAVE,
    ITEM_Y_CONTROLLER_SAVE,
    ITEM_TEXT_CONTROLLER_SAVE,
    IfThen(
      Memory.Controller.MappedCorrectly(),
      IfThen(
        Memory.Controller.ItemIndex = ITEM_CONTROLLER_SAVE,
        COLOR_WHITE,
        COLOR_GRAY
      ),
      COLOR_DARK
    )
  );
end;


procedure TRenderer.RenderControllerButtonSelection();
begin
  if not Memory.Controller.Changing then Exit;

  RenderText(
    ITEM_X_CONTROLLER_BUTTON[Memory.Controller.ButtonIndex],
    ITEM_Y_CONTROLLER_BUTTON[Memory.Controller.ButtonIndex],
    ITEM_TEXT_CONTROLLER_BUTTON[Memory.Controller.ButtonIndex],
    IfThen(
      Memory.Controller.Mapping,
      IfThen(Clock.FrameIndexInHalf, COLOR_DARK, COLOR_WHITE),
      COLOR_WHITE
    )
  );

  RenderText(
    ITEM_X_CONTROLLER_BUTTON[Memory.Controller.ButtonIndex] - ITEM_X_MARKER,
    ITEM_Y_CONTROLLER_BUTTON[Memory.Controller.ButtonIndex],
    ITEM_TEXT_MARKER,
    IfThen(
      Memory.Controller.Mapping,
      IfThen(Clock.FrameIndexInHalf, COLOR_DARK, COLOR_WHITE),
      COLOR_WHITE
    )
  );
end;


procedure TRenderer.RenderControllerButtonScanCodes();
var
  Index: Integer;
begin
  for Index := ITEM_KEYBOARD_SCANCODE_FIRST to ITEM_KEYBOARD_SCANCODE_LAST do
    RenderText(
      ITEM_X_CONTROLLER_SCANCODE,
      ITEM_Y_CONTROLLER_BUTTON[Index],
      ITEM_TEXT_CONTROLLER_SCANCODE[Memory.Controller.ScanCodes[Index]],
      IfThen(
        Memory.Controller.Changing,
        IfThen(
          Memory.Controller.ButtonIndex = Index,
          IfThen(
            Memory.Controller.Mapping,
            IfThen(Clock.FrameIndexInHalf, COLOR_DARK, COLOR_WHITE),
            COLOR_WHITE
          ),
          COLOR_GRAY
        ),
        COLOR_GRAY
      )
    );
end;


procedure TRenderer.RenderLegal();
begin

end;


procedure TRenderer.RenderMenu();
begin
  RenderMenuSelection();
end;


procedure TRenderer.RenderLobby();
begin
  RenderLobbySelection();
  RenderLobbyItems();
  RenderLobbyParameters();
  RenderLobbyBestScores();
end;


procedure TRenderer.RenderGame();
begin
  RenderGameTop();
  RenderGameBurned();
  RenderGameTetrises();
  RenderGameGain();
  RenderGameController();

  RenderGameStack();

  RenderGameScore();
  RenderGameLines();
  RenderGameLevel();
  RenderGameNext();
  RenderGamePiece();
end;


procedure TRenderer.RenderPause();
begin
  RenderPauseSelection();
  RenderPauseItems();
end;


procedure TRenderer.RenderTopOut();
begin
  RenderTopOutSelection();
  RenderTopOutItems();
  RenderTopOutResult();
end;


procedure TRenderer.RenderOptions();
begin
  RenderOptionsSelection();
  RenderOptionsItems();
  RenderOptionsParameters();
end;


procedure TRenderer.RenderKeyboard();
begin
  RenderKeyboardItemSelection();
  RenderKeyboardItems();
  RenderKeyboardKeySelection();
  RenderKeyboardKeyScanCodes();
end;


procedure TRenderer.RenderController();
begin
  RenderControllerItemSelection();
  RenderControllerItems();
  RenderControllerButtonSelection();
  RenderControllerButtonScanCodes();
end;


procedure TRenderer.RenderBSoD();
var
  Rect: TSDL_Rect;
begin
  if Memory.BSoD.State <> BSOD_STATE_CURTAIN then Exit;

  Rect.X := 0;
  Rect.Y := 0;
  Rect.W := BUFFER_WIDTH;
  Rect.H := Round(BUFFER_HEIGHT * ((Memory.BSoD.Timer + 1) / (DURATION_HANG_BSOD_CURTAIN * Clock.FrameRateLimit)));

  SDL_RenderCopy(Window.Renderer, Grounds[SCENE_BSOD], @Rect, @Rect);
end;


procedure TRenderer.RenderQuit();
begin

end;


procedure TRenderer.RenderBegin();
begin
  SDL_SetRenderTarget(Window.Renderer, Buffers.Native);
  SDL_SetRenderDrawColor(Window.Renderer, 0, 0, 0, 255);
  SDL_RenderClear(Window.Renderer);
end;


procedure TRenderer.RenderEnd();
begin
  SDL_SetRenderTarget(Window.Renderer, nil);
end;


procedure TRenderer.RenderScene();
begin
  RenderBegin();
  RenderGround();

  case Logic.Scene.Current of
    SCENE_LEGAL:       RenderLegal();
    SCENE_MENU:        RenderMenu();
    SCENE_LOBBY:       RenderLobby();
    SCENE_GAME_NORMAL: RenderGame();
    SCENE_GAME_FLASH:  RenderGame();
    SCENE_PAUSE:       RenderPause();
    SCENE_TOP_OUT:     RenderTopOut();
    SCENE_OPTIONS:     RenderOptions();
    SCENE_KEYBOARD:    RenderKeyboard();
    SCENE_CONTROLLER:  RenderController();
    SCENE_BSOD:        RenderBSoD();
    SCENE_QUIT:        RenderQuit();
  end;

  RenderEnd();
end;


end.

