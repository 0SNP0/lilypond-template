@echo off
REM Native Windows PDF+MIDI build. Requires Python 3 and LilyPond in PATH.
py -3 "%~dp0scripts\build.py" build %*
