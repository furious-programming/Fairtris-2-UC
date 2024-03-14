
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


type
  TConverter = class(TObject)
  public
    function ScoreToString(AScore: Integer): String;
    function ScoreToStringPlaceholder(AScore: Integer): String;
  public
    function PointsPerLineToString(APoints: Integer): String;
    function PointsPerLineToStringPlaceholder(APoints: Integer): String;
  public
    function LinesToString(ALines: Integer): String;
    function LinesToStringPlaceholder(ALines: Integer): String;
  public
    function LevelToString(ALevel: Integer): String;
    function LevelToStringPlaceholder(ALevel: Integer; AShort: Boolean = False): String;
  public
    function TetrisesToString(ATetrises: Integer): String;
    function TetrisesToStringPlaceholder(ATetrises: Integer): String;
  public
    function GainToString(AGain: Integer): String;
    function GainToStringPlaceholder(AGain: Integer): String;
  end;


var
  Converter: TConverter;


implementation

uses
  SysUtils,
  Fairtris.Arrays;


function TConverter.ScoreToString(AScore: Integer): String;
begin
  Result := AScore.ToString();
end;


function TConverter.ScoreToStringPlaceholder(AScore: Integer): String;
begin
  Result := StringOfChar('0', 8 - ScoreToString(AScore).Length);
end;


function TConverter.PointsPerLineToString(APoints: Integer): String;
begin
  Result := APoints.ToString();
end;


function TConverter.PointsPerLineToStringPlaceholder(APoints: Integer): String;
begin
  Result := StringOfChar('0', 5 - PointsPerLineToString(APoints).Length);
end;


function TConverter.LinesToString(ALines: Integer): String;
begin
  Result := ALines.ToString();
end;


function TConverter.LinesToStringPlaceholder(ALines: Integer): String;
begin
  Result := StringOfChar('0', 4 - LinesToString(ALines).Length);
end;


function TConverter.LevelToString(ALevel: Integer): String;
begin
  Result := ALevel.ToString();
end;


function TConverter.LevelToStringPlaceholder(ALevel: Integer; AShort: Boolean): String;
begin
  Result := StringOfChar('0', 3 - Ord(AShort) - LevelToString(ALevel).Length);
end;


function TConverter.TetrisesToString(ATetrises: Integer): String;
begin
  Result := ATetrises.ToString() + '%';
end;


function TConverter.TetrisesToStringPlaceholder(ATetrises: Integer): String;
begin
  Result := StringOfChar('0', 3 - ATetrises.ToString().Length);
end;


function TConverter.GainToString(AGain: Integer): String;
begin
  if AGain > 0 then
    Result := AGain.ToString()
  else
    Result := '';
end;


function TConverter.GainToStringPlaceholder(AGain: Integer): String;
begin
  Result := StringOfChar('0', 6 - GainToString(AGain).Length);
end;


end.

