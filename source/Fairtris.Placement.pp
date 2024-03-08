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

unit Fairtris.Placement;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  SDL2,
  Fairtris.Arrays;


type
  TPlacement = class(TObject)
  private
    FInitialized: Boolean;
  private
    FVideoEnabled: Boolean;
    FVideoBounds: TSDL_Rect;
  private
    FMonitorIndex: Integer;
    FMonitorBounds: TSDL_Rect;
  private
    FWindowSizeID: Integer;
    FWindowBounds: TSDL_Rect;
    FWindowClient: TSDL_Rect;
  private
    procedure SetWindowSize(ASizeID: Integer);
  private
    procedure UpdateWindowBounds();
    procedure UpdateWindowClient();
    procedure UpdateWindowCursor();
    procedure UpdateWindowHitTest();
    procedure UpdateWindowPlacement();
  private
    procedure UpdateMonitor();
    procedure UpdateWindow();
    procedure UpdateBuffer();
    procedure UpdateVideo();
  public
    constructor Create();
  public
    procedure Initialize();
  public
    procedure EnlargeWindow();
    procedure ReduceWindow();
    procedure ExposeWindow();
  public
    procedure ToggleVideoMode();
  public
    property VideoEnabled: Boolean read FVideoEnabled;
  public
    property WindowSize: Integer read FWindowSizeID write SetWindowSize;
    property WindowBounds: TSDL_Rect read FWindowBounds;
    property WindowClient: TSDL_Rect read FWindowClient;
  end;


var
  Placement: TPlacement;


implementation

uses
  Math,
  Fairtris.Window,
  Fairtris.Buffers,
  Fairtris.Settings,
  Fairtris.Utils,
  Fairtris.Constants;


function WindowHitTest(AWindow: PSDL_Window; const APoint: PSDL_Point; AData: Pointer): TSDL_HitTestResult; cdecl;
begin
  if Placement.WindowSize = SIZE_FULLSCREEN then
    Result := SDL_HITTEST_NORMAL
  else
  begin
    Result := SDL_HITTEST_DRAGGABLE;
    Placement.ExposeWindow();
  end;
end;


constructor TPlacement.Create();
begin
  FMonitorIndex := 0;
  FWindowSizeID := SIZE_DEFAULT;

  SDL_GetDisplayBounds(0, @FVideoBounds);
  SDL_GetDisplayBounds(0, @FMonitorBounds);

  UpdateWindow();
end;


procedure TPlacement.Initialize();
begin
  FVideoEnabled := Settings.Video.Enabled;

  FMonitorIndex := Settings.General.Monitor;
  SDL_GetDisplayBounds(FMonitorIndex, @FMonitorBounds);

  FWindowSizeID := Settings.General.Size;
  FWindowBounds.X := Settings.General.Left;
  FWindowBounds.Y := Settings.General.Top;

  UpdateWindow();

  if FVideoEnabled then
    UpdateVideo();

  FInitialized := True;
end;


procedure TPlacement.SetWindowSize(ASizeID: Integer);
begin
  if FWindowSizeID <> ASizeID then
  begin
    FWindowSizeID := ASizeID;

    UpdateMonitor();
    UpdateWindow();
    UpdateBuffer();
  end;
end;


procedure TPlacement.UpdateWindowBounds();
var
  NewWidth, NewHeight: Integer;
begin
  if FVideoEnabled then
    FWindowBounds := FVideoBounds
  else
  case FWindowSizeID of
    SIZE_NATIVE, SIZE_ZOOM_2X, SIZE_ZOOM_3X, SIZE_ZOOM_4X:
    begin
      NewWidth := Ord(FWindowSizeID) * BUFFER_WIDTH + BUFFER_WIDTH;
      NewWidth := Round(NewWidth * WINDOW_RATIO);

      NewHeight := Ord(FWindowSizeID) * BUFFER_HEIGHT + BUFFER_HEIGHT;

      if FInitialized then
      begin
        FWindowBounds.X := FMonitorBounds.X + (FMonitorBounds.W - NewWidth) div 2;
        FWindowBounds.Y := FMonitorBounds.Y + (FMonitorBounds.H - NewHeight) div 2;
      end;

      FWindowBounds.W := NewWidth;
      FWindowBounds.H := NewHeight;
    end;
    SIZE_FULLSCREEN:
      FWindowBounds := FMonitorBounds;
  end;
