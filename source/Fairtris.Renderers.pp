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

unit Fairtris.Renderers;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  SDL2,
  Fairtris.Interfaces,
  Fairtris.BestScores,
  Fairtris.Constants;


type
  TRenderer = class(TInterfacedObject)
  private
    function CharToIndex(AChar: Char): Integer;
  protected
    function MarathonEntryToString(AEntry: TScoreEntry = nil): String;
    function SpeedrunEntryToString(AEntry: TScoreEntry = nil): String;
  protected
    procedure RenderSprite(ASprite: PSDL_Texture; ABufferRect, ASpriteRect: TSDL_Rect);
    procedure RenderText(AX, AY: Integer; const AText: String; AColor: Integer = COLOR_WHITE; AAlign: Integer = ALIGN_LEFT);
    procedure RenderNext(AX, AY, APiece, ALevel: Integer);
    procedure RenderBrick(AX, AY, ABrick, ALevel: Integer);
  protected
    procedure RenderGround(ASceneID: Integer);
  protected
    procedure RenderMenuSelection();
  protected
    procedure RenderModesSelection();
    procedure RenderModesItems();
  protected
    procedure RenderGameModeSeed();
    procedure RenderGameModeTimer();
  protected
    procedure RenderFreeMarathonSelection();
    procedure RenderFreeMarathonItems();
    procedure RenderFreeMarathonParameters();
    procedure RenderFreeMarathonBestScores();
  protected
    procedure RenderFreeSpeedrunSelection();
    procedure RenderFreeSpeedrunItems();
    procedure RenderFreeSpeedrunParameters();
    procedure RenderFreeSpeedrunBestScores();
  protected
    procedure RenderMarathonQualsSelection();
    procedure RenderMarathonQualsItems();
    procedure RenderMarathonQualsParameters();
    procedure RenderMarathonQualsBestScores();
  protected
    procedure RenderMarathonMatchSelection();
    procedure RenderMarathonMatchItems();
    procedure RenderMarathonMatchParameters();
    procedure RenderMarathonMatchBestScores();
  protected
    procedure RenderSpeedrunQualsSelection();
    procedure RenderSpeedrunQualsItems();
    procedure RenderSpeedrunQualsParameters();
    procedure RenderSpeedrunQualsBestScores();
  protected
    procedure RenderSpeedrunMatchSelection();
    procedure RenderSpeedrunMatchItems();
    procedure RenderSpeedrunMatchParameters();
    procedure RenderSpeedrunMatchBestScores();
  protected
    procedure RenderGameBestTitle();
    procedure RenderGameBest();
    procedure RenderGameScore();
    procedure RenderGameLines();
    procedure RenderGameLevel();
    procedure RenderGameNext();
    procedure RenderGameTime();
    procedure RenderGameStack();
    procedure RenderGamePiece();
  protected
    procedure RenderPauseSelection();
    procedure RenderPauseItems();
  protected
    procedure RenderTopOutResultScore();
    procedure RenderTopOutResultTotalTime();
    procedure RenderTopOutResultTransition();
    procedure RenderTopOutResultLinesCleared();
    procedure RenderTopOutResultLinesBurned();
    procedure RenderTopOutResultTetrisRate();
    procedure RenderTopOutResultQualsEndIn();
  protected
    procedure RenderTopOutSelection();
    procedure RenderTopOutItems();
    procedure RenderTopOutResult();
  protected
    procedure RenderOptionsSelection();
    procedure RenderOptionsItems();
    procedure RenderOptionsParameters();
  protected
    procedure RenderKeyboardItemSelection();
    procedure RenderKeyboardItems();
    procedure RenderKeyboardKeySelection();
    procedure RenderKeyboardKeyScanCodes();
  protected
    procedure RenderControllerItemSelection();
    procedure RenderControllerItems();
    procedure RenderControllerButtonSelection();
    procedure RenderControllerButtonScanCodes();
  protected
    procedure RenderBegin();
    procedure RenderEnd();
  end;


type
  TModernRenderer = class(TRenderer, IRenderable)
  private
    procedure RenderButton(AX, AY, AButton: Integer);
  private
    procedure RenderGameBurned();
    procedure RenderGameTetrises();
    procedure RenderGameGain();
    procedure RenderGameInput();
  private
    procedure RenderLegal();
    procedure RenderMenu();
    procedure RenderModes();
    procedure RenderFreeMarathon();
    procedure RenderFreeSpeedrun();
    procedure RenderMarathonQuals();
    procedure RenderMarathonMatch();
    procedure RenderSpeedrunQuals();
    procedure RenderSpeedrunMatch();
    procedure RenderGame();
    procedure RenderPause();
    procedure RenderTopOut();
    procedure RenderOptions();
    procedure RenderKeyboard();
    procedure RenderController();
    procedure RenderQuit();
  public
    procedure RenderScene(ASceneID: Integer);
  end;


type
  TClassicRenderer = class(TRenderer, IRenderable)
  private
    procedure RenderMiniature(AX, AY, APiece, ALevel: Integer);
  private
    procedure RenderGameStats();
  private
    procedure RenderLegal();
    procedure RenderMenu();
    procedure RenderModes();
    procedure RenderFreeMarathon();
    procedure RenderFreeSpeedrun();
    procedure RenderMarathonQuals();
    procedure RenderMarathonMatch();
    procedure RenderSpeedrunQuals();
    procedure RenderSpeedrunMatch();
    procedure RenderGame();
    procedure RenderPause();
    procedure RenderTopOut();
    procedure RenderOptions();
    procedure RenderKeyboard();
    procedure RenderController();
    procedure RenderQuit();
  public
    procedure RenderScene(ASceneID: Integer);
  end;


type
  TRenderers = class(TObject)
  private
    FTheme: IRenderable;
    FThemeID: Integer;
  private
    FModern: IRenderable;
    FClassic: IRenderable;
  private
    procedure SetThemeID(AThemeID: Integer);
  private
    function GetModern(): TModernRenderer;
    function GetClassic(): TClassicRenderer;
  public
    constructor Create();
  public
    procedure Initialize();
  public
    property Theme: IRenderable read FTheme;
    property ThemeID: Integer read FThemeID write SetThemeID;
  public
    property Modern: TModernRenderer read GetModern;
    property Classic: TClassicRenderer read GetClassic;
  end;


var
  Renderers: TRenderers;


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
  Fairtris.Placement,
  Fairtris.Converter,
  Fairtris.Grounds,
  Fairtris.Sprites,
  Fairtris.Settings,
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


