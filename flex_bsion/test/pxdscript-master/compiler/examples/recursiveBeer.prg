// A 'hack' to print a string from script.. send it via a 'setint' on the player as the name..
void printLog(string msg) {
  setint(TYPE_PLY, msg, 2, 0);
}

void recursiveBeerSong(int nrBeers) {
 // stop recursion
 if (nrBeers == -1)
  return;
  
 // construct string for nrBeers 
 string thisMany;
 if (nrBeers == 0) 
   thisMany = "No";
 else 
   thisMany = nrBeers;
 
 // construct string for (nrBeers - 1)
 string oneLess;
 if (nrBeers < 2) 
   oneLess = "No";
 else 
   oneLess = nrBeers - 1;
 
 // Print the verse
 printLog(thisMany + " bottles of beer on the wall");
 printLog(thisMany + " bottles of beer");
 printLog("Take one down and pass it around");
 printLog(oneLess + " bottle of beer on the wall");
 printLog("");
 
 // call recursively.
 recursiveBeerSong(nrBeers-1);
}


program testRecursion trigger_on_init {
  recursiveBeerSong(10);
}