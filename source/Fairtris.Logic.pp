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

unit Fairtris.Logic;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  Fairtris.Classes;


type
  TScene = specialize TCustomState<Integer>;


type
  TLogic = class(TObject)
  private
    FScene: TScene;
    FStopped: Boolean;
  private
    procedure UpdateItemIndex(var AItemIndex: Integer; ACount, AStep: Integer);
  private
    function InputMenuSetPrev(): Boolean;
    function InputMenuSetNext(): Boolean;
    function InputMenuAccepted(): Boolean;
    function InputMenuRejected(): Boolean;
  private
    function InputOptionSetPrev(): Boolean;
    function InputOptionSetNext(): Boolean;
    function InputOptionRollPrev(): Boolean;
    function InputOptionRollNext(): Boolean;
    function InputOptionCopy(): Boolean;
    function InputOptionPaste(): Boolean;
    function InputOptionGenerate(): Boolean;
  private
    procedure OpenHelp();
  private
    procedure PrepareModesSelection();
    procedure PrepareFreeMarathonSelection();
    procedure PrepareFreeSpeedrunSelection();
    procedure PrepareMarathonQualsSelection();
    procedure PrepareMarathonQualsLevel();
    procedure PrepareMarathonMatchSelection();
    procedure PrepareSpeedrunQualsSelection();
    procedure PrepareSpeedrunMatchSelection();
  private
    procedure PrepareGameScene();
  private
    procedure PreparePauseSelection();
    procedure PreparePauseScene();
  private
    procedure PrepareTopOutSelection();
    procedure PrepareTopOutResult();
    procedure PrepareTopOutBestScore();
  private
    procedure PrepareOptionsSelection();
    procedure PrepareOptionsScene();
  private
    procedure PrepareKeyboardSelection();
    procedure PrepareKeyboardScanCodes();
  private
    procedure PrepareControllerSelection();
    procedure PrepareControllerScanCodes();
  private
    procedure PrepareModes();
    procedure PrepareFreeMarathon();
    procedure PrepareFreeSpeedrun();
    procedure PrepareMarathonQuals();
    procedure PrepareMarathonMatch();
    procedure PrepareSpeedrunQuals();
    procedure PrepareSpeedrunMatch();
    procedure PreparePause();
    procedure PrepareTopOut();
    procedure PreapreOptions();
    procedure PrepareKeyboard();
    procedure PrepareController();
    procedure PrepareQuit();
  private
    function CopySeedToClipboard(): Boolean;
  private
    function PasteSeedFromClipboard(): Boolean;
    function PasteTimerFromClipboard(): Boolean;
  private
    procedure PasteRandomSeed();
  private
    procedure UpdateLegalHang();
    procedure UpdateLegalScene();
  private
    procedure UpdateMenuSelection();
    procedure UpdateMenuScene();
  private
    procedure UpdateModesSelection();
    procedure UpdateModesScene();
  private
    procedure UpdateMatchSeed();
    procedure UpdateQualsTimer();
  private
    procedure UpdateFreeMarathonSelection();
    procedure UpdateFreeMarathonRegion();
    procedure UpdateFreeMarathonGenerator();
    procedure UpdateFreeMarathonLevel();
    procedure UpdateFreeMarathonScene();
  private
    procedure UpdateFreeSpeedrunSelection();
    procedure UpdateFreeSpeedrunRegion();
    procedure UpdateFreeSpeedrunGenerator();
    procedure UpdateFreeSpeedrunScene();
  private
    procedure UpdateMarathonQualsSelection();
    procedure UpdateMarathonQualsRegion();
    procedure UpdateMarathonQualsGenerator();
    procedure UpdateMarathonQualsLevel();
    procedure UpdateMarathonQualsTimer();
    procedure UpdateMarathonQualsScene();
  private
    procedure UpdateMarathonMatchSelection();
    procedure UpdateMarathonMatchRegion();
    procedure UpdateMarathonMatchGenerator();
    procedure UpdateMarathonMatchLevel();
    procedure UpdateMarathonMatchSeed();
    procedure UpdateMarathonMatchScene();
  private
    procedure UpdateSpeedrunQualsSelection();
    procedure UpdateSpeedrunQualsRegion();
    procedure UpdateSpeedrunQualsGenerator();
    procedure UpdateSpeedrunQualsTimer();
    procedure UpdateSpeedrunQualsScene();
  private
    procedure UpdateSpeedrunMatchSelection();
    procedure UpdateSpeedrunMatchRegion();
    procedure UpdateSpeedrunMatchGenerator();
    procedure UpdateSpeedrunMatchSeed();
    procedure UpdateSpeedrunMatchScene();
  private
    procedure UpdateGameState();
    procedure UpdateGameScene();
  private
    procedure UpdatePauseCommon();
    procedure UpdatePauseSelection();
    procedure UpdatePauseScene();
  private
    procedure UpdateTopOutSelection();
    procedure UpdateTopOutScene();
  private
    procedure UpdateOptionsSelection();
    procedure UpdateOptionsInput();
    procedure UpdateOptionsWindow();
    procedure UpdateOptionsTheme();
    procedure UpdateOptionsControls();
    procedure UpdateOptionsSounds();
    procedure UpdateOptionsScene();
  private
    procedure UpdateKeyboardItemSelection();
    procedure UpdateKeyboardKeySelection();
    procedure UpdateKeyboardKeyScanCode();
    procedure UpdateKeyboardScene();
  private
    procedure UpdateControllerItemSelection();
    procedure UpdateControllerButtonSelection();
    procedure UpdateControllerButtonScanCode();
    procedure UpdateControllerScene();
  private
    procedure UpdateQuitHang();
    procedure UpdateQuitScene();
  private
    procedure UpdateCommon();
    procedure UpdateLegal();
    procedure UpdateMenu();
    procedure UpdateModes();
    procedure UpdateFreeMarathon();
    procedure UpdateFreeSpeedrun();
    procedure UpdateMarathonQuals();
    procedure UpdateMarathonMatch();
    procedure UpdateSpeedrunQuals();
    procedure UpdateSpeedrunMatch();
    procedure UpdateGame();
    procedure UpdatePause();
    procedure UpdateTopOut();
    procedure UpdateOptions();
    procedure UpdateKeyboard();
    procedure UpdateController();
    procedure UpdateQuit();
  public
    constructor Create();
    destructor Destroy(); override;
  public
    procedure Update();
    procedure Reset();
    procedure Stop();
  public
    property Scene: TScene read FScene;
    property Stopped: Boolean read FStopped;
  end;


var
  Logic: TLogic;


implementation

uses
  SDL2,
  Math,
  SysUtils,
  Fairtris.Window,
  Fairtris.Clock,
  Fairtris.Buffers,
  Fairtris.Input,
  Fairtris.Memory,
  Fairtris.Placement,
  Fairtris.Converter,
  Fairtris.Renderers,
  Fairtris.Grounds,
  Fairtris.Sounds,
  Fairtris.BestScores,
  Fairtris.Generators,
  Fairtris.Core,
  Fairtris.Help,
  Fairtris.Utils,
  Fairtris.Arrays,
  Fairtris.Constants;


constructor TLogic.Create();
begin
  FScene := TScene.Create({$IFDEF MODE_DEBUG} SCENE_MENU {$ELSE} SCENE_LEGAL {$ENDIF});
end;


destructor TLogic.Destroy();
begin
  FScene.Free();
  inherited Destroy();
end;


procedure TLogic.UpdateItemIndex(var AItemIndex: Integer; ACount, AStep: Integer);
begin
  AItemIndex := WrapAround(AItemIndex, ACount, AStep);
end;


function TLogic.InputMenuSetPrev(): Boolean;
begin
  Result := Input.Fixed.Up.JustPressed or Input.Controller.Up.JustPressed;
end;


function TLogic.InputMenuSetNext(): Boolean;
begin
  Result := Input.Fixed.Down.JustPressed or Input.Controller.Down.JustPressed;
end;


function TLogic.InputMenuAccepted(): Boolean;
begin
  Result := Input.Fixed.Accept.JustPressed or Input.Controller.Start.JustPressed or Input.Controller.A.JustPressed;
end;


function TLogic.InputMenuRejected(): Boolean;
begin
  Result := Input.Fixed.Cancel.JustPressed or Input.Controller.B.JustPressed;
end;


function TLogic.InputOptionSetPrev(): Boolean;
begin
  Result := Input.Fixed.Left.JustPressed or Input.Controller.Left.JustPressed;
end;


function TLogic.InputOptionSetNext(): Boolean;
begin
  Result := Input.Fixed.Right.JustPressed or Input.Controller.Right.JustPressed;
end;


function TLogic.InputOptionRollPrev(): Boolean;
begin
  Result := Input.Fixed.Left.Pressed or Input.Controller.Left.Pressed;
end;


function TLogic.InputOptionRollNext(): Boolean;
begin
  Result := Input.Fixed.Right.Pressed or Input.Controller.Right.Pressed;
end;


function TLogic.InputOptionCopy(): Boolean;
begin
  Result := Input.Keyboard.Device[SDL_SCANCODE_LCTRL].Pressed and Input.Keyboard.Device[SDL_SCANCODE_C].JustPressed;
end;


function TLogic.InputOptionPaste(): Boolean;
begin
  Result := Input.Keyboard.Device[SDL_SCANCODE_INSERT].JustPressed;

  if not Result then
    Result := Input.Keyboard.Device[SDL_SCANCODE_LCTRL].Pressed and Input.Keyboard.Device[SDL_SCANCODE_V].JustPressed;
end;


function TLogic.InputOptionGenerate(): Boolean;
begin
  Result := Input.Keyboard.Device[SDL_SCANCODE_LCTRL].Pressed and Input.Keyboard.Device[SDL_SCANCODE_G].JustPressed;
  Result := Result or Input.Controller.Select.JustPressed;
end;


procedure TLogic.OpenHelp();
begin
  Sounds.PlaySound(SOUND_START);

  if Placement.VideoEnabled then
    Placement.ToggleVideoMode();

  with THelpThread.Create(True) do
  begin
    FreeOnTerminate := True;
    Start();
  end;
end;


procedure TLogic.PrepareModesSelection();
begin
  Memory.Modes.ItemIndex := ITEM_MODES_FREE_MARATHON;
end;


procedure TLogic.PrepareFreeMarathonSelection();
begin
  Memory.FreeMarathon.ItemIndex := ITEM_FREE_MARATHON_START;
end;


procedure TLogic.PrepareFreeSpeedrunSelection();
begin
  Memory.FreeSpeedrun.ItemIndex := ITEM_FREE_SPEEDRUN_START;
end;


procedure TLogic.PrepareMarathonQualsSelection();
begin
  Memory.MarathonQuals.ItemIndex := ITEM_MARATHON_QUALS_START;
end;


procedure TLogic.PrepareMarathonQualsLevel();
begin
  Memory.GameModes.Level := Min(Memory.GameModes.Level, LEVEL_LAST_QUALS);
end;


procedure TLogic.PrepareMarathonMatchSelection();
begin
  Memory.MarathonMatch.ItemIndex := ITEM_MARATHON_MATCH_START;
end;


procedure TLogic.PrepareSpeedrunQualsSelection();
begin
  Memory.SpeedrunQuals.ItemIndex := ITEM_SPEEDRUN_QUALS_START;
end;