end;


procedure TPlacement.UpdateWindowClient();
var
  CurrentWidth, CurrentHeight, NewWidth, NewHeight: Integer;
begin
  if FVideoEnabled or (FWindowSizeID = SIZE_FULLSCREEN) then
  begin
    CurrentWidth := IfThen(FVideoEnabled, FMonitorBounds.W, FWindowBounds.W);
    CurrentHeight := IfThen(FVideoEnabled, FMonitorBounds.H, FWindowBounds.H);

    NewHeight := CurrentHeight;
    NewWidth := Round(NewHeight * CLIENT_RATIO_LANDSCAPE);

    if NewWidth > CurrentWidth then
    begin
      NewWidth := CurrentWidth;
      NewHeight := Round(NewWidth * CLIENT_RATIO_PORTRAIT);
    end;

    FWindowClient.X := (CurrentWidth - NewWidth) div 2;
    FWindowClient.Y := (CurrentHeight - NewHeight) div 2;

    FWindowClient.W := NewWidth;
    FWindowClient.H := NewHeight;
  end
  else
    FWindowClient := SDL_Rect(0, 0, FWindowBounds.W, FWindowBounds.H);

  UpdateBuffer();
end;


procedure TPlacement.UpdateWindowCursor();
begin
  if FVideoEnabled or (FWindowSizeID = SIZE_FULLSCREEN) then
    SDL_ShowCursor(SDL_DISABLE)
  else
    SDL_ShowCursor(SDL_ENABLE);
end;


procedure TPlacement.UpdateWindowHitTest();
begin
  if FVideoEnabled or (FWindowSizeID = SIZE_FULLSCREEN) then
    SDL_SetWindowHitTest(Window.Window, nil, nil)
  else
    SDL_SetWindowHitTest(Window.Window, @WindowHitTest, nil);
end;


procedure TPlacement.UpdateWindowPlacement();
begin
  SDL_SetWindowSize(Window.Window, FWindowBounds.W, FWindowBounds.H);
  SDL_SetWindowPosition(Window.Window, FWindowBounds.X, FWindowBounds.Y);
end;


procedure TPlacement.UpdateMonitor();
begin
  FMonitorIndex := SDL_GetWindowDisplayIndex(Window.Window);
  SDL_GetDisplayBounds(FMonitorIndex, @FMonitorBounds);
end;


procedure TPlacement.UpdateWindow();
begin
  UpdateWindowBounds();
  UpdateWindowClient();
  UpdateWindowCursor();
  UpdateWindowHitTest();
  UpdateWindowPlacement();
end;


procedure TPlacement.UpdateBuffer();
begin
  Buffers.Client := FWindowClient;
end;


procedure TPlacement.UpdateVideo();
begin
  if FVideoEnabled then
  begin
    SDL_ShowCursor(SDL_DISABLE);
    SDL_SetWindowHitTest(Window.Window, nil, nil);

    SDL_SetWindowSize(Window.Window, FVideoBounds.W, FVideoBounds.H);
    SDL_SetWindowPosition(Window.Window, FVideoBounds.X, FVideoBounds.Y);
    SDL_SetWindowFullScreen(Window.Window, SDL_WINDOW_FULLSCREEN);

    UpdateMonitor();
    UpdateWindowClient();
  end
  else
  begin
    SDL_SetWindowFullScreen(Window.Window, SDL_DISABLE);
    UpdateWindow();
  end;
end;


procedure TPlacement.EnlargeWindow();
begin
  if FVideoEnabled then Exit;

  if FWindowSizeID < SIZE_LAST then
  begin
    FWindowSizeID += 1;

    UpdateMonitor();
    UpdateWindow();
  end;
end;


procedure TPlacement.ReduceWindow();
begin
  if FVideoEnabled then Exit;

  if FWindowSizeID > SIZE_FIRST then
  begin
    FWindowSizeID -= 1;

    UpdateMonitor();
    UpdateWindow();
  end;
end;


procedure TPlacement.ExposeWindow();
begin
  if not FVideoEnabled then
    SDL_GetWindowPosition(Window.Window, @FWindowBounds.X, @FWindowBounds.Y);
end;


procedure TPlacement.ToggleVideoMode();
begin
  FVideoEnabled := not FVideoEnabled;
  UpdateVideo();
end;


end.

