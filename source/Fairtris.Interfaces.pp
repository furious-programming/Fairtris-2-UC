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

    property Switch[AIndex: Integer]: TSwitch read GetSwitch;
    property ScanCode[AIndex: Integer]: UInt8 read GetScanCode;

    property Up: TSwitch index DEVICE_UP read GetSwitch;
    property Down: TSwitch index DEVICE_DOWN read GetSwitch;
    property Left: TSwitch index DEVICE_LEFT read GetSwitch;
    property Right: TSwitch index DEVICE_RIGHT read GetSwitch;
    property Select: TSwitch index DEVICE_SELECT read GetSwitch;
    property Start: TSwitch index DEVICE_START read GetSwitch;
    property B: TSwitch index DEVICE_B read GetSwitch;
    property A: TSwitch index DEVICE_A read GetSwitch;

    property Connected: Boolean read GetConnected;
  end;


type
  IRenderable = interface(IInterface)
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

    procedure RenderScene(ASceneID: Integer);
  end;


type
  IGenerable = interface(IInterface)
    procedure Initialize();
    procedure UnlockRandomness();

    procedure Prepare(ASeed: Integer = SEED_USE_RANDOM);
    procedure Shuffle(APreShuffling: Boolean = False);
    procedure Step(APicking: Boolean = False);

    function Pick(): Integer;
  end;


implementation

end.