procedure TLogic.PrepareSpeedrunMatchSelection();
begin
  Memory.SpeedrunMatch.ItemIndex := ITEM_SPEEDRUN_MATCH_START;
end;


procedure TLogic.PrepareGameScene();
begin
  if not (FScene.Previous in [SCENE_GAME_NORMAL .. SCENE_SPEEDRUN_FLASH, SCENE_PAUSE]) then
    Core.Reset();
end;


procedure TLogic.PreparePauseSelection();
begin
  Memory.Pause.ItemIndex := IfThen(Input.Device.Connected, ITEM_PAUSE_FIRST, ITEM_PAUSE_OPTIONS);
end;


procedure TLogic.PreparePauseScene();
begin
  if FScene.Previous in [SCENE_GAME_NORMAL .. SCENE_SPEEDRUN_FLASH] then
    Memory.Pause.FromScene := FScene.Previous;
end;


procedure TLogic.PrepareTopOutSelection();
begin
  Memory.TopOut.ItemIndex := ITEM_TOP_OUT_FIRST;
end;


procedure TLogic.PrepareTopOutResult();
begin
  Memory.TopOut.TotalScore := Memory.Game.Score;
  Memory.TopOut.Transition := Memory.Game.Transition;

  Memory.TopOut.LinesCleared := Memory.Game.LinesCleared;
  Memory.TopOut.LinesBurned := Memory.Game.LinesBurned;

  Memory.TopOut.TetrisRate := Memory.Game.TetrisRate;
end;


procedure TLogic.PrepareTopOutBestScore();
var
  Entry: TScoreEntry;
begin
  Entry := TScoreEntry.Create(Memory.GameModes.IsSpeedrun, Memory.GameModes.Region, True);

  Entry.LinesCleared := Memory.Game.LinesCleared;
  Entry.LevelBegin := Memory.GameModes.Level;
  Entry.LevelEnd := Memory.Game.Level;
  Entry.TetrisRate := Memory.Game.TetrisRate;
  Entry.TotalScore := Memory.Game.Score;
  Entry.TotalTime := Memory.Game.SpeedrunTimer;
  Entry.Completed := Memory.Game.SpeedrunCompleted;

  BestScores[Memory.GameModes.IsSpeedrun][Memory.GameModes.Region][Memory.GameModes.Generator].Add(Entry);

  if Memory.GameModes.IsQuals then
    BestScores.Quals[Memory.GameModes.IsSpeedrun][Memory.GameModes.Region][Memory.GameModes.Generator].Add(Entry.Clone());

  if Memory.GameModes.IsMatch then
    BestScores.Match[Memory.GameModes.IsSpeedrun][Memory.GameModes.Region][Memory.GameModes.Generator].Add(Entry.Clone());
end;


procedure TLogic.PrepareOptionsSelection();
begin
  Memory.Options.ItemIndex := ITEM_OPTIONS_FIRST;
end;


procedure TLogic.PrepareOptionsScene();
begin
  if FScene.Previous in [SCENE_MENU, SCENE_PAUSE] then
    Memory.Options.FromScene := FScene.Previous;
end;


procedure TLogic.PrepareKeyboardSelection();
begin
  Memory.Keyboard.ItemIndex := ITEM_KEYBOARD_FIRST;
  Memory.Keyboard.KeyIndex := ITEM_KEYBOARD_KEY_FIRST;
end;


procedure TLogic.PrepareKeyboardScanCodes();
var
  Index: Integer;
begin
  for Index := Low(Memory.Keyboard.ScanCodes) to High(Memory.Keyboard.ScanCodes) do
    Memory.Keyboard.ScanCodes[Index] := Input.Keyboard.ScanCode[Index];
end;


procedure TLogic.PrepareControllerSelection();
begin
  Memory.Controller.ItemIndex := ITEM_CONTROLLER_FIRST;
  Memory.Controller.ButtonIndex := ITEM_CONTROLLER_BUTTON_FIRST;
end;


procedure TLogic.PrepareControllerScanCodes();
var
  Index: Integer;
begin
  for Index := Low(Memory.Controller.ScanCodes) to High(Memory.Controller.ScanCodes) do
    Memory.Controller.ScanCodes[Index] := Input.Controller.ScanCode[Index];
end;


procedure TLogic.PrepareModes();
begin
  if not FScene.Changed then Exit;

  if FScene.Previous = SCENE_MENU then
    PrepareModesSelection();
end;


procedure TLogic.PrepareFreeMarathon();
begin
  if not FScene.Changed then Exit;

  if FScene.Previous = SCENE_MODES then
    PrepareFreeMarathonSelection();

  Memory.Game.Started := False;
  Memory.Game.FromScene := SCENE_FREE_MARATHON;
  Memory.GameModes.Mode := MODE_FREE_MARATHON;
end;


procedure TLogic.PrepareFreeSpeedrun();
begin
  if not FScene.Changed then Exit;

  if FScene.Previous = SCENE_MODES then
    PrepareFreeSpeedrunSelection();

  Memory.Game.Started := False;
  Memory.Game.FromScene := SCENE_FREE_SPEEDRUN;
  Memory.GameModes.Mode := MODE_FREE_SPEEDRUN;
end;


procedure TLogic.PrepareMarathonQuals();
begin
  if not FScene.Changed then Exit;

  if FScene.Previous = SCENE_MODES then
  begin
    PrepareMarathonQualsSelection();
    PrepareMarathonQualsLevel();
  end;

  Memory.Game.Started := False;
  Memory.Game.FromScene := SCENE_MARATHON_QUALS;
  Memory.GameModes.Mode := MODE_MARATHON_QUALS;
end;


procedure TLogic.PrepareMarathonMatch();
begin
  if not FScene.Changed then Exit;

  if FScene.Previous = SCENE_MODES then
    PrepareMarathonMatchSelection();

  Memory.Game.Started := False;
  Memory.Game.FromScene := SCENE_MARATHON_MATCH;
  Memory.GameModes.Mode := MODE_MARATHON_MATCH;
end;


procedure TLogic.PrepareSpeedrunQuals();
begin
  if not FScene.Changed then Exit;

  if FScene.Previous = SCENE_MODES then
    PrepareSpeedrunQualsSelection();

  Memory.Game.Started := False;
  Memory.Game.FromScene := SCENE_SPEEDRUN_QUALS;
  Memory.GameModes.Mode := MODE_SPEEDRUN_QUALS;
end;


procedure TLogic.PrepareSpeedrunMatch();
begin
  if not FScene.Changed then Exit;

  if FScene.Previous = SCENE_MODES then
    PrepareSpeedrunMatchSelection();

  Memory.Game.Started := False;
  Memory.Game.FromScene := SCENE_SPEEDRUN_MATCH;
  Memory.GameModes.Mode := MODE_SPEEDRUN_MATCH;
end;


procedure TLogic.PreparePause();
begin
  if not FScene.Changed then Exit;

  if FScene.Previous <> SCENE_OPTIONS then
  begin
    PreparePauseSelection();
    PreparePauseScene();
  end;
end;


procedure TLogic.PrepareTopOut();
begin
  if FScene.Changed then
  begin
    PrepareTopOutSelection();
    PrepareTopOutResult();
    PrepareTopOutBestScore();

    Memory.Game.Started := False;
    Generators.Generator.UnlockRandomness();
  end;
end;


procedure TLogic.PreapreOptions();
begin
  if not FScene.Changed then Exit;

  if FScene.Previous in [SCENE_MENU, SCENE_PAUSE] then
  begin
    PrepareOptionsSelection();
    PrepareOptionsScene();
  end;
end;


procedure TLogic.PrepareKeyboard();
begin
  if not FScene.Changed then Exit;

  if FScene.Previous = SCENE_OPTIONS then
  begin
    PrepareKeyboardSelection();
    PrepareKeyboardScanCodes();
  end;
end;


procedure TLogic.PrepareController();
begin
  if not FScene.Changed then Exit;

  if FScene.Previous = SCENE_OPTIONS then
  begin
    PrepareControllerSelection();
    PrepareControllerScanCodes();
  end;
end;


procedure TLogic.PrepareQuit();
var
  OldTarget: PSDL_Texture;
begin
  if not FScene.Changed then Exit;

  OldTarget := SDL_GetRenderTarget(Window.Renderer);
  SDL_SetRenderTarget(Window.Renderer, Memory.Quit.Buffer);

  SDL_RenderCopy(Window.Renderer, Buffers.Native, nil, nil);
  SDL_RenderCopy(Window.Renderer, Grounds[Memory.Options.Theme][SCENE_QUIT], nil, nil);

  SDL_SetRenderTarget(Window.Renderer, OldTarget);
end;


function TLogic.CopySeedToClipboard(): Boolean;
begin
  Result := not Memory.GameModes.SeedChanging;
  Result := Result and (SDL_SetClipboardText(PChar(Memory.GameModes.SeedData)) = 0);

  Sounds.PlaySound(IfThen(Result, SOUND_COIN, SOUND_HUM));
end;


function TLogic.PasteSeedFromClipboard(): Boolean;
var
  SeedData: String;
begin
  Result := False;

  if SDL_HasClipboardText() = SDL_FALSE then
    Sounds.PlaySound(SOUND_HUM)
  else
  begin
    SeedData := Converter.TextToSeed(SDL_GetClipboardText());

    if SeedData = '' then
      Sounds.PlaySound(SOUND_HUM)
    else
    begin
      Memory.GameModes.SeedData := SeedData;
      Memory.GameModes.SeedChanging := False;

      Sounds.PlaySound(SOUND_COIN);
      Result := True;
    end;
  end;
end;


function TLogic.PasteTimerFromClipboard(): Boolean;
var
  TimerData: String;
begin
  Result := False;

  if SDL_HasClipboardText() = SDL_FALSE then
    Sounds.PlaySound(SOUND_HUM)
  else
  begin
    TimerData := Converter.TextToTimer(SDL_GetClipboardText());

    if TimerData = '' then
      Sounds.PlaySound(SOUND_HUM)
    else
    begin
      Memory.GameModes.TimerData := TimerData;
      Memory.GameModes.TimerChanging := False;

      Result := True;

      if TimerData = TIMER_DEFAULT_DATA then
        Sounds.PlaySound(SOUND_BURN)
      else
        Sounds.PlaySound(SOUND_COIN);
    end;
  end;
end;


procedure TLogic.PasteRandomSeed();
begin
  Memory.GameModes.SeedData := GenerateRandomSeed();
  Memory.GameModes.SeedChanging := False;

  Sounds.PlaySound(SOUND_COIN);
end;


procedure TLogic.UpdateLegalHang();
begin
  Memory.Legal.HangTimer += 1;
end;


procedure TLogic.UpdateLegalScene();
begin
  FScene.Validate();

  if Memory.Legal.HangTimer = DURATION_HANG_LEGAL * Clock.FrameRateLimit then
    FScene.Current := SCENE_MENU;
end;


procedure TLogic.UpdateMenuSelection();
begin
  if InputMenuSetPrev() then
  begin
    UpdateItemIndex(Memory.Menu.ItemIndex, ITEM_MENU_COUNT, ITEM_PREV);
    Sounds.PlaySound(SOUND_BLIP);
  end;

  if InputMenuSetNext() then
  begin
    UpdateItemIndex(Memory.Menu.ItemIndex, ITEM_MENU_COUNT, ITEM_NEXT);
    Sounds.PlaySound(SOUND_BLIP);
  end;