function TRenderer.SpeedrunEntryToString(AEntry: TScoreEntry): String;
begin
  if AEntry <> nil then
  begin
    Result := Converter.FramesToTimeString(AEntry.TotalTime, True);
    Result += '%.3d'.Format([AEntry.LinesCleared]).PadLeft(6);
    Result += Converter.ScoreToString(AEntry.TotalScore).PadLeft(10);
  end
  else
    Result := '-          -           -';
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
begin
  if APiece <> PIECE_UNKNOWN then
  begin
    ALevel := ALevel mod 10;

    RenderSprite(
      Sprites.Pieces,
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
begin
  if ABrick = BRICK_EMPTY then Exit;
  begin
    ALevel := ALevel mod 10;

    RenderSprite(
      Sprites.Bricks,
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


procedure TRenderer.RenderGround(ASceneID: Integer);
begin
  if ASceneID = SCENE_QUIT then
    SDL_RenderCopy(Window.Renderer, Memory.Quit.Buffer, nil, nil)
  else
    SDL_RenderCopy(Window.Renderer, Grounds[Memory.Options.Theme][ASceneID], nil, nil);
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


procedure TRenderer.RenderModesSelection();
begin
  RenderText(
    ITEM_X_MODES[Memory.Modes.ItemIndex],
    ITEM_Y_MODES[Memory.Modes.ItemIndex],
    ITEM_TEXT_MODES[Memory.Modes.ItemIndex]
  );

  RenderText(
    ITEM_X_MODES[Memory.Modes.ItemIndex] - ITEM_X_MARKER,
    ITEM_Y_MODES[Memory.Modes.ItemIndex],
    ITEM_TEXT_MARKER,
    IfThen(
      Memory.GameModes.QualsActive,
      IfThen(
        (Memory.Modes.ItemIndex = ITEM_MODES_MARATHON_QUALS) and (Memory.GameModes.QualsMode = QUALS_MODE_MARATHON),
        COLOR_WHITE,
        IfThen(
          (Memory.Modes.ItemIndex = ITEM_MODES_SPEEDRUN_QUALS) and (Memory.GameModes.QualsMode = QUALS_MODE_SPEEDRUN),
          COLOR_WHITE,
          IfThen(Memory.Modes.ItemIndex = ITEM_MODES_BACK, COLOR_WHITE, COLOR_DARK)
        )
      ),
      COLOR_WHITE
    )
  );
end;


procedure TRenderer.RenderModesItems();
begin
  if not Memory.GameModes.QualsActive then Exit;

  RenderText(
    ITEM_X_MODES_FREE_MARATHON,
    ITEM_Y_MODES_FREE_MARATHON,
    ITEM_TEXT_MODES_FREE_MARATHON,
    COLOR_DARK
  );

  RenderText(
    ITEM_X_MODES_FREE_SPEEDRUN,
    ITEM_Y_MODES_FREE_SPEEDRUN,
    ITEM_TEXT_MODES_FREE_SPEEDRUN,
    COLOR_DARK
  );

  RenderText(
    ITEM_X_MODES_MARATHON_MATCH,
    ITEM_Y_MODES_MARATHON_MATCH,
    ITEM_TEXT_MODES_MARATHON_MATCH,
    COLOR_DARK
  );

  RenderText(
    ITEM_X_MODES_SPEEDRUN_MATCH,
    ITEM_Y_MODES_SPEEDRUN_MATCH,
    ITEM_TEXT_MODES_SPEEDRUN_MATCH,
    COLOR_DARK
  );

  if Memory.GameModes.QualsMode = QUALS_MODE_MARATHON then
    RenderText(
      ITEM_X_MODES_SPEEDRUN_QUALS,
      ITEM_Y_MODES_SPEEDRUN_QUALS,
      ITEM_TEXT_MODES_SPEEDRUN_QUALS,
      COLOR_DARK
    )
  else
    RenderText(
      ITEM_X_MODES_MARATHON_QUALS,
      ITEM_Y_MODES_MARATHON_QUALS,
      ITEM_TEXT_MODES_MARATHON_QUALS,
      COLOR_DARK
    );
end;


procedure TRenderer.RenderGameModeSeed();
var
  Digits, Placeholder: String;
begin
  if not Memory.GameModes.SeedChanging then
    RenderText(
      ITEM_X_GAME_MODE_PARAM,
      ITEM_Y_GAME_MODE_SEED,
      Memory.GameModes.SeedData,
      IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
    )
  else
  begin
    Converter.SeedEditorToStrings(Memory.GameModes.SeedEditor, Digits, Placeholder);

    RenderText(
      ITEM_X_GAME_MODE_PARAM,
      ITEM_Y_GAME_MODE_SEED,
      Digits
    );

    RenderText(
      ITEM_X_GAME_MODE_PARAM + Digits.Length * CHAR_WIDTH,
      ITEM_Y_GAME_MODE_SEED,
      Placeholder,
      IfThen(Clock.FrameIndexInHalf, COLOR_WHITE, COLOR_DARK)
    );

    RenderText(
      ITEM_X_GAME_MODE_PARAM - ITEM_X_MARKER,
      ITEM_Y_GAME_MODE_SEED,
      ITEM_TEXT_MARKER,
      IfThen(Clock.FrameIndexInHalf, COLOR_WHITE, COLOR_DARK)
    );
  end;
end;


procedure TRenderer.RenderGameModeTimer();
var
  Digits, Placeholder: String;
begin
  if not Memory.GameModes.TimerChanging then
    RenderText(
      ITEM_X_GAME_MODE_PARAM,
      ITEM_Y_GAME_MODE_TIMER,
      IfThen(
        Memory.GameModes.QualsActive,
        Converter.FramesToTimerString(Memory.GameModes.QualsRemaining, True),
        Memory.GameModes.TimerData
      ),
      IfThen(
        Memory.GameModes.TimerData = TIMER_DEFAULT_DATA,
        COLOR_DARK,
        IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
      )
    )
  else
  begin
    Converter.TimerEditorToStrings(Memory.GameModes.TimerEditor, Digits, Placeholder);

    RenderText(
      ITEM_X_GAME_MODE_PARAM,
      ITEM_Y_GAME_MODE_TIMER,
      Digits
    );

    RenderText(
      ITEM_X_GAME_MODE_PARAM + Digits.Length * CHAR_WIDTH,
      ITEM_Y_GAME_MODE_TIMER,
      Placeholder,
      IfThen(Clock.FrameIndexInHalf, COLOR_WHITE, COLOR_DARK)
    );

    RenderText(
      ITEM_X_GAME_MODE_PARAM - ITEM_X_MARKER,
      ITEM_Y_GAME_MODE_TIMER,
      ITEM_TEXT_MARKER,
      IfThen(Clock.FrameIndexInHalf, COLOR_WHITE, COLOR_DARK)
    );
  end;
end;


procedure TRenderer.RenderFreeMarathonSelection();
begin
  RenderText(
    ITEM_X_FREE_MARATHON[Memory.FreeMarathon.ItemIndex],
    ITEM_Y_FREE_MARATHON[Memory.FreeMarathon.ItemIndex],
    ITEM_TEXT_FREE_MARATHON[Memory.FreeMarathon.ItemIndex]
  );

  RenderText(
    ITEM_X_FREE_MARATHON[Memory.FreeMarathon.ItemIndex] - ITEM_X_MARKER,
    ITEM_Y_FREE_MARATHON[Memory.FreeMarathon.ItemIndex],
    ITEM_TEXT_MARKER,
    IfThen(
      Memory.FreeMarathon.ItemIndex = ITEM_FREE_MARATHON_START,
      IfThen(Input.Device.Connected, COLOR_WHITE, COLOR_DARK),
      COLOR_WHITE
    )
  );
end;


procedure TRenderer.RenderFreeMarathonItems();
begin
  RenderText(
    ITEM_X_GAME_MODE_START,
    ITEM_Y_GAME_MODE_START,
    ITEM_TEXT_GAME_MODE_START,
    IfThen(
      Input.Device.Connected,
      IfThen(
        Memory.FreeMarathon.ItemIndex = ITEM_FREE_MARATHON_START,
        COLOR_WHITE,
        IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
      ),
      COLOR_DARK
    )
  );
end;


procedure TRenderer.RenderFreeMarathonParameters();
begin
  RenderText(
    ITEM_X_GAME_MODE_PARAM,
    ITEM_Y_GAME_MODE_REGION,
    ITEM_TEXT_GAME_MODE_REGION[Memory.GameModes.Region],
    IfThen(
      Memory.FreeMarathon.ItemIndex = ITEM_FREE_MARATHON_REGION,
      COLOR_WHITE,
      IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
    )
  );

  RenderText(
    ITEM_X_GAME_MODE_PARAM,
    ITEM_Y_GAME_MODE_GENERATOR,
    ITEM_TEXT_GAME_MODE_GENERATOR[Memory.GameModes.Generator],
    IfThen(
      Memory.FreeMarathon.ItemIndex = ITEM_FREE_MARATHON_GENERATOR,
      COLOR_WHITE,
      IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
    )
  );

  RenderText(
    ITEM_X_GAME_MODE_PARAM,
    ITEM_Y_GAME_MODE_LEVEL,
    Memory.GameModes.Level.ToString(),
    IfThen(
      Memory.FreeMarathon.ItemIndex = ITEM_FREE_MARATHON_LEVEL,
      COLOR_WHITE,
      IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
    )
  );
end;


procedure TRenderer.RenderFreeMarathonBestScores();
var
  Index: Integer;
begin
  for Index := BEST_SCORES_FIRST to BEST_SCORES_LAST do
    if Index < BestScores[Memory.GameModes.IsSpeedrun][Memory.GameModes.Region][Memory.GameModes.Generator].Count then
      RenderText(
        ITEM_X_GAME_MODE_BEST_SCORE,
        ITEM_Y_GAME_MODE_BEST_SCORES[Memory.Options.Theme] + Index * BEST_SCORES_SPACING_Y,
        MarathonEntryToString(
          BestScores
            [Memory.GameModes.IsSpeedrun]
            [Memory.GameModes.Region]
            [Memory.GameModes.Generator].Entry[Index]
        ),
        IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
      )
    else
      RenderText(
        ITEM_X_GAME_MODE_BEST_SCORE,
        ITEM_Y_GAME_MODE_BEST_SCORES[Memory.Options.Theme] + Index * BEST_SCORES_SPACING_Y,
        MarathonEntryToString(),
        COLOR_DARK
      );
end;


procedure TRenderer.RenderFreeSpeedrunSelection();
begin
  RenderText(
    ITEM_X_FREE_SPEEDRUN[Memory.FreeSpeedrun.ItemIndex],
    ITEM_Y_FREE_SPEEDRUN[Memory.FreeSpeedrun.ItemIndex],
    ITEM_TEXT_FREE_SPEEDRUN[Memory.FreeSpeedrun.ItemIndex]
  );

  RenderText(
    ITEM_X_FREE_SPEEDRUN[Memory.FreeSpeedrun.ItemIndex] - ITEM_X_MARKER,
    ITEM_Y_FREE_SPEEDRUN[Memory.FreeSpeedrun.ItemIndex],
    ITEM_TEXT_MARKER,
    IfThen(
      Memory.FreeSpeedrun.ItemIndex = ITEM_FREE_SPEEDRUN_START,
      IfThen(Input.Device.Connected, COLOR_WHITE, COLOR_DARK),
      COLOR_WHITE
    )
  );
end;


procedure TRenderer.RenderFreeSpeedrunItems();
begin
  RenderText(
    ITEM_X_GAME_MODE_START,
    ITEM_Y_GAME_MODE_START,
    ITEM_TEXT_GAME_MODE_START,
    IfThen(
      Input.Device.Connected,
      IfThen(
        Memory.FreeSpeedrun.ItemIndex = ITEM_FREE_SPEEDRUN_START,
        COLOR_WHITE,
        IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
      ),
      COLOR_DARK
    )
  );
end;


procedure TRenderer.RenderFreeSpeedrunParameters();
begin
  RenderText(
    ITEM_X_GAME_MODE_PARAM,
    ITEM_Y_GAME_MODE_REGION,
    ITEM_TEXT_GAME_MODE_REGION[Memory.GameModes.Region],
    IfThen(
      Memory.FreeSpeedrun.ItemIndex = ITEM_FREE_SPEEDRUN_REGION,
      COLOR_WHITE,
      IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
    )
  );

  RenderText(
    ITEM_X_GAME_MODE_PARAM,
    ITEM_Y_GAME_MODE_GENERATOR,
    ITEM_TEXT_GAME_MODE_GENERATOR[Memory.GameModes.Generator],
    IfThen(
      Memory.FreeSpeedrun.ItemIndex = ITEM_FREE_SPEEDRUN_GENERATOR,
      COLOR_WHITE,
      IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
    )
  );
end;


procedure TRenderer.RenderFreeSpeedrunBestScores();
var
  Index: Integer;
begin
  for Index := BEST_SCORES_FIRST to BEST_SCORES_LAST do
    if Index < BestScores[Memory.GameModes.IsSpeedrun][Memory.GameModes.Region][Memory.GameModes.Generator].Count then
      RenderText(
        ITEM_X_GAME_MODE_BEST_SCORE,
        ITEM_Y_GAME_MODE_BEST_SCORES[Memory.Options.Theme] + Index * BEST_SCORES_SPACING_Y,
        SpeedrunEntryToString(
          BestScores
            [Memory.GameModes.IsSpeedrun]
            [Memory.GameModes.Region]
            [Memory.GameModes.Generator].Entry[Index]
        ),
        IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
      )
    else
      RenderText(
        ITEM_X_GAME_MODE_BEST_SCORE,
        ITEM_Y_GAME_MODE_BEST_SCORES[Memory.Options.Theme] + Index * BEST_SCORES_SPACING_Y,
        SpeedrunEntryToString(),
        COLOR_DARK
      );
end;


procedure TRenderer.RenderMarathonQualsSelection();
begin
  if not Memory.GameModes.TimerChanging then
    RenderText(
      ITEM_X_MARATHON_QUALS[Memory.MarathonQuals.ItemIndex],
      ITEM_Y_MARATHON_QUALS[Memory.MarathonQuals.ItemIndex],
      ITEM_TEXT_MARATHON_QUALS[Memory.MarathonQuals.ItemIndex]
    );


  RenderText(
    ITEM_X_MARATHON_QUALS[Memory.MarathonQuals.ItemIndex] - ITEM_X_MARKER,
    ITEM_Y_MARATHON_QUALS[Memory.MarathonQuals.ItemIndex],
    ITEM_TEXT_MARKER,
    IfThen(
      Memory.MarathonQuals.ItemIndex = ITEM_MARATHON_QUALS_START,
      IfThen(
        Input.Device.Connected,
        IfThen(
          Memory.GameModes.TimerChanging,
          IfThen(
            Memory.GameModes.TimerData <> TIMER_DEFAULT_DATA,
            IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE),
            COLOR_DARK
          ),
          IfThen(Memory.GameModes.TimerData <> TIMER_DEFAULT_DATA, COLOR_WHITE, COLOR_DARK)
        ),
        COLOR_DARK
      ),
      IfThen(
        Memory.GameModes.QualsActive,
        IfThen(Memory.MarathonQuals.ItemIndex > ITEM_MARATHON_QUALS_GENERATOR, COLOR_WHITE, COLOR_DARK),
        COLOR_WHITE
      )
    )
  );
end;


procedure TRenderer.RenderMarathonQualsItems();
begin
  RenderText(
    ITEM_X_GAME_MODE_START,
    ITEM_Y_GAME_MODE_START,
    ITEM_TEXT_GAME_MODE_START,
    IfThen(
      Input.Device.Connected,
      IfThen(
        Memory.MarathonQuals.ItemIndex = ITEM_MARATHON_QUALS_START,
        IfThen(
          Memory.GameModes.TimerChanging,
          IfThen(
            Memory.GameModes.TimerData <> TIMER_DEFAULT_DATA,
            IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE),
            COLOR_DARK
          ),
          IfThen(Memory.GameModes.TimerData <> TIMER_DEFAULT_DATA, COLOR_WHITE, COLOR_DARK)
        ),
        IfThen(
          Memory.GameModes.TimerData <> TIMER_DEFAULT_DATA,
          IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE),
          COLOR_DARK
        )
      ),
      COLOR_DARK
    )
  );

  if Memory.GameModes.QualsActive then
  begin
    RenderText(
      ITEM_X_GAME_MODE_REGION,
      ITEM_Y_GAME_MODE_REGION,
      ITEM_TEXT_GAME_MODE_REGION_TITLE,
      COLOR_DARK
    );

    RenderText(
      ITEM_X_GAME_MODE_GENERATOR,
      ITEM_Y_GAME_MODE_GENERATOR,
      ITEM_TEXT_GAME_MODE_GENERATOR_TITLE,
      COLOR_DARK
    );
  end;
