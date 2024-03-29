
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

unit Fairtris.Constants;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  SDL2;


const
  CLOCK_FRAMERATE_NTSC    = 60;
  CLOCK_FRAMERATE_PAL     = 50;

  CLOCK_FRAMERATE_DEFAULT = CLOCK_FRAMERATE_NTSC;


const
  MONITOR_DEFAULT = 0;


const
  BUFFER_WIDTH  = 336;
  BUFFER_HEIGHT = 240;

const
  BUFFER_PIXEL_RATIO_X = 8 / 7;
  BUFFER_PIXEL_RATIO_Y = 7 / 8;


const
  CLIENT_RATIO_LANDSCAPE = BUFFER_WIDTH  / BUFFER_HEIGHT * BUFFER_PIXEL_RATIO_X;
  CLIENT_RATIO_PORTRAIT  = BUFFER_HEIGHT / BUFFER_WIDTH  * BUFFER_PIXEL_RATIO_Y;


const
  ROSE_ORIGIN_X = BUFFER_HEIGHT / 2;
  ROSE_ORIGIN_Y = BUFFER_HEIGHT / 2;

  ROSE_SIZE     = BUFFER_HEIGHT / 2 - 1;

const
  ROSE_DURATION_CYCLE = 120;


const
  SCENE_LEGAL       = 0;
  SCENE_ROSE_NORMAL = 1;
  SCENE_ROSE_FLASH  = 2;
  SCENE_MENU        = 3;
  SCENE_SETUP       = 4;
  SCENE_GAME_NORMAL = 5;
  SCENE_GAME_FLASH  = 6;
  SCENE_PAUSE       = 7;
  SCENE_SUMMARY     = 8;
  SCENE_OPTIONS     = 9;
  SCENE_KEYBOARD    = 10;
  SCENE_CONTROLLER  = 11;
  SCENE_BSOD        = 12;
  SCENE_QUIT        = 13;
  SCENE_STOP        = 14;

  SCENE_FIRST       = SCENE_LEGAL;
  SCENE_LAST        = SCENE_QUIT;


const
  GAME_STATE_PIECE_CONTROL   = 0;
  GAME_STATE_PIECE_LOCK      = 1;
  GAME_STATE_PIECE_SPAWN     = 2;
  GAME_STATE_LINES_CHECK     = 3;
  GAME_STATE_LINES_CLEAR     = 4;
  GAME_STATE_STACK_LOWER     = 5;
  GAME_STATE_UPDATE_COUNTERS = 6;
  GAME_STATE_UPDATE_TOP_OUT  = 7;


const
  BSOD_STATE_START   = 0;
  BSOD_STATE_CURTAIN = 1;
  BSOD_STATE_HANG    = 2;
  BSOD_STATE_CONTROL = 3;


const
  SOUND_REGION_NTSC  = 0;
  SOUND_REGION_PAL   = 1;

  SOUND_REGION_FIRST = SOUND_REGION_NTSC;
  SOUND_REGION_LAST  = SOUND_REGION_PAL;


const
  SPRITE_CHARSET         = 0;
  SPRITE_BRICKS          = 1;
  SPRITE_BRICKS_GLITCHED = 2;
  SPRITE_PIECES          = 3;
  SPRITE_PIECES_GLITCHED = 4;
  SPRITE_CONTROLLER      = 5;

  SPRITE_FIRST           = SPRITE_CHARSET;
  SPRITE_LAST            = SPRITE_CONTROLLER;


const
  CHAR_WIDTH  = 8;
  CHAR_HEIGHT = 8;


const
  SOUND_UNKNOWN    = 0;
  SOUND_BLIP       = 1;
  SOUND_START      = 2;
  SOUND_SHIFT      = 3;
  SOUND_SPIN       = 4;
  SOUND_DROP       = 5;
  SOUND_BURN       = 6;
  SOUND_TETRIS     = 7;
  SOUND_TRANSITION = 8;
  SOUND_TOP_OUT    = 9;
  SOUND_SUCCESS    = 10;
  SOUND_PAUSE      = 11;
  SOUND_HUM        = 12;
  SOUND_COIN       = 13;
  SOUND_GLASS      = 14;

  SOUND_FIRST      = SOUND_BLIP;
  SOUND_LAST       = SOUND_GLASS;

const
  SOUND_CHANNELS_COUNT = 8;


const
  DURATION_HANG_LEGAL = 5;
  DURATION_HANG_QUIT  = 2;
  DURATION_HANG_GAIN  = 3;

const
  DURATION_HANG_BSOD_START   = 2;
  DURATION_HANG_BSOD_CURTAIN = 0.5;
  DURATION_HANG_BSOD_HANG    = 4;


const
  ITEM_NEXT = +1;
  ITEM_PREV = -1;


const
  ITEM_MENU_PLAY    = 0;
  ITEM_MENU_OPTIONS = 1;
  ITEM_MENU_HELP    = 2;
  ITEM_MENU_QUIT    = 3;

  ITEM_MENU_FIRST   = ITEM_MENU_PLAY;
  ITEM_MENU_LAST    = ITEM_MENU_QUIT;

  ITEM_MENU_COUNT   = ITEM_MENU_LAST + 1;


const
  ITEM_SETUP_REGION    = 0;
  ITEM_SETUP_GENERATOR = 1;
  ITEM_SETUP_LEVEL     = 2;
  ITEM_SETUP_START     = 3;
  ITEM_SETUP_BACK      = 4;

  ITEM_SETUP_FIRST     = ITEM_SETUP_REGION;
  ITEM_SETUP_LAST      = ITEM_SETUP_BACK;

  ITEM_SETUP_COUNT     = ITEM_SETUP_LAST + 1;


const
  ITEM_PAUSE_RESUME  = 0;
  ITEM_PAUSE_RESTART = 1;
  ITEM_PAUSE_OPTIONS = 2;
  ITEM_PAUSE_BACK    = 3;

  ITEM_PAUSE_FIRST   = ITEM_PAUSE_RESUME;
  ITEM_PAUSE_LAST    = ITEM_PAUSE_BACK;

  ITEM_PAUSE_COUNT   = ITEM_PAUSE_LAST + 1;


const
  ITEM_SUMMARY_PLAY  = 0;
  ITEM_SUMMARY_BACK  = 1;

  ITEM_SUMMARY_FIRST = ITEM_SUMMARY_PLAY;
  ITEM_SUMMARY_LAST  = ITEM_SUMMARY_BACK;

  ITEM_SUMMARY_COUNT = ITEM_SUMMARY_LAST + 1;

