About the SFK binary for Apple Macintosh:

-  outside of the .DMG container SFK binaries are also
   deployed with an .exe file extension, just because
   web servers need this extension to provide correct
   content types for safe download by web browsers.
   THESE BINARIES ARE NOT IN WINDOWS .EXE FILE FORMAT.
   Do not simply double click on any .exe file,
   as the Mac Finder cannot do anything useful with it.

-  before using, open a Terminal (within Applications/Tools).
   you must rename the binary to "sfk" and set the correct 
   execution mode, like:
   
      mv sfk-mac-i686.exe sfk
      chmod +x sfk

   then type ./sfk to start.

-  if you copy sfk to your home directory,
   alias sfk='/home/youraccount/sfk'
   might be of use.

-  note that the mac syntax is different to the windows syntax,
   due to bash limitations. run sfk under mac without any
   parameters to get the full syntax overview (wherever "linux"
   is mentioned, it also means "mac").