end;


procedure TRenderer.RenderMarathonQualsParameters();
begin
  RenderText(
    ITEM_X_GAME_MODE_PARAM,
    ITEM_Y_GAME_MODE_REGION,
    ITEM_TEXT_GAME_MODE_REGION[Memory.GameModes.Region],
    IfThen(
      Memory.GameModes.QualsActive,
      COLOR_DARK,
      IfThen(
        Memory.MarathonQuals.ItemIndex = ITEM_MARATHON_QUALS_REGION,
        COLOR_WHITE,
        IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
      )
    )
  );

  RenderText(
    ITEM_X_GAME_MODE_PARAM,
    ITEM_Y_GAME_MODE_GENERATOR,
    ITEM_TEXT_GAME_MODE_GENERATOR[Memory.GameModes.Generator],
    IfThen(
      Memory.GameModes.QualsActive,
      COLOR_DARK,
      IfThen(
        Memory.MarathonQuals.ItemIndex = ITEM_MARATHON_QUALS_GENERATOR,
        COLOR_WHITE,
        IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
      )
    )
  );

  RenderText(
    ITEM_X_GAME_MODE_PARAM,
    ITEM_Y_GAME_MODE_LEVEL,
    Memory.GameModes.Level.ToString(),
    IfThen(
      Memory.MarathonQuals.ItemIndex = ITEM_MARATHON_QUALS_LEVEL,
      COLOR_WHITE,
      IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
    )
  );

  RenderGameModeTimer();