const
  ITEM_SUMMARY_RESULT_TOTAL_SCORE     = 0;
  ITEM_SUMMARY_RESULT_POINTS_PER_LINE = 1;
  ITEM_SUMMARY_RESULT_LINES_CLEARED   = 2;
  ITEM_SUMMARY_RESULT_LINES_BURNED    = 3;
  ITEM_SUMMARY_RESULT_TETRIS_RATE     = 4;

  ITEM_SUMMARY_RESULT_FIRST           = ITEM_SUMMARY_RESULT_TOTAL_SCORE;
  ITEM_SUMMARY_RESULT_LAST            = ITEM_SUMMARY_RESULT_TETRIS_RATE;


const
  ITEM_OPTIONS_INPUT      = 0;
  ITEM_OPTIONS_SET_UP     = 1;
  ITEM_OPTIONS_SHIFT_NTSC = 2;
  ITEM_OPTIONS_SHIFT_PAL  = 3;
  ITEM_OPTIONS_SIZE       = 4;
  ITEM_OPTIONS_SOUNDS     = 5;
  ITEM_OPTIONS_BACK       = 6;

  ITEM_OPTIONS_FIRST      = ITEM_OPTIONS_INPUT;
  ITEM_OPTIONS_LAST       = ITEM_OPTIONS_BACK;

  ITEM_OPTIONS_COUNT      = ITEM_OPTIONS_LAST + 1;


const
  ITEM_KEYBOARD_CHANGE  = 0;
  ITEM_KEYBOARD_RESTORE = 1;
  ITEM_KEYBOARD_SAVE    = 2;
  ITEM_KEYBOARD_CANCEL  = 3;

  ITEM_KEYBOARD_FIRST   = ITEM_KEYBOARD_CHANGE;
  ITEM_KEYBOARD_LAST    = ITEM_KEYBOARD_CANCEL;

  ITEM_KEYBOARD_COUNT   = ITEM_KEYBOARD_LAST + 1;

const
  ITEM_KEYBOARD_KEY_UP     = 0;
  ITEM_KEYBOARD_KEY_DOWN   = 1;
  ITEM_KEYBOARD_KEY_LEFT   = 2;
  ITEM_KEYBOARD_KEY_RIGHT  = 3;
  ITEM_KEYBOARD_KEY_SELECT = 4;
  ITEM_KEYBOARD_KEY_START  = 5;
  ITEM_KEYBOARD_KEY_B      = 6;
  ITEM_KEYBOARD_KEY_A      = 7;
  ITEM_KEYBOARD_KEY_BACK   = 8;

  ITEM_KEYBOARD_KEY_FIRST  = ITEM_KEYBOARD_KEY_UP;
  ITEM_KEYBOARD_KEY_LAST   = ITEM_KEYBOARD_KEY_BACK;

  ITEM_KEYBOARD_KEY_COUNT  = ITEM_KEYBOARD_KEY_LAST + 1;

const
  ITEM_KEYBOARD_SCANCODE_FIRST = ITEM_KEYBOARD_KEY_UP;
  ITEM_KEYBOARD_SCANCODE_LAST  = ITEM_KEYBOARD_KEY_A;


const
  ITEM_CONTROLLER_CHANGE  = 0;
  ITEM_CONTROLLER_RESTORE = 1;
  ITEM_CONTROLLER_SAVE    = 2;
  ITEM_CONTROLLER_CANCEL  = 3;

  ITEM_CONTROLLER_FIRST   = ITEM_CONTROLLER_CHANGE;
  ITEM_CONTROLLER_LAST    = ITEM_CONTROLLER_CANCEL;

  ITEM_CONTROLLER_COUNT   = ITEM_CONTROLLER_LAST + 1;

const
  ITEM_CONTROLLER_BUTTON_UP     = 0;
  ITEM_CONTROLLER_BUTTON_DOWN   = 1;
  ITEM_CONTROLLER_BUTTON_LEFT   = 2;
  ITEM_CONTROLLER_BUTTON_RIGHT  = 3;
  ITEM_CONTROLLER_BUTTON_SELECT = 4;
  ITEM_CONTROLLER_BUTTON_START  = 5;
  ITEM_CONTROLLER_BUTTON_B      = 6;
  ITEM_CONTROLLER_BUTTON_A      = 7;
  ITEM_CONTROLLER_BUTTON_BACK   = 8;

  ITEM_CONTROLLER_BUTTON_FIRST  = ITEM_CONTROLLER_BUTTON_UP;
  ITEM_CONTROLLER_BUTTON_LAST   = ITEM_CONTROLLER_BUTTON_BACK;

  ITEM_CONTROLLER_BUTTON_COUNT  = ITEM_CONTROLLER_BUTTON_LAST + 1;

const
  ITEM_CONTROLLER_SCANCODE_FIRST = ITEM_CONTROLLER_BUTTON_UP;
  ITEM_CONTROLLER_SCANCODE_LAST  = ITEM_CONTROLLER_BUTTON_A;


const
  ITEM_X_MARKER = 12;

const
  ITEM_X_MENU_PLAY    = 144;
  ITEM_X_MENU_OPTIONS = 144;
  ITEM_X_MENU_HELP    = 144;
  ITEM_X_MENU_QUIT    = 144;

const
  ITEM_X_SETUP_REGION           = 96;
  ITEM_X_SETUP_GENERATOR        = 96;
  ITEM_X_SETUP_LEVEL            = 96;
  ITEM_X_SETUP_START            = 96;
  ITEM_X_SETUP_BACK             = 96;
  ITEM_X_SETUP_PARAM            = 184;

  ITEM_X_SETUP_BEST_LINES       = 56;
  ITEM_X_SETUP_BEST_LEVEL_BEGIN = 104;
  ITEM_X_SETUP_BEST_LEVEL_DASH  = 120;
  ITEM_X_SETUP_BEST_LEVEL_END   = 128;
  ITEM_X_SETUP_BEST_TETRISES    = 168;
  ITEM_X_SETUP_BEST_SCORE       = 216;

const
  ITEM_X_PAUSE_RESUME  = 120;
  ITEM_X_PAUSE_RESTART = 120;
  ITEM_X_PAUSE_OPTIONS = 120;
  ITEM_X_PAUSE_BACK    = 120;

const
  ITEM_X_SUMMARY_PLAY = 120;
  ITEM_X_SUMMARY_BACK = 120;

const
  ITEM_X_SUMMARY_RESULT_TOTAL_SCORE     = 272;
  ITEM_X_SUMMARY_RESULT_POINTS_PER_LINE = 272;
  ITEM_X_SUMMARY_RESULT_LINES_CLEARED   = 272;
  ITEM_X_SUMMARY_RESULT_LINES_BURNED    = 272;
  ITEM_X_SUMMARY_RESULT_TETRIS_RATE     = 272;
  ITEM_X_SUMMARY_RESULT_QUALS_END_IN    = 272;

