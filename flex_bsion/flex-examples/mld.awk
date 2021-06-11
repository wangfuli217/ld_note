#!/usr/bin/gawk -f
{
  for(i=1;i<=NF;i++)
    new = new $i "[ \\t\\n]+"
  system("rm mgrep.l");
  print "%{" > "mgrep.l"
  print "int yylineno;" >> "mgrep.l"
  print "%}" >> "mgrep.l"
  print "%%" >> "mgrep.l"
  print "\\n {yylineno++;}" >> "mgrep.l"
  print new,"{printf(\"%d\\n\",yylineno); exit(yylineno);}" >> "mgrep.l"
  print ". " >> "mgrep.l"
  print "%%" >> "mgrep.l"
  print "#include \"lex.main.c\"" >> "mgrep.l"
  if (system("flex mgrep.l") != 0) {
    print "Error in Regular Expression"
    exit 1;
  }
  else if (system("gcc lex.yy.c") != 0) {
    print "Error in Regular Expression"
    exit 1;
  }
  else {
    nline = system("a.out < FILENAME");
    if (nline != 0) {
      print FILENAME, nline
  }
}