end;


procedure TLogic.UpdateMenuScene();
begin
  FScene.Validate();

  if InputMenuAccepted() then
  begin
    case Memory.Menu.ItemIndex of
      ITEM_MENU_PLAY:    FScene.Current := SCENE_MODES;
      ITEM_MENU_OPTIONS: FScene.Current := SCENE_OPTIONS;
      ITEM_MENU_QUIT:    FScene.Current := SCENE_QUIT;
    end;

    if Memory.Menu.ItemIndex <> ITEM_MENU_QUIT then
      Sounds.PlaySound(SOUND_START)
    else
      Sounds.PlaySound(SOUND_GLASS, True);

    if Memory.Menu.ItemIndex = ITEM_MENU_HELP then
      OpenHelp();
  end;
end;


procedure TLogic.UpdateModesSelection();
begin
  if InputMenuSetPrev() then
  begin
    UpdateItemIndex(Memory.Modes.ItemIndex, ITEM_MODES_COUNT, ITEM_PREV);
    Sounds.PlaySound(SOUND_BLIP);
  end;

  if InputMenuSetNext() then
  begin
    UpdateItemIndex(Memory.Modes.ItemIndex, ITEM_MODES_COUNT, ITEM_NEXT);
    Sounds.PlaySound(SOUND_BLIP);
  end;
end;


procedure TLogic.UpdateModesScene();
begin
  FScene.Validate();

  if InputMenuRejected() then
  begin
    FScene.Current := SCENE_MENU;
    Sounds.PlaySound(SOUND_DROP);
  end;

  if InputMenuAccepted() then
  begin
    if Memory.GameModes.QualsActive and (Memory.Modes.ItemIndex <> ITEM_MODES_BACK) then
    case Memory.Modes.ItemIndex of
      ITEM_MODES_MARATHON_QUALS:
        if Memory.GameModes.QualsMode = QUALS_MODE_MARATHON then
        begin
          FScene.Current := SCENE_MARATHON_QUALS;
          Sounds.PlaySound(SOUND_START);
        end
        else
          Sounds.PlaySound(SOUND_HUM);
      ITEM_MODES_SPEEDRUN_QUALS:
        if Memory.GameModes.QualsMode = QUALS_MODE_SPEEDRUN then
        begin
          FScene.Current := SCENE_SPEEDRUN_QUALS;
          Sounds.PlaySound(SOUND_START);
        end
        else
          Sounds.PlaySound(SOUND_HUM);
    otherwise
      Sounds.PlaySound(SOUND_HUM);
    end
    else
    begin
      case Memory.Modes.ItemIndex of
        ITEM_MODES_FREE_MARATHON:  FScene.Current := SCENE_FREE_MARATHON;
        ITEM_MODES_FREE_SPEEDRUN:  FScene.Current := SCENE_FREE_SPEEDRUN;
        ITEM_MODES_MARATHON_QUALS: FScene.Current := SCENE_MARATHON_QUALS;
        ITEM_MODES_MARATHON_MATCH: FScene.Current := SCENE_MARATHON_MATCH;
        ITEM_MODES_SPEEDRUN_QUALS: FScene.Current := SCENE_SPEEDRUN_QUALS;
        ITEM_MODES_SPEEDRUN_MATCH: FScene.Current := SCENE_SPEEDRUN_MATCH;
        ITEM_MODES_BACK:           FScene.Current := SCENE_MENU;
      end;

      if Memory.Modes.ItemIndex <> ITEM_MODES_BACK then
        Sounds.PlaySound(SOUND_START)
      else
        Sounds.PlaySound(SOUND_DROP);
    end;
  end;
end;


procedure TLogic.UpdateMatchSeed();
var
  ScanCode: UInt8 = KEYBOARD_SCANCODE_KEY_NOT_MAPPED;
begin
  if InputOptionPaste() and PasteSeedFromClipboard() then Exit;

  if InputOptionCopy() then
  begin
    CopySeedToClipboard();
    Exit;
  end;

  if InputOptionGenerate() then
  begin
    PasteRandomSeed();
    Exit;
  end;

  if not Memory.GameModes.SeedChanging then Exit;

  if Memory.GameModes.SeedEditor.Length < SEED_LENGTH then
  begin
    if Input.Keyboard.CatchedOneHexDigit(ScanCode) then
    begin
      Memory.GameModes.SeedEditor += Converter.ScanCodeToChar(ScanCode);
      Sounds.PlaySound(SOUND_SHIFT);
    end;
  end
  else
    if Input.Keyboard.CatchedOneHexDigit(ScanCode) then
      Sounds.PlaySound(SOUND_HUM);

  if Input.Fixed.Accept.JustPressed then
    if Memory.GameModes.SeedEditor.Length = SEED_LENGTH then
    begin
      Input.Fixed.Accept.Validate();

      Memory.GameModes.SeedData := Memory.GameModes.SeedEditor;
      Memory.GameModes.SeedChanging := False;

      Sounds.PlaySound(SOUND_TETRIS);
    end
    else
      Sounds.PlaySound(SOUND_HUM);

  if Input.Fixed.Clear.JustPressed then
    if Memory.GameModes.SeedEditor.Length > 0 then
    begin
      SetLength(Memory.GameModes.SeedEditor, Memory.GameModes.SeedEditor.Length - 1);
      Sounds.PlaySound(SOUND_BURN);
    end
    else
      Sounds.PlaySound(SOUND_HUM);

  if Input.Fixed.Cancel.JustPressed then
  begin
    Input.Fixed.Cancel.Validate();

    Memory.GameModes.SeedChanging := False;
    Sounds.PlaySound(SOUND_DROP);
  end;
end;


procedure TLogic.UpdateQualsTimer();
var
  ScanCode: UInt8 = KEYBOARD_SCANCODE_KEY_NOT_MAPPED;
  DigitNew, DigitMax: Char;
begin
  if not Memory.GameModes.QualsActive then
    if InputOptionPaste() and PasteTimerFromClipboard() then Exit;

  if not Memory.GameModes.TimerChanging then Exit;

  if Memory.GameModes.TimerEditor.Length < TIMER_LENGTH then
  begin
    if Input.Keyboard.CatchedOneDigit(ScanCode) then
    begin
      DigitNew := Converter.ScanCodeToChar(ScanCode);
      DigitMax := TIMER_MAX_DIGITS[Memory.GameModes.TimerEditor.Length + 1];

      if DigitNew <= DigitMax then
      begin
        Memory.GameModes.TimerEditor += DigitNew;
        Sounds.PlaySound(SOUND_SHIFT);
      end
      else
        Sounds.PlaySound(SOUND_HUM);

      if Memory.GameModes.TimerEditor.Length < TIMER_LENGTH then
        if TIMER_PLACEHOLDER[Memory.GameModes.TimerEditor.Length + 1] = TIMER_SEPARATOR then
          Memory.GameModes.TimerEditor += TIMER_SEPARATOR;
    end;
  end
  else
    if Input.Keyboard.CatchedOneDigit(ScanCode) then
      Sounds.PlaySound(SOUND_HUM);

  if Input.Fixed.Accept.JustPressed then
    if Memory.GameModes.TimerEditor.Length < TIMER_LENGTH then
      Sounds.PlaySound(SOUND_HUM)
    else
    begin
      Input.Fixed.Accept.Validate();

      if Memory.GameModes.QualsActive then
      begin
        if Converter.StringToTimerSeconds(Memory.GameModes.TimerEditor) = 0 then
        begin
          Memory.GameModes.TimerData := Memory.GameModes.TimerEditor;
          Memory.GameModes.TimerChanging := False;

          Memory.GameModes.QualsActive := False;
          Memory.GameModes.QualsMode := QUALS_MODE_DEFAULT;
          Memory.GameModes.QualsRemaining := 0;

          BestScores.Quals[Memory.GameModes.IsSpeedrun].Clear();

          Sounds.PlaySound(SOUND_BURN);
        end
        else
          Sounds.PlaySound(SOUND_HUM);
      end
      else
      begin
        Memory.GameModes.TimerData := Memory.GameModes.TimerEditor;
        Memory.GameModes.TimerChanging := False;

        if Converter.StringToTimerSeconds(Memory.GameModes.TimerEditor) = 0 then
          Sounds.PlaySound(SOUND_BURN)
        else
          Sounds.PlaySound(SOUND_TETRIS);
      end;
    end;

  if Input.Fixed.Clear.JustPressed then
    if Memory.GameModes.TimerEditor.Length > 0 then
    begin
      SetLength(Memory.GameModes.TimerEditor, Memory.GameModes.TimerEditor.Length - 1);

      if Memory.GameModes.TimerEditor.Length > 0 then
        if TIMER_PLACEHOLDER[Memory.GameModes.TimerEditor.Length + 1] = TIMER_SEPARATOR then
          SetLength(Memory.GameModes.TimerEditor, Memory.GameModes.TimerEditor.Length - 1);

      Sounds.PlaySound(SOUND_BURN);
    end
    else
      Sounds.PlaySound(SOUND_HUM);

  if Input.Fixed.Cancel.JustPressed then
  begin
    Input.Fixed.Cancel.Validate();

    Memory.GameModes.TimerChanging := False;
    Sounds.PlaySound(SOUND_DROP);
  end;
end;


procedure TLogic.UpdateFreeMarathonSelection();
begin
  if InputMenuSetPrev() then
  begin
    UpdateItemIndex(Memory.FreeMarathon.ItemIndex, ITEM_FREE_MARATHON_COUNT, ITEM_PREV);
    Sounds.PlaySound(SOUND_BLIP);
  end;

  if InputMenuSetNext() then
  begin
    UpdateItemIndex(Memory.FreeMarathon.ItemIndex, ITEM_FREE_MARATHON_COUNT, ITEM_NEXT);
    Sounds.PlaySound(SOUND_BLIP);
  end;
end;


procedure TLogic.UpdateFreeMarathonRegion();
begin
  if Memory.FreeMarathon.ItemIndex <> ITEM_FREE_MARATHON_REGION then Exit;

  if InputOptionSetPrev() then
  begin
    UpdateItemIndex(Memory.GameModes.Region, REGION_COUNT, ITEM_PREV);
    Sounds.PlaySound(SOUND_SHIFT);
  end;

  if InputOptionSetNext() then
  begin
    UpdateItemIndex(Memory.GameModes.Region, REGION_COUNT, ITEM_NEXT);
    Sounds.PlaySound(SOUND_SHIFT);
  end;

  Clock.FrameRateLimit := CLOCK_FRAMERATE_LIMIT[Memory.GameModes.Region];

  if Memory.GameModes.Region in [REGION_PAL .. REGION_PAL_EXTENDED] then
    Memory.GameModes.Level := Min(Memory.GameModes.Level, LEVEL_LAST_FREE_GAME_PAL);
end;


procedure TLogic.UpdateFreeMarathonGenerator();
begin
  if Memory.FreeMarathon.ItemIndex <> ITEM_FREE_MARATHON_GENERATOR then Exit;

  if InputOptionSetPrev() then
  begin
    UpdateItemIndex(Memory.GameModes.Generator, GENERATOR_COUNT, ITEM_PREV);
    Sounds.PlaySound(SOUND_SHIFT);
  end;

  if InputOptionSetNext() then
  begin
    UpdateItemIndex(Memory.GameModes.Generator, GENERATOR_COUNT, ITEM_NEXT);
    Sounds.PlaySound(SOUND_SHIFT);
  end;

  Generators.GeneratorID := Memory.GameModes.Generator;