end;


procedure TRenderer.RenderMarathonQualsBestScores();
var
  Index: Integer;
begin
  for Index := BEST_SCORES_FIRST to BEST_SCORES_LAST do
    if Index < BestScores.Quals[Memory.GameModes.IsSpeedrun][Memory.GameModes.Region][Memory.GameModes.Generator].Count then
      RenderText(
        ITEM_X_GAME_MODE_BEST_SCORE,
        ITEM_Y_GAME_MODE_BEST_SCORES[Memory.Options.Theme] + Index * BEST_SCORES_SPACING_Y,
        MarathonEntryToString(
          BestScores.Quals
            [Memory.GameModes.IsSpeedrun]
            [Memory.GameModes.Region]
            [Memory.GameModes.Generator].Entry[Index]
        ),
        IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
      )
    else
      RenderText(
        ITEM_X_GAME_MODE_BEST_SCORE,
        ITEM_Y_GAME_MODE_BEST_SCORES[Memory.Options.Theme] + Index * BEST_SCORES_SPACING_Y,
        MarathonEntryToString(),
        COLOR_DARK
      );
end;


procedure TRenderer.RenderMarathonMatchSelection();
begin
  if not Memory.GameModes.SeedChanging then
    RenderText(
      ITEM_X_MARATHON_MATCH[Memory.MarathonMatch.ItemIndex],
      ITEM_Y_MARATHON_MATCH[Memory.MarathonMatch.ItemIndex],
      ITEM_TEXT_MARATHON_MATCH[Memory.MarathonMatch.ItemIndex]
    );

  RenderText(
    ITEM_X_MARATHON_MATCH[Memory.MarathonMatch.ItemIndex] - ITEM_X_MARKER,
    ITEM_Y_MARATHON_MATCH[Memory.MarathonMatch.ItemIndex],
    ITEM_TEXT_MARKER,
    IfThen(
      Memory.MarathonMatch.ItemIndex = ITEM_MARATHON_MATCH_START,
      IfThen(
        Input.Device.Connected,
        IfThen(
          Memory.GameModes.SeedChanging,
          IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE),
          COLOR_WHITE
        ),
        COLOR_DARK
      ),
      COLOR_WHITE
    )
  );
end;


procedure TRenderer.RenderMarathonMatchItems();
begin
  RenderText(
    ITEM_X_GAME_MODE_START,
    ITEM_Y_GAME_MODE_START,
    ITEM_TEXT_GAME_MODE_START,
    IfThen(
      Input.Device.Connected,
      IfThen(
        Memory.MarathonMatch.ItemIndex = ITEM_MARATHON_MATCH_START,
        IfThen(
          Memory.GameModes.SeedChanging,
          IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE),
          COLOR_WHITE
        ),
        IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
      ),
      COLOR_DARK
    )
  );
end;


procedure TRenderer.RenderMarathonMatchParameters();
begin
  RenderText(
    ITEM_X_GAME_MODE_PARAM,
    ITEM_Y_GAME_MODE_REGION,
    ITEM_TEXT_GAME_MODE_REGION[Memory.GameModes.Region],
    IfThen(
      Memory.MarathonMatch.ItemIndex = ITEM_MARATHON_MATCH_REGION,
      COLOR_WHITE,
      IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
    )
  );

  RenderText(
    ITEM_X_GAME_MODE_PARAM,
    ITEM_Y_GAME_MODE_GENERATOR,
    ITEM_TEXT_GAME_MODE_GENERATOR[Memory.GameModes.Generator],
    IfThen(
      Memory.MarathonMatch.ItemIndex = ITEM_MARATHON_MATCH_GENERATOR,
      COLOR_WHITE,
      IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
    )
  );

  RenderText(
    ITEM_X_GAME_MODE_PARAM,
    ITEM_Y_GAME_MODE_LEVEL,
    Memory.GameModes.Level.ToString(),
    IfThen(
      Memory.MarathonMatch.ItemIndex = ITEM_MARATHON_MATCH_LEVEL,
      COLOR_WHITE,
      IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
    )
  );

  RenderGameModeSeed();
end;


procedure TRenderer.RenderMarathonMatchBestScores();
var
  Index: Integer;
begin
  for Index := BEST_SCORES_FIRST to BEST_SCORES_LAST do
    if Index < BestScores.Match[Memory.GameModes.IsSpeedrun][Memory.GameModes.Region][Memory.GameModes.Generator].Count then
      RenderText(
        ITEM_X_GAME_MODE_BEST_SCORE,
        ITEM_Y_GAME_MODE_BEST_SCORES[Memory.Options.Theme] + Index * BEST_SCORES_SPACING_Y,
        MarathonEntryToString(
          BestScores.Match
            [Memory.GameModes.IsSpeedrun]
            [Memory.GameModes.Region]
            [Memory.GameModes.Generator].Entry[Index]
        ),
        IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
      )
    else
      RenderText(
        ITEM_X_GAME_MODE_BEST_SCORE,
        ITEM_Y_GAME_MODE_BEST_SCORES[Memory.Options.Theme] + Index * BEST_SCORES_SPACING_Y,
        MarathonEntryToString(),
        COLOR_DARK
      );
end;