const
  ITEM_X_OPTIONS_INPUT      = 80;
  ITEM_X_OPTIONS_SET_UP     = 80;
  ITEM_X_OPTIONS_SHIFT_NTSC = 80;
  ITEM_X_OPTIONS_SHIFT_PAL  = 80;
  ITEM_X_OPTIONS_SIZE       = 80;
  ITEM_X_OPTIONS_SOUNDS     = 80;
  ITEM_X_OPTIONS_BACK       = 80;
  ITEM_X_OPTIONS_PARAM      = 184;

const
  ITEM_X_KEYBOARD_CHANGE  = 64;
  ITEM_X_KEYBOARD_RESTORE = 64;
  ITEM_X_KEYBOARD_SAVE    = 64;
  ITEM_X_KEYBOARD_CANCEL  = 64;

const
  ITEM_X_KEYBOARD_KEY_UP     = 168;
  ITEM_X_KEYBOARD_KEY_DOWN   = 168;
  ITEM_X_KEYBOARD_KEY_LEFT   = 168;
  ITEM_X_KEYBOARD_KEY_RIGHT  = 168;
  ITEM_X_KEYBOARD_KEY_SELECT = 168;
  ITEM_X_KEYBOARD_KEY_START  = 168;
  ITEM_X_KEYBOARD_KEY_B      = 168;
  ITEM_X_KEYBOARD_KEY_A      = 168;
  ITEM_X_KEYBOARD_KEY_BACK   = 168;
  ITEM_X_KEYBOARD_SCANCODE   = 232;

const
  ITEM_X_CONTROLLER_CHANGE  = 64;
  ITEM_X_CONTROLLER_RESTORE = 64;
  ITEM_X_CONTROLLER_SAVE    = 64;
  ITEM_X_CONTROLLER_CANCEL  = 64;

const
  ITEM_X_CONTROLLER_BUTTON_UP     = 168;
  ITEM_X_CONTROLLER_BUTTON_DOWN   = 168;
  ITEM_X_CONTROLLER_BUTTON_LEFT   = 168;
  ITEM_X_CONTROLLER_BUTTON_RIGHT  = 168;
  ITEM_X_CONTROLLER_BUTTON_SELECT = 168;
  ITEM_X_CONTROLLER_BUTTON_START  = 168;
  ITEM_X_CONTROLLER_BUTTON_B      = 168;
  ITEM_X_CONTROLLER_BUTTON_A      = 168;
  ITEM_X_CONTROLLER_BUTTON_BACK   = 168;
  ITEM_X_CONTROLLER_SCANCODE      = 232;


const
  ITEM_Y_MENU_PLAY    = 88;
  ITEM_Y_MENU_OPTIONS = 100;
  ITEM_Y_MENU_HELP    = 120;
  ITEM_Y_MENU_QUIT    = 132;

const
  ITEM_Y_SETUP_REGION    = 56;
  ITEM_Y_SETUP_GENERATOR = 68;
  ITEM_Y_SETUP_LEVEL     = 80;
  ITEM_Y_SETUP_START     = 100;
  ITEM_Y_SETUP_BACK      = 112;
  ITEM_Y_SETUP_BEST      = 140;

const
  ITEM_Y_PAUSE_RESUME  = 88;
  ITEM_Y_PAUSE_RESTART = 100;
  ITEM_Y_PAUSE_OPTIONS = 120;
  ITEM_Y_PAUSE_BACK    = 132;

const
  ITEM_Y_SUMMARY_PLAY = 152;
  ITEM_Y_SUMMARY_BACK = 164;

const
  ITEM_Y_SUMMARY_RESULT_TOTAL_SCORE     = 56;
  ITEM_Y_SUMMARY_RESULT_POINTS_PER_LINE = 68;
  ITEM_Y_SUMMARY_RESULT_LINES_CLEARED   = 88;
  ITEM_Y_SUMMARY_RESULT_LINES_BURNED    = 100;
  ITEM_Y_SUMMARY_RESULT_TETRIS_RATE     = 120;
  ITEM_Y_SUMMARY_RESULT_QUALS_END_IN    = 120;

const
  ITEM_Y_OPTIONS_INPUT      = 60;
  ITEM_Y_OPTIONS_SET_UP     = 72;
  ITEM_Y_OPTIONS_SHIFT_NTSC = 92;
  ITEM_Y_OPTIONS_SHIFT_PAL  = 104;
  ITEM_Y_OPTIONS_SIZE       = 124;
  ITEM_Y_OPTIONS_SOUNDS     = 136;
  ITEM_Y_OPTIONS_BACK       = 156;

const
  ITEM_Y_KEYBOARD_CHANGE  = 48;
  ITEM_Y_KEYBOARD_RESTORE = 60;
  ITEM_Y_KEYBOARD_SAVE    = 80;
  ITEM_Y_KEYBOARD_CANCEL  = 92;

const
  ITEM_Y_KEYBOARD_KEY_UP     = 48;
  ITEM_Y_KEYBOARD_KEY_DOWN   = 60;
  ITEM_Y_KEYBOARD_KEY_LEFT   = 72;
  ITEM_Y_KEYBOARD_KEY_RIGHT  = 84;
  ITEM_Y_KEYBOARD_KEY_SELECT = 104;
  ITEM_Y_KEYBOARD_KEY_START  = 116;
  ITEM_Y_KEYBOARD_KEY_B      = 136;
  ITEM_Y_KEYBOARD_KEY_A      = 148;
  ITEM_Y_KEYBOARD_KEY_BACK   = 168;

const
  ITEM_Y_CONTROLLER_CHANGE  = 48;
  ITEM_Y_CONTROLLER_RESTORE = 60;
  ITEM_Y_CONTROLLER_SAVE    = 80;
  ITEM_Y_CONTROLLER_CANCEL  = 92;

const
  ITEM_Y_CONTROLLER_BUTTON_UP     = 48;
  ITEM_Y_CONTROLLER_BUTTON_DOWN   = 60;
  ITEM_Y_CONTROLLER_BUTTON_LEFT   = 72;
  ITEM_Y_CONTROLLER_BUTTON_RIGHT  = 84;
  ITEM_Y_CONTROLLER_BUTTON_SELECT = 104;
  ITEM_Y_CONTROLLER_BUTTON_START  = 116;
  ITEM_Y_CONTROLLER_BUTTON_B      = 136;
  ITEM_Y_CONTROLLER_BUTTON_A      = 148;
  ITEM_Y_CONTROLLER_BUTTON_BACK   = 168;