end;


procedure TLogic.UpdateFreeMarathonLevel();
begin
  if Memory.FreeMarathon.ItemIndex <> ITEM_FREE_MARATHON_LEVEL then Exit;

  if InputOptionSetPrev() then
  begin
    Memory.FreeMarathon.Autorepeat := 0;

    UpdateItemIndex(Memory.GameModes.Level, LEVEL_COUNT_FREE_GAME[Memory.GameModes.Region], ITEM_PREV);
    Sounds.PlaySound(SOUND_SHIFT);
  end
  else
    if InputOptionRollPrev() then
    begin
      Memory.FreeMarathon.Autorepeat += 1;

      if Memory.FreeMarathon.Autorepeat = AUTOSHIFT_FRAMES_CHARGE[Memory.GameModes.Region] then
      begin
        Memory.FreeMarathon.Autorepeat := AUTOSHIFT_FRAMES_PRECHARGE[Memory.GameModes.Region];

        UpdateItemIndex(Memory.GameModes.Level, LEVEL_COUNT_FREE_GAME[Memory.GameModes.Region], ITEM_PREV);
        Sounds.PlaySound(SOUND_SHIFT);
      end;
    end;

  if InputOptionSetNext() then
  begin
    Memory.FreeMarathon.Autorepeat := 0;

    UpdateItemIndex(Memory.GameModes.Level, LEVEL_COUNT_FREE_GAME[Memory.GameModes.Region], ITEM_NEXT);
    Sounds.PlaySound(SOUND_SHIFT);
  end
  else
    if InputOptionRollNext() then
    begin
      Memory.FreeMarathon.Autorepeat += 1;

      if Memory.FreeMarathon.Autorepeat = AUTOSHIFT_FRAMES_CHARGE[Memory.GameModes.Region] then
      begin
        Memory.FreeMarathon.Autorepeat := AUTOSHIFT_FRAMES_PRECHARGE[Memory.GameModes.Region];

        UpdateItemIndex(Memory.GameModes.Level, LEVEL_COUNT_FREE_GAME[Memory.GameModes.Region], ITEM_NEXT);
        Sounds.PlaySound(SOUND_SHIFT);
      end;
    end;
end;


procedure TLogic.UpdateFreeMarathonScene();
begin
  FScene.Validate();

  if InputMenuRejected() then
  begin
    FScene.Current := SCENE_MODES;
    Sounds.PlaySound(SOUND_DROP);
  end;

  if not Input.Device.Connected then
    if Memory.FreeMarathon.ItemIndex = ITEM_FREE_MARATHON_START then
    begin
      if InputMenuAccepted() then
        Sounds.PlaySound(SOUND_HUM);

      Exit;
    end;

  if InputMenuAccepted() then
  case Memory.FreeMarathon.ItemIndex of
    ITEM_FREE_MARATHON_START:
    begin
      FScene.Current := SCENE_GAME_NORMAL;
      Sounds.PlaySound(SOUND_START);
    end;
    ITEM_FREE_MARATHON_BACK:
    begin
      FScene.Current := SCENE_MODES;
      Sounds.PlaySound(SOUND_DROP);
    end;
  end;
end;


procedure TLogic.UpdateFreeSpeedrunSelection();
begin
  if InputMenuSetPrev() then
  begin
    UpdateItemIndex(Memory.FreeSpeedrun.ItemIndex, ITEM_FREE_SPEEDRUN_COUNT, ITEM_PREV);
    Sounds.PlaySound(SOUND_BLIP);
  end;

  if InputMenuSetNext() then
  begin
    UpdateItemIndex(Memory.FreeSpeedrun.ItemIndex, ITEM_FREE_SPEEDRUN_COUNT, ITEM_NEXT);
    Sounds.PlaySound(SOUND_BLIP);
  end;
end;


procedure TLogic.UpdateFreeSpeedrunRegion();
begin
  if Memory.FreeSpeedrun.ItemIndex <> ITEM_FREE_SPEEDRUN_REGION then Exit;

  if InputOptionSetPrev() then
  begin
    UpdateItemIndex(Memory.GameModes.Region, REGION_COUNT, ITEM_PREV);
    Sounds.PlaySound(SOUND_SHIFT);
  end;

  if InputOptionSetNext() then
  begin
    UpdateItemIndex(Memory.GameModes.Region, REGION_COUNT, ITEM_NEXT);
    Sounds.PlaySound(SOUND_SHIFT);
  end;

  Clock.FrameRateLimit := CLOCK_FRAMERATE_LIMIT[Memory.GameModes.Region];
end;


procedure TLogic.UpdateFreeSpeedrunGenerator();
begin
  if Memory.FreeSpeedrun.ItemIndex <> ITEM_FREE_SPEEDRUN_GENERATOR then Exit;

  if InputOptionSetPrev() then
  begin
    UpdateItemIndex(Memory.GameModes.Generator, GENERATOR_COUNT, ITEM_PREV);
    Sounds.PlaySound(SOUND_SHIFT);
  end;

  if InputOptionSetNext() then
  begin
    UpdateItemIndex(Memory.GameModes.Generator, GENERATOR_COUNT, ITEM_NEXT);
    Sounds.PlaySound(SOUND_SHIFT);
  end;

  Generators.GeneratorID := Memory.GameModes.Generator;
end;


procedure TLogic.UpdateFreeSpeedrunScene();
begin
  FScene.Validate();

  if InputMenuRejected() then
  begin
    FScene.Current := SCENE_MODES;
    Sounds.PlaySound(SOUND_DROP);
  end;

  if not Input.Device.Connected then
    if Memory.FreeSpeedrun.ItemIndex = ITEM_FREE_SPEEDRUN_START then
    begin
      if InputMenuAccepted() then
        Sounds.PlaySound(SOUND_HUM);

      Exit;
    end;

  if InputMenuAccepted() then
  case Memory.FreeSpeedrun.ItemIndex of
    ITEM_FREE_SPEEDRUN_START:
    begin
      FScene.Current := SCENE_SPEEDRUN_NORMAL;
      Sounds.PlaySound(SOUND_START);
    end;
    ITEM_FREE_SPEEDRUN_BACK:
    begin
      FScene.Current := SCENE_MODES;
      Sounds.PlaySound(SOUND_DROP);
    end;
  end;
end;


procedure TLogic.UpdateMarathonQualsSelection();
begin
  if Memory.GameModes.TimerChanging then Exit;

  if InputMenuSetPrev() then
  begin
    UpdateItemIndex(Memory.MarathonQuals.ItemIndex, ITEM_MARATHON_QUALS_COUNT, ITEM_PREV);
    Sounds.PlaySound(SOUND_BLIP);
  end;

  if InputMenuSetNext() then
  begin
    UpdateItemIndex(Memory.MarathonQuals.ItemIndex, ITEM_MARATHON_QUALS_COUNT, ITEM_NEXT);
    Sounds.PlaySound(SOUND_BLIP);
  end;

  if (Memory.MarathonQuals.ItemIndex = ITEM_MARATHON_QUALS_START) and InputOptionSetNext() then
  begin
    Memory.GameModes.TimerChanging := True;
    Memory.GameModes.TimerEditor := TIMER_DEFAULT_EDITOR;

    Sounds.PlaySound(SOUND_START);
  end;
end;


procedure TLogic.UpdateMarathonQualsRegion();
begin
  if Memory.MarathonQuals.ItemIndex <> ITEM_MARATHON_QUALS_REGION then Exit;

  if InputOptionSetPrev() then
    if Memory.GameModes.QualsActive then
      Sounds.PlaySound(SOUND_HUM)
    else
    begin
      UpdateItemIndex(Memory.GameModes.Region, REGION_COUNT, ITEM_PREV);
      Sounds.PlaySound(SOUND_SHIFT);
    end;

  if InputOptionSetNext() then
    if Memory.GameModes.QualsActive then
      Sounds.PlaySound(SOUND_HUM)
    else
    begin
      UpdateItemIndex(Memory.GameModes.Region, REGION_COUNT, ITEM_NEXT);
      Sounds.PlaySound(SOUND_SHIFT);
    end;

  Clock.FrameRateLimit := CLOCK_FRAMERATE_LIMIT[Memory.GameModes.Region];
end;


procedure TLogic.UpdateMarathonQualsGenerator();
begin
  if Memory.MarathonQuals.ItemIndex <> ITEM_MARATHON_QUALS_GENERATOR then Exit;

  if InputOptionSetPrev() then
    if Memory.GameModes.QualsActive then
      Sounds.PlaySound(SOUND_HUM)
    else
    begin
      UpdateItemIndex(Memory.GameModes.Generator, GENERATOR_COUNT, ITEM_PREV);
      Sounds.PlaySound(SOUND_SHIFT);
    end;

  if InputOptionSetNext() then
    if Memory.GameModes.QualsActive then
      Sounds.PlaySound(SOUND_HUM)
    else
    begin
      UpdateItemIndex(Memory.GameModes.Generator, GENERATOR_COUNT, ITEM_NEXT);
      Sounds.PlaySound(SOUND_SHIFT);
    end;

  Generators.GeneratorID := Memory.GameModes.Generator;
end;


procedure TLogic.UpdateMarathonQualsLevel();
begin
  if Memory.MarathonQuals.ItemIndex <> ITEM_MARATHON_QUALS_LEVEL then Exit;

  if InputOptionSetPrev() then
  begin
    Memory.MarathonQuals.Autorepeat := 0;

    UpdateItemIndex(Memory.GameModes.Level, LEVEL_COUNT_QUALS[Memory.GameModes.Region], ITEM_PREV);
    Sounds.PlaySound(SOUND_SHIFT);
  end
  else
    if InputOptionRollPrev() then
    begin
      Memory.MarathonQuals.Autorepeat += 1;

      if Memory.MarathonQuals.Autorepeat = AUTOSHIFT_FRAMES_CHARGE[Memory.GameModes.Region] then
      begin
        Memory.MarathonQuals.Autorepeat := AUTOSHIFT_FRAMES_PRECHARGE[Memory.GameModes.Region];

        UpdateItemIndex(Memory.GameModes.Level, LEVEL_COUNT_QUALS[Memory.GameModes.Region], ITEM_PREV);
        Sounds.PlaySound(SOUND_SHIFT);
      end;
    end;

  if InputOptionSetNext() then
  begin
    Memory.MarathonQuals.Autorepeat := 0;

    UpdateItemIndex(Memory.GameModes.Level, LEVEL_COUNT_QUALS[Memory.GameModes.Region], ITEM_NEXT);
    Sounds.PlaySound(SOUND_SHIFT);
  end
  else
    if InputOptionRollNext() then
    begin
      Memory.MarathonQuals.Autorepeat += 1;

      if Memory.MarathonQuals.Autorepeat = AUTOSHIFT_FRAMES_CHARGE[Memory.GameModes.Region] then
      begin
        Memory.MarathonQuals.Autorepeat := AUTOSHIFT_FRAMES_PRECHARGE[Memory.GameModes.Region];

        UpdateItemIndex(Memory.GameModes.Level, LEVEL_COUNT_QUALS[Memory.GameModes.Region], ITEM_NEXT);
        Sounds.PlaySound(SOUND_SHIFT);
      end;
    end;