procedure TRenderer.RenderSpeedrunQualsSelection();
begin
  if not Memory.GameModes.TimerChanging then
    RenderText(
      ITEM_X_SPEEDRUN_QUALS[Memory.SpeedrunQuals.ItemIndex],
      ITEM_Y_SPEEDRUN_QUALS[Memory.SpeedrunQuals.ItemIndex],
      ITEM_TEXT_SPEEDRUN_QUALS[Memory.SpeedrunQuals.ItemIndex]
    );

  RenderText(
    ITEM_X_SPEEDRUN_QUALS[Memory.SpeedrunQuals.ItemIndex] - ITEM_X_MARKER,
    ITEM_Y_SPEEDRUN_QUALS[Memory.SpeedrunQuals.ItemIndex],
    ITEM_TEXT_MARKER,
    IfThen(
      Memory.SpeedrunQuals.ItemIndex = ITEM_SPEEDRUN_QUALS_START,
      IfThen(
        Input.Device.Connected,
        IfThen(
          Memory.GameModes.TimerChanging,
          IfThen(
            Memory.GameModes.TimerData <> TIMER_DEFAULT_DATA,
            IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE),
            COLOR_DARK
          ),
          IfThen(Memory.GameModes.TimerData <> TIMER_DEFAULT_DATA, COLOR_WHITE, COLOR_DARK)
        ),
        COLOR_DARK
      ),
      IfThen(
        Memory.GameModes.QualsActive,
        IfThen(Memory.SpeedrunQuals.ItemIndex > ITEM_SPEEDRUN_QUALS_GENERATOR, COLOR_WHITE, COLOR_DARK),
        COLOR_WHITE
      )
    )
  );
end;


procedure TRenderer.RenderSpeedrunQualsItems();
begin
  RenderText(
    ITEM_X_GAME_MODE_START,
    ITEM_Y_GAME_MODE_START,
    ITEM_TEXT_GAME_MODE_START,
    IfThen(
      Input.Device.Connected,
      IfThen(
        Memory.SpeedrunQuals.ItemIndex = ITEM_SPEEDRUN_QUALS_START,
        IfThen(
          Memory.GameModes.TimerChanging,
          IfThen(
            Memory.GameModes.TimerData <> TIMER_DEFAULT_DATA,
            IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE),
            COLOR_DARK
          ),
          IfThen(Memory.GameModes.TimerData <> TIMER_DEFAULT_DATA, COLOR_WHITE, COLOR_DARK)
        ),
        IfThen(
          Memory.GameModes.TimerData <> TIMER_DEFAULT_DATA,
          IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE),
          COLOR_DARK
        )
      ),
      COLOR_DARK
    )
  );

  if Memory.GameModes.QualsActive then
  begin
    RenderText(
      ITEM_X_GAME_MODE_REGION,
      ITEM_Y_GAME_MODE_REGION,
      ITEM_TEXT_GAME_MODE_REGION_TITLE,
      COLOR_DARK
    );

    RenderText(
      ITEM_X_GAME_MODE_GENERATOR,
      ITEM_Y_GAME_MODE_GENERATOR,
      ITEM_TEXT_GAME_MODE_GENERATOR_TITLE,
      COLOR_DARK
    );
  end;
end;


procedure TRenderer.RenderSpeedrunQualsParameters();
begin
  RenderText(
    ITEM_X_GAME_MODE_PARAM,
    ITEM_Y_GAME_MODE_REGION,
    ITEM_TEXT_GAME_MODE_REGION[Memory.GameModes.Region],
    IfThen(
      Memory.GameModes.QualsActive,
      COLOR_DARK,
      IfThen(
        Memory.SpeedrunQuals.ItemIndex = ITEM_SPEEDRUN_QUALS_REGION,
        COLOR_WHITE,
        IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
      )
    )
  );

  RenderText(
    ITEM_X_GAME_MODE_PARAM,
    ITEM_Y_GAME_MODE_GENERATOR,
    ITEM_TEXT_GAME_MODE_GENERATOR[Memory.GameModes.Generator],
    IfThen(
      Memory.GameModes.QualsActive,
      COLOR_DARK,
      IfThen(
        Memory.SpeedrunQuals.ItemIndex = ITEM_SPEEDRUN_QUALS_GENERATOR,
        COLOR_WHITE,
        IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
      )
    )
  );

  RenderGameModeTimer();
end;


procedure TRenderer.RenderSpeedrunQualsBestScores();
var
  Index: Integer;
begin
  for Index := BEST_SCORES_FIRST to BEST_SCORES_LAST do
    if Index < BestScores.Quals[Memory.GameModes.IsSpeedrun][Memory.GameModes.Region][Memory.GameModes.Generator].Count then
      RenderText(
        ITEM_X_GAME_MODE_BEST_SCORE,
        ITEM_Y_GAME_MODE_BEST_SCORES[Memory.Options.Theme] + Index * BEST_SCORES_SPACING_Y,
        SpeedrunEntryToString(
          BestScores.Quals
            [Memory.GameModes.IsSpeedrun]
            [Memory.GameModes.Region]
            [Memory.GameModes.Generator].Entry[Index]
        ),
        IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
      )
    else
      RenderText(
        ITEM_X_GAME_MODE_BEST_SCORE,
        ITEM_Y_GAME_MODE_BEST_SCORES[Memory.Options.Theme] + Index * BEST_SCORES_SPACING_Y,
        SpeedrunEntryToString(),
        COLOR_DARK
      );
end;


procedure TRenderer.RenderSpeedrunMatchSelection();
begin
  if not Memory.GameModes.SeedChanging then
    RenderText(
      ITEM_X_SPEEDRUN_MATCH[Memory.SpeedrunMatch.ItemIndex],
      ITEM_Y_SPEEDRUN_MATCH[Memory.SpeedrunMatch.ItemIndex],
      ITEM_TEXT_SPEEDRUN_MATCH[Memory.SpeedrunMatch.ItemIndex]
    );

  RenderText(
    ITEM_X_SPEEDRUN_MATCH[Memory.SpeedrunMatch.ItemIndex] - ITEM_X_MARKER,
    ITEM_Y_SPEEDRUN_MATCH[Memory.SpeedrunMatch.ItemIndex],
    ITEM_TEXT_MARKER,
    IfThen(
      Memory.SpeedrunMatch.ItemIndex = ITEM_SPEEDRUN_MATCH_START,
      IfThen(
        Input.Device.Connected,
        IfThen(
          Memory.GameModes.SeedChanging,
          IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE),
          COLOR_WHITE
        ),
        COLOR_DARK
      ),
      COLOR_WHITE
    )
  );
end;


procedure TRenderer.RenderSpeedrunMatchItems();
begin
  RenderText(
    ITEM_X_GAME_MODE_START,
    ITEM_Y_GAME_MODE_START,
    ITEM_TEXT_GAME_MODE_START,
    IfThen(
      Input.Device.Connected,
      IfThen(
        Memory.SpeedrunMatch.ItemIndex = ITEM_SPEEDRUN_MATCH_START,
        IfThen(
          Memory.GameModes.SeedChanging,
          IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE),
          COLOR_WHITE
        ),
        IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
      ),
      COLOR_DARK
    )
  );
end;


procedure TRenderer.RenderSpeedrunMatchParameters();
begin
  RenderText(
    ITEM_X_GAME_MODE_PARAM,
    ITEM_Y_GAME_MODE_REGION,
    ITEM_TEXT_GAME_MODE_REGION[Memory.GameModes.Region],
    IfThen(
      Memory.SpeedrunMatch.ItemIndex = ITEM_SPEEDRUN_MATCH_REGION,
      COLOR_WHITE,
      IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
    )
  );

  RenderText(
    ITEM_X_GAME_MODE_PARAM,
    ITEM_Y_GAME_MODE_GENERATOR,
    ITEM_TEXT_GAME_MODE_GENERATOR[Memory.GameModes.Generator],
    IfThen(
      Memory.SpeedrunMatch.ItemIndex = ITEM_SPEEDRUN_MATCH_GENERATOR,
      COLOR_WHITE,
      IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
    )
  );

  RenderGameModeSeed();
end;


procedure TRenderer.RenderSpeedrunMatchBestScores();
var
  Index: Integer;
