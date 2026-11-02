@echo off
REM Native Windows PDF+MIDI+FLAC+MP3. Pass --soundfont "C:\path\file.sf3".
py -3 "%~dp0scripts\build.py" build --audio %*
