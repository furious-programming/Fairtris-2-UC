
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

unit Fairtris.Converter;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  SDL2;


type
  TConverter = class(TObject)
  public
    function PiecesToString(APieces: Integer): String;
    function ScoreToString(AScore: Integer): String;
    function LinesToString(ALines: Integer): String;
    function LevelToString(ALevel: Integer): String;
    function BurnedToString(ABurned: Integer): String;
    function TetrisesToString(ATetrises: Integer): String;
    function GainToString(AGain: Integer): String;
  end;


var
  Converter: TConverter;


implementation

uses
  SysUtils,
  Fairtris.Memory,
  Fairtris.Arrays,
  Fairtris.Constants;


function TConverter.PiecesToString(APieces: Integer): String;
begin
  Result := '%.3d'.Format([APieces]);
end;


function TConverter.ScoreToString(AScore: Integer): String;
begin
  Result := '%.8d'.Format([AScore])
end;


function TConverter.LinesToString(ALines: Integer): String;
begin
  Result := ALines.ToString();
end;


function TConverter.LevelToString(ALevel: Integer): String;
begin
  Result := ALevel.ToString();
end;


function TConverter.BurnedToString(ABurned: Integer): String;
begin
  Result := ABurned.ToString();
end;


function TConverter.TetrisesToString(ATetrises: Integer): String;
begin
  Result := ATetrises.ToString() + '%';
end;


function TConverter.GainToString(AGain: Integer): String;
begin
  Result := AGain.ToString();
end;


end.