begin
  for Index := BEST_SCORES_FIRST to BEST_SCORES_LAST do
    if Index < BestScores.Match[Memory.GameModes.IsSpeedrun][Memory.GameModes.Region][Memory.GameModes.Generator].Count then
      RenderText(
        ITEM_X_GAME_MODE_BEST_SCORE,
        ITEM_Y_GAME_MODE_BEST_SCORES[Memory.Options.Theme] + Index * BEST_SCORES_SPACING_Y,
        SpeedrunEntryToString(
          BestScores.Match
            [Memory.GameModes.IsSpeedrun]
            [Memory.GameModes.Region]
            [Memory.GameModes.Generator].Entry[Index]
        ),
        IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
      )
    else
      RenderText(
        ITEM_X_GAME_MODE_BEST_SCORE,
        ITEM_Y_GAME_MODE_BEST_SCORES[Memory.Options.Theme] + Index * BEST_SCORES_SPACING_Y,
        SpeedrunEntryToString(),
        COLOR_DARK
      );
end;


procedure TRenderer.RenderGameBestTitle();
begin
  if Memory.GameModes.IsQuals then
    RenderText(
      TOP_TITLE_X[Memory.Options.Theme],
      TOP_TITLE_Y[Memory.Options.Theme],
      ITEM_TEXT_QUALS_LEFT,
      COLOR_WHITE,
      IfThen(Memory.Options.Theme = THEME_MODERN, ALIGN_RIGHT, ALIGN_LEFT)
    );
end;


procedure TRenderer.RenderGameBest();
begin
  RenderText(
    TOP_X[Memory.Options.Theme],
    TOP_Y[Memory.Options.Theme],
    IfThen(
      Memory.GameModes.IsQuals,
      Converter.FramesToTimerString(Memory.GameModes.QualsRemaining),
      IfThen(
        Memory.GameModes.IsMarathon,
        Converter.ScoreToString(Memory.Game.Best),
        Converter.FramesToTimeString(Memory.Game.Best)
      )
    ),
    IfThen(
      Memory.GameModes.IsQuals,
      IfThen(
        Converter.IsTimerRunningOut(Memory.GameModes.QualsRemaining),
        IfThen(Clock.FrameIndexInHalf, COLOR_DARK, COLOR_WHITE),
        COLOR_WHITE
      ),
      COLOR_WHITE
    )
  );
end;


procedure TRenderer.RenderGameScore();
begin
  RenderText(
    SCORES_X[Memory.Options.Theme],
    SCORES_Y[Memory.Options.Theme],
    Converter.ScoreToString(Memory.Game.Score)
  );
end;


procedure TRenderer.RenderGameLines();
begin
  RenderText(
    LINES_X[Memory.Options.Theme],
    LINES_Y[Memory.Options.Theme],
    Converter.LinesToString(Memory.Game.Lines)
  );
end;


procedure TRenderer.RenderGameLevel();
begin
  RenderText(
    LEVEL_X[Memory.Options.Theme],
    LEVEL_Y[Memory.Options.Theme],
    Converter.LevelToString(Memory.Game.Level)
  );
end;


procedure TRenderer.RenderGameNext();
begin
  if Memory.Game.NextVisible then
    RenderNext(
      NEXT_X[Memory.Options.Theme],
      NEXT_Y[Memory.Options.Theme],
      Memory.Game.Next,
      Memory.Game.Level
    );
end;


procedure TRenderer.RenderGameTime();
begin
  if Memory.GameModes.IsSpeedrun then
    RenderText(
      TIME_X[Memory.Options.Theme],
      TIME_Y[Memory.Options.Theme],
      Converter.FramesToTimeString(Memory.Game.SpeedrunTimer),
      IfThen(
        Memory.Game.State <> STATE_UPDATE_TOP_OUT,
        IfThen(
          Converter.IsTimeRunningOut(Memory.Game.SpeedrunTimer),
          IfThen(Clock.FrameIndexInHalf, COLOR_DARK, COLOR_WHITE),
          COLOR_WHITE
        ),
        COLOR_WHITE
      )
    );
end;


procedure TRenderer.RenderGameStack();
var
  OffsetX, OffsetY, BrickX, BrickY: Integer;
begin
  OffsetY := STACK_Y[Memory.Options.Theme];
  BrickY := 0;

  while BrickY <= 19 do
  begin
    OffsetX := STACK_X[Memory.Options.Theme];
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
  if Memory.Game.PieceID = PIECE_UNKNOWN then Exit;

  BrickXMin := Max(Memory.Game.PieceX - 2, 0);
  BrickXMax := Min(Memory.Game.PieceX + 2, 9);

  BrickYMin := Max(Memory.Game.PieceY - 2, 0);
  BrickYMax := Min(Memory.Game.PieceY + 2, 19);

  for BrickY := BrickYMin to BrickYMax do
  begin
    OffsetY := STACK_Y[Memory.Options.Theme];
    OffsetY += BrickY * BRICK_CELL_HEIGHT;

    for BrickX := BrickXMin to BrickXMax do
    begin
      OffsetX := STACK_X[Memory.Options.Theme];
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
        IfThen(
          Memory.GameModes.IsQuals,
          IfThen(
            Memory.Pause.ItemIndex = ITEM_PAUSE_RESUME,
            COLOR_DARK,
            IfThen(
              Memory.Pause.ItemIndex = ITEM_PAUSE_RESTART,
              IfThen(Memory.GameModes.QualsRemaining > 0, COLOR_WHITE, COLOR_DARK),
              COLOR_WHITE
            )
          ),
          COLOR_WHITE
        ),
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
        Memory.GameModes.IsQuals,
        COLOR_DARK,
        IfThen(
          Memory.Pause.ItemIndex = ITEM_PAUSE_RESUME,
          COLOR_WHITE,
          IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
        )
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
        Memory.GameModes.IsQuals,
        IfThen(
          Memory.GameModes.QualsRemaining > 0,
          IfThen(
            Memory.Pause.ItemIndex = ITEM_PAUSE_RESTART,
            COLOR_WHITE,
            IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
          ),
          COLOR_DARK
        ),
        IfThen(
          Memory.Pause.ItemIndex = ITEM_PAUSE_RESTART,
          COLOR_WHITE,
          IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
        )
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


procedure TRenderer.RenderTopOutResultTotalTime();
begin
  if not Memory.GameModes.IsSpeedrun then Exit;

  RenderText(
    ITEM_X_TOP_OUT_RESULT_TOTAL_TIME_TITLE,
    ITEM_Y_TOP_OUT_RESULT_TOTAL_TIME_TITLE,
    ITEM_TEXT_TOP_OUT_RESULT_TOTAL_TIME_TITLE,
    IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_ORANGE, COLOR_WHITE)
  );

  RenderText(
    ITEM_X_TOP_OUT_RESULT_TOTAL_TIME,
    ITEM_Y_TOP_OUT_RESULT_TOTAL_TIME,
    IfThen(
      Memory.Game.SpeedrunCompleted,
      Converter.FramesToTimeString(Memory.Game.SpeedrunTimer, True),
      '-'
    ),
    IfThen(Memory.Game.SpeedrunCompleted, COLOR_WHITE, COLOR_DARK),
    ALIGN_RIGHT
  );
end;


procedure TRenderer.RenderTopOutResultTransition();
begin
  if Memory.GameModes.IsSpeedrun then Exit;

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
  if Memory.GameModes.IsQuals then Exit;

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


