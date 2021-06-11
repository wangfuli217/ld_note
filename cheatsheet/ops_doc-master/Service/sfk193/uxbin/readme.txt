About the sfk binaries for linux:

-  please rename to 'sfk' before use like
   mv sfk-linux.exe sfk
   
-  make them exectuable like
   chmod +x sfk

-  start reading the help by
   ./sfk

-  if you copy this to your home directory,
   alias sfk='/home/youraccount/sfk'
   might be of use.

-  note that the linux syntax is different to the windows syntax,
   due to bash limitations. run sfk under linux without any
   parameters to get the full linux syntax overview.

sfk-linux.exe:
   the default 32 bits x86 binary, for current systems, e.g. Ubuntu.
   compiled with gcc 4.1, uses libstdc++.so.6.

sfk-linux-lib5.exe:
   the compatibility 32 bits x86 binary, for older systems, e.g. DSL/Knoppix.
   compiled with gcc 3.3, uses libstdc++.so.5.

sfk-linux64.exe:
   the 64 bits x86 binary for current desktop linux systems.

sfk-arm.exe:
   for all ARM systems like Raspberry Pi.

