$TEXE -nocol copy -quiet=2 -yes testfiles testfiles2 >/dev/null

$TEXE -nocol copy -quiet=2 -yes testfiles/Formats/01-native-tab-crlf.txt 01-native-tab-crlf-cmp1.txt
$TEXE -nocol detab=3 -yes testfiles/Formats/01-native-tab-crlf.txt >/dev/null
$TEXE -nocol test $TCMD T01.1.detab testfiles/Formats/01-native-tab-crlf.txt

$TEXE -nocol scantab testfiles/Formats >res-01.txt
$TEXE -nocol test $TCMD T01.2.scantab res-01.txt

$TEXE -nocol remcrlf testfiles/Formats/02-crlf.txt >/dev/null
$TEXE -nocol test $TCMD T01.3.remcrlf testfiles/Formats/02-crlf.txt

$TEXE -nocol addcrlf testfiles/Formats/04-lf.txt >/dev/null
$TEXE -nocol test $TCMD T01.4.addcrlf testfiles/Formats/04-lf.txt

$TEXE -nocol text-join-lines -quiet testfiles/Formats/05-split-text.txt res-02.txt
$TEXE -nocol test $TCMD T01.5.joinlines res-02.txt

$TEXE -nocol stat -nosum testfiles/FooBank >res-03.txt
$TEXE -nocol test $TCMD T02.1.stat res-03.txt

$TEXE -nocol list testfiles/FooBank >res-04.txt
$TEXE -nocol test $TCMD T02.2.list res-04.txt

$TEXE -nocol grep -text -pat include -dir testfiles >res-05.txt
$TEXE -nocol test $TCMD T02.3.grep res-05.txt

$TEXE -nocol grep -pat include -dir testfiles -file .cpp .hpp >res-06.txt
$TEXE -nocol test $TCMD T02.4.grep res-06.txt

$TEXE -nocol bin-to-src -pack testfiles/Formats/06-binary.jpg res-07.txt mydat
$TEXE -nocol test $TCMD T02.5.bin2src res-07.txt

$TEXE -nocol filter <testfiles/Formats/07-filter-src.txt -+something -:delete >res-08.txt
$TEXE -nocol test $TCMD T02.6.filter res-08.txt

$TEXE -nocol filter testfiles/Formats/07-filter-src.txt ++delete ++something >res-09.txt
$TEXE -nocol test $TCMD T02.7.filter res-09.txt

$TEXE -nocol addhead -blank <testfiles/Formats/08-head-tail.txt >res-10.txt test1 test2 test3
$TEXE -nocol test $TCMD T02.8.addhead res-10.txt

$TEXE -nocol addtail -noblank <testfiles/Formats/08-head-tail.txt >res-11.txt test1 test2 test3
$TEXE -nocol test $TCMD T02.9.addtail res-11.txt

$TEXE -nocol deblank -yes -quiet testfiles/Formats
$TEXE -nocol list testfiles :umlauts >res-13.txt
$TEXE -nocol test $TCMD T02.11.deblank res-13.txt

$TEXE -nocol snapto=all-src.cpp -nometa -dir testfiles :testfiles/Formats -file .hpp .cpp >/dev/null
$TEXE -nocol test $TCMD T03.1.snapto all-src.cpp

$TEXE -nocol copy -quiet=2 -yes all-src.cpp detab2-step1.txt
$TEXE -nocol copy -quiet=2 -yes all-src.cpp detab2-step2.txt
$TEXE -nocol entab=4 -yes detab2-step2.txt >/dev/null
$TEXE -nocol copy -quiet=2 -yes detab2-step2.txt detab2-step3.txt
$TEXE -nocol detab=4 -yes detab2-step3.txt >/dev/null
$TEXE -nocol md5 detab2-step1.txt detab2-step3.txt >res-detab2.txt
$TEXE -nocol filter -write -yes res-detab2.txt -+content >/dev/null
$TEXE -nocol test $TCMD T03.5.detab2 res-detab2.txt

