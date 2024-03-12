
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

unit Fairtris.Interfaces;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  Fairtris.Classes,
  Fairtris.Constants;


type
  IControllable = interface(IInterface)
    function GetSwitch(AIndex: Integer): TSwitch;
    function GetScanCode(AIndex: Integer): UInt8;
    function GetConnected(): Boolean;

    property Switch  [AIndex: Integer]: TSwitch read GetSwitch;
    property ScanCode[AIndex: Integer]: UInt8   read GetScanCode;

    property Up:     TSwitch index TRIGGER_DEVICE_UP     read GetSwitch;
    property Down:   TSwitch index TRIGGER_DEVICE_DOWN   read GetSwitch;
    property Left:   TSwitch index TRIGGER_DEVICE_LEFT   read GetSwitch;
    property Right:  TSwitch index TRIGGER_DEVICE_RIGHT  read GetSwitch;
    property Select: TSwitch index TRIGGER_DEVICE_SELECT read GetSwitch;
    property Start:  TSwitch index TRIGGER_DEVICE_START  read GetSwitch;
    property B:      TSwitch index TRIGGER_DEVICE_B      read GetSwitch;
    property A:      TSwitch index TRIGGER_DEVICE_A      read GetSwitch;

    property Connected: Boolean read GetConnected;
  end;


type
  IGenerable = interface(IInterface)
    procedure Initialize();
    procedure Shuffle(APreShuffling: Boolean = False);
    procedure Step(APicking: Boolean = False);
    function  Pick(): Integer;
  end;


implementation

end.