procedure TRenderer.RenderTopOutResultQualsEndIn();
begin
  if not Memory.GameModes.IsQuals then Exit;

  RenderText(
    ITEM_X_TOP_OUT_RESULT_QUALS_END_IN_TITLE,
    ITEM_Y_TOP_OUT_RESULT_QUALS_END_IN_TITLE,
    ITEM_TEXT_TOP_OUT_RESULT_QUALS_END_IN_TITLE,
    IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_ORANGE, COLOR_WHITE)
  );

  RenderText(
    ITEM_X_TOP_OUT_RESULT_QUALS_END_IN,
    ITEM_Y_TOP_OUT_RESULT_QUALS_END_IN,
    Converter.FramesToTimerString(Memory.GameModes.QualsRemaining, True),
    IfThen(
      Converter.IsTimerRunningOut(Memory.GameModes.QualsRemaining),
      IfThen(Clock.FrameIndexInHalf, COLOR_DARK, COLOR_WHITE),
      COLOR_WHITE
    ),
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
        IfThen(
          Memory.GameModes.IsQuals,
          IfThen(Memory.GameModes.QualsRemaining > 0, COLOR_WHITE, COLOR_DARK),
          COLOR_WHITE
        ),
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
        IfThen(
          Memory.GameModes.IsQuals,
          IfThen(Memory.GameModes.QualsRemaining > 0, COLOR_WHITE, COLOR_DARK),
          COLOR_WHITE
        ),
        IfThen(
          Memory.GameModes.IsQuals,
          IfThen(
            Memory.GameModes.QualsRemaining > 0,
            IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE),
            COLOR_DARK
          ),
          IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
        )
      ),
      COLOR_DARK
    )
  );
end;


procedure TRenderer.RenderTopOutResult();
begin
  RenderTopOutResultScore();
  RenderTopOutResultTotalTime();
  RenderTopOutResultTransition();
  RenderTopOutResultLinesCleared();
  RenderTopOutResultLinesBurned();
  RenderTopOutResultTetrisRate();
  RenderTopOutResultQualsEndIn();
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
        IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
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
        IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
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
        IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
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
        IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
      ),
      COLOR_DARK
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
        IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
      )
    )
  );

  RenderText(
    ITEM_X_OPTIONS_PARAM,
    ITEM_Y_OPTIONS_THEME,
    ITEM_TEXT_OPTIONS_THEME[Memory.Options.Theme],
    IfThen(
      Memory.Options.ItemIndex = ITEM_OPTIONS_THEME,
      COLOR_WHITE,
      IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
    )
  );

  RenderText(
    ITEM_X_OPTIONS_PARAM,
    ITEM_Y_OPTIONS_CONTROLS,
    ITEM_TEXT_OPTIONS_CONTROLS[Memory.Options.Controls],
    IfThen(
      Memory.Options.ItemIndex = ITEM_OPTIONS_CONTROLS,
      COLOR_WHITE,
      IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
    )
  );

  RenderText(
    ITEM_X_OPTIONS_PARAM,
    ITEM_Y_OPTIONS_SOUNDS,
    ITEM_TEXT_OPTIONS_SOUNDS[Memory.Options.Sounds],
    IfThen(
      Memory.Options.ItemIndex = ITEM_OPTIONS_SOUNDS,
      COLOR_WHITE,
      IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
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
          IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE),
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
        IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
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
          IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
        ),
        IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
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
          IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE),
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
        IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
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
          IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
        ),
        IfThen(Memory.Options.Theme = THEME_MODERN, COLOR_GRAY, COLOR_WHITE)
      )
    );
end;


procedure TRenderer.RenderBegin();
begin
  SDL_SetRenderTarget(Window.Renderer, Buffers.Native);
end;


procedure TRenderer.RenderEnd();
begin
  SDL_SetRenderTarget(Window.Renderer, nil);
end;


procedure TModernRenderer.RenderButton(AX, AY, AButton: Integer);
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


procedure TModernRenderer.RenderGameBurned();
begin
  RenderText(
    BURNED_X,
    BURNED_Y,
    Converter.BurnedToString(Memory.Game.Burned),
    COLOR_WHITE,
    ALIGN_RIGHT
  );
end;


procedure TModernRenderer.RenderGameTetrises();
begin
  RenderText(
    TETRISES_X,
    TETRISES_Y,
    Converter.TetrisesToString(Memory.Game.TetrisRate),
    COLOR_WHITE,
    ALIGN_RIGHT
  );
end;


procedure TModernRenderer.RenderGameGain();
begin
  if Memory.Game.GainTimer > 0 then
    RenderText(
      GAIN_X,
      GAIN_Y,
      Converter.GainToString(Memory.Game.Gain),
      COLOR_WHITE,
      ALIGN_RIGHT
    );
end;


procedure TModernRenderer.RenderGameInput();
var
  Index: Integer;
begin
  for Index := DEVICE_FIRST to DEVICE_LAST do
    if Input.Device.Switch[Index].Pressed then
      RenderButton(
        CONTROLLER_X + THUMBNAIL_BUTTON_X[Index],
        CONTROLLER_Y + THUMBNAIL_BUTTON_Y[Index],
        Index
      );
end;


procedure TModernRenderer.RenderLegal();
begin

end;


procedure TModernRenderer.RenderMenu();
begin
  RenderMenuSelection();
end;


procedure TModernRenderer.RenderModes();
begin
  RenderModesSelection();
  RenderModesItems();
end;


procedure TModernRenderer.RenderFreeMarathon();
begin
  RenderFreeMarathonSelection();
  RenderFreeMarathonItems();
  RenderFreeMarathonParameters();
  RenderFreeMarathonBestScores();
end;


procedure TModernRenderer.RenderFreeSpeedrun();
begin
  RenderFreeSpeedrunSelection();
  RenderFreeSpeedrunItems();
  RenderFreeSpeedrunParameters();
  RenderFreeSpeedrunBestScores();
end;


procedure TModernRenderer.RenderMarathonQuals();
begin
  RenderMarathonQualsSelection();
  RenderMarathonQualsItems();
  RenderMarathonQualsParameters();
  RenderMarathonQualsBestScores();
end;


procedure TModernRenderer.RenderMarathonMatch();
begin
  RenderMarathonMatchSelection();
  RenderMarathonMatchItems();
  RenderMarathonMatchParameters();
  RenderMarathonMatchBestScores();
end;


procedure TModernRenderer.RenderSpeedrunQuals();
begin
  RenderSpeedrunQualsSelection();
  RenderSpeedrunQualsItems();
  RenderSpeedrunQualsParameters();
  RenderSpeedrunQualsBestScores();
end;


procedure TModernRenderer.RenderSpeedrunMatch();
begin
  RenderSpeedrunMatchSelection();
  RenderSpeedrunMatchItems();
  RenderSpeedrunMatchParameters();
  RenderSpeedrunMatchBestScores();
end;


procedure TModernRenderer.RenderGame();
begin
  RenderGameBestTitle();
  RenderGameBest();
  RenderGameScore();
  RenderGameLines();
  RenderGameLevel();
  RenderGameNext();
  RenderGameTime();
  RenderGameStack();
  RenderGamePiece();

  RenderGameBurned();
  RenderGameTetrises();
  RenderGameGain();
  RenderGameInput();
end;


procedure TModernRenderer.RenderPause();
begin
  RenderPauseSelection();
  RenderPauseItems();
end;


procedure TModernRenderer.RenderTopOut();
begin
  RenderTopOutSelection();
  RenderTopOutItems();
  RenderTopOutResult();
end;


procedure TModernRenderer.RenderOptions();
begin
  RenderOptionsSelection();
  RenderOptionsItems();
  RenderOptionsParameters();
end;


procedure TModernRenderer.RenderKeyboard();
begin
  RenderKeyboardItemSelection();
  RenderKeyboardItems();
  RenderKeyboardKeySelection();
  RenderKeyboardKeyScanCodes();
end;


procedure TModernRenderer.RenderController();
begin
  RenderControllerItemSelection();
  RenderControllerItems();
  RenderControllerButtonSelection();
  RenderControllerButtonScanCodes();
end;


procedure TModernRenderer.RenderQuit();
begin

end;


