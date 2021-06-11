%{
unsigned long charCount = 0, wordCount = 0, lineCount = 0;
%}

word [^ \t\n]+ 
eol \n 

%%
{word} { wordCount++; charCount += yyleng; }
{eol} { charCount++; lineCount++; }
. charCount++;

%%

char **fileList;
unsigned nFiles;
unsigned currentFile = 0;
unsigned long totalCC = 0;
unsigned long totalWC = 0;
unsigned long totalLC = 0;

main ( int argc, char **argv) {
  FILE *file;

  fileList = argv + 1; nFiles = argc - 1;

  if (nFiles == 0) {
    fprintf(stderr,"Usage is:\n%s file1 file2 file3 ...\n",argv[0]);
    exit(1);
  }
  file = fopen (fileList[0], "r");
  if (!file) {
      fprintf (stderr, "could not open %s\n", argv[1]);
      exit (1);
  }
  currentFile = 1; yyrestart(file);
  yylex ();
  printf ("%8lu %8lu %8lu %s\n", lineCount, wordCount,
    charCount, fileList[currentFile - 1]);
  if (argc > 2) {
      totalCC += charCount; totalWC += wordCount; totalLC += lineCount;
      printf ("%8lu %8lu %8lu total\n", totalLC, totalWC, totalCC);
  }
  return 0;
}

int yywrap () {
  FILE *file;

  if (nFiles == 1) return 1;
  if ((currentFile > 0) && (currentFile < nFiles)) {
     printf ("%8lu %8lu %8lu %s\n", lineCount, wordCount,
       charCount, fileList[currentFile - 1]);
     totalCC += charCount; totalWC += wordCount; totalLC += lineCount;
     charCount = wordCount = lineCount = 0;
     fclose (yyin);

     while (fileList[currentFile] != (char *) 0) {
       file = fopen (fileList[currentFile++], "r");
       if (file != NULL) { yyrestart(file); break; }
	  fprintf (stderr, "could not open %s\n", fileList[currentFile - 1]);
     }
     return (file ? 0 : 1);
    }
    return 1;
}
