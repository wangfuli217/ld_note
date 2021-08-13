@echo off
rem XMake 0.5 - Cross network make of projects.
rem Client script for the Windows command line.
rem 
rem Sync sources, compile remote, receive error output,
rem forward compiled binaries to target device.
rem requires:
rem   sfk.exe on your Windows PC, download from
rem     stahlworks.com/sfk.exe
rem   xmakeserv.sh running on build server (which runs sfk)
rem example call:
rem   xmake.bat mp9 i686 200 clean
rem   meaning: compile product mp9 for architecture i686
rem            and target ip .200 from scratch (clean)

rem === short parameters ===
set PRODUCT=%1
set TOOLCHAIN=%2
set TARGET=%3
set CLEAN=%4

IF NOT "%TOOLCHAIN%"=="" GOTO haveparms

echo "usage  : xmake product architecture targetip [clean]"
echo "example: xmake mp8 bbb 192.168.1.100"
echo "         xmake mp9 a13 192.168.1.200 clean"
GOTO end

:haveparms

rem === dataway defaults ===
rem = all source code is edited in: LOCAL_WORK
rem = xmakeserv.sh runs on machine: BUILD_SERVER
rem = file transfer uses password : TRANSFER_PW
rem = your Windows PC running DView is  : LOG_TARGET
rem = the target devices are in a subnet: TARGET_NET

set LOCAL_WORKDRIVE=c:
set LOCAL_WORKDIR=c:\work
set BUILD_SERVER=192.168.1.101:2201
set TRANSFER_PW=mycmdpw123
set LOG_TARGET=192.168.1.100
set TARGET_NET=192.168.1

rem === internal inits ===
rem = this batch file logs to DView by network text
rem = (enable Setup / General / Network text).
rem = file sync should be non verbose.
rem = redirect output of some commands using TONETLOG.
rem = sfk uses ftp password from SFK_FTP_PW.

set SFK_LOGTO=term,net:%LOG_TARGET%
set FTPOPT=-nohead -quiet -noprog
set TONETLOG=sfk filt "-! files of*sent" -lshigh cyan "<*" +tonetlog
set SFK_FTP_PW=%TRANSFER_PW%

rem === auto extend short parms to full parms ===
rem = extend product "mp9" to "m9player".
rem = extend target "200" to "192.168.1.200".

IF "%PRODUCT%"=="mp8" (set PRODUCT=m8player)
IF "%PRODUCT%"=="mp9" (set PRODUCT=m9player)

sfk -quiet strlen "%TARGET%"
IF %ERRORLEVEL% LEQ 3 (set TARGET=%TARGET_NET%.%TARGET%)

rem === show a hello in the network text (SFK_LOGTO) ===

sfk echo "[green]=== xmake: %PRODUCT% %TOOLCHAIN% %CLEAN% for %TARGET% ===[def]" +tolog

rem change parameter "clean" to "0" or "1"
IF "%CLEAN%"=="clean" ( SET CLEAN="1" ) ELSE ( SET CLEAN="0" )

rem === go into local workspace containing project folders ===

%LOCAL_WORKDRIVE%
cd %LOCAL_WORKDIR%

rem === 1. sync changed files to build server ===

rem send compile script. enforce unix line endings before upload:
sfk -quiet=2 remcr xmakerem.sh
sfk select xmakerem.sh +sft %FTPOPT% %BUILD_SERVER% cput -yes | %TONETLOG%

rem send changed sources.
sfk select -dir %PRODUCT% -file !.bak !.tmp +sft %FTPOPT% %BUILD_SERVER% cput -yes | %TONETLOG%

rem === 2. run build on server ===

del xmakerem.log
sfk sft %FTPOPT% %BUILD_SERVER% run "bash xmakerem.sh %PRODUCT% %TOOLCHAIN% %TARGET% %CLEAN% %LOG_TARGET% >xmakerem.log 2>&1" -yes | %TONETLOG%

rem get terminal output
sfk sft %FTPOPT% %BUILD_SERVER% get xmakerem.log
type xmakerem.log

rem === 3. confirm completion ===

sfk echo "[green]=== xmake done. ===[def]" +tolog

rem === uncomment this to keep script window open ===
rem sfk echo "[Magenta]=== waiting for user to close script window. ===[def]" +tolog +then pause

:end