end;


procedure TLogic.UpdateMarathonQualsTimer();
begin
  UpdateQualsTimer();
end;


procedure TLogic.UpdateMarathonQualsScene();
begin
  FScene.Validate();

  if not Memory.GameModes.TimerChanging then
    if InputMenuRejected() then
    begin
      FScene.Current := SCENE_MODES;
      Sounds.PlaySound(SOUND_DROP);
    end;

  if not Input.Device.Connected then
    if Memory.MarathonQuals.ItemIndex = ITEM_MARATHON_QUALS_START then
    begin
      if InputMenuAccepted() then
        Sounds.PlaySound(SOUND_HUM);

      Exit;
    end;

  if Memory.GameModes.TimerChanging then Exit;

  if InputMenuRejected() then
  begin
    FScene.Current := SCENE_MODES;
    Sounds.PlaySound(SOUND_DROP);
  end;

  if InputMenuAccepted() then
  case Memory.MarathonQuals.ItemIndex of
    ITEM_MARATHON_QUALS_START:
      if Memory.GameModes.TimerData <> TIMER_DEFAULT_DATA then
      begin
        if not Memory.GameModes.QualsActive then
        begin
          Memory.GameModes.QualsActive := True;
          Memory.GameModes.QualsMode := QUALS_MODE_MARATHON;
          Memory.GameModes.QualsRemaining := Converter.StringToTimerFrames(Memory.GameModes.TimerData);

          BestScores.Quals[False].Clear();
        end;

        FScene.Current := SCENE_GAME_NORMAL;
        Sounds.PlaySound(SOUND_START);
      end
      else
        Sounds.PlaySound(SOUND_HUM);
    ITEM_MARATHON_QUALS_BACK:
    begin
      FScene.Current := SCENE_MODES;
      Sounds.PlaySound(SOUND_DROP);
    end;
  end;
end;


procedure TLogic.UpdateMarathonMatchSelection();
begin
  if Memory.GameModes.SeedChanging then Exit;

  if InputMenuSetPrev() then
  begin
    UpdateItemIndex(Memory.MarathonMatch.ItemIndex, ITEM_MARATHON_MATCH_COUNT, ITEM_PREV);
    Sounds.PlaySound(SOUND_BLIP);
  end;

  if InputMenuSetNext() then
  begin
    UpdateItemIndex(Memory.MarathonMatch.ItemIndex, ITEM_MARATHON_MATCH_COUNT, ITEM_NEXT);
    Sounds.PlaySound(SOUND_BLIP);
  end;

  if (Memory.MarathonMatch.ItemIndex = ITEM_MARATHON_MATCH_START) and InputOptionSetNext() then
  begin
    Memory.GameModes.SeedChanging := True;
    Memory.GameModes.SeedEditor := SEED_DEFAULT_EDITOR;

    Sounds.PlaySound(SOUND_START);
  end;
end;


procedure TLogic.UpdateMarathonMatchRegion();
begin
  if Memory.MarathonMatch.ItemIndex <> ITEM_MARATHON_MATCH_REGION then Exit;

  if InputOptionSetPrev() then
  begin
    UpdateItemIndex(Memory.GameModes.Region, REGION_COUNT, ITEM_PREV);
    Sounds.PlaySound(SOUND_SHIFT);
  end;

  if InputOptionSetNext() then
  begin
    UpdateItemIndex(Memory.GameModes.Region, REGION_COUNT, ITEM_NEXT);
    Sounds.PlaySound(SOUND_SHIFT);
  end;

  Clock.FrameRateLimit := CLOCK_FRAMERATE_LIMIT[Memory.GameModes.Region];

  if Memory.GameModes.Region in [REGION_PAL .. REGION_PAL_EXTENDED] then
    Memory.GameModes.Level := Min(Memory.GameModes.Level, LEVEL_LAST_FREE_GAME_PAL);
end;


procedure TLogic.UpdateMarathonMatchGenerator();
begin
  if Memory.MarathonMatch.ItemIndex <> ITEM_MARATHON_MATCH_GENERATOR then Exit;

  if InputOptionSetPrev() then
  begin
    UpdateItemIndex(Memory.GameModes.Generator, GENERATOR_COUNT, ITEM_PREV);
    Sounds.PlaySound(SOUND_SHIFT);
  end;

  if InputOptionSetNext() then
  begin
    UpdateItemIndex(Memory.GameModes.Generator, GENERATOR_COUNT, ITEM_NEXT);
    Sounds.PlaySound(SOUND_SHIFT);
  end;

  Generators.GeneratorID := Memory.GameModes.Generator;
end;


procedure TLogic.UpdateMarathonMatchLevel();
begin
  if Memory.MarathonMatch.ItemIndex <> ITEM_MARATHON_MATCH_LEVEL then Exit;

  if InputOptionSetPrev() then
  begin
    Memory.MarathonMatch.Autorepeat := 0;

    UpdateItemIndex(Memory.GameModes.Level, LEVEL_COUNT_FREE_GAME[Memory.GameModes.Region], ITEM_PREV);
    Sounds.PlaySound(SOUND_SHIFT);
  end
  else
    if InputOptionRollPrev() then
    begin
      Memory.MarathonMatch.Autorepeat += 1;

      if Memory.MarathonMatch.Autorepeat = AUTOSHIFT_FRAMES_CHARGE[Memory.GameModes.Region] then
      begin
        Memory.MarathonMatch.Autorepeat := AUTOSHIFT_FRAMES_PRECHARGE[Memory.GameModes.Region];

        UpdateItemIndex(Memory.GameModes.Level, LEVEL_COUNT_FREE_GAME[Memory.GameModes.Region], ITEM_PREV);
        Sounds.PlaySound(SOUND_SHIFT);
      end;
    end;

  if InputOptionSetNext() then
  begin
    Memory.MarathonMatch.Autorepeat := 0;

    UpdateItemIndex(Memory.GameModes.Level, LEVEL_COUNT_FREE_GAME[Memory.GameModes.Region], ITEM_NEXT);
    Sounds.PlaySound(SOUND_SHIFT);
  end
  else
    if InputOptionRollNext() then
    begin
      Memory.MarathonMatch.Autorepeat += 1;

      if Memory.MarathonMatch.Autorepeat = AUTOSHIFT_FRAMES_CHARGE[Memory.GameModes.Region] then
      begin
        Memory.MarathonMatch.Autorepeat := AUTOSHIFT_FRAMES_PRECHARGE[Memory.GameModes.Region];

        UpdateItemIndex(Memory.GameModes.Level, LEVEL_COUNT_FREE_GAME[Memory.GameModes.Region], ITEM_NEXT);
        Sounds.PlaySound(SOUND_SHIFT);
      end;
    end;
end;


procedure TLogic.UpdateMarathonMatchSeed();
begin
  UpdateMatchSeed();
end;


procedure TLogic.UpdateMarathonMatchScene();
begin
  FScene.Validate();

  if not Memory.GameModes.SeedChanging then
    if InputMenuRejected() then
    begin
      FScene.Current := SCENE_MODES;
      Sounds.PlaySound(SOUND_DROP);
    end;

  if not Input.Device.Connected then
    if Memory.MarathonMatch.ItemIndex = ITEM_MARATHON_MATCH_START then
    begin
      if InputMenuAccepted() then
        Sounds.PlaySound(SOUND_HUM);

      Exit;
    end;

  if Memory.GameModes.SeedChanging then Exit;

  if InputMenuRejected() then
  begin
    FScene.Current := SCENE_MODES;
    Sounds.PlaySound(SOUND_DROP);
  end;

  if InputMenuAccepted() then
  case Memory.MarathonMatch.ItemIndex of
    ITEM_MARATHON_MATCH_START:
    begin
      FScene.Current := SCENE_GAME_NORMAL;
      Sounds.PlaySound(SOUND_START);
    end;
    ITEM_MARATHON_MATCH_BACK:
    begin
      FScene.Current := SCENE_MODES;
      Sounds.PlaySound(SOUND_DROP);
    end;
  end;
end;


procedure TLogic.UpdateSpeedrunQualsSelection();
begin
  if Memory.GameModes.TimerChanging then Exit;

  if InputMenuSetPrev() then
  begin
    UpdateItemIndex(Memory.SpeedrunQuals.ItemIndex, ITEM_SPEEDRUN_QUALS_COUNT, ITEM_PREV);
    Sounds.PlaySound(SOUND_BLIP);
  end;

  if InputMenuSetNext() then
  begin
    UpdateItemIndex(Memory.SpeedrunQuals.ItemIndex, ITEM_SPEEDRUN_QUALS_COUNT, ITEM_NEXT);
    Sounds.PlaySound(SOUND_BLIP);
  end;

  if (Memory.SpeedrunQuals.ItemIndex = ITEM_SPEEDRUN_QUALS_START) and InputOptionSetNext() then
  begin
    Memory.GameModes.TimerChanging := True;
    Memory.GameModes.TimerEditor := TIMER_DEFAULT_EDITOR;

    Sounds.PlaySound(SOUND_START);
  end;
end;


procedure TLogic.UpdateSpeedrunQualsRegion();
begin
  if Memory.SpeedrunQuals.ItemIndex <> ITEM_SPEEDRUN_QUALS_REGION then Exit;

  if InputOptionSetPrev() then
    if Memory.GameModes.QualsActive then
      Sounds.PlaySound(SOUND_HUM)
    else
    begin
      UpdateItemIndex(Memory.GameModes.Region, REGION_COUNT, ITEM_PREV);
      Sounds.PlaySound(SOUND_SHIFT);
    end;

  if InputOptionSetNext() then
    if Memory.GameModes.QualsActive then
      Sounds.PlaySound(SOUND_HUM)
    else
    begin
      UpdateItemIndex(Memory.GameModes.Region, REGION_COUNT, ITEM_NEXT);
      Sounds.PlaySound(SOUND_SHIFT);
    end;

  Clock.FrameRateLimit := CLOCK_FRAMERATE_LIMIT[Memory.GameModes.Region];
end;


procedure TLogic.UpdateSpeedrunQualsGenerator();
begin
  if Memory.SpeedrunQuals.ItemIndex <> ITEM_SPEEDRUN_QUALS_GENERATOR then Exit;

  if InputOptionSetPrev() then
    if Memory.GameModes.QualsActive then
      Sounds.PlaySound(SOUND_HUM)
    else
    begin
      UpdateItemIndex(Memory.GameModes.Generator, GENERATOR_COUNT, ITEM_PREV);
      Sounds.PlaySound(SOUND_SHIFT);
    end;

  if InputOptionSetNext() then
    if Memory.GameModes.QualsActive then
      Sounds.PlaySound(SOUND_HUM)
    else
    begin
      UpdateItemIndex(Memory.GameModes.Generator, GENERATOR_COUNT, ITEM_NEXT);
      Sounds.PlaySound(SOUND_SHIFT);
    end;

  Generators.GeneratorID := Memory.GameModes.Generator;
end;


procedure TLogic.UpdateSpeedrunQualsTimer();
begin
  UpdateQualsTimer();
end;