$TEXE -nocol snapto=all-src-2.cpp -pure -dir testfiles :testfiles/Formats :testfiles/BaseLib -file .hpp .txt -norec >/dev/null
$TEXE -nocol test $TCMD T03.2.snapto all-src-2.cpp

$TEXE -nocol snapto=all-src-3.cpp -nometa -wrap=80 -prefix=#file# -stat -dir testfiles :testfiles/Formats :testfiles/BaseLib -file .hpp .cpp .txt >/dev/null
$TEXE -nocol test $TCMD T03.3.snapto all-src-3.cpp

$TEXE -nocol filter testfiles/Formats/10-dir-list.txt >res-14.txt -rep _/_/_ -rep xC:xx
$TEXE -nocol test $TCMD T05.1.filtrep res-14.txt

$TEXE -nocol filter testfiles/Formats/12-foo-jam.txt -ls+class -+void >res-15.txt
$TEXE -nocol filter testfiles/Formats/12-foo-jam.txt +ls+class -+void >>res-15.txt
$TEXE -nocol filter testfiles/Formats/12-foo-jam.txt ++class ++bar    >>res-15.txt
$TEXE -nocol filter -case -lnum testfiles/Formats/12-foo-jam.txt -+bottle -+Trace >>res-15.txt
$TEXE -nocol test $TCMD T05.2.filter res-15.txt

$TEXE -nocol reflist -quiet -case -dir testfiles -file .cpp -dir testfiles -file .hpp >res-20-pre.txt
$TEXE -nocol filter res-20-pre.txt >res-20.txt "-:00002 testfiles"
$TEXE -nocol test $TCMD T06.1.reflist res-20.txt

$TEXE -nocol remcrlf ../scripts/50-patch-all-ux.cpp >/dev/null
$TEXE -nocol patch -qs ../scripts/50-patch-all-ux.cpp >/dev/null
$TEXE -nocol test $TCMD T07.1.patch all-src.cpp

$TEXE -nocol snapto=all-src-4.cpp -nometa testfiles/Formats 11-wide-line.txt 13-eof-null.txt 14-all-codes.txt >/dev/null
$TEXE -nocol test $TCMD T08.1.snapform all-src-4.cpp

$TEXE -nocol find -text testfiles/Formats scope01 quarter03 lead05 >res-21.txt
$TEXE -nocol test $TCMD T09.1.findwrap res-21.txt

$TEXE -nocol find -text testfiles/Formats the wrap >res-22.txt
$TEXE -nocol test $TCMD T09.2.findwrap res-22.txt


$TEXE -nocol -spat filter -bin testfiles/Formats/14-all-codes.txt -nocasemin -rep "_\x01_Char01 replaced_" -rep "_\xFF_CharFF replaced_" >res-25.txt
$TEXE -nocol -spat filter -bin testfiles/Formats/14-all-codes.txt -sep "\x20" -form "#col6" >>res-25.txt
$TEXE -nocol test $TCMD T12.1.replacex res-25.txt

$TEXE -nocol split -quiet 2000b testfiles/Formats/18-ziptest.zip >res-26.txt
$TEXE -nocol join testfiles/Formats/18-ziptest.zip.part1 testfiles/Formats/18-ziptest2.zip >>res-26.txt
$TEXE -nocol test $TCMD T13.1.split res-26.txt

$TEXE -nocol hexdump testfiles/Formats/06-binary.jpg >res-27.txt
$TEXE -nocol hexdump -wide testfiles/Formats/06-binary.jpg >>res-27.txt
$TEXE -nocol hexdump -pure testfiles/Formats/06-binary.jpg >>res-27.txt
$TEXE -nocol hexdump -hexsrc testfiles/Formats/06-binary.jpg >>res-27.txt
$TEXE -nocol hexdump -decsrc testfiles/Formats/06-binary.jpg >>res-27.txt
$TEXE -nocol test $TCMD T14.1.hexdump res-27.txt

