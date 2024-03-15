THIS DOCUMENT AND THE PROJECT WIKI ARE STILL UNDER DEVELOPMENT!

![banner.png](blob/readme/banner.png)

**Fairtris 2: The Ultimate Challenge**</br>
Copyleft (ɔ) furious programming 2024. All rights reversed.

</br>

PC clone of the official classic **[Nintendo Tetris®](https://en.wikipedia.org/wiki/Tetris_(NES_video_game))** for the **[NES](https://en.wikipedia.org/wiki/Nintendo_Entertainment_System)** console and the successor to the **[Fairtris](https://github.com/furious-programming/Fairtris)** video game, intended for Windows and Linux systems. Ready to take on the ultimate challenge? **[Download the game]()** and try yourself!

</br></br>

# Compilation and developing

**[Lazarus 3.2](https://sourceforge.net/projects/lazarus)** was used to compile and work on the code, so you should use that as well (or a newer version if available). The **[headers for SDL2](https://github.com/PascalGameDevelopment/SDL2-for-Pascal)** are in the `source\sdl\` subdirectory, while the `.dll` libraries are in the `bin\` folder, where the executable file is created after compilation. The compiled `.dll` libraries were downloaded from the official **[SDL repository](https://github.com/libsdl-org/SDL)**. So all you need to do is just open the project in **Lazarus** and hit the compile button.

If you are using **Free Pascal IDE** or regular text editor such as **Notepad++** or **Vim**, be sure to somehow add the **SDL** units path in the project settings and well... keep torturing yourself.

</br>

# What is Fairtris?

**Fairtris 2** is a video game, a clone of the 32-year-old **[Tetris®](https://en.wikipedia.org/wiki/Tetris_(NES_video_game))** produced by **[Nintendo](https://www.nintendo.com)** for the **[Famicom](https://en.wikipedia.org/wiki/Nintendo_Entertainment_System)** and **[NES](https://en.wikipedia.org/wiki/Nintendo_Entertainment_System)** consoles, designed for modern Windows and Linux systems. It is the successor to the first [Fairtris](https://github.com/furious-programming/Fairtris) video game, with refreshed graphics, newly defined functionality and introducing a number of new features that ensure even more fun.

</br>

# What's new in Fairtris 2?

The first **Fairtris** was mainly an experiment to create the classic **Tetris®** as a native application for modern platforms, using all available knowledge about the structure and operation of the official **Tetris®** from **Nintendo**. I consider the experiment to be a complete success, and in the meantime, the classic **Tetris®** scene has moved forward significantly, drastically pushing the boundaries of what is possible. 

Maxout is no feat today — currently the best players in the world know no limits, they can go so far that the classic **Tetris®** gives up, starts rendering game frames with glitched colors, or even crashes and goes into soft lock. The first to do this was **Blue Scuti**, and his achievement in the form of a game crash became an incredible sensation, which was even reported by the media around the world. Soon, others joined this elite, including **Fractal** and **Pixel Andy** (as of the date of writing this document). This was the main impulse for creating the **Fairtris** sequel, it was time to take the next step.

</b>

## Removed NES Tetris® compatibility

**Fairtris 2** has been redefined, new goals have been defined. The decision has been made to discontinue compatibility support with classic **Tetris®** and tools such as **NestrisChamps** and **Maxout Club**. The new version should have the shape of a typical game, not an experimental tool for testing various algorithms. Everything related to compatibility with the progenitor has been removed. This is mainly about the classic theme and aspect ratio, as well as the classic, clumsy control mechanics and **hard-drop**, which was an experiment. Transition to level `19` no longer has any significance, and there is no killscreen at level `29`, which is such a high speed of falling pieces that further play becomes practically impossible. Speedrun and qualification modes have also been removed, as well as support for setting a fixed seed for RNG.

## New game design and aspect ratio

The new version of **Fairtris** has one, richer graphics design and the game image is rendered in `16:10` aspect ratio, which is the standard for modern LCD displays. Instead of flat characters, piece bricks and other game objects, the new version uses more colors and subtle gradients, as well as more animated elements, including the main background for all game scenes. Now it feels more like a **SNES** game instead of an **NES** game.

</b>

## Unified control mechanics

The controls have been unified, only the best mechanics have been selected, ensuring the best responsiveness and intuitive control, and adapting them to the new game goals. Instead of supporting the classic control mechanics, it is now possible to set the speed of automatic shifting of pieces, called **DAS**. By default, the speed is consistent with its predecessor, but more experienced players can increase it to be able to stack higher and wait longer for the longbar.

## New game goal

In the first **Fairtris**, just like in the classic **Tetris®**, the goal was to collect as many points as possible and reach level `29`, at which most of the time the game ended (killscreen). **Fairtris 2** does not have any killscreen limitations. The maximum falling speed of the pieces has been set to that of level `19`, which ensures an infinitely long gameplay. However, this still does not change the fact that playing at this speed is difficult and requires a lot of experience, so the bar is still set high.

To diversify the gameplay, support for glitched colors of pieces and stack bricks has been added, consistent with that existing in **Nintendo Tetris®**. These glitched colors, as in the original, are used at levels `138` to `255`, which requires clearing over `1,300` lines. In the original, the pieces in some levels were black and therefore almost invisible, which made playing very difficult. Since the new version of **Fairtris** uses gentle gradients, also for pieces and the content of the stack, the colors can be consistent with the predecessor while not being unfair.

The ultimate challenge is to pass level `255`, which in **Nintendo Tetris®** caused the level counter to overflow and return to level `0`. **Fairtris 2** has a special handling of such a situation and a reward for the player for achieving such an outstanding achievement. Beating level `255` results in... it's a secret — It's up to you to discover what it is!

</br>

# License

Information on the license can be found in the **[LICENSE](LICENSE)** file. In general, this project is also completely free, you can use it for whatever purpose you want, both the entire game and parts of it. So play, share, fork, modify — do what you want, I still don't give a shit about it.

</br>

# Bindings

**Fairtris 2** mainly targets 64-bit **Windows** systems, versions `Vista`, `7`, `8`, `8.1`, `10` and `11`. In the future, its clones for other platforms may appear — if someone decides to fork this repository and modify the game source code. Currently available releases:

* **[Fairtris 2 for Windows](https://github.com/furious-programming/fairtris-2-uc)** by **[furious programming](https://github.com/furious-programming)**

</br>

# Acknowledgments and useful links

In addition to the **[previously gained knowledge](https://github.com/furious-programming/Fairtris#acknowledgments-and-useful-links)**, useful to create the first **[Fairtris](https://github.com/furious-programming/Fairtris)** video game, during the development of **Fairtris 2** the **[FCEUX](https://fceux.com/)** emulator and a modified ROM of the original **[Nintendo Tetris®](https://en.wikipedia.org/wiki/Tetris_(NES_video_game))**, called **[TetrisGYM](https://github.com/kirjavascript/TetrisGYM)**, were used. Many thanks to the authors of **[Lazarus](https://www.lazarus-ide.org/)**, the **[SDL2 headers](https://github.com/PascalGameDevelopment/SDL2-for-Pascal)** and the **[SDL library](https://www.libsdl.org/)**. These tools allowed for the convenient creation of the **Fairtris** in a light and super-efficient form.
