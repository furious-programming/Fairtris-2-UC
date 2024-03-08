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

unit Fairtris.Game;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface


type
  TGame = class(TObject)
  private
    procedure CreateSystem();
    procedure CreateObjects();
  private
    procedure DestroySystem();
    procedure DestroyObjects();
  private
    procedure Initialize();
    procedure Finalize();
  private
    procedure OpenFrame();
    procedure CloseFrame();
  private
    procedure UpdateQueue();
    procedure UpdateInput();
    procedure UpdateLogic();
    procedure UpdateBuffer();
    procedure UpdateWindow();
    procedure UpdateTaskbar();
  public
    constructor Create();
    destructor Destroy(); override;
  public
    procedure Run();
  end;


implementation

uses
  SDL2,
  SDL2_Mixer,
  SysUtils,
  Fairtris.Window,
  Fairtris.Taskbar,
  Fairtris.Clock,
  Fairtris.Buffers,
  Fairtris.Input,
  Fairtris.Memory,
  Fairtris.Placement,
  Fairtris.Renderers,
  Fairtris.Sounds,
  Fairtris.Grounds,
  Fairtris.Sprites,
  Fairtris.Settings,
  Fairtris.BestScores,
  Fairtris.Generators,
  Fairtris.Logic,
  Fairtris.Core,
  Fairtris.Classes,
  Fairtris.Converter,
  Fairtris.Arrays,
  Fairtris.Constants;


procedure TGame.CreateSystem();
begin
  SDL_SetHint(SDL_HINT_VIDEO_MINIMIZE_ON_FOCUS_LOSS, '0');
  SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, 'linear');

  if SDL_Init(SDL_INIT_VIDEO or SDL_INIT_AUDIO or SDL_INIT_JOYSTICK or SDL_INIT_EVENTS) < 0 then
    raise SDLException.CreateFmt(ERROR_MESSAGE_SDL, [ERROR_MESSAGE[ERROR_SDL_INITIALIZE_SYSTEM], SDL_GetError()]);

  if Mix_OpenAudio(MIX_DEFAULT_FREQUENCY, MIX_DEFAULT_FORMAT, MIX_DEFAULT_CHANNELS, 1024) < 0 then
    raise SDLException.CreateFmt(ERROR_MESSAGE_SDL, [ERROR_MESSAGE[ERROR_SDL_INITIALIZE_AUDIO], Mix_GetError()]);

  if Mix_AllocateChannels(SOUND_CHANNELS_COUNT) < SOUND_CHANNELS_COUNT then
    raise Exception.Create(ERROR_MESSAGE[ERROR_SDL_ALLOCATE_CHANNELS]);
end;


procedure TGame.CreateObjects();
begin
  Window := TWindow.Create();
  Taskbar := TTaskbar.Create();

  Clock := TClock.Create();
  Buffers := TBuffers.Create();
  Input := TInput.Create();
  Placement := TPlacement.Create();
  Renderers := TRenderers.Create();

  Sounds := TSounds.Create();
  Grounds := TGrounds.Create();
  Sprites := TSprites.Create();
  Settings := TSettings.Create();
  BestScores := TBestScores.Create();

  Generators := TGenerators.Create();
  Logic := TLogic.Create();
  Core := TCore.Create();
  Memory := TMemory.Create();
  Converter := TConverter.Create();
end;


procedure TGame.DestroySystem();
begin
  Mix_CloseAudio();
  SDL_Quit();
end;


procedure TGame.DestroyObjects();
begin
  Window.Free();
  Taskbar.Free();

  Clock.Free();
  Buffers.Free();
  Input.Free();
  Placement.Free();
  Renderers.Free();

  Sounds.Free();
  Grounds.Free();
  Sprites.Free();
  Settings.Free();
  BestScores.Free();

  Generators.Free();
  Logic.Free();
  Core.Free();
  Memory.Free();
  Converter.Free();
end;


constructor TGame.Create();
begin
  CreateSystem();
  CreateObjects();
end;


destructor TGame.Destroy();
begin
  DestroyObjects();
  DestroySystem();

  inherited Destroy();
end;


procedure TGame.Initialize();
begin
  Sounds.Load();
  Grounds.Load();
  Sprites.Load();
  Settings.Load();
  BestScores.Load();

  Clock.Initialize();
  Input.Initialize();
  Memory.Initialize();
  Placement.Initialize();
  Renderers.Initialize();
  Sounds.Initilize();
  Taskbar.Initialize();

  Generators.Initialize();
end;


procedure TGame.Finalize();
begin
  Settings.Save();
  BestScores.Save();
end;


procedure TGame.OpenFrame();
begin
  Clock.UpdateFrameBegin();
end;


procedure TGame.CloseFrame();
begin
  Clock.UpdateFrameEnd();
  Clock.UpdateFrameAlign();
end;


procedure TGame.UpdateQueue();
var
  Event: TSDL_Event;
begin
  Event := Default(TSDL_Event);
  SDL_PumpEvents();

  while SDL_PollEvent(@Event) = 1 do
  case Event.Type_ of
    SDL_MOUSEWHEEL:
    begin
      if Event.Wheel.Y < 0 then Placement.ReduceWindow();
      if Event.Wheel.Y > 0 then Placement.EnlargeWindow();

      Memory.Options.Size := Placement.WindowSize;
    end;
    SDL_JOYDEVICEADDED:   Input.Controller.Attach();
    SDL_JOYDEVICEREMOVED: Input.Controller.Detach();
    SDL_QUITEV:
      Logic.Stop();
  end;
end;


procedure TGame.UpdateInput();
begin
  if Window.Focused then
    Input.Update()
  else
    Input.Reset();
end;


procedure TGame.UpdateLogic();
begin
  Logic.Update();

  if Logic.Scene.Current = SCENE_STOP then
    Logic.Stop();
end;


procedure TGame.UpdateBuffer();
begin
  Renderers.Theme.RenderScene(Logic.Scene.Current);
end;


procedure TGame.UpdateWindow();
begin
  SDL_RenderCopy(Window.Renderer, Buffers.Native, nil, @Buffers.Client);
  SDL_RenderPresent(Window.Renderer);
end;


procedure TGame.UpdateTaskbar();
begin
  Taskbar.Update();
end;


procedure TGame.Run();
begin
  Initialize();

  repeat
    OpenFrame();
      UpdateWindow();
      UpdateQueue();
      UpdateInput();
      UpdateLogic();

      if not Logic.Scene.Changed and not Logic.Stopped then
      begin
        UpdateBuffer();
        UpdateTaskbar();
      end;

    CloseFrame();
  until Logic.Stopped;

  Finalize();
end;


end.