$TEXE -nocol runloop 1 50 "echo test number #i" -nohead >res-28.txt
$TEXE -nocol runloop 1 50 "echo test number #05i" -nohead >>res-28.txt
$TEXE -nocol test $TCMD T15.1.runloop res-28.txt

$TEXE -nocol copy -quiet=2 testfiles/Formats/18-ziptest.zip testfiles/Formats/50-ziptest.zip -yes
$TEXE -nocol replace -case testfiles/Formats/50-ziptest.zip -quiet -yes -bylist testfiles/Formats/21-patch-bin.txt >/dev/null
$TEXE -nocol md5 testfiles/Formats/18-ziptest.zip testfiles/Formats/50-ziptest.zip >>res-50.txt
$TEXE -nocol test $TCMD T16.1.replace res-50.txt

$TEXE -nocol md5gento=tmp-51.txt testfiles/FooBank >/dev/null
$TEXE -nocol md5gento tmp-52.txt testfiles/FooBank >/dev/null
$TEXE -nocol md5check=tmp-51.txt -quiet >res-51.txt
$TEXE -nocol md5check tmp-52.txt -skip 2 -quiet >res-52.txt
$TEXE -nocol filter res-51.txt -sep " " -form "#col1" >res-51-2.txt
$TEXE -nocol filter res-52.txt -sep " " -form "#col1" >res-52-2.txt
$TEXE -nocol test $TCMD T16.2.md5gen res-51-2.txt
$TEXE -nocol test $TCMD T16.3.md5gen res-52-2.txt

$TEXE -nocol crcgento=tmp-51.txt testfiles/FooBank >/dev/null
$TEXE -nocol crcgento tmp-52.txt testfiles/FooBank >/dev/null
$TEXE -nocol crccheck=tmp-51.txt -quiet >res-53.txt
$TEXE -nocol crccheck tmp-52.txt -skip 2 -quiet >res-54.txt
$TEXE -nocol filter res-53.txt -sep " " -form "#col1" >res-53-2.txt
$TEXE -nocol filter res-54.txt -sep " " -form "#col1" >res-54-2.txt
$TEXE -nocol test $TCMD T16.4.crcgen res-53-2.txt
$TEXE -nocol test $TCMD T16.5.crcgen res-54-2.txt

$TEXE -nocol echo "mid include quick fox" >res-60-1.txt
$TEXE -nocol filt testfiles/Formats/23-filt-patterns.txt "-+quick*fox" >>res-60-1.txt

$TEXE -nocol echo -spat "\\nmid exclude time" >>res-60-1.txt
$TEXE -nocol filt testfiles/Formats/23-filt-patterns.txt "-: ??:??:?? " >>res-60-1.txt

$TEXE -nocol echo -spat "\\nlstart include warn" >>res-60-1.txt
$TEXE -nocol filt testfiles/Formats/23-filt-patterns.txt "-ls+warn:" >>res-60-1.txt

$TEXE -nocol echo -spat "\\nlstart exclude test" >>res-60-1.txt
$TEXE -nocol filt testfiles/Formats/23-filt-patterns.txt "-ls:test:" >>res-60-1.txt

$TEXE -nocol echo -spat "\\nlend include marks" >>res-60-1.txt
$TEXE -nocol filt testfiles/Formats/23-filt-patterns.txt "-le+marks?" >>res-60-1.txt

$TEXE -nocol echo -spat "\\nlend exclude modx" >>res-60-1.txt
$TEXE -nocol filt testfiles/Formats/23-filt-patterns.txt "-le:[modx]" >>res-60-1.txt

$TEXE -nocol echo -spat "\\nfilter stars and quests" >>res-60-1.txt
$TEXE -nocol filt testfiles/Formats/23-filt-patterns.txt -spat "-+one \* two" "-+\?" >>res-60-1.txt