procedure TModernRenderer.RenderScene(ASceneID: Integer);
begin
  RenderBegin();
  RenderGround(ASceneID);

  case ASceneID of
    SCENE_LEGAL:           RenderLegal();
    SCENE_MENU:            RenderMenu();
    SCENE_MODES:           RenderModes();
    SCENE_FREE_MARATHON:   RenderFreeMarathon();
    SCENE_FREE_SPEEDRUN:   RenderFreeSpeedrun();
    SCENE_MARATHON_QUALS:  RenderMarathonQuals();
    SCENE_MARATHON_MATCH:  RenderMarathonMatch();
    SCENE_SPEEDRUN_QUALS:  RenderSpeedrunQuals();
    SCENE_SPEEDRUN_MATCH:  RenderSpeedrunMatch();
    SCENE_GAME_NORMAL:     RenderGame();
    SCENE_GAME_FLASH:      RenderGame();
    SCENE_SPEEDRUN_NORMAL: RenderGame();
    SCENE_SPEEDRUN_FLASH:  RenderGame();
    SCENE_PAUSE:           RenderPause();
    SCENE_TOP_OUT:         RenderTopOut();
    SCENE_OPTIONS:         RenderOptions();
    SCENE_KEYBOARD:        RenderKeyboard();
    SCENE_CONTROLLER:      RenderController();
    SCENE_QUIT:            RenderQuit();
  end;

  RenderEnd();
end;


procedure TClassicRenderer.RenderMiniature(AX, AY, APiece, ALevel: Integer);
begin
  if APiece <> MINIATURE_UNKNOWN then
  begin
    ALevel := ALevel mod 10;

    RenderSprite(
      Sprites.Miniatures,
      SDL_Rect(
        AX,
        AY,
        MINIATURE_WIDTH,
        MINIATURE_HEIGHT
      ),
      SDL_Rect(
        APiece * MINIATURE_WIDTH,
        ALevel * MINIATURE_HEIGHT,
        MINIATURE_WIDTH,
        MINIATURE_HEIGHT
      )
    );
  end;
end;


procedure TClassicRenderer.RenderGameStats();
var
  Index: Integer;
begin
  for Index := PIECE_FIRST to PIECE_LAST do
  begin
    RenderMiniature(
      MINIATURE_X[Index],
      MINIATURE_Y[Index],
      Index,
      Memory.Game.Level
    );

    RenderText(
      STATISTIC_X[Index],
      STATISTIC_Y[Index],
      Converter.PiecesToString(Memory.Game.Stats[Index]),
      COLOR_RED
    );
  end;
end;


procedure TClassicRenderer.RenderLegal();
begin

end;


procedure TClassicRenderer.RenderMenu();
begin
  RenderMenuSelection();
end;


procedure TClassicRenderer.RenderModes();
begin
  RenderModesSelection();
  RenderModesItems();
end;


procedure TClassicRenderer.RenderFreeMarathon();
begin
  RenderFreeMarathonSelection();
  RenderFreeMarathonItems();
  RenderFreeMarathonParameters();
  RenderFreeMarathonBestScores();
end;


procedure TClassicRenderer.RenderFreeSpeedrun();
begin
  RenderFreeSpeedrunSelection();
  RenderFreeSpeedrunItems();
  RenderFreeSpeedrunParameters();
  RenderFreeSpeedrunBestScores();
end;


procedure TClassicRenderer.RenderMarathonQuals();
begin
  RenderMarathonQualsSelection();
  RenderMarathonQualsItems();
  RenderMarathonQualsParameters();
  RenderMarathonQualsBestScores();
end;


procedure TClassicRenderer.RenderMarathonMatch();
begin
  RenderMarathonMatchSelection();
  RenderMarathonMatchItems();
  RenderMarathonMatchParameters();
  RenderMarathonMatchBestScores();
end;


procedure TClassicRenderer.RenderSpeedrunQuals();
begin
  RenderSpeedrunQualsSelection();
  RenderSpeedrunQualsItems();
  RenderSpeedrunQualsParameters();
  RenderSpeedrunQualsBestScores();
end;


procedure TClassicRenderer.RenderSpeedrunMatch();
begin
  RenderSpeedrunMatchSelection();
  RenderSpeedrunMatchItems();
  RenderSpeedrunMatchParameters();
  RenderSpeedrunMatchBestScores();
end;


procedure TClassicRenderer.RenderGame();
begin
  RenderGameBestTitle();
  RenderGameBest();
  RenderGameScore();
  RenderGameLines();
  RenderGameLevel();
  RenderGameNext();
  RenderGameTime();
  RenderGameStack();
  RenderGamePiece();

  RenderGameStats();
end;


procedure TClassicRenderer.RenderPause();
begin
  RenderPauseSelection();
  RenderPauseItems();
end;


procedure TClassicRenderer.RenderTopOut();
begin
  RenderTopOutSelection();
  RenderTopOutItems();
  RenderTopOutResult();
end;


procedure TClassicRenderer.RenderOptions();
begin
  RenderOptionsSelection();
  RenderOptionsItems();
  RenderOptionsParameters();
end;


procedure TClassicRenderer.RenderKeyboard();
begin
  RenderKeyboardItemSelection();
  RenderKeyboardItems();
  RenderKeyboardKeySelection();
  RenderKeyboardKeyScanCodes();
end;


procedure TClassicRenderer.RenderController();
begin
  RenderControllerItemSelection();
  RenderControllerItems();
  RenderControllerButtonSelection();
  RenderControllerButtonScanCodes();
end;


procedure TClassicRenderer.RenderQuit();
begin

end;


procedure TClassicRenderer.RenderScene(ASceneID: Integer);
begin
  RenderBegin();
  RenderGround(ASceneID);

  case ASceneID of
    SCENE_LEGAL:           RenderLegal();
    SCENE_MENU:            RenderMenu();
    SCENE_MODES:           RenderModes();
    SCENE_FREE_MARATHON:   RenderFreeMarathon();
    SCENE_FREE_SPEEDRUN:   RenderFreeSpeedrun();
    SCENE_MARATHON_QUALS:  RenderMarathonQuals();
    SCENE_MARATHON_MATCH:  RenderMarathonMatch();
    SCENE_SPEEDRUN_QUALS:  RenderSpeedrunQuals();
    SCENE_SPEEDRUN_MATCH:  RenderSpeedrunMatch();
    SCENE_GAME_NORMAL:     RenderGame();
    SCENE_GAME_FLASH:      RenderGame();
    SCENE_SPEEDRUN_NORMAL: RenderGame();
    SCENE_SPEEDRUN_FLASH:  RenderGame();
    SCENE_PAUSE:           RenderPause();
    SCENE_TOP_OUT:         RenderTopOut();
    SCENE_OPTIONS:         RenderOptions();
    SCENE_KEYBOARD:        RenderKeyboard();
    SCENE_CONTROLLER:      RenderController();
    SCENE_QUIT:            RenderQuit();
  end;

  RenderEnd();
end;


constructor TRenderers.Create();
begin
  FModern := TModernRenderer.Create();
  FClassic := TClassicRenderer.Create();

  FTheme := FModern;
  FThemeID := THEME_MODERN;
end;


procedure TRenderers.SetThemeID(AThemeID: Integer);
begin
  FThemeID := AThemeID;

  case FThemeID of
    THEME_MODERN:  FTheme := FModern;
    THEME_CLASSIC: FTheme := FClassic;
  end;
end;


function TRenderers.GetModern(): TModernRenderer;
begin
  Result := FModern as TModernRenderer;
end;


function TRenderers.GetClassic(): TClassicRenderer;
begin
  Result := FClassic as TClassicRenderer;
end;


procedure TRenderers.Initialize();
begin
  SetThemeID(Settings.General.Theme);
end;


end.

