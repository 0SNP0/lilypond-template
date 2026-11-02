@echo off
REM Native Windows PDF+MIDI+21 MP3 stems+orchestra MP3. Pass --soundfont "C:\path\file.sf3".
py -3 "%~dp0scripts\build.py" build --audio %*
