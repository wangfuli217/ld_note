@echo off
sfk script 02-conv-win-to-ux.bat -from begin >12-sub-test-ux.bat
type 15-sfk-selftest-ux-fix.txt >>12-sub-test-ux.bat
copy 13-sfk-selftest-ux-pre.bat 03-sfk-selftest-ux.bat >nul
sfk remcrlf 03-sfk-selftest-ux.bat >nul
sfk patch -nopid -qs 14-sfk-selftest-ux-fix.txt
sfk remcrlf 12-sub-test-ux.bat >nul
echo created: 03-sfk-selftest-ux.bat
echo created: 12-sub-test-ux.bat
echo "now transfer and run 03-sfk-selftest-ux.bat"
GOTO xend2

sfk label begin

   +filter 11-sub-test-win.bat

      -!20-tab-data -!T11.1
      -!34-csv-data -!T27.1

      -rep "_$_#_" 
      -rep _\_/_ 
      -rep _/n_\\n_  -rep _\\nested_/nested_
      -rep _/\*_\\*_ 
      -rep _/\?_\\?_ 
      -rep _/x3f_\\x3f_ 
      -rep /%TCMD%/$TCMD/ 
      -rep /%TEXE%/$TEXE/ 
      -rep /!/:/ 
      -rep "x>nulx>/dev/nullx" 
      -rep "_$TEXE_$TEXE -nocol_"
      
   +filter -literal
      
      -where "sel -dir" -rep _*_%_
      -where "filefind" -rep _*_%_

   +end

:xend2

