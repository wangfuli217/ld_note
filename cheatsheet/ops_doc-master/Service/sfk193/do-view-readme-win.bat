@echo off
sfk pathfind -quiet dview.exe
IF %ERRORLEVEL%==0 GOTO havedview
sfk pathfind -quiet notepad
IF %ERRORLEVEL%==0 GOTO havenotepad
echo Neither dview.exe nor notepad.exe found.
echo You may try to download Depeche View:
echo sfk wget http://stahlworks.com/dview.exe
GOTO done

:havenotepad
notepad readme.txt
GOTO done

:havedview
start dview readme.txt
GOTO done

:done
