# How to build your project for Arduboy in pure C/C++ code

![](imgs/gnu-make-arduboy.png)

This repository has an example of how to build vanilla C/C++ project for Arduboy
with GNU Make.

## Available make tasks

The Makefile provides follow tasks:

 - `make clean` removes the output directory;
 - `make core` builds the Arduino core library;
 - `make arduboy2` builds the Arduboy2 library;
 - `make compile` compiles all files and links them as a single binary file; 
 - `make hex` creates the \*.hex file;
 - `make size` shows the size of the binary file and \*.hex file;
 - `make compile_commands.json` creates a compilation database as a `compile_commands.json` file;
 - `make emulate` runs project in ArdensPlayer;
 - `make upload` to upload project to the board **NOT IMPLEMENTED YET**

## Set user specific variables

To work with Makefile from this project you need:

  - avr tools (compiler, lincker, etc)
  - arduino libraries (core, hardware, etc)
  - extra libraries (Arduboy2, ArdBitmap, ArduboyPlaytune, etc)
  - emulator (optional). In this project the [Ardens](https://github.com/tiberiusbrown/Ardens) is used.

All variables, which have to be specified, are declared on the top of the [Makefile](Makefile)
in appropriate section.

Most of values for user specific variables can be taken from the ArduinoIDE
installation. It's also possible to install everything in different ways:
install avr tools from the repo of your OS, download libraries manually from the
github, etc. But here we will look at getting everything except emulator from
the ArduinoIDE installation.

## Get tools and dependencies from the ArduinoIDE

Follow instructions from the official web-site to install it: https://www.arduino.cc/en/software .

Install `Arduboy2` library:

`Tools ❱ Manage Libraries...`

![](imgs/install-arduboy2.png)

Choose `Arduino Leonardo` as the board:

`Tools ❱ Board ❱ Arduino AVR Boards ❱ Arduino Leonardo`

![](imgs/select-board.png)

Turn on additional logs:

`Settings... ❱ Settings ❱ Show verbose output during ❱  compile`

![](imgs/turn-on-logs.png)

Open any example for Arduboy:

`Files ❱ Examples ❱ Arduboy2 ❱ HelloWorld`

![](imgs/hello-world-example.png)

### Set variables in the Makefile

To use the Makefile you have to set the next variables:

```make
# Path to the arduino installation:
ARDUINO_DIR=

# Path to the directory with avr binaries:
AVR_DIR=

# Path to the directory with hardware libs:
ARDUINO_HARDWARE_DIR=

# Path to the directory with already installed arduino libraries:
LIBS_DIR=
```

If you run verification of the example in ArduinoIDE, you may take many needed paths
from the log:

```sh
FQBN: arduino:avr:leonardo
Using board 'leonardo' from platform in folder: /Users/dokwork/Library/Arduino15/packages/arduino/hardware/avr/1.8.6
Using core 'arduino' from platform in folder: /Users/dokwork/Library/Arduino15/packages/arduino/hardware/avr/1.8.6

Detecting libraries used...
/Users/dokwork/Library/Arduino15/packages/arduino/tools/avr-gcc/7.3.0-atmel3.6.1-arduino7/bin/avr-g++ ...
Alternatives for Arduboy2.h: [Arduboy2@6.0.0]
ResolveLibrary(Arduboy2.h)
  -> candidates: [Arduboy2@6.0.0]
...
Using library Arduboy2 at version 6.0.0 in folder: /Users/dokwork/Projects/Arduino/libraries/Arduboy2 
Using library EEPROM at version 2.0 in folder: /Users/dokwork/Library/Arduino15/packages/arduino/hardware/avr/1.8.6/libraries/EEPROM 
...
```

Here we can find follow paths:

```make
ARDUINO_DIR=/Users/dokwork/Library/Arduino15/packages/arduino
AVR_DIR=$(ARDUINO_DIR)/tools/avr-gcc/7.3.0-atmel3.6.1-arduino7/bin
ARDUINO_HARDWARE_DIR=/Users/dokwork/Library/Arduino15/packages/arduino/hardware/avr/1.8.6
LIBS_DIR=/Users/dokwork/Projects/Arduino/libraries
```

## Install Ardens emulator

To install the ArdensPlayer you may take appropriate asset from the [releases page](https://github.com/tiberiusbrown/Ardens/releases),
or read [docs](https://github.com/tiberiusbrown/Ardens) to follow another way.

When the ArdensPlayer has been installed, set the path to the directory with its
binaries in the Makefile:

```sh
ARDENS=$(HOME)/Arduino/Ardens/ArdensPlayer
```

## Generate the compile_commands.json

This Makefile generates [command objects](https://clang.llvm.org/docs/JSONCompilationDatabase.html) 
when compiling files. But, it doesn't produce the `compile_commands.json` by
default. To generate that file run `make compile_commands.json` command. To make
the content of this file valid, we have to be sure that every file will be
compiled. This is why the target `compile_commands.json` depends on clean task.

Notice, that the `compile_commands.json` task is default.
