![banner.png](blob/readme/banner.png)

**Fairtris 2: The Ultimate Challenge**</br>
Copyleft (ɔ) furious programming 2024. All rights reversed.

</br>

PC clone of the official classic **[Nintendo Tetris®](https://en.wikipedia.org/wiki/Tetris_(NES_video_game))** for the **[NES](https://en.wikipedia.org/wiki/Nintendo_Entertainment_System)** console and the successor to the **[Fairtris](https://github.com/furious-programming/Fairtris)** video game, intended for Windows and Linux systems. Ready to take on the ultimate challenge? **[Download the game]()** and try yourself!

</br></br>

# Compilation and developing

**[Lazarus 3.2](https://sourceforge.net/projects/lazarus)** was used to compile and work on the code, so you should use that as well (or a newer version if available). The **[headers for SDL2](https://github.com/PascalGameDevelopment/SDL2-for-Pascal)** are in the `source\sdl\` subdirectory, while the `.dll` libraries are in the `bin\` folder, where the executable file is created after compilation. The compiled `.dll` libraries were downloaded from the official **[SDL repository](https://github.com/libsdl-org/SDL). So all you need to do is just open the project in **Lazarus** and hit the compile button.

If you are using **Free Pascal IDE** or regular text editor such as **Notepad++** or **Vim**, be sure to somehow add the **SDL** units path in the project settings and well... keep torturing yourself.

</br>

# License

Information on the license can be found in the **[LICENSE](LICENSE)** file. In general, this project is also completely free, you can use it for whatever purpose you want, both the entire game and parts of it. So play, share, fork, modify — do what you want, I still don't give a shit about it.

</br>

# Bindings

**Fairtris** mainly targets 64-bit **Windows** systems, versions `Vista`, `7`, `8`, `8.1`, `10` and `11`. In the future, its clones for other platforms may appear — if someone decides to fork this repository and modify the game source code. Currently available releases:

* **[Fairtris 2 for Windows](https://github.com/furious-programming/fairtris-2-uc)** by **[furious programming](https://github.com/furious-programming)**

</br>

# Acknowledgments and useful links

In addition to the **[previously gained knowledge](https://github.com/furious-programming/Fairtris#acknowledgments-and-useful-links)**, useful to create the first **[Fairtris](https://github.com/furious-programming/Fairtris)** video game, during the development of **Fairtris 2** the **[FCEUX](http://fceux.com)** emulator and a modified ROM of the original **[Nintendo Tetris®](https://en.wikipedia.org/wiki/Tetris_(NES_video_game))**, called **[TetrisGYM](https://github.com/kirjavascript/TetrisGYM)**, were used. Many thanks to the authors of **[Lazarus](https://www.lazarus-ide.org/)**, the **[SDL2 headers](https://github.com/PascalGameDevelopment/SDL2-for-Pascal)** and the **[SDL library](https://github.com/libsdl-org/SDL)**. These tools allowed for the convenient creation of the **Fairtris** in a light and super-efficient form.