procedure TLogic.UpdateSpeedrunQualsScene();
begin
  FScene.Validate();

  if not Memory.GameModes.TimerChanging then
    if InputMenuRejected() then
    begin
      FScene.Current := SCENE_MODES;
      Sounds.PlaySound(SOUND_DROP);
    end;

  if not Input.Device.Connected then
    if Memory.SpeedrunQuals.ItemIndex = ITEM_SPEEDRUN_QUALS_START then
    begin
      if InputMenuAccepted() then
        Sounds.PlaySound(SOUND_HUM);

      Exit;
    end;

  if Memory.GameModes.TimerChanging then Exit;

  if InputMenuRejected() then
  begin
    FScene.Current := SCENE_MODES;
    Sounds.PlaySound(SOUND_DROP);
  end;

  if InputMenuAccepted() then
  case Memory.SpeedrunQuals.ItemIndex of
    ITEM_SPEEDRUN_QUALS_START:
      if Memory.GameModes.TimerData <> TIMER_DEFAULT_DATA then
      begin
        if not Memory.GameModes.QualsActive then
        begin
          Memory.GameModes.QualsActive := True;
          Memory.GameModes.QualsMode := QUALS_MODE_SPEEDRUN;
          Memory.GameModes.QualsRemaining := Converter.StringToTimerFrames(Memory.GameModes.TimerData);

          BestScores.Quals[True].Clear();
        end;

        FScene.Current := SCENE_SPEEDRUN_NORMAL;
        Sounds.PlaySound(SOUND_START);
      end
      else
        Sounds.PlaySound(SOUND_HUM);
    ITEM_SPEEDRUN_QUALS_BACK:
    begin
      FScene.Current := SCENE_MODES;
      Sounds.PlaySound(SOUND_DROP);
    end;
  end;
end;


procedure TLogic.UpdateSpeedrunMatchSelection();
begin
  if Memory.GameModes.SeedChanging then Exit;

  if InputMenuSetPrev() then
  begin
    UpdateItemIndex(Memory.SpeedrunMatch.ItemIndex, ITEM_SPEEDRUN_MATCH_COUNT, ITEM_PREV);
    Sounds.PlaySound(SOUND_BLIP);
  end;

  if InputMenuSetNext() then
  begin
    UpdateItemIndex(Memory.SpeedrunMatch.ItemIndex, ITEM_SPEEDRUN_MATCH_COUNT, ITEM_NEXT);
    Sounds.PlaySound(SOUND_BLIP);
  end;

  if (Memory.SpeedrunMatch.ItemIndex = ITEM_SPEEDRUN_MATCH_START) and InputOptionSetNext() then
  begin
    Memory.GameModes.SeedChanging := True;
    Memory.GameModes.SeedEditor := SEED_DEFAULT_EDITOR;

    Sounds.PlaySound(SOUND_START);
  end;
end;


procedure TLogic.UpdateSpeedrunMatchRegion();
begin
  if Memory.SpeedrunMatch.ItemIndex <> ITEM_SPEEDRUN_MATCH_REGION then Exit;

  if InputOptionSetPrev() then
  begin
    UpdateItemIndex(Memory.GameModes.Region, REGION_COUNT, ITEM_PREV);
    Sounds.PlaySound(SOUND_SHIFT);
  end;

  if InputOptionSetNext() then
  begin
    UpdateItemIndex(Memory.GameModes.Region, REGION_COUNT, ITEM_NEXT);
    Sounds.PlaySound(SOUND_SHIFT);
  end;

  Clock.FrameRateLimit := CLOCK_FRAMERATE_LIMIT[Memory.GameModes.Region];
end;


procedure TLogic.UpdateSpeedrunMatchGenerator();
begin
  if Memory.SpeedrunMatch.ItemIndex <> ITEM_SPEEDRUN_MATCH_GENERATOR then Exit;

  if InputOptionSetPrev() then
  begin
    UpdateItemIndex(Memory.GameModes.Generator, GENERATOR_COUNT, ITEM_PREV);
    Sounds.PlaySound(SOUND_SHIFT);
  end;

  if InputOptionSetNext() then
  begin
    UpdateItemIndex(Memory.GameModes.Generator, GENERATOR_COUNT, ITEM_NEXT);
    Sounds.PlaySound(SOUND_SHIFT);
  end;

  Generators.GeneratorID := Memory.GameModes.Generator;
end;


procedure TLogic.UpdateSpeedrunMatchSeed();
begin
  UpdateMatchSeed();
end;


procedure TLogic.UpdateSpeedrunMatchScene();
begin
  FScene.Validate();

  if not Memory.GameModes.SeedChanging then
    if InputMenuRejected() then
    begin
      FScene.Current := SCENE_MODES;
      Sounds.PlaySound(SOUND_DROP);
    end;

  if not Input.Device.Connected then
    if Memory.SpeedrunMatch.ItemIndex = ITEM_SPEEDRUN_MATCH_START then
    begin
      if InputMenuAccepted() then
        Sounds.PlaySound(SOUND_HUM);

      Exit;
    end;

  if Memory.GameModes.SeedChanging then Exit;

  if InputMenuRejected() then
  begin
    FScene.Current := SCENE_MODES;
    Sounds.PlaySound(SOUND_DROP);
  end;

  if InputMenuAccepted() then
  case Memory.SpeedrunMatch.ItemIndex of
    ITEM_SPEEDRUN_MATCH_START:
    begin
      FScene.Current := SCENE_SPEEDRUN_NORMAL;
      Sounds.PlaySound(SOUND_START);
    end;
    ITEM_SPEEDRUN_MATCH_BACK:
    begin
      FScene.Current := SCENE_MODES;
      Sounds.PlaySound(SOUND_DROP);
    end;
  end;
end;


procedure TLogic.UpdateGameState();
begin
  if FScene.Changed then
    PrepareGameScene();

  Core.Update();
end;


procedure TLogic.UpdateGameScene();
begin
  FScene.Current := IfThen(
    Memory.GameModes.IsSpeedrun,
    IfThen(Memory.Game.Flashing, SCENE_SPEEDRUN_FLASH, SCENE_SPEEDRUN_NORMAL),
    IfThen(Memory.Game.Flashing, SCENE_GAME_FLASH, SCENE_GAME_NORMAL)
  );

  FScene.Validate();

  if Memory.Game.State = STATE_UPDATE_TOP_OUT then
  begin
    if Memory.Game.Ended then
      FScene.Current := SCENE_TOP_OUT;
  end
  else
    if not Input.Device.Connected or Input.Device.Start.JustPressed then
      if not Memory.GameModes.IsMatch then
      begin
        FScene.Current := SCENE_PAUSE;
        Sounds.PlaySound(SOUND_PAUSE, True);
      end
      else
        if Input.Device.Connected then
          Sounds.PlaySound(SOUND_HUM);
end;


procedure TLogic.UpdatePauseCommon();
begin
  Generators.Generator.Step();
end;


procedure TLogic.UpdatePauseSelection();
begin
  if InputMenuSetPrev() then
  begin
    UpdateItemIndex(Memory.Pause.ItemIndex, ITEM_PAUSE_COUNT, ITEM_PREV);
    Sounds.PlaySound(SOUND_BLIP);
  end;

  if InputMenuSetNext() then
  begin
    UpdateItemIndex(Memory.Pause.ItemIndex, ITEM_PAUSE_COUNT, ITEM_NEXT);
    Sounds.PlaySound(SOUND_BLIP);
  end;
end;


procedure TLogic.UpdatePauseScene();
begin
  FScene.Validate();

  if not Input.Device.Connected then
    if Memory.Pause.ItemIndex in [ITEM_PAUSE_RESUME, ITEM_PAUSE_RESTART] then
    begin
      if InputMenuAccepted() then
        Sounds.PlaySound(SOUND_HUM);

      Exit;
    end;

  if InputMenuAccepted() or Input.Device.Start.JustPressed or Input.Keyboard.Start.JustPressed then
  case Memory.Pause.ItemIndex of
    ITEM_PAUSE_RESUME:
      if not Memory.GameModes.IsQuals then
        FScene.Current := Memory.Pause.FromScene
      else
        Sounds.PlaySound(SOUND_HUM);
    ITEM_PAUSE_RESTART:
      if (not Memory.GameModes.IsQuals) or (Memory.GameModes.QualsRemaining > 0) then
      begin
        FScene.Current := Memory.Game.FromScene;
        FScene.Current := SCENE_GAME_NORMAL;

        Sounds.PlaySound(SOUND_START);
      end
      else
        Sounds.PlaySound(SOUND_HUM);
  end;

  if InputMenuAccepted() then
  case Memory.Pause.ItemIndex of
    ITEM_PAUSE_OPTIONS:
    begin
      FScene.Current := SCENE_OPTIONS;
      Sounds.PlaySound(SOUND_START);
    end;
    ITEM_PAUSE_BACK:
    begin
      FScene.Current := Memory.Game.FromScene;

      Generators.Generator.UnlockRandomness();
      Sounds.PlaySound(SOUND_DROP);
    end;
  end;
end;


procedure TLogic.UpdateTopOutSelection();
begin
  if InputMenuSetPrev() then
  begin
    UpdateItemIndex(Memory.TopOut.ItemIndex, ITEM_TOP_OUT_COUNT, ITEM_PREV);
    Sounds.PlaySound(SOUND_BLIP);
  end;

  if InputMenuSetNext() then
  begin
    UpdateItemIndex(Memory.TopOut.ItemIndex, ITEM_TOP_OUT_COUNT, ITEM_NEXT);
    Sounds.PlaySound(SOUND_BLIP);
  end;
end;


procedure TLogic.UpdateTopOutScene();
begin
  FScene.Validate();

  if not Input.Device.Connected then
    if Memory.TopOut.ItemIndex = ITEM_TOP_OUT_PLAY then
    begin
      if InputMenuAccepted() then
        Sounds.PlaySound(SOUND_HUM);

      Exit;
    end;

  if InputMenuRejected() then
  begin
    FScene.Current := Memory.Game.FromScene;
    Sounds.PlaySound(SOUND_DROP);
  end;

  if InputMenuAccepted() or Input.Device.Start.JustPressed or Input.Keyboard.Start.JustPressed then
    if Memory.TopOut.ItemIndex = ITEM_TOP_OUT_PLAY then
      if (not Memory.GameModes.IsQuals) or (Memory.GameModes.QualsRemaining > 0) then
      begin
        Memory.Game.Reset();

        FScene.Current := SCENE_GAME_NORMAL;
        Sounds.PlaySound(SOUND_START);
      end
      else
        Sounds.PlaySound(SOUND_HUM);

  if InputMenuAccepted() then
    if Memory.TopOut.ItemIndex = ITEM_TOP_OUT_BACK then
    begin
      FScene.Current := Memory.Game.FromScene;
      Sounds.PlaySound(SOUND_DROP);
    end;
end;


procedure TLogic.UpdateOptionsSelection();
begin
  if InputMenuSetPrev() then
  begin
    UpdateItemIndex(Memory.Options.ItemIndex, ITEM_OPTIONS_COUNT, ITEM_PREV);
    Sounds.PlaySound(SOUND_BLIP);
  end;

  if InputMenuSetNext() then
  begin
    UpdateItemIndex(Memory.Options.ItemIndex, ITEM_OPTIONS_COUNT, ITEM_NEXT);
    Sounds.PlaySound(SOUND_BLIP);
  end;
end;