$TEXE -nocol echo -spat "\\nfilter slashx 3f quest anywhere" >>res-60-1.txt
$TEXE -nocol filt testfiles/Formats/23-filt-patterns.txt -spat "-+\\x3f" >>res-60-1.txt

$TEXE -nocol echo -spat "\\nfilter slashx 3f at line end" >>res-60-1.txt
$TEXE -nocol filt testfiles/Formats/23-filt-patterns.txt -spat "-le+\\x3f" >>res-60-1.txt

$TEXE -nocol echo -spat "\\nfilter literal star lstart" >>res-60-1.txt
$TEXE -nocol filt testfiles/Formats/23-filt-patterns.txt -lit "-ls+*" >>res-60-1.txt

$TEXE -nocol echo -spat "\\nfilter literal star lend" >>res-60-1.txt
$TEXE -nocol filt testfiles/Formats/23-filt-patterns.txt -lit "-le+*" >>res-60-1.txt

$TEXE -nocol echo -spat "\\nfilter literal quest lstart" >>res-60-1.txt
$TEXE -nocol filt testfiles/Formats/23-filt-patterns.txt -lit "-ls+?" >>res-60-1.txt

$TEXE -nocol echo -spat "\\nfilter literal quest lend" >>res-60-1.txt
$TEXE -nocol filt testfiles/Formats/23-filt-patterns.txt -lit "-le+?" >>res-60-1.txt

$TEXE -nocol echo -spat "\\nreplace literal star by literstar and filter" >>res-60-1.txt
$TEXE -nocol filt testfiles/Formats/23-filt-patterns.txt -lit -rep "_*_literstar_" +filt -+literstar >>res-60-1.txt

$TEXE -nocol test $TCMD T20.1.filtpat res-60-1.txt

$TEXE -nocol mkdir testfiles/DupTest
$TEXE -nocol echo "test content 01 for duptest" >testfiles/DupTest/SingleFile.txt
$TEXE -nocol echo "test content 02 for duptest" >testfiles/DupTest/TwoFiles01.txt
$TEXE -nocol echo "test content 02 for duptest" >testfiles/DupTest/TwoFiles02.txt
$TEXE -nocol echo "test content 03 for duptest" >testfiles/DupTest/FiveFiles01.txt
$TEXE -nocol echo "test content 03 for duptest" >testfiles/DupTest/FiveFiles02.txt
$TEXE -nocol echo "test content 03 for duptest" >testfiles/DupTest/FiveFiles03.txt
$TEXE -nocol echo "test content 03 for duptest" >testfiles/DupTest/FiveFiles04.txt
$TEXE -nocol echo "test content 03 for duptest" >testfiles/DupTest/FiveFiles05.txt
$TEXE -nocol dupfind testfiles/DupTest >res-61-1.txt
$TEXE -nocol filter res-61-1.txt -rep "_   __" -write -yes >/dev/null
$TEXE -nocol test $TCMD T21.1.dupfind res-61-1.txt

$TEXE -nocol list -sort testfiles2 +filter -+foo -+form -:umlauts -count >res-70-1.txt
$TEXE -nocol test $TCMD T22.1.sortname res-70-1.txt
$TEXE -nocol list -big=20 testfiles2 :pack-tape3 +filter -+foo -+form -count >res-70-2.txt
$TEXE -nocol test $TCMD T22.2.sortsize res-70-2.txt

$TEXE -nocol copy testfiles2 testfiles3 -dir . :duptest -quiet -yes >/dev/null
$TEXE -nocol copy testfiles3 testfiles4 -dir . :duptest -quiet -yes >/dev/null
$TEXE -nocol sel testfiles4 .cpp +ffilter -rep _bar_Test_ -write -quiet -yes >res-71-2.txt
$TEXE -nocol sel testfiles3 .hpp +del -quiet -yes >/dev/null
$TEXE -nocol list -sincedir testfiles3 testfiles4 +run "$TEXE -nocol echo ref:#qsince file:#qfile" -quiet -yes >>res-71-2.txt
$TEXE -nocol test $TCMD T23.2.sincedir res-71-2.txt

