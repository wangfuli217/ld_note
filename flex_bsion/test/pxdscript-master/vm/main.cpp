#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "Logger.h"
#include "Player.h"
#include "ScriptManager.h"


// Simulator:
int main(int argc, char **argv) {
  string scriptFile;
  if(argc < 2){
    printf("Usage: vm <scriptfile>\n");
    exit(1);
  } 
  else {
    scriptFile = argv[1];
  }
 
  // Randomize:
  srand(time(NULL));
     
  // Create a log file 
  logger = new Logger("vmlog.txt");
  
  if (!ScriptManager::instance()->load(scriptFile)) {
    printf("no such file '%s'\n", scriptFile.c_str());
    delete logger;
    exit(1); 
  } 

  // Main loop:
  Log("***Entering main loop***");
  while(ScriptManager::instance()->hasRunningPrograms()) {
    ScriptManager::instance()->handleScripts();   
    
    // Here you would put your 'renderScene' call:
    
  }
 
  delete logger; 
  return 0;
}
