
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

unit Fairtris.Classes;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  SysUtils;


type
  SDLException = class(Exception);


type
  generic TCustomState<T> = class(TObject)
  protected
    FPrevious: T;
    FCurrent:  T;
    FDefault:  T;
  protected
    FChanged: Boolean;
  protected
    procedure SetCurrent(AState: T); virtual;
    procedure SetDefault(ADefault: T); virtual;
  public
    constructor Create(ADefault: T);
  public
    procedure Reset(); virtual;
    procedure Validate();
    procedure Invalidate();
  public
    property Previous: T read FPrevious;
    property Current:  T read FCurrent write SetCurrent;
    property Default:  T read FDefault write SetDefault;
  public
    property Changed: Boolean read FChanged;
  end;


type
  TSwitch = class(specialize TCustomState<Boolean>)
  private
    function GetDown(): Boolean;
    function GetUp(): Boolean;
    function GetPressed(): Boolean;
    function GetReleased(): Boolean;
  public
    property Down:     Boolean read GetDown write SetCurrent;
    property Up:       Boolean read GetUp;
    property Pressed:  Boolean read GetPressed;
    property Released: Boolean read GetReleased;
  end;


implementation


constructor TCustomState.Create(ADefault: T);
begin
  FDefault := ADefault;
  Reset();
end;


procedure TCustomState.SetCurrent(AState: T);
begin
  FPrevious := FCurrent;
  FCurrent  := AState;
  FChanged  := FPrevious <> FCurrent;
end;


procedure TCustomState.SetDefault(ADefault: T);
begin
  FDefault := ADefault;
  Reset();
end;


procedure TCustomState.Reset();
begin
  FPrevious := FDefault;
  FCurrent  := FDefault;
  FChanged  := False;
end;


procedure TCustomState.Validate();
begin
  SetCurrent(FCurrent);
end;


procedure TCustomState.Invalidate();
begin
  FChanged := True;
end;


function TSwitch.GetDown(): Boolean;
begin
  Result := FCurrent;
end;


function TSwitch.GetUp(): Boolean;
begin
  Result := not FCurrent;
end;


function TSwitch.GetPressed(): Boolean;
begin
  Result := not FPrevious and FCurrent;
end;


function TSwitch.GetReleased(): Boolean;
begin
  Result := FPrevious and not FCurrent;
end;


end.