procedure TLogic.UpdateOptionsInput();
begin
  if Memory.Options.ItemIndex <> ITEM_OPTIONS_INPUT then Exit;

  if InputOptionSetPrev() then
  begin
    UpdateItemIndex(Memory.Options.Input, INPUT_COUNT, ITEM_PREV);
    Sounds.PlaySound(SOUND_SHIFT);
  end;

  if InputOptionSetNext() then
  begin
    UpdateItemIndex(Memory.Options.Input, INPUT_COUNT, ITEM_NEXT);
    Sounds.PlaySound(SOUND_SHIFT);
  end;

  Input.DeviceID := Memory.Options.Input;
end;


procedure TLogic.UpdateOptionsWindow();
begin
  if Memory.Options.ItemIndex <> ITEM_OPTIONS_SIZE then Exit;

  Memory.Options.Size := Placement.WindowSize;

  if InputOptionSetPrev() then
    if not Placement.VideoEnabled then
    begin
      UpdateItemIndex(Memory.Options.Size, SIZE_COUNT, ITEM_PREV);
      Sounds.PlaySound(SOUND_SHIFT);
    end
    else
      Sounds.PlaySound(SOUND_HUM);

  if InputOptionSetNext() then
    if not Placement.VideoEnabled then
    begin
      UpdateItemIndex(Memory.Options.Size, SIZE_COUNT, ITEM_NEXT);
      Sounds.PlaySound(SOUND_SHIFT);
    end
    else
      Sounds.PlaySound(SOUND_HUM);

  Placement.WindowSize := Memory.Options.Size;
end;


procedure TLogic.UpdateOptionsTheme();
begin
  if Memory.Options.ItemIndex <> ITEM_OPTIONS_THEME then Exit;

  if InputOptionSetPrev() then
  begin
    UpdateItemIndex(Memory.Options.Theme, THEME_COUNT, ITEM_PREV);
    Sounds.PlaySound(SOUND_SHIFT);
  end;

  if InputOptionSetNext() then
  begin
    UpdateItemIndex(Memory.Options.Theme, THEME_COUNT, ITEM_NEXT);
    Sounds.PlaySound(SOUND_SHIFT);
  end;

  Renderers.ThemeID := Memory.Options.Theme;
end;


procedure TLogic.UpdateOptionsControls();
begin
  if Memory.Options.ItemIndex <> ITEM_OPTIONS_CONTROLS then Exit;

  if InputOptionSetPrev() then
  begin
    UpdateItemIndex(Memory.Options.Controls, CONTROLS_COUNT, ITEM_PREV);
    Sounds.PlaySound(SOUND_SHIFT);
  end;

  if InputOptionSetNext() then
  begin
    UpdateItemIndex(Memory.Options.Controls, CONTROLS_COUNT, ITEM_NEXT);
    Sounds.PlaySound(SOUND_SHIFT);
  end;
end;


procedure TLogic.UpdateOptionsSounds();
begin
  if Memory.Options.ItemIndex <> ITEM_OPTIONS_SOUNDS then Exit;

  if InputOptionSetPrev() then
  begin
    UpdateItemIndex(Memory.Options.Sounds, SOUNDS_COUNT, ITEM_PREV);

    Sounds.Enabled := Memory.Options.Sounds;
    Sounds.PlaySound(SOUND_SHIFT);
  end;

  if InputOptionSetNext() then
  begin
    UpdateItemIndex(Memory.Options.Sounds, SOUNDS_COUNT, ITEM_NEXT);

    Sounds.Enabled := Memory.Options.Sounds;
    Sounds.PlaySound(SOUND_SHIFT);
  end;
end;


procedure TLogic.UpdateOptionsScene();
begin
  FScene.Validate();

  if not Input.Device.Connected then
  begin
    if InputMenuRejected() then
      Sounds.PlaySound(SOUND_DROP);

    if Memory.Options.ItemIndex in [ITEM_OPTIONS_SET_UP, ITEM_OPTIONS_BACK] then
      if InputMenuAccepted() then
        Sounds.PlaySound(SOUND_HUM);

    Exit;
  end;

  if InputMenuRejected() then
  begin
    FScene.Current := Memory.Options.FromScene;
    Sounds.PlaySound(SOUND_DROP);
  end;

  if InputMenuAccepted() then
  case Memory.Options.ItemIndex of
    ITEM_OPTIONS_SET_UP:
    case Memory.Options.Input of
      INPUT_KEYBOARD:
        if Input.Keyboard.Device.Connected then
        begin
          FScene.Current := SCENE_KEYBOARD;
          Sounds.PlaySound(SOUND_START);
        end;
      INPUT_CONTROLLER:
        if Input.Controller.Device.Connected then
        begin
          FScene.Current := SCENE_CONTROLLER;
          Sounds.PlaySound(SOUND_START);
        end;
      end;
    ITEM_OPTIONS_BACK:
    begin
      FScene.Current := Memory.Options.FromScene;
      Sounds.PlaySound(SOUND_DROP);
    end;
  end;
end;


procedure TLogic.UpdateKeyboardItemSelection();
begin
  if Memory.Keyboard.Changing or Memory.Keyboard.Mapping then Exit;

  if InputMenuSetPrev() then
  begin
    UpdateItemIndex(Memory.Keyboard.ItemIndex, ITEM_KEYBOARD_COUNT, ITEM_PREV);
    Sounds.PlaySound(SOUND_BLIP);
  end;

  if InputMenuSetNext() then
  begin
    UpdateItemIndex(Memory.Keyboard.ItemIndex, ITEM_KEYBOARD_COUNT, ITEM_NEXT);
    Sounds.PlaySound(SOUND_BLIP);
  end;

  case Memory.Keyboard.ItemIndex of
    ITEM_KEYBOARD_CHANGE:
      if InputMenuAccepted() then
      begin
        Input.Validate();

        Memory.Keyboard.KeyIndex := ITEM_KEYBOARD_KEY_FIRST;
        Memory.Keyboard.Changing := True;

        Sounds.PlaySound(SOUND_START);
      end;
    ITEM_KEYBOARD_RESTORE:
      if InputMenuAccepted() then
      begin
        Input.Keyboard.Restore();
        PrepareKeyboardScanCodes();

        Sounds.PlaySound(SOUND_TOP_OUT, True);
      end;
  end;
end;


procedure TLogic.UpdateKeyboardKeySelection();
begin
  if not Memory.Keyboard.Changing or Memory.Keyboard.Mapping then Exit;

  if InputMenuSetPrev() then
  begin
    UpdateItemIndex(Memory.Keyboard.KeyIndex, ITEM_KEYBOARD_KEY_COUNT, ITEM_PREV);
    Sounds.PlaySound(SOUND_BLIP);
  end;

  if InputMenuSetNext() then
  begin
    UpdateItemIndex(Memory.Keyboard.KeyIndex, ITEM_KEYBOARD_KEY_COUNT, ITEM_NEXT);
    Sounds.PlaySound(SOUND_BLIP);
  end;

  if Memory.Keyboard.KeyIndex < ITEM_KEYBOARD_KEY_LAST then
    if Input.Fixed.Clear.JustPressed then
      if Memory.Keyboard.ScanCodes[Memory.Keyboard.KeyIndex] <> KEYBOARD_SCANCODE_KEY_NOT_MAPPED then
      begin
        Memory.Keyboard.ScanCodes[Memory.Keyboard.KeyIndex] := KEYBOARD_SCANCODE_KEY_NOT_MAPPED;
        Sounds.PlaySound(SOUND_BURN);
      end
      else
        Sounds.PlaySound(SOUND_HUM);

  if Memory.Keyboard.KeyIndex in [ITEM_KEYBOARD_SCANCODE_FIRST .. ITEM_KEYBOARD_SCANCODE_LAST] then
    if InputMenuAccepted() then
    begin
      Memory.Keyboard.Mapping := True;

      Input.Keyboard.Validate();
      Sounds.PlaySound(SOUND_START);
    end;

  if Memory.Keyboard.KeyIndex = ITEM_KEYBOARD_KEY_BACK then
    if InputMenuAccepted() then
    begin
      Memory.Keyboard.Changing := False;
      Sounds.PlaySound(SOUND_DROP);
    end;

  if not Memory.Keyboard.Mapping then
    if InputMenuRejected() then
    begin
      Input.Fixed.Cancel.Validate();
      Input.Controller.B.Validate();

      Memory.Keyboard.Changing := False;
      Sounds.PlaySound(SOUND_DROP);
    end;
end;


procedure TLogic.UpdateKeyboardKeyScanCode();
var
  ScanCode: UInt8 = KEYBOARD_SCANCODE_KEY_NOT_MAPPED;
begin
  if not Memory.Keyboard.Mapping then Exit;

  if Input.Fixed.Cancel.JustPressed then
  begin
    Memory.Keyboard.Mapping := False;
    Sounds.PlaySound(SOUND_DROP);

    Exit;
  end;

  if Input.Keyboard.CatchedOneKey(ScanCode) then
  begin
    Memory.Keyboard.ScanCodes[Memory.Keyboard.KeyIndex] := ScanCode;
    Memory.Keyboard.Mapping := False;
    Memory.Keyboard.RemoveDuplicates(ScanCode, Memory.Keyboard.KeyIndex);

    Sounds.PlaySound(SOUND_START);
  end;
end;


procedure TLogic.UpdateKeyboardScene();
begin
  FScene.Validate();

  if Memory.Keyboard.Changing then Exit;

  if InputMenuRejected() then
  begin
    if Memory.Keyboard.MappedCorrectly() then
    begin
      FScene.Current := SCENE_OPTIONS;
      Sounds.PlaySound(SOUND_DROP);
    end
    else
      Sounds.PlaySound(SOUND_HUM);
  end;

  if Memory.Keyboard.ItemIndex = ITEM_KEYBOARD_SAVE then
    if InputMenuAccepted() then
      if Memory.Keyboard.MappedCorrectly() then
      begin
        Input.Keyboard.Introduce();

        FScene.Current := SCENE_OPTIONS;
        Sounds.PlaySound(SOUND_TETRIS, True);
      end
      else
        Sounds.PlaySound(SOUND_HUM);

  if Memory.Keyboard.ItemIndex = ITEM_KEYBOARD_CANCEL then
    if InputMenuAccepted() then
    begin
      FScene.Current := SCENE_OPTIONS;
      Sounds.PlaySound(SOUND_DROP);
    end;
end;


procedure TLogic.UpdateControllerItemSelection();
begin
  if Memory.Controller.Changing or Memory.Controller.Mapping then Exit;

  if InputMenuSetPrev() then
  begin
    UpdateItemIndex(Memory.Controller.ItemIndex, ITEM_CONTROLLER_COUNT, ITEM_PREV);
    Sounds.PlaySound(SOUND_BLIP);
  end;

  if InputMenuSetNext() then
  begin
    UpdateItemIndex(Memory.Controller.ItemIndex, ITEM_CONTROLLER_COUNT, ITEM_NEXT);
    Sounds.PlaySound(SOUND_BLIP);
  end;

  case Memory.Controller.ItemIndex of
    ITEM_CONTROLLER_CHANGE:
      if InputMenuAccepted() then
      begin
        Input.Validate();

        Memory.Controller.ButtonIndex := ITEM_CONTROLLER_BUTTON_FIRST;
        Memory.Controller.Changing := True;

        Sounds.PlaySound(SOUND_START);
      end;
    ITEM_CONTROLLER_RESTORE:
      if InputMenuAccepted() then
      begin
        Input.Controller.Restore();
        PrepareControllerScanCodes();

        Sounds.PlaySound(SOUND_TOP_OUT, True);
      end;
  end;
