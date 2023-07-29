# SAPI - Free Pascal interface to Microsoft SAPI

## WARNING

This software is in development. The software is not complete and there is no documentation yet. Use with caution!

## Introduction

This package contains a library for interfacing Free Pascal with Microsoft SAPI.

This software was written to make it easier to use Text To Speech as a VTuber. The ability to write spoken text to an text file is to allow the text to show up in OBS. The option to change the output device makes it easy to use a virtual patch cable to route the audio to the VTuber software.

## Building

To build this project use the script `build.bat` or `build.sh`.

For help in the build scripts run the command `build.bat help` or `./build.sh help`.

To Manually build this project:

* Run the command `fpcmake` to create the file `Makefile`.
* Run the command `make` to build the project.

## Contents

Contents of this package:

* sapi.pas - The SAPI library.
* doc/sapi.mc - Documentation for the SAPI library.
* tts.pas - TTS program that uses the SAPI library.
* ttsdemo.pas - Demo for using the SAPI library.
* LICENSE - MIT License.
* build.bat, build.sh - Build scripts for Windows and Unix-like systems.
* Makefile.fpc - FreePascal fpcmake file.

## TODO

* Create Unit tests.
* Implement an interface for making use of the Status property.
* Partial string matching on Voice and Audio Output Device. The names can be long and complicated.
* Expand the tts program to be more useful as a VTuber.
  Perhaps move this to a new project?

## References

* Microsoft SAPI Documentation on the SpVoice interface.\
  <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/ee125640(v=vs.85)>

* Microsoft SAPI Documentation on the SpFileStream  interface.\
  <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/ee125548(v=vs.85)>

* Python SAPI interface.\
  <https://github.com/DeepHorizons/tts/blob/master/tts/sapi.py>

* Lazarus Forum topic for preventing the SpVoice.Speak method from causing an exception.\
  <https://forum.lazarus.freepascal.org/index.php/topic,17852.0>

* Free Pascal Wiki page on SAPI.\
  <https://wiki.freepascal.org/SAPI>

## Copyright and License

Copyright (c) 2023 Violet Bit Kitten

Distributed under the MIT license. Please see the file LICENSE.