const
  ITEM_TEXT_MARKER   = '>';
  ITEM_TEXT_BAR_CELL = '#';

const
  ITEM_TEXT_MENU_PLAY    = 'PLAY';
  ITEM_TEXT_MENU_OPTIONS = 'OPTIONS';
  ITEM_TEXT_MENU_HELP    = 'HELP';
  ITEM_TEXT_MENU_QUIT    = 'QUIT';

const
  ITEM_TEXT_SETUP_REGION_TITLE         = 'REGION';
    ITEM_TEXT_SETUP_REGION_NTSC        = 'NTSC';
    ITEM_TEXT_SETUP_REGION_PAL         = 'PAL';
  ITEM_TEXT_SETUP_GENERATOR_TITLE      = 'RNG TYPE';
    ITEM_TEXT_SETUP_GENERATOR_7_BAG    = '7-BAG';
    ITEM_TEXT_SETUP_GENERATOR_MULTIBAG = 'MULTI-BAG';
    ITEM_TEXT_SETUP_GENERATOR_CLASSIC  = 'CLASSIC';
    ITEM_TEXT_SETUP_GENERATOR_BALANCED = 'BALANCED';
    ITEM_TEXT_SETUP_GENERATOR_TGM      = 'TGM';
    ITEM_TEXT_SETUP_GENERATOR_TGM3     = 'TGM TERROR';
    ITEM_TEXT_SETUP_GENERATOR_UNFAIR   = 'UNFAIR';
  ITEM_TEXT_SETUP_LEVEL                = 'LEVEL';
  ITEM_TEXT_SETUP_START                = 'START';
  ITEM_TEXT_SETUP_BACK                 = 'BACK';

const
  ITEM_TEXT_PAUSE_RESUME  = 'RESUME';
  ITEM_TEXT_PAUSE_RESTART = 'RESTART';
  ITEM_TEXT_PAUSE_OPTIONS = 'OPTIONS';
  ITEM_TEXT_PAUSE_BACK    = 'BACK TO MENU';

const
  ITEM_TEXT_SUMMARY_PLAY = 'PLAY AGAIN';
  ITEM_TEXT_SUMMARY_BACK = 'BACK TO MENU';

const
  ITEM_TEXT_OPTIONS_INPUT_TITLE        = 'INPUT';
    ITEM_TEXT_OPTIONS_INPUT_KEYBOARD   = 'KEYBOARD';
    ITEM_TEXT_OPTIONS_INPUT_CONTROLLER = 'CONTROLLER';
  ITEM_TEXT_OPTIONS_SET_UP             = 'SET UP';
  ITEM_TEXT_OPTIONS_SHIFT_NTSC         = 'SHIFT NTSC';
  ITEM_TEXT_OPTIONS_SHIFT_PAL          = 'SHIFT PAL';
  ITEM_TEXT_OPTIONS_SIZE_TITLE         = 'WINDOW';
    ITEM_TEXT_OPTIONS_SIZE_NATIVE      = 'NATIVE';
    ITEM_TEXT_OPTIONS_SIZE_ZOOM_2X     = 'ZOOM 2X';
    ITEM_TEXT_OPTIONS_SIZE_ZOOM_3X     = 'ZOOM 3X';
    ITEM_TEXT_OPTIONS_SIZE_FULLSCREEN  = 'FULLSCREEN';
    ITEM_TEXT_OPTIONS_SIZE_VIDEO_MODE  = 'VIDEO MODE';
  ITEM_TEXT_OPTIONS_SOUNDS_TITLE       = 'SOUNDS';
    ITEM_TEXT_OPTIONS_SOUNDS_ENABLED   = 'ENABLED';
    ITEM_TEXT_OPTIONS_SOUNDS_DISABLED  = 'DISABLED';
  ITEM_TEXT_OPTIONS_BACK               = 'BACK';

const
  ITEM_TEXT_KEYBOARD_CHANGE       = 'CHANGE';
    ITEM_TEXT_KEYBOARD_KEY_UP     = 'UP';
    ITEM_TEXT_KEYBOARD_KEY_DOWN   = 'DOWN';
    ITEM_TEXT_KEYBOARD_KEY_LEFT   = 'LEFT';
    ITEM_TEXT_KEYBOARD_KEY_RIGHT  = 'RIGHT';
    ITEM_TEXT_KEYBOARD_KEY_SELECT = 'SELECT';
    ITEM_TEXT_KEYBOARD_KEY_START  = 'START';
    ITEM_TEXT_KEYBOARD_KEY_B      = 'B';
    ITEM_TEXT_KEYBOARD_KEY_A      = 'A';
    ITEM_TEXT_KEYBOARD_KEY_BACK   = 'BACK';
  ITEM_TEXT_KEYBOARD_RESTORE      = 'RESTORE';
  ITEM_TEXT_KEYBOARD_SAVE         = 'SAVE';
  ITEM_TEXT_KEYBOARD_CANCEL       = 'CANCEL';

const
  ITEM_TEXT_CONTROLLER_CHANGE          = 'CHANGE';
    ITEM_TEXT_CONTROLLER_BUTTON_UP     = 'UP';
    ITEM_TEXT_CONTROLLER_BUTTON_DOWN   = 'DOWN';
    ITEM_TEXT_CONTROLLER_BUTTON_LEFT   = 'LEFT';
    ITEM_TEXT_CONTROLLER_BUTTON_RIGHT  = 'RIGHT';
    ITEM_TEXT_CONTROLLER_BUTTON_SELECT = 'SELECT';
    ITEM_TEXT_CONTROLLER_BUTTON_START  = 'START';
    ITEM_TEXT_CONTROLLER_BUTTON_B      = 'B';
    ITEM_TEXT_CONTROLLER_BUTTON_A      = 'A';
    ITEM_TEXT_CONTROLLER_BUTTON_BACK   = 'BACK';
  ITEM_TEXT_CONTROLLER_RESTORE         = 'RESTORE';
  ITEM_TEXT_CONTROLLER_SAVE            = 'SAVE';
  ITEM_TEXT_CONTROLLER_CANCEL          = 'CANCEL';


const
  GAME_TOP_TITLE_X = 88;
  GAME_TOP_TITLE_Y = 40;

  GAME_TOP_X = 48;
  GAME_TOP_Y = 50;

const
  GAME_BURNED_TITLE_X = 64;
  GAME_BURNED_TITLE_Y = 72;

  GAME_BURNED_X = 112;
  GAME_BURNED_Y = 82;

