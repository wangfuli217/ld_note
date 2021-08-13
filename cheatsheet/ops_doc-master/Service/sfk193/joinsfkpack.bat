@echo off
sfk script %~f0 -from begin %*
rem %~f0 is the absolute batch file name
GOTO xend

// required input folders:
//   sfklib\zlib

sfk label begin -var

   +call providelib

   +setvar cnt=1

   +echo -spat "
      /*
         SFKPack V1.0.2, a frozen monolithic code containing

            zlib     1.2.11

         for easiest possible compilation. Created by
         joinsfkpack.bat using the Swiss File Knife tool.

         All source files were heavily modified to allow freezing
         them into a single source code, compilable in C++ mode.
         For input source files see sfklib.zip within sfk.zip.

         This library can be used free of charge in any project,
         based on the original library licenses, which are all 
         BSD compatible. This means you may use them also in
         closed source commercial applications, but without
         any warranty.

         If errors occur on file compression, do not ask the original
         authors of zlib as they have nothing to do with SFKPack. 
         Instead, download the original source codes 
         of those libraries, then compile your project with these,
         and see if it works. If so, you may be better off with the 
         original libraries. But if the error is produced just and
         only by SFKPack, and can be easily reproduced (by a sample 
         data file) you may also submit a bug report to the 
         Swiss File Knife project.
      */
      #ifdef _WIN32
       #include <windows.h>
       #include <direct.h>
      #else
       #include <sys/stat.h>
       #include <utime.h>
      #endif
      #include <stdlib.h>
      #include <stdio.h>
      #include <string.h>
      #include <setjmp.h>
      #include <math.h>
      #include <time.h>
      #include <errno.h>
      #define TBLS 8
      #define NO_DUMMY_DECL
      #ifdef _MSC_VER
       #ifndef _PTRDIFF_T_DEFINED
        #define _PTRDIFF_T_DEFINED
        typedef long ptrdiff_t;
       #endif
      #endif
      typedef unsigned int u4;
      #define DIST_CODE_LEN  512
      #define Z_BUFSIZE   (256*1024)
      #define UNZ_BUFSIZE (256*1024)
      #define NOCRYPT
      #ifdef _WIN32
      extern "C" {
         int _fseeki64(FILE *stream, __int64 offset, int origin);
         __int64 _ftelli64(FILE * _File);
      }
      #endif
      "
      +tofile sfkpack-tmp.c

   // #define BYFOUR - not 64 bit compatible

   +echo "
      sfklib\zlib\zconf.h
      sfklib\zlib\zlib.h
      sfklib\zlib\zutil.h
      sfklib\zlib\deflate.h
      sfklib\zlib\crc32.h
      sfklib\zlib\inftrees.h
      sfklib\zlib\inffixed.h
      sfklib\zlib\inffast.h
      sfklib\zlib\inflate.h
      sfklib\zlib\trees.h

      sfklib\zlib\deflate.c
      sfklib\zlib\adler32.c
      sfklib\zlib\compress.c
      sfklib\zlib\crc32.c      zlcrc32
      sfklib\zlib\infback.c
      sfklib\zlib\inffast.c
      sfklib\zlib\inflate.c    zlinflate
      sfklib\zlib\inftrees.c
      sfklib\zlib\trees.c      zltrees
      sfklib\zlib\zutil.c

      sfklib\zlib\contrib\minizip\ioapi.h      mzioapih
      sfklib\zlib\contrib\minizip\ioapi.c
      sfklib\zlib\contrib\minizip\zip.h        miniziph
      sfklib\zlib\contrib\minizip\zip.c        zipc
      sfklib\zlib\contrib\minizip\minizip.c    minizipc
      sfklib\zlib\contrib\minizip\unzip.h
      sfklib\zlib\contrib\minizip\miniunz.c    miniunzc
      sfklib\zlib\contrib\minizip\unzip.c      unzipc
      "

   +filter -no-empty-lines

   +perline -yes
      "call addfile sfkpack-tmp.c #text"

   +then list -size -time sfkpack-tmp.c

   +then call makecpp

   +then list -size -time sfkpack.cpp

   +end