$TEXE -nocol rem "===== variable length replacement tests ====="

$TEXE -nocol mkdir testfiles5 >/dev/null

$TEXE -nocol copy -yes testfiles/Formats/18-ziptest.zip testfiles5/binfile.dat.part1 >/dev/null
$TEXE -nocol copy -yes testfiles/Formats/19-jartest.jar testfiles5/binfile.dat.part2 >/dev/null
$TEXE -nocol copy -yes testfiles/Formats/14-all-codes.txt testfiles5/binfile.dat.part3 >/dev/null
$TEXE -nocol join -force testfiles5/binfile.dat.part1 >/dev/null
$TEXE -nocol runloop 1 9 "$TEXE -nocol copy -yes testfiles/Formats/12-foo-jam.txt testfiles5/textfile.txt.part#i" -yes >/dev/null
$TEXE -nocol join -force testfiles5/textfile.txt.part1 >/dev/null
$TEXE -nocol copy -yes testfiles5/binfile.dat  testfiles5/binfile2.dat >/dev/null
$TEXE -nocol copy -yes testfiles5/textfile.txt testfiles5/textfile2.txt >/dev/null
$TEXE -nocol copy -yes testfiles5/textfile.txt testfiles5/textfile3.txt >/dev/null
$TEXE -nocol copy -yes testfiles5/textfile.txt testfiles5/textfile4.txt >/dev/null

$TEXE -nocol replace -case -yes testfiles5/binfile2.dat "/Formats/The quick brown fox/" "_char test code_unq987_" >/dev/null
$TEXE -nocol copy -yes     testfiles5/binfile2.dat testfiles5/binfile3.dat >/dev/null
$TEXE -nocol replace -case -yes testfiles5/binfile3.dat "/The quick brown fox/Formats/" "_unq987_char test code_" >/dev/null
$TEXE -nocol md5 testfiles5/binfile.dat testfiles5/binfile3.dat >res-72-1.txt
$TEXE -nocol test $TCMD T24.1.replace res-72-1.txt

$TEXE -nocol replace -case -yes testfiles5/textfile2.txt      "/class/The quick brown fox/"      "_to easily demonstrate sfk functionality__" >/dev/null
$TEXE -nocol filter -write testfiles5/textfile3.txt -rep "/class/The quick brown fox/" -rep "_to easily demonstrate sfk functionality__" -yes >/dev/null
$TEXE -nocol addcr testfiles5/textfile3.txt >/dev/null
$TEXE -nocol md5 testfiles5/textfile2.txt testfiles5/textfile3.txt >res-72-2.txt
$TEXE -nocol test $TCMD T24.2.replace res-72-2.txt

$TEXE -nocol echo "the quickest brown fox" >tmp1.txt
$TEXE -nocol copy -yes     testfiles/Formats/18-ziptest.zip tmp1.zip >/dev/null
$TEXE -nocol copy -yes     testfiles/Formats/18-ziptest.zip tmp2.zip >/dev/null
$TEXE -nocol partcopy tmp1.txt 4 8 tmp2.zip 0x00002260 -yes -quiet
$TEXE -nocol copy -yes     tmp2.zip tmp3.zip >/dev/null
$TEXE -nocol echo "the dir/tree brown fox" >tmp4.txt
$TEXE -nocol partcopy tmp4.txt 4 8 tmp3.zip 0x00002260 -yes -quiet
$TEXE -nocol md5 tmp1.zip tmp2.zip  >res-73-1.txt
$TEXE -nocol md5 tmp1.zip tmp3.zip >>res-73-1.txt
$TEXE -nocol test $TCMD T25.1.partcopy res-73-1.txt