end;


procedure TLogic.UpdateControllerButtonSelection();
begin
  if not Memory.Controller.Changing or Memory.Controller.Mapping then Exit;

  if InputMenuSetPrev() then
  begin
    UpdateItemIndex(Memory.Controller.ButtonIndex, ITEM_CONTROLLER_BUTTON_COUNT, ITEM_PREV);
    Sounds.PlaySound(SOUND_BLIP);
  end;

  if InputMenuSetNext() then
  begin
    UpdateItemIndex(Memory.Controller.ButtonIndex, ITEM_CONTROLLER_BUTTON_COUNT, ITEM_NEXT);
    Sounds.PlaySound(SOUND_BLIP);
  end;

  if Memory.Controller.ButtonIndex < ITEM_CONTROLLER_BUTTON_LAST then
    if Input.Fixed.Clear.JustPressed then
      if Memory.Controller.ScanCodes[Memory.Controller.ButtonIndex] <> CONTROLLER_SCANCODE_BUTTON_NOT_MAPPED then
      begin
        Memory.Controller.ScanCodes[Memory.Controller.ButtonIndex] := CONTROLLER_SCANCODE_BUTTON_NOT_MAPPED;
        Sounds.PlaySound(SOUND_BURN);
      end
      else
        Sounds.PlaySound(SOUND_HUM);

  if Memory.Controller.ButtonIndex in [ITEM_CONTROLLER_SCANCODE_FIRST .. ITEM_CONTROLLER_SCANCODE_LAST] then
    if InputMenuAccepted() then
    begin
      Memory.Controller.Mapping := True;

      Input.Controller.Validate();
      Sounds.PlaySound(SOUND_START);
    end;

  if Memory.Controller.ButtonIndex = ITEM_CONTROLLER_BUTTON_BACK then
    if InputMenuAccepted() then
    begin
      Memory.Controller.Changing := False;
      Sounds.PlaySound(SOUND_DROP);
    end;

  if not Memory.Controller.Mapping then
    if InputMenuRejected() then
    begin
      Input.Fixed.Cancel.Validate();
      Input.Controller.B.Validate();

      Memory.Controller.Changing := False;
      Sounds.PlaySound(SOUND_DROP);
    end;
end;


procedure TLogic.UpdateControllerButtonScanCode();
var
  ScanCode: UInt8 = CONTROLLER_SCANCODE_BUTTON_NOT_MAPPED;
begin
  if not Memory.Controller.Mapping then Exit;

  if Input.Fixed.Cancel.JustPressed then
  begin
    Memory.Controller.Mapping := False;
    Sounds.PlaySound(SOUND_DROP);

    Exit;
  end;

  if Input.Controller.CatchedOneButton(ScanCode) then
  begin
    Memory.Controller.ScanCodes[Memory.Controller.ButtonIndex] := ScanCode;
    Memory.Controller.Mapping := False;
    Memory.Controller.RemoveDuplicates(ScanCode, Memory.Controller.ButtonIndex);

    Sounds.PlaySound(SOUND_START);
  end;
end;


procedure TLogic.UpdateControllerScene();
begin
  FScene.Validate();

  if not Input.Controller.Connected then
  begin
    FScene.Current := SCENE_OPTIONS;

    Memory.Controller.Changing := False;
    Memory.Controller.Mapping := False;

    Sounds.PlaySound(SOUND_TOP_OUT, True);
    Exit;
  end;

  if Memory.Controller.Changing then Exit;

  if InputMenuRejected() then
  begin
    if Memory.Controller.MappedCorrectly() then
    begin
      FScene.Current := SCENE_OPTIONS;
      Sounds.PlaySound(SOUND_DROP);
    end
    else
      Sounds.PlaySound(SOUND_HUM);
  end;

  if Memory.Controller.ItemIndex = ITEM_CONTROLLER_SAVE then
    if InputMenuAccepted() then
      if Memory.Controller.MappedCorrectly() then
      begin
        Input.Controller.Introduce();

        FScene.Current := SCENE_OPTIONS;
        Sounds.PlaySound(SOUND_TETRIS, True);
      end
      else
        Sounds.PlaySound(SOUND_HUM);

  if Memory.Controller.ItemIndex = ITEM_CONTROLLER_CANCEL then
    if InputMenuAccepted() then
    begin
      FScene.Current := SCENE_OPTIONS;
      Sounds.PlaySound(SOUND_DROP);
    end;
end;


procedure TLogic.UpdateQuitHang();
begin
  Memory.Quit.HangTimer += 1;
end;


procedure TLogic.UpdateQuitScene();
begin
  FScene.Validate();

  if Memory.Quit.HangTimer = DURATION_HANG_QUIT * Clock.FrameRateLimit then
    FStopped := True;
end;


procedure TLogic.UpdateCommon();
begin
  if Input.Fixed.Help.JustPressed then OpenHelp();
  if Input.Fixed.ToggleVideo.JustPressed then Placement.ToggleVideoMode();

  if Input.Fixed.ToggleTheme.JustPressed then
  begin
    Memory.Options.Theme := WrapAround(Memory.Options.Theme, THEME_COUNT, 1);
    Renderers.ThemeID := Memory.Options.Theme;
  end;

  if not Memory.Game.Started then
    Generators.Shuffle();

  if Memory.GameModes.QualsActive then
    if Memory.GameModes.QualsRemaining > 0 then
    begin
      Memory.GameModes.QualsRemaining -= 1;

      if Memory.GameModes.QualsRemaining = 0 then
      begin
        Memory.GameModes.QualsActive := False;
        Memory.GameModes.QualsMode := QUALS_MODE_DEFAULT;
        Memory.GameModes.TimerData := TIMER_DEFAULT_DATA;

        Sounds.PlaySound(SOUND_COIN);
      end;
    end;
end;


procedure TLogic.UpdateLegal();
begin
  UpdateLegalHang();
  UpdateLegalScene();
end;


procedure TLogic.UpdateMenu();
begin
  UpdateMenuSelection();
  UpdateMenuScene();
end;


procedure TLogic.UpdateModes();
begin
  PrepareModes();

  UpdateModesSelection();
  UpdateModesScene();
end;


procedure TLogic.UpdateFreeMarathon();
begin
  PrepareFreeMarathon();

  UpdateFreeMarathonSelection();
  UpdateFreeMarathonRegion();
  UpdateFreeMarathonGenerator();
  UpdateFreeMarathonLevel();
  UpdateFreeMarathonScene();
end;


procedure TLogic.UpdateFreeSpeedrun();
begin
  PrepareFreeSpeedrun();

  UpdateFreeSpeedrunSelection();
  UpdateFreeSpeedrunRegion();
  UpdateFreeSpeedrunGenerator();
  UpdateFreeSpeedrunScene();
end;


procedure TLogic.UpdateMarathonQuals();
begin
  PrepareMarathonQuals();

  UpdateMarathonQualsSelection();
  UpdateMarathonQualsRegion();
  UpdateMarathonQualsGenerator();
  UpdateMarathonQualsLevel();
  UpdateMarathonQualsTimer();
  UpdateMarathonQualsScene();
end;


procedure TLogic.UpdateMarathonMatch();
begin
  PrepareMarathonMatch();

  UpdateMarathonMatchSelection();
  UpdateMarathonMatchRegion();
  UpdateMarathonMatchGenerator();
  UpdateMarathonMatchLevel();
  UpdateMarathonMatchSeed();
  UpdateMarathonMatchScene();
end;


procedure TLogic.UpdateSpeedrunQuals();
begin
  PrepareSpeedrunQuals();

  UpdateSpeedrunQualsSelection();
  UpdateSpeedrunQualsRegion();
  UpdateSpeedrunQualsGenerator();
  UpdateSpeedrunQualsTimer();
  UpdateSpeedrunQualsScene();
end;


procedure TLogic.UpdateSpeedrunMatch();
begin
  PrepareSpeedrunMatch();

  UpdateSpeedrunMatchSelection();
  UpdateSpeedrunMatchRegion();
  UpdateSpeedrunMatchGenerator();
  UpdateSpeedrunMatchSeed();
  UpdateSpeedrunMatchScene();
end;


procedure TLogic.UpdateGame();
begin
  UpdateGameState();
  UpdateGameScene();
end;


procedure TLogic.UpdatePause();
begin
  PreparePause();

  UpdatePauseCommon();
  UpdatePauseSelection();
  UpdatePauseScene();
end;


procedure TLogic.UpdateTopOut();
begin
  PrepareTopOut();

  UpdateTopOutSelection();
  UpdateTopOutScene();
end;


procedure TLogic.UpdateOptions();
begin
  PreapreOptions();

  UpdateOptionsSelection();
  UpdateOptionsInput();
  UpdateOptionsWindow();
  UpdateOptionsTheme();
  UpdateOptionsControls();
  UpdateOptionsSounds();
  UpdateOptionsScene();
end;


procedure TLogic.UpdateKeyboard();
begin
  PrepareKeyboard();

  UpdateKeyboardItemSelection();
  UpdateKeyboardKeySelection();
  UpdateKeyboardKeyScanCode();
  UpdateKeyboardScene();
end;


procedure TLogic.UpdateController();
begin
  PrepareController();

  UpdateControllerItemSelection();
  UpdateControllerButtonSelection();
  UpdateControllerButtonScanCode();
  UpdateControllerScene();
end;


procedure TLogic.UpdateQuit();
begin
  PrepareQuit();

  UpdateQuitHang();
  UpdateQuitScene();
end;


procedure TLogic.Update();
begin
  UpdateCommon();

  case FScene.Current of
    SCENE_LEGAL:           UpdateLegal();
    SCENE_MENU:            UpdateMenu();
    SCENE_MODES:           UpdateModes();
    SCENE_FREE_MARATHON:   UpdateFreeMarathon();
    SCENE_FREE_SPEEDRUN:   UpdateFreeSpeedrun();
    SCENE_MARATHON_QUALS:  UpdateMarathonQuals();
    SCENE_MARATHON_MATCH:  UpdateMarathonMatch();
    SCENE_SPEEDRUN_QUALS:  UpdateSpeedrunQuals();
    SCENE_SPEEDRUN_MATCH:  UpdateSpeedrunMatch();
    SCENE_GAME_NORMAL:     UpdateGame();
    SCENE_GAME_FLASH:      UpdateGame();
    SCENE_SPEEDRUN_NORMAL: UpdateGame();
    SCENE_SPEEDRUN_FLASH:  UpdateGame();
    SCENE_PAUSE:           UpdatePause();
    SCENE_TOP_OUT:         UpdateTopOut();
    SCENE_OPTIONS:         UpdateOptions();
    SCENE_KEYBOARD:        UpdateKeyboard();
    SCENE_CONTROLLER:      UpdateController();
    SCENE_QUIT:            UpdateQuit();
  end;
end;


procedure TLogic.Reset();
begin
  FScene.Reset();
end;


procedure TLogic.Stop();
begin
  if FScene.Current <> SCENE_QUIT then
  begin
    FScene.Current := SCENE_QUIT;
    Sounds.PlaySound(SOUND_GLASS, True);
  end;
end;


end.