const
  GAME_TETRISES_TITLE_X = 48;
  GAME_TETRISES_TITLE_Y = 96;

  GAME_TETRISES_X = 112;
  GAME_TETRISES_Y = 106;

const
  GAME_GAIN_TITLE_X = 80;
  GAME_GAIN_TITLE_Y = 128;

  GAME_GAIN_X = 112;
  GAME_GAIN_Y = 138;

const
  GAME_CONTROLLER_X = 55;
  GAME_CONTROLLER_Y = 176;

const
  GAME_STACK_X = 128;
  GAME_STACK_Y = 40;

const
  GAME_SCORE_TITLE_X = 224;
  GAME_SCORE_TITLE_Y = 40;

  GAME_SCORE_X = 224;
  GAME_SCORE_Y = 50;

const
  GAME_LINES_TITLE_X = 224;
  GAME_LINES_TITLE_Y = 72;

  GAME_LINES_X = 224;
  GAME_LINES_Y = 82;

const
  GAME_LEVEL_TITLE_X = 224;
  GAME_LEVEL_TITLE_Y = 96;

  GAME_LEVEL_X = 224;
  GAME_LEVEL_Y = 106;

const
  GAME_NEXT_TITLE_X = 224;
  GAME_NEXT_TITLE_Y = 128;

  GAME_NEXT_X = 224;
  GAME_NEXT_Y = 144;


const
  GAME_TOP_TITLE      = 'TOP';
  GAME_BURNED_TITLE   = 'BURNED';
  GAME_TETRISES_TITLE = 'TETRISES';
  GAME_GAIN_TITLE     = 'GAIN';
  GAME_SCORE_TITLE    = 'SCORE';
  GAME_LINES_TITLE    = 'LINES';
  GAME_LEVEL_TITLE    = 'LEVEL';
  GAME_NEXT_TITLE     = 'NEXT';


const
  REGION_NTSC    = 0;
  REGION_PAL     = 1;

  REGION_FIRST   = REGION_NTSC;
  REGION_LAST    = REGION_PAL;

  REGION_COUNT   = REGION_LAST + 1;
  REGION_DEFAULT = REGION_NTSC;


const
  GENERATOR_MULTIBAG = 0;
  GENERATOR_CLASSIC  = 1;
  GENERATOR_BALANCED = 2;
  GENERATOR_TGM      = 3;
  GENERATOR_TGM3     = 4;
  GENERATOR_UNFAIR   = 5;
  GENERATOR_7_BAG    = 6;

  GENERATOR_FIRST    = GENERATOR_MULTIBAG;
  GENERATOR_LAST     = GENERATOR_7_BAG;

  GENERATOR_COUNT    = GENERATOR_LAST + 1;
  GENERATOR_DEFAULT  = GENERATOR_MULTIBAG;


const
  LEVEL_FIRST   = 0;
  LEVEL_LAST    = 19;

  LEVEL_COUNT   = LEVEL_LAST + 1;
  LEVEL_DEFAULT = LEVEL_FIRST;

const
  LEVEL_GLITCHED = 138;
  LEVEL_BSOD     = 256;


const
  BEST_SCORES_FIRST = 0;
  BEST_SCORES_LAST  = 2;

  BEST_SCORES_COUNT = BEST_SCORES_LAST + 1;

  BEST_SCORES_SPACING_Y = 12;


const
  INPUT_KEYBOARD   = 0;
  INPUT_CONTROLLER = 1;

  INPUT_FIRST      = INPUT_KEYBOARD;
  INPUT_LAST       = INPUT_CONTROLLER;

  INPUT_COUNT      = INPUT_LAST + 1;
  INPUT_DEFAULT    = INPUT_KEYBOARD;


const
  TRIGGER_DEVICE_UP     = 0;
  TRIGGER_DEVICE_DOWN   = 1;
  TRIGGER_DEVICE_LEFT   = 2;
  TRIGGER_DEVICE_RIGHT  = 3;
  TRIGGER_DEVICE_SELECT = 4;
  TRIGGER_DEVICE_START  = 5;
  TRIGGER_DEVICE_B      = 6;
  TRIGGER_DEVICE_A      = 7;

  TRIGGER_DEVICE_FIRST  = TRIGGER_DEVICE_UP;
  TRIGGER_DEVICE_LAST   = TRIGGER_DEVICE_A;


const
  TRIGGER_KEYBOARD_KEY_UP     = TRIGGER_DEVICE_UP;
  TRIGGER_KEYBOARD_KEY_DOWN   = TRIGGER_DEVICE_DOWN;
  TRIGGER_KEYBOARD_KEY_LEFT   = TRIGGER_DEVICE_LEFT;
  TRIGGER_KEYBOARD_KEY_RIGHT  = TRIGGER_DEVICE_RIGHT;
  TRIGGER_KEYBOARD_KEY_SELECT = TRIGGER_DEVICE_SELECT;
  TRIGGER_KEYBOARD_KEY_START  = TRIGGER_DEVICE_START;
  TRIGGER_KEYBOARD_KEY_B      = TRIGGER_DEVICE_B;
  TRIGGER_KEYBOARD_KEY_A      = TRIGGER_DEVICE_A;

  TRIGGER_KEYBOARD_KEY_FIRST  = TRIGGER_KEYBOARD_KEY_UP;
  TRIGGER_KEYBOARD_KEY_LAST   = TRIGGER_KEYBOARD_KEY_A;


const
  CONTROLLER_COUNT_BUTTONS = 32;
  CONTROLLER_COUNT_AXES    = 8;
  CONTROLLER_COUNT_HATS    = 2;

  CONTROLLER_COUNT_BUTTONS_PER_AXIS = 2;
  CONTROLLER_COUNT_BUTTONS_PER_HAT  = 4;

const
  TRIGGER_CONTROLLER_BUTTON_UP     = TRIGGER_DEVICE_UP;
  TRIGGER_CONTROLLER_BUTTON_DOWN   = TRIGGER_DEVICE_DOWN;
  TRIGGER_CONTROLLER_BUTTON_LEFT   = TRIGGER_DEVICE_LEFT;
  TRIGGER_CONTROLLER_BUTTON_RIGHT  = TRIGGER_DEVICE_RIGHT;
  TRIGGER_CONTROLLER_BUTTON_SELECT = TRIGGER_DEVICE_SELECT;
  TRIGGER_CONTROLLER_BUTTON_START  = TRIGGER_DEVICE_START;
  TRIGGER_CONTROLLER_BUTTON_B      = TRIGGER_DEVICE_B;
  TRIGGER_CONTROLLER_BUTTON_A      = TRIGGER_DEVICE_A;

  TRIGGER_CONTROLLER_BUTTON_FIRST  = TRIGGER_CONTROLLER_BUTTON_UP;
  TRIGGER_CONTROLLER_BUTTON_LAST   = TRIGGER_CONTROLLER_BUTTON_A;