$TEXE -nocol echo -spat "----- block1.1 begin -----\\nnormal echo [red]with color coding[def]" >res-79.txt
$TEXE -nocol echo "using full line mode, second line here," >>res-79.txt
$TEXE -nocol echo -spat "and the third line here.\\n----- block1.1 end -----" >>res-79.txt
$TEXE -nocol echo "[ ]" >>res-79.txt
$TEXE -nocol echo -spat "----- block1.2 begin -----\\nnormal echo [red]with color coding[def]" +tofile -append res-79.txt
$TEXE -nocol echo "again full line mode, now with tofile," +tofile -append res-79.txt
$TEXE -nocol echo -spat "and another separate line.\\n----- block1.2 end -----" +tofile -append res-79.txt
$TEXE -nocol echo "[ ]" >>res-79.txt
$TEXE -nocol echo -noline -spat "----- block2 begin -----\\nstream text echo [green]with color coding[def] " >>res-79.txt
$TEXE -nocol echo -noline "continuing the streamed paragraph, " >>res-79.txt
$TEXE -nocol echo -spat "end of sentence.\\n----- block2 end -----" >>res-79.txt
$TEXE -nocol echo "[ ]" >>res-79.txt
$TEXE -nocol echo -lit "----- block3.1 begin -----" >>res-79.txt
$TEXE -nocol echo -lit "literal echo [blue]without any color coding[def]" >>res-79.txt
$TEXE -nocol echo -lit -spat "... using full line mode with a blank line:\\n" >>res-79.txt
$TEXE -nocol echo -lit "... and another separate line." >>res-79.txt
$TEXE -nocol echo -lit "----- block3.1 end -----" >>res-79.txt
$TEXE -nocol echo "[ ]" >>res-79.txt
$TEXE -nocol echo -lit "----- block3.2 begin -----" +tofile -append res-79.txt
$TEXE -nocol echo -lit "again literal echo [blue]without any color coding[def]" +tofile -append res-79.txt
$TEXE -nocol echo -lit -spat "... and full line mode, but with tofile, empty line:\\n" +tofile -append res-79.txt
$TEXE -nocol echo -lit "... again another separate line." +tofile -append res-79.txt
$TEXE -nocol echo -lit "----- block3.2 end -----" +tofile -append res-79.txt
$TEXE -nocol echo "[ ]" >>res-79.txt
$TEXE -nocol echo -lit "----- block4 begin -----" >>res-79.txt
$TEXE -nocol echo -lit -noline "literal streamed echo [yellow]without any color coding[def] " >>res-79.txt
$TEXE -nocol echo -lit -noline "and the paragraph continues " >>res-79.txt
$TEXE -nocol echo -lit "until here." >>res-79.txt
$TEXE -nocol echo -lit "----- block4 end -----" >>res-79.txt
$TEXE -nocol addcr -quiet res-79.txt >/dev/null
$TEXE -nocol md5 -name res-79.txt >res-79-2.txt
$TEXE -nocol test $TCMD T26.1.echo res-79-2.txt