sfk label addfile

   // outfile infile handle

   +echo "
      /* 
      :file %2 
      */
      "
      +tofile -append %1

   +xed %2
      "_/\*\*/__"
      "_/\*_\x10_" "_\*/_\x11_"

   // +xed
   //    "_\x10[1.10000 bytes not \x11]copyright[1.10000 bytes not \x10]\x11_[all]_"
   //    "_\x10[1.10000 bytes]\x11__"

   +xed
      "_\x10_/\*_" "_\x11_\*/_"

   +filter -no-empty-lines

   +xed -case
     "/const char deflate_/const char zldef01_/"
     "/const char inflate_/const char zlinf01_/"
     "/z_errmsg/z2_errmsg/"

   +tif "%3 <> " tcall "%3"

   +xed -case
      "_#*include *[eol]__"
      +tofile -append %1

   +then calc "#(cnt)+1" +setvar cnt

   +end

sfk label zlcrc32
   +xed -case
      "/DO1/DO1crc/"
      "/DO8/DO8crc/"
      "/define TBLS/define TBLS2/"

      // "/if (sizeof(void *) == sizeof(ptrdiff_t)) {
      //  /if (sizeof(void *) == sizeof(ZPOS64_T)) {/"

      // "/while (len && ((ptrdiff_t)buf & 3)) {
      //  /while (len && ((ZPOS64_T)buf & 3)) {/"

   +tend

sfk label zlinflate
   +xed -case
      "/fixedtables/fxtablesinf/"
      "/PULLBYTE/PULLBYTE2/"
      "/NEEDBITS/NEEDBITS2/"
   +tend

sfk label zltrees
   +xed -case
     "/[char not a-z0-9_]code[char not a-z0-9_]
      /[part1]foocode[part3]/"
   +tend

sfk label mzioapih
   +xed -case
      "/#if (_MSC_VER >= 1400) && (!(defined(NO_MSCVER_FILE64_FUNC)))*
       /#if 1/"
   +tend

sfk label miniziph
   +xed -case
      "/#define _zip12_H
       /#define _zip12_H\n
        #ifdef _WIN32\n
        void fill_win32_filefunc OF((zlib_filefunc_def* pzlib_filefunc_def));\n
        void fill_win32_filefunc64 OF((zlib_filefunc64_def* pzlib_filefunc_def));\n
        void fill_win32_filefunc64A OF((zlib_filefunc64_def* pzlib_filefunc_def));\n
        void fill_win32_filefunc64W OF((zlib_filefunc64_def* pzlib_filefunc_def));\n
        #endif\n
       /"
   +tend

sfk label zipc
   +xed -case
      "/crc32(zi->ci.crc32,buf,(uInt)len)
       /crc32(zi->ci.crc32,(const Bytef *)buf,(uInt)len)/"
      "/zi->ci.bstream.next_in = (void\*)buf;
       /zi->ci.bstream.next_in = (char *)buf;/"
   +tend

sfk label unzipc
   +xed -case
      "/pfile_in_zip_read_info->stream.next_in = (voidpf)0;
       /pfile_in_zip_read_info->stream.next_in = (Bytef *)0;/"
   +tend