const
  KEYBOARD_SCANCODE_KEY_FIRST = 0;
  KEYBOARD_SCANCODE_KEY_LAST  = 255;

const
  KEYBOARD_SCANCODE_KEY_UP         = SDL_SCANCODE_UP;
  KEYBOARD_SCANCODE_KEY_DOWN       = SDL_SCANCODE_DOWN;
  KEYBOARD_SCANCODE_KEY_LEFT       = SDL_SCANCODE_LEFT;
  KEYBOARD_SCANCODE_KEY_RIGHT      = SDL_SCANCODE_RIGHT;
  KEYBOARD_SCANCODE_KEY_SELECT     = SDL_SCANCODE_V;
  KEYBOARD_SCANCODE_KEY_START      = SDL_SCANCODE_Z;
  KEYBOARD_SCANCODE_KEY_B          = SDL_SCANCODE_X;
  KEYBOARD_SCANCODE_KEY_A          = SDL_SCANCODE_C;
  KEYBOARD_SCANCODE_KEY_NOT_MAPPED = SDL_SCANCODE_UNKNOWN;


const
  CONTROLLER_SCANCODE_BUTTON_0  = 0;
  CONTROLLER_SCANCODE_BUTTON_1  = 1;
  CONTROLLER_SCANCODE_BUTTON_2  = 2;
  CONTROLLER_SCANCODE_BUTTON_3  = 3;
  CONTROLLER_SCANCODE_BUTTON_4  = 4;
  CONTROLLER_SCANCODE_BUTTON_5  = 5;
  CONTROLLER_SCANCODE_BUTTON_6  = 6;
  CONTROLLER_SCANCODE_BUTTON_7  = 7;
  CONTROLLER_SCANCODE_BUTTON_8  = 8;
  CONTROLLER_SCANCODE_BUTTON_9  = 9;
  CONTROLLER_SCANCODE_BUTTON_10 = 10;
  CONTROLLER_SCANCODE_BUTTON_11 = 11;
  CONTROLLER_SCANCODE_BUTTON_12 = 12;
  CONTROLLER_SCANCODE_BUTTON_13 = 13;
  CONTROLLER_SCANCODE_BUTTON_14 = 14;
  CONTROLLER_SCANCODE_BUTTON_15 = 15;
  CONTROLLER_SCANCODE_BUTTON_16 = 16;
  CONTROLLER_SCANCODE_BUTTON_17 = 17;
  CONTROLLER_SCANCODE_BUTTON_18 = 18;
  CONTROLLER_SCANCODE_BUTTON_19 = 19;
  CONTROLLER_SCANCODE_BUTTON_20 = 20;
  CONTROLLER_SCANCODE_BUTTON_21 = 21;
  CONTROLLER_SCANCODE_BUTTON_22 = 22;
  CONTROLLER_SCANCODE_BUTTON_23 = 23;
  CONTROLLER_SCANCODE_BUTTON_24 = 24;
  CONTROLLER_SCANCODE_BUTTON_25 = 25;
  CONTROLLER_SCANCODE_BUTTON_26 = 26;
  CONTROLLER_SCANCODE_BUTTON_27 = 27;
  CONTROLLER_SCANCODE_BUTTON_28 = 28;
  CONTROLLER_SCANCODE_BUTTON_29 = 29;
  CONTROLLER_SCANCODE_BUTTON_30 = 30;
  CONTROLLER_SCANCODE_BUTTON_31 = 31;

const
  CONTROLLER_SCANCODE_AXIS_X_NEGATIVE = 32;
  CONTROLLER_SCANCODE_AXIS_X_POSITIVE = 33;
  CONTROLLER_SCANCODE_AXIS_Y_NEGATIVE = 34;
  CONTROLLER_SCANCODE_AXIS_Y_POSITIVE = 35;
  CONTROLLER_SCANCODE_AXIS_Z_NEGATIVE = 36;
  CONTROLLER_SCANCODE_AXIS_Z_POSITIVE = 37;
  CONTROLLER_SCANCODE_AXIS_R_NEGATIVE = 38;
  CONTROLLER_SCANCODE_AXIS_R_POSITIVE = 39;
  CONTROLLER_SCANCODE_AXIS_U_NEGATIVE = 40;
  CONTROLLER_SCANCODE_AXIS_U_POSITIVE = 41;
  CONTROLLER_SCANCODE_AXIS_V_NEGATIVE = 42;
  CONTROLLER_SCANCODE_AXIS_V_POSITIVE = 43;
  CONTROLLER_SCANCODE_AXIS_6_NEGATIVE = 44;
  CONTROLLER_SCANCODE_AXIS_6_POSITIVE = 45;
  CONTROLLER_SCANCODE_AXIS_7_NEGATIVE = 46;
  CONTROLLER_SCANCODE_AXIS_7_POSITIVE = 47;

const
  CONTROLLER_SCANCODE_HAT_0_X_NEGATIVE = 48;
  CONTROLLER_SCANCODE_HAT_0_X_POSITIVE = 49;
  CONTROLLER_SCANCODE_HAT_0_Y_NEGATIVE = 50;
  CONTROLLER_SCANCODE_HAT_0_Y_POSITIVE = 51;

const
  CONTROLLER_SCANCODE_HAT_1_X_NEGATIVE = 52;
  CONTROLLER_SCANCODE_HAT_1_X_POSITIVE = 53;
  CONTROLLER_SCANCODE_HAT_1_Y_NEGATIVE = 54;
  CONTROLLER_SCANCODE_HAT_1_Y_POSITIVE = 55;

const
  CONTROLLER_SCANCODE_BUTTON_FIRST = CONTROLLER_SCANCODE_BUTTON_0;
  CONTROLLER_SCANCODE_BUTTON_LAST  = CONTROLLER_SCANCODE_HAT_1_Y_POSITIVE;

const
  CONTROLLER_OFFSET_ARROWS = CONTROLLER_SCANCODE_AXIS_X_NEGATIVE;
  CONTROLLER_OFFSET_HATS   = CONTROLLER_SCANCODE_HAT_0_X_NEGATIVE;