$TEXE -nocol echo -spat "[filter -cut  including markers: strip ads]\\n" +tofile res-80.txt
$TEXE -nocol filter testfiles/Formats/24-line-blocks.txt -cut  ad-begin to ad-end +tofile -append res-80.txt
$TEXE -nocol echo -spat "\\n[filter -cut- excluding markers: strip ads]\\n" +tofile -append res-80.txt
$TEXE -nocol filter testfiles/Formats/24-line-blocks.txt -cut- ad-begin to ad-end +tofile -append res-80.txt
$TEXE -nocol echo -spat "\\n[filter -cut- * to marker: isolate footer]\\n" +tofile -append res-80.txt
$TEXE -nocol filter testfiles/Formats/24-line-blocks.txt -cut- "*" to "=====" +tofile -append res-80.txt
$TEXE -nocol echo -spat "\\n[filter -cut marker to *: cut all from first ad]\\n" +tofile -append res-80.txt
$TEXE -nocol filter testfiles/Formats/24-line-blocks.txt -cut "ad-begin" to "*" +tofile -append res-80.txt
$TEXE -nocol echo -spat "\\n[filter -inc including markers: isolate ads]\\n" +tofile -append res-80.txt
$TEXE -nocol filter testfiles/Formats/24-line-blocks.txt -inc "ad-begin" to "ad-end" +tofile -append res-80.txt
$TEXE -nocol echo -spat "\\n[filter -inc excluding markers: isolate ads]\\n" +tofile -append res-80.txt
$TEXE -nocol filter testfiles/Formats/24-line-blocks.txt -inc- "ad-begin" to "ad-end" +tofile -append res-80.txt
$TEXE -nocol addcr -quiet res-80.txt >/dev/null
$TEXE -nocol md5 -name res-80.txt >res-81.txt
$TEXE -nocol test $TCMD T26.2.cutinc res-81.txt


cd testfiles
cd myproj
../../$TEXE -nocol sel -dir .              +tofile    ../../myproj.txt
../../$TEXE -nocol sel -dir . -sub :myscm    +tdifflines -quiet ../../myproj.txt >../../res-30-1.txt
../../$TEXE -nocol sel -dir . -sub :/.myscm  +tdifflines -quiet ../../myproj.txt >../../res-30-2.txt
../../$TEXE -nocol sel -dir . :.myscm/     +tdifflines -quiet ../../myproj.txt >../../res-30-3.txt
../../$TEXE -nocol sel -dir . :/.myscm/    +tdifflines -quiet ../../myproj.txt >../../res-30-4.txt
../../$TEXE -nocol sel -dir . :.myscm      +tdifflines -quiet ../../myproj.txt >../../res-30-5.txt
../../$TEXE -nocol sel -dir . :/gui/login/ +tdifflines -quiet ../../myproj.txt >../../res-30-6.txt

../../$TEXE -nocol sel -dir . -subdir %myscm +tdifflines -quiet ../../myproj.txt >../../res-31-1.txt
../../$TEXE -nocol sel -dir . %/.myscm     +tdifflines -quiet ../../myproj.txt >../../res-31-2.txt
../../$TEXE -nocol sel -dir . %.myscm/     +tdifflines -quiet ../../myproj.txt >../../res-31-3.txt
../../$TEXE -nocol sel -dir . %/.myscm/    +tdifflines -quiet ../../myproj.txt >../../res-31-4.txt
../../$TEXE -nocol sel -dir . %/gui/login/ +tdifflines -quiet ../../myproj.txt >../../res-31-5.txt
../../$TEXE -nocol sel -dir . %.myscm      +tdifflines -quiet ../../myproj.txt >../../res-31-6.txt

../../$TEXE -nocol sel -dir . -file :myscm      +tdifflines -quiet ../../myproj.txt >../../res-32-1.txt
../../$TEXE -nocol sel -dir . -file :/.myscm    +tdifflines -quiet ../../myproj.txt >../../res-32-2.txt
../../$TEXE -nocol sel -dir . -file :.myscm/    +tdifflines -quiet ../../myproj.txt >../../res-32-3.txt
../../$TEXE -nocol sel -dir . -file :/.myscm/   +tdifflines -quiet ../../myproj.txt >../../res-32-4.txt
../../$TEXE -nocol sel -dir . -file :.myscm     +tdifflines -quiet ../../myproj.txt >../../res-32-5.txt
../../$TEXE -nocol sel -dir . -file :/oth%scm/  +tdifflines -quiet ../../myproj.txt >../../res-32-6.txt

