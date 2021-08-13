@echo off
..\sfk script %~f0 -from begin %*
rem %~f0 is the absolute batch file name
GOTO xend

sfk label begin -var
   +cd ..
   +rmtree tmp-selftest-win -yes -quiet=2
   +mkdir  tmp-selftest-win
   +mkdir  tmp-selftest-win\ftp
   +mkdir  tmp-selftest-win\web
   +mkdir  tmp-selftest-win\foo
   +mkdir  tmp-selftest-win\foo3
   +cd     tmp-selftest-win
   +echo . +tofile ftp\this-is-tmp-ftp.txt
   +echo . +tofile web\this-is-tmp-web.txt
   +cd     ftp
   +run "start ..\..\sfk sftserv -rw -verbose" -yes
   +sleep 500
   +cd ..
   +echo . +tofile test1.txt
   +echo . +tofile foo\test2.txt
   +echo . +tofile foo3\test4.txt
   +sft localhost put test1.txt
   +sft localhost put foo\test2.txt
   +sft localhost put foo..\test3.txt
   +sft localhost put foo3\test4.txt
   +sft -test localhost put x:\foo\test.txt
   +sft -test localhost put x:/foo\test.txt
   +sft -test localhost put x:/foo/test.txt
   +sft -test localhost put .
   +sft -test localhost put mydir\..\bar.txt
   +sft -test localhost put mydir/..\bar.txt
   +sft -test localhost put mydir/..
   +sft -test localhost put mydir\..
   +sft -test localhost put ..
   +sft -test localhost put ..\
   +end

:xend
