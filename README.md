# SAPI - Free Pascal interface to Microsoft SAPI

[![FreePascal](https://img.shields.io/badge/FreePascal-3.2.2-blue?logo=lazarus)](https://www.freepascal.org/)
[![Github: VioletBitKitten - SAPI](https://img.shields.io/github/license/VioletBitKitten/SAPI)](https://github.com/VioletBitKitten/SAPI/blob/main/LICENSE)
[![Github: VioletBitKitten - SAPI](https://img.shields.io/github/last-commit/VioletBitKitten/SAPI/main)](https://github.com/VioletBitKitten/SAPI/commits/main)
[![Github: VioletBitKitten - SAPI](https://img.shields.io/github/issues/VioletBitKitten/SAPI)](https://github.com/VioletBitKitten/SAPI/issues)
[![Github: VioletBitKitten - SAPI](https://img.shields.io/github/stars/VioletBitKitten/SAPI)](https://github.com/VioletBitKitten/SAPI)
[![Discord](https://img.shields.io/discord/1144984263347929098?label=Discord)](https://discord.gg/4ZQuQFEYht)

[![Twitter: VioletBitKitten](https://img.shields.io/twitter/follow/violetbitkitten?style=social)](https://twitter.com/violetbitkitten)

## WARNING

This software is in development. The software is not complete and there is little documentation. Use with caution!

## Introduction

This package contains a library for interfacing Free Pascal with Microsoft SAPI.

This software was written to make it easier to use Text To Speech as a VTuber. The ability to write spoken text to an text file is to allow the text to show up in OBS. The option to change the output device makes it easy to use a virtual patch cable to route the audio to the VTuber software.

## Building

To build this project use the script `build.bat`.

For help in the build scripts run the command `build.bat help`.

To Manually build this project:

* Run the command `fpcmake` to create the file `Makefile`.
* Run the command `make` to build the project.

## Contents

Contents of this package:

* sapi.pas - The SAPI library.
* mmdeviceapi.pas - Interface to the MM Device API. This is only used to get the default Audio Output Device.
* doc/sapi.mc - Documentation for the SAPI library.
* tts.pas - TTS program that uses the SAPI library.
* ttsdemo.pas - Demo for using the SAPI library.
* LICENSE - MIT License.
* build.bat, build.sh - Build scripts for Windows and Unix-like systems.
* Makefile.fpc - FreePascal fpcmake file.

## Using the SAPI library in your own project

Copy the files `sapi.pas` and `mmdeviceapi.pas` to where your source files live. Use the unit `sapi` in your source file.

If you do not want to include `mmdeviceapi.pas` then add `-dSAPI_NO_AUDIO_DEFAULT` to the compiler directives. For example add the following to `Makefile.fpc``:

```text
[compiler]
options=-dSAPI_NO_AUDIO_DEFAULT
```

## TODO

* Create Unit tests. - In Progress.
* Implement an interface for making use of the Status property.

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
