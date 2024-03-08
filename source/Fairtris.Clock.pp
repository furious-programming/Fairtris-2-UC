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

unit Fairtris.Clock;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  Fairtris.Classes;


type
  TClockFrameRate = specialize TCustomState<Integer>;
  TClockFrameLoad = specialize TCustomState<Integer>;


type
  TClock = class(TObject)
  private
    FTicksPerSecond: Int64;
    FTicksPerFrame: Int64;
  private
    FFrameTicksBegin: Int64;
    FFrameTicksEnd: Int64;
    FFrameTicksNext: Int64;
  private
    FFrameIndex: Integer;
  private
    FFrameRate: TClockFrameRate;
    FFrameLoad: TClockFrameLoad;
  private
    FFrameRateTank: Integer;
    FFrameRateSecond: Integer;
    FFrameRateLimit: Integer;
  private
    FFrameLoadTank: Integer;
  private
    function GetFrameIndexInHalf(): Boolean;
    procedure SetFrameRateLimit(AFrameRateLimit: Integer);
  private
    function GetCounterFrequency(): Int64;
    function GetCounterValue(): Int64;
  private
    procedure InitCounters();
    procedure DoneCounters();
  private
    procedure InitFrameRate();
    procedure InitTicks();
  private
    procedure UpdateFrameRate();
    procedure UpdateFrameLoad();
  public
    constructor Create();
    destructor Destroy(); override;
  public
    procedure Initialize();
  public
    procedure UpdateFrameBegin();
    procedure UpdateFrameEnd();
    procedure UpdateFrameAlign();
  public
    property FrameIndex: Integer read FFrameIndex;
    property FrameIndexInHalf: Boolean read GetFrameIndexInHalf;
    property FrameRateLimit: Integer read FFrameRateLimit write SetFrameRateLimit;
  public
    property FrameRate: TClockFrameRate read FFrameRate;
    property FrameLoad: TClockFrameLoad read FFrameLoad;
  end;


var
  Clock: TClock;


implementation

uses
  SDL2,
  Windows,
  Math,
  SysUtils,
  DateUtils,
  Fairtris.Settings,
  Fairtris.Arrays,
  Fairtris.Constants;


constructor TClock.Create();
begin
  InitCounters();
  InitFrameRate();
  InitTicks();
end;


destructor TClock.Destroy();
begin
  DoneCounters();
  inherited Destroy();
end;


function TClock.GetFrameIndexInHalf(): Boolean;
begin
  Result := FFrameIndex mod FFrameRateLimit < FFrameRateLimit div 2;
end;


procedure TClock.SetFrameRateLimit(AFrameRateLimit: Integer);
begin
  FFrameRateLimit := AFrameRateLimit;
  FTicksPerFrame := FTicksPerSecond div FFrameRateLimit;
end;


function TClock.GetCounterFrequency(): Int64;
begin
  Result := 0;
  QueryPerformanceFrequency(Result);
end;


function TClock.GetCounterValue(): Int64;
begin
  Result := 0;
  QueryPerformanceCounter(Result);
end;


procedure TClock.InitCounters();
begin
  FFrameRate := TClockFrameRate.Create(0);
  FFrameLoad := TClockFrameLoad.Create(0);
end;


procedure TClock.DoneCounters();
begin
  FFrameRate.Free();
  FFrameLoad.Free();
end;


procedure TClock.InitFrameRate();
begin
  FFrameRateSecond := SecondOf(Now());
  FFrameRateLimit := CLOCK_FRAMERATE_DEFAULT;
end;


procedure TClock.InitTicks();
begin
  FTicksPerSecond := GetCounterFrequency();
  FTicksPerFrame := FTicksPerSecond div FFrameRateLimit;
end;


procedure TClock.UpdateFrameRate();
var
  NewSecond: Integer;
begin
  NewSecond := SecondOf(Now());

  if NewSecond = FFrameRateSecond then
    FFrameRateTank += 1
  else
  begin
    FFrameRate.Current := FFrameRateTank;

    FFrameRateTank := 1;
    FFrameRateSecond := NewSecond;
  end;
end;


procedure TClock.UpdateFrameLoad();
begin
  if FFrameIndex mod (FFrameRateLimit div 4) <> 0 then
    FFrameLoadTank += (FFrameTicksEnd - FFrameTicksBegin) * 100 div FTicksPerFrame
  else
  begin
    FFrameLoad.Current := FFrameLoadTank div (FFrameRateLimit div 4);
    FFrameLoadTank := (FFrameTicksEnd - FFrameTicksBegin) * 100 div FTicksPerFrame;
  end;
end;


procedure TClock.Initialize();
begin
  SetFrameRateLimit(CLOCK_FRAMERATE_LIMIT[Settings.General.Region]);
end;


procedure TClock.UpdateFrameBegin();
begin
  FFrameTicksBegin := GetCounterValue();
  FFrameTicksNext := FFrameTicksBegin + FTicksPerFrame;
end;


procedure TClock.UpdateFrameEnd();
begin
  FFrameTicksEnd := GetCounterValue();
  FFrameIndex += 1;

  UpdateFrameRate();
  UpdateFrameLoad();
end;


procedure TClock.UpdateFrameAlign();
var
  SleepTime: Single;
begin
  SleepTime := 1000 / FFrameRateLimit * (1 - (FFrameTicksEnd - FFrameTicksBegin) / FTicksPerFrame) - 1;
  SleepTime -= Ord(Round(SleepTime) > SleepTime);
  SleepTime := Max(SleepTime, 0);

  SDL_Delay(Round(SleepTime));

  while GetCounterValue() < FFrameTicksNext do
  asm
    pause
  end;
end;


end.