../../$TEXE -nocol sel -dir . -file myscm       +tdifflines -quiet ../../myproj.txt >../../res-33-1.txt
../../$TEXE -nocol sel -dir . -file /.myscm     +tdifflines -quiet ../../myproj.txt >../../res-33-2.txt
../../$TEXE -nocol sel -dir . -file .myscm/     +tdifflines -quiet ../../myproj.txt >../../res-33-3.txt
../../$TEXE -nocol sel -dir . -file /.myscm/    +tdifflines -quiet ../../myproj.txt >../../res-33-4.txt
../../$TEXE -nocol sel -dir . -file .myscm      +tdifflines -quiet ../../myproj.txt >../../res-33-5.txt
../../$TEXE -nocol sel -dir . -file /oth%scm/   +tdifflines -quiet ../../myproj.txt >../../res-33-6.txt

../../$TEXE -nocol filefind oth scm       >../../res-34-1.txt
../../$TEXE -nocol filefind oth%scm       >../../res-34-2.txt
../../$TEXE -nocol filefind .myscm        >../../res-34-3.txt
cd ..
cd ..

$TEXE -nocol test $TCMD T30.1.dex.any    res-30-1.txt
$TEXE -nocol test $TCMD T30.2.dex.start  res-30-2.txt
$TEXE -nocol test $TCMD T30.3.dex.end    res-30-3.txt
$TEXE -nocol test $TCMD T30.4.dex.exact  res-30-4.txt
$TEXE -nocol test $TCMD T30.5.dex.ext    res-30-5.txt
$TEXE -nocol test $TCMD T30.6.dex.combi  res-30-6.txt

$TEXE -nocol test $TCMD T31.1.din.any    res-31-1.txt
$TEXE -nocol test $TCMD T31.2.din.start  res-31-2.txt
$TEXE -nocol test $TCMD T31.3.din.end    res-31-3.txt
$TEXE -nocol test $TCMD T31.4.din.exact  res-31-4.txt
$TEXE -nocol test $TCMD T31.5.din.combi  res-31-5.txt
$TEXE -nocol test $TCMD T31.6.din.any2   res-31-6.txt

$TEXE -nocol test $TCMD T32.1.fex.any    res-32-1.txt
$TEXE -nocol test $TCMD T32.2.fex.start  res-32-2.txt
$TEXE -nocol test $TCMD T32.3.fex.end    res-32-3.txt
$TEXE -nocol test $TCMD T32.4.fex.exact  res-32-4.txt
$TEXE -nocol test $TCMD T32.5.fex.ext    res-32-5.txt
$TEXE -nocol test $TCMD T32.6.fex.combi  res-32-6.txt

$TEXE -nocol test $TCMD T33.1.fin.any    res-33-1.txt
$TEXE -nocol test $TCMD T33.2.fin.start  res-33-2.txt
$TEXE -nocol test $TCMD T33.3.fin.end    res-33-3.txt
$TEXE -nocol test $TCMD T33.4.fin.exact  res-33-4.txt
$TEXE -nocol test $TCMD T33.5.fin.combi  res-33-5.txt
$TEXE -nocol test $TCMD T33.6.fin.any2   res-33-6.txt

$TEXE -nocol test $TCMD T34.1.ff.and     res-34-1.txt
$TEXE -nocol test $TCMD T34.2.ff.mask    res-34-2.txt
$TEXE -nocol test $TCMD T34.3.ff.ext     res-34-3.txt

$TEXE -nocol filter testfiles/Formats/20-tab-data-line.txt -spat -rep "_\q__" -sep "\t" -form "\"#col1\";\"#col2\";\"#col3\";\"#col4\";\"#col5\"" >res-24.txt
$TEXE test $TCMD T11.1.tabform res-24.txt

$TEXE -nocol filter testfiles/Formats/34-csv-data-lines.txt -spat -rep "_\x01__" -within "\q*\q" -rep "_,_\x01_" -sep "," -form "#col5\t#col3\t#col1\t#col2\t#col4" -rep "_\x01_,_" >res-271.txt
$TEXE test $TCMD T27.1.csvdata res-271.txt
