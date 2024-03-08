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

unit Fairtris.Utils;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  SDL2;


  function SDL_Rect(ALeft, ATop, AWidth, AHeight: SInt32): TSDL_Rect;

  function WrapAround(AValue, ACount, AStep: Integer): Integer;

  function GetR(AColor: Integer): UInt8;
  function GetG(AColor: Integer): UInt8;
  function GetB(AColor: Integer): UInt8;

  function GenerateRandomSeed(): String;


implementation

uses
  SysUtils,
  Fairtris.Constants;


function SDL_Rect(ALeft, ATop, AWidth, AHeight: SInt32): TSDL_Rect;
begin
  Result.X := ALeft;
  Result.Y := ATop;
  Result.W := AWidth;
  Result.H := AHeight;
end;


function WrapAround(AValue, ACount, AStep: Integer): Integer;
begin
  Result := (AValue + ACount + AStep) mod ACount;
end;


function GetR(AColor: Integer): UInt8;
begin
  Result := AColor and $000000FF;
end;


function GetG(AColor: Integer): UInt8;
begin
  Result := (AColor and $0000FF00) shr 8;
end;


function GetB(AColor: Integer): UInt8;
begin
  Result := (AColor and $00FF0000) shr 16;
end;


function GenerateRandomSeed(): String;
const
  SEED_DIGITS = '0123456789ABCDEF';
var
  SeedIsValid: Boolean;
  Digit: Char;
begin
  repeat
    Result := '';
    SeedIsValid := True;

    while Result.Length < SEED_LENGTH do
      Result += SEED_DIGITS.ToCharArray()[Random(SEED_DIGITS.Length)];

    for Digit in Result do
      if Result.CountChar(Digit) > 3 then
      begin
        SeedIsValid := False;
        Break;
      end;
  until SeedIsValid;
end;


end.