const
  CONTROLLER_SCANCODE_BUTTON_UP         = CONTROLLER_SCANCODE_HAT_0_Y_NEGATIVE;
  CONTROLLER_SCANCODE_BUTTON_DOWN       = CONTROLLER_SCANCODE_HAT_0_Y_POSITIVE;
  CONTROLLER_SCANCODE_BUTTON_LEFT       = CONTROLLER_SCANCODE_HAT_0_X_NEGATIVE;
  CONTROLLER_SCANCODE_BUTTON_RIGHT      = CONTROLLER_SCANCODE_HAT_0_X_POSITIVE;
  CONTROLLER_SCANCODE_BUTTON_SELECT     = CONTROLLER_SCANCODE_BUTTON_6;
  CONTROLLER_SCANCODE_BUTTON_START      = CONTROLLER_SCANCODE_BUTTON_7;
  CONTROLLER_SCANCODE_BUTTON_B          = CONTROLLER_SCANCODE_BUTTON_0;
  CONTROLLER_SCANCODE_BUTTON_A          = CONTROLLER_SCANCODE_BUTTON_1;
  CONTROLLER_SCANCODE_BUTTON_NOT_MAPPED = CONTROLLER_SCANCODE_BUTTON_LAST + 1;


const
  SHIFT_NTSC_FIRST   = 0;
  SHIFT_NTSC_LAST    = 5;

  SHIFT_NTSC_DEFAULT = SHIFT_NTSC_FIRST;

const
  SHIFT_PAL_FIRST   = 0;
  SHIFT_PAL_LAST    = 4;

  SHIFT_PAL_DEFAULT = SHIFT_PAL_FIRST;


const
  SIZE_NATIVE     = 0;
  SIZE_ZOOM_2X    = 1;
  SIZE_ZOOM_3X    = 2;
  SIZE_FULLSCREEN = 3;

  SIZE_FIRST      = SIZE_NATIVE;
  SIZE_LAST       = SIZE_FULLSCREEN;

  SIZE_COUNT      = SIZE_LAST + 1;
  SIZE_DEFAULT    = SIZE_ZOOM_2X;


const
  SOUNDS_ENABLED  = 0;
  SOUNDS_DISABLED = 1;

  SOUNDS_FIRST    = SOUNDS_ENABLED;
  SOUNDS_LAST     = SOUNDS_DISABLED;

  SOUNDS_COUNT    = SOUNDS_LAST + 1;
  SOUNDS_DEFAULT  = SOUNDS_ENABLED;


const
  PIECE_UNKNOWN = 0;
  PIECE_T       = 1;
  PIECE_J       = 2;
  PIECE_Z       = 3;
  PIECE_O       = 4;
  PIECE_S       = 5;
  PIECE_L       = 6;
  PIECE_I       = 7;

  PIECE_FIRST   = PIECE_T;
  PIECE_LAST    = PIECE_I;


const
  PIECE_WIDTH  = 31;
  PIECE_HEIGHT = 15;


const
  PIECE_ORIENTATION_DOWN  = 0;
  PIECE_ORIENTATION_LEFT  = 1;
  PIECE_ORIENTATION_UP    = 2;
  PIECE_ORIENTATION_RIGHT = 3;

  PIECE_ORIENTATION_FIRST = PIECE_ORIENTATION_DOWN;
  PIECE_ORIENTATION_LAST  = PIECE_ORIENTATION_RIGHT;

  PIECE_ORIENTATION_COUNT = PIECE_ORIENTATION_LAST + 1;
  PIECE_ORIENTATION_SPAWN = PIECE_ORIENTATION_DOWN;


const
  PIECE_SPAWN_X = 5;
  PIECE_SPAWN_Y = 0;


const
  PIECE_SHIFT_LEFT  = -1;
  PIECE_SHIFT_RIGHT = +1;


const
  PIECE_ROTATE_COUNTERCLOCKWISE = -1;
  PIECE_ROTATE_CLOCKWISE        = +1;


const
  LINES_UNKNOWN  = 0;
  LINES_SINGLES  = 1;
  LINES_DOUBLES  = 2;
  LINES_TRIPLES  = 3;
  LINES_TETRISES = 4;

  LINES_FIRST    = LINES_SINGLES;
  LINES_LAST     = LINES_TETRISES;


const
  MULTIBAG_BAG_FIRST  = 0;
  MULTIBAG_BAG_LAST   = 6;

  MULTIBAG_BAGS_COUNT = MULTIBAG_BAG_LAST + 1;

const
  MULTIBAG_PIECE_FIRST  = 0;
  MULTIBAG_PIECE_LAST   = 7;

  MULTIBAG_PIECES_COUNT = MULTIBAG_PIECE_LAST + 1;


const
  BALANCED_HISTORY_PIECE_FIRST  = 0;
  BALANCED_HISTORY_PIECE_LAST   = 9;

  BALANCED_HISTORY_PIECES_COUNT = BALANCED_HISTORY_PIECE_LAST + 1;

const
  BALANCED_FLOOD_COUNT   = 3;
  BALANCED_DROUGHT_COUNT = 10;


const
  TGM_POOL_PIECE_FIRST  = 0;
  TGM_POOL_PIECE_LAST   = 6;

  TGM_POOL_PIECES_COUNT = TGM_POOL_PIECE_LAST + 1;

const
  TGM_POOL_SPECIAL_FIRST = 0;
  TGM_POOL_SPECIAL_LAST  = 3;

  TGM_POOL_SPECIAL_COUNT = TGM_POOL_SPECIAL_LAST + 1;

const
  TGM_POOL_HISTORY_FIRST = 0;
  TGM_POOL_HISTORY_LAST  = 2;

  TGM_POOL_HISTORY_COUNT = TGM_POOL_HISTORY_LAST + 1;


const
  TGM3_POOL_PIECE_FIRST  = 0;
  TGM3_POOL_PIECE_LAST   = 6;

  TGM3_POOL_PIECES_COUNT = TGM3_POOL_PIECE_LAST + 1;

const
  TGM3_POOL_SPECIAL_FIRST = 0;
  TGM3_POOL_SPECIAL_LAST  = 3;

  TGM3_POOL_SPECIAL_COUNT = TGM3_POOL_SPECIAL_LAST + 1;

const
  TGM3_POOL_POOL_FIRST = 0;
  TGM3_POOL_POOL_LAST  = 34;

  TGM3_POOL_POOL_COUNT = TGM3_POOL_POOL_LAST + 1;

const
  TGM3_POOL_HISTORY_FIRST = 0;
  TGM3_POOL_HISTORY_LAST  = 2;

  TGM3_POOL_HISTORY_COUNT = TGM3_POOL_HISTORY_LAST + 1;


const
  BRICK_UNKNOWN = 0;
  BRICK_EMPTY   = 0;
  BRICK_A       = 1;
  BRICK_B       = 2;
  BRICK_C       = 3;

const
  BRICK_WIDTH  = 7;
  BRICK_HEIGHT = 7;