sfk label minizipc
   +xed -case
      "/#define USEWIN32IOAPI
       /#define USEWIN32IOAPI_NOT/"
      "/crc32(calculate_crc,buf,size_read)
       /crc32(calculate_crc,(const Bytef *)buf,size_read)/"
      "/filetime(filenameinzip,
       /filetime((char*)filenameinzip,/"
      "/int main(argc,
       /#ifdef TESTZIP\nint main(argc,/"
      "/[end]/#endif\n/"
      "/#ifdef unix || __APPLE__/#if 1/"
   +tend

sfk label miniunzc
   +xed -case
      "/#define USEWIN32IOAPI
       /#define USEWIN32IOAPI_NOT/"
      "/WRITEBUFFERSIZE/WRITEBUFFERSIZE2/"
      "/do_banner/do_banner2/"
      "/do_help/do_help2/"
      "/int main(argc,
       /#ifdef TESTUNZIP\nint main(argc,/"
      "/[end]/#endif\n/"
      "/makedir(write_filename)
       /makedir((char*)write_filename)/"
      "/#ifdef unix || __APPLE__/#if 1/"
   +tend

sfk label makecpp

   +filter sfkpack-tmp.c -rtrim

   +xed

      "/int lcodes, dcodes, blcodes;
       /int lcodes;\nint dcodes;\nint blcodes;/"

   +xed -case

      "/this/that/"

   +xed

      "
       /[lstart]local[ortext]void[ortext]int *(*)[eol]
         [white]*;*[eol]
         {
       /[parts 2-3]
        ([part9]) {\n
       /
      "

      "
       /[lstart]local[ortext]void[ortext]int *(*)[eol]
         [white]*;*[eol]
         [white]*;*[eol]
         {
       /[parts 2-3]
        ([part9], [part14]) {\n
       /
      "

      "
       /[lstart]local[ortext]void[ortext]int *(*)[eol]
         [white]*;*[eol]
         [white]*;*[eol]
         [white]*;*[eol]
         {
       /[parts 2-3]
        ([part9], [part14], [part19]) {\n
       /
      "

      "
       /[lstart]local[ortext]void[ortext]int *(*)[eol]
         [white]*;*[eol]
         [white]*;*[eol]
         [white]*;*[eol]
         [white]*;*[eol]
         {
       /[parts 2-3]
        ([part9], [part14], [part19], [part24]) {\n
       /
      "

      "
       /[lstart]local[ortext]void[ortext]int *(*)[eol]
         [white]*;*[eol]
         [white]*;*[eol]
         [white]*;*[eol]
         [white]*;*[eol]
         [white]*;*[eol]
         {
       /[parts 2-3]
        ([part9], [part14], [part19], [part24], [part29]) {\n
       /
      "

      "
       /[lstart]local[ortext]void[ortext]int *(*)[eol]
         [white]*;*[eol]
         [white]*;*[eol]
         [white]*;*[eol]
         [white]*;*[eol]
         [white]*;*[eol]
         [white]*;*[eol]
         {
       /[parts 2-3]
        ([part9], [part14], [part19], [part24], [part29], [part34]) {\n
       /
      "

      "
       /[lstart]* zexport *(*)[eol]
         [white]*;[eol]
         {
       /[parts 2-4]
        ([part10]) {\n
       /
      "

      "
       /[lstart]* zexport *(*)[eol]
         [white]*;[eol]
         [white]*;[eol]
         {
       /[parts 2-4]
        ([part10], [part14]) {\n
       /
      "

      "
       /[lstart]* zexport *(*)[white][eol]
         [white]*;[eol]
         [white]*;[eol]
         [white]*;[eol]
         {
       /[parts 2-4]
        ([part11], [part15], [part19]) {\n
       /
      "

      "
       /[lstart]* zexport *(*)[eol]
         [white]*;[eol]
         [white]*;[eol]
         [white]*;[eol]
         [white]*;[eol]
         {
       /[parts 2-4]
        ([part10], [part14], [part18], [part22]) {\n
       /
      "
 
      "
       /[lstart]* zexport *(*)[eol]
         [white]*;[eol]
         [white]*;[eol]
         [white]*;[eol]
         [white]*;[eol]
         [white]*;[eol]
         {
       /[parts 2-4]
        ([part10], [part14], [part18], [part22], [part26]) {\n
       /
      "

      "
       /[lstart]* zexport *(**)[eol]
         [white]*;[eol]
         [white]*;[eol]
         [white]*;[eol]
         [white]*;[eol]
         [white]*;[eol]
         [white]*;[eol]
         [white]*;[eol]
         [white]*;[eol]
         {
       /[parts 2-4]
        ([part10], [part14], [part18], [part22], [part26],
         [part30], [part34], [part38]) {\n
       /
      "

      "/uLong filetime(f, tmzip, dt)**{
       /uLong filetime(char *f, tm_zip *tmzip, uLong *dt)\n{/"

   +xed 
      "_[eol][eol][eol][eol][eol]_[parts 1,2]_"
      "_[eol][eol][eol][eol]_[parts 1,2]_"
      "_[eol][eol][eol]_[parts 1,2]_"

      -tofile sfkpack.cpp

   +then filter sfkpackio.cpp
      +tofile -append sfkpack.cpp

   +end

sfk label providelib
   +ifexist sfklib begin
      +if "rc=2"
         stop 0
      +stop 9
         "invalid sfklib folder"
      +endif
   +tell "Missing sfklib folder."
   +prompt "[yellow]Press ENTER to extract sfklib.zip, or CTRL+C to stop."
   +unzip -yes sfklib.zip
   +end

:xend
