@echo off
set TEXE=..\sfk.exe
IF "%2"=="" GOTO xdef01
set TEXE=%2
:xdef01
IF NOT EXIST %TEXE% GOTO xerr03
%TEXE% test workdir scripts >nul 2>&1
IF "%1"=="" GOTO xerr01
IF ERRORLEVEL 1 GOTO xerr02

cd ..
IF EXIST tmp-selftest-win rmdir /S /Q tmp-selftest-win
md tmp-selftest-win
cd tmp-selftest-win
%TEXE% copy ..\testfiles testfiles -yes >nul
%TEXE% copy ..\scripts\50-patch-all-win.cpp 50-patch-all-src.cpp -yes >nul

set TCMD=%1 ..\scripts\10-sfk-selftest-db.txt

set TEXE2=%TEXE%
set TEXE=%TEXE2% -memcheck
call ..\scripts\11-sub-test-win.bat
set TEXE=%TEXE2%
%TEXE% syntest

cd ..\scripts
GOTO done

:xerr01
echo supply cmp to run a regression test   (compare).
echo supply upd to add new test case datas (update).
echo supply rec to overwrite all test output signatures.
GOTO done

:xerr02
echo run this batch from the scripts directory please.
GOTO done

:xerr03
echo missing binary: %TEXE%
GOTO done

:done