const
  BRICK_SPACING_X = 1;
  BRICK_SPACING_Y = 1;

const
  BRICK_CELL_WIDTH  = BRICK_WIDTH + BRICK_SPACING_X;
  BRICK_CELL_HEIGHT = BRICK_HEIGHT + BRICK_SPACING_Y;


const
  COLOR_WHITE = $FFFFFF;
  COLOR_GRAY  = $7F7F7F;
  COLOR_DARK  = $1F1F1F;


const
  ALIGN_LEFT  = 0;
  ALIGN_RIGHT = 1;


const
  SETTINGS_FILENAME = 'settings.ini';

const
  SETTINGS_SECTION_VIDEO      = 'VIDEO';
  SETTINGS_SECTION_GENERAL    = 'GENERAL';
  SETTINGS_SECTION_KEYBOARD   = 'KEYBOARD';
  SETTINGS_SECTION_CONTROLLER = 'CONTROLLER';

const
  SETTINGS_KEY_VIDEO_ENABLED      = 'ENABLED';

  SETTINGS_KEY_GENERAL_MONITOR    = 'MONITOR';
  SETTINGS_KEY_GENERAL_LEFT       = 'LEFT';
  SETTINGS_KEY_GENERAL_TOP        = 'TOP';
  SETTINGS_KEY_GENERAL_INPUT      = 'INPUT';
  SETTINGS_KEY_GENERAL_SHIFT_NTSC = 'SHIFT NTSC';
  SETTINGS_KEY_GENERAL_SHIFT_PAL  = 'SHIFT PAL';
  SETTINGS_KEY_GENERAL_SIZE       = 'WINDOW';
  SETTINGS_KEY_GENERAL_SOUNDS     = 'SOUNDS';
  SETTINGS_KEY_GENERAL_REGION     = 'REGION';
  SETTINGS_KEY_GENERAL_GENERATOR  = 'RNG';
  SETTINGS_KEY_GENERAL_LEVEL      = 'LEVEL';

  SETTINGS_KEY_MAPPING_UP         = 'UP';
  SETTINGS_KEY_MAPPING_DOWN       = 'DOWN';
  SETTINGS_KEY_MAPPING_LEFT       = 'LEFT';
  SETTINGS_KEY_MAPPING_RIGHT      = 'RIGHT';
  SETTINGS_KEY_MAPPING_SELECT     = 'SELECT';
  SETTINGS_KEY_MAPPING_START      = 'START';
  SETTINGS_KEY_MAPPING_B          = 'B';
  SETTINGS_KEY_MAPPING_A          = 'A';

const
  SETTINGS_VALUE_VIDEO_ENABLED      = True;

  SETTINGS_VALUE_GENERAL_MONITOR    = MONITOR_DEFAULT;
  SETTINGS_VALUE_GENERAL_LEFT       = 0;
  SETTINGS_VALUE_GENERAL_TOP        = 0;
  SETTINGS_VALUE_GENERAL_INPUT      = INPUT_DEFAULT;
  SETTINGS_VALUE_GENERAL_SHIFT_NTSC = SHIFT_NTSC_DEFAULT;
  SETTINGS_VALUE_GENERAL_SHIFT_PAL  = SHIFT_PAL_DEFAULT;
  SETTINGS_VALUE_GENERAL_SIZE       = SIZE_DEFAULT;
  SETTINGS_VALUE_GENERAL_SOUNDS     = SOUNDS_DEFAULT;
  SETTINGS_VALUE_GENERAL_REGION     = REGION_DEFAULT;
  SETTINGS_VALUE_GENERAL_GENERATOR  = GENERATOR_DEFAULT;
  SETTINGS_VALUE_GENERAL_LEVEL      = LEVEL_DEFAULT;


const
  BEST_SCORES_SECTION_GENERAL = 'GENERAL';
  BEST_SCORES_SECTION_SCORE   = 'SCORE %d';

const
  BEST_SCORES_KEY_GENERAL_COUNT       = 'COUNT';

  BEST_SCORES_KEY_SCORE_LINES_CLEARED = 'LINES CLEARED';
  BEST_SCORES_KEY_SCORE_LEVEL_BEGIN   = 'LEVEL BEGIN';
  BEST_SCORES_KEY_SCORE_LEVEL_END     = 'LEVEL END';
  BEST_SCORES_KEY_SCORE_TETRIS_RATE   = 'TETRIS RATE';
  BEST_SCORES_KEY_SCORE_TOTAL_SCORE   = 'TOTAL SCORE';


const
  ERROR_SDL_INITIALIZE_SYSTEM  = 0;
  ERROR_SDL_INITIALIZE_AUDIO   = 1;
  ERROR_SDL_ALLOCATE_CHANNELS  = 2;
  ERROR_SDL_CREATE_WINDOW      = 3;
  ERROR_SDL_CREATE_RENDERER    = 4;
  ERROR_SDL_CREATE_HANDLE      = 5;
  ERROR_SDL_CREATE_HITTEST     = 6;
  ERROR_SDL_CREATE_BACK_BUFFER = 7;
  ERROR_SDL_CREATE_BSOD_BUFFER = 8;
  ERROR_SDL_CREATE_QUIT_BUFFER = 9;
  ERROR_SDL_LOAD_SPRITE        = 10;
  ERROR_SDL_LOAD_GROUND        = 11;
  ERROR_SDL_LOAD_SOUND         = 12;

  ERROR_FIRST                  = ERROR_SDL_INITIALIZE_SYSTEM;
  ERROR_LAST                   = ERROR_SDL_LOAD_SOUND;


const
  FOLDER_ORGANIZATION = 'furious-programming';
  FOLDER_APPLICATION  = 'fairtris2';


const
  ERROR_TITLE = 'Fairtris 2: The Ultimate Crash!';

const
  ERROR_MESSAGE_SDL =
    'A fatal error occurred while booting the game, and the startup process must be interrupted.' +

    LineEnding + LineEnding +

    'General message: "%s".' + LineEnding + LineEnding +
    'SDL message: "%s".' + LineEnding + LineEnding +

    'Reinstalling the game may fix the problem, and if it persists, contact the author or report ' +
    'a bug in the project''s repository (see the file "license.txt" for helpful information).';

const
  ERROR_MESSAGE_UNKNOWN =
    'An unexpected exception has occurred and the game must be terminated.' +

    LineEnding + LineEnding +

    'Exception message: "%s".' + LineEnding + LineEnding +

    'Reinstalling the game may fix the problem, and if it persists, contact the author or report ' +
    'a bug in the project''s repository (see the file "license.txt" for helpful information).';


implementation

end.

