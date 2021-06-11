// Set the player 'hp' integer variable:
void setPlayerHp(int amount) {
  setint(TYPE_PLY, "", 0, amount);
}

// Set the player 'score' integer variable:
void setPlayerScore(int amount) {
  setint(TYPE_PLY, "", 1, amount);
}

// A 'hack' to print a string from script.. send it via a 'setint' on the player as the name..
void printLog(string msg) {
  setint(TYPE_PLY, msg, 2, 0);
}


// Fibonacci numbers.
int fib(int a) {
 if (a==0 || a==1) 
   return 1;
 else
   return (fib(a-2) + fib(a-1));
}

// Some messing around with integers and bools
program start trigger_on_init {
  printLog("testing bools:"); 
  bool b = true;
  printLog("b is " + b);
  printLog("!b is " + !b);
  
  printLog("Testing integer stuff:");
  int k = (int)"100";   // test string to int cast
  while(true) {
    k = k + 1;          // test the iadd opcode
    k = k * 2 - 1;      // test imul and isub opcode
    k = k % 1000;       // test the irem opcode
        
    setPlayerHp(k);
    setPlayerScore(-(k/10)); // test the ineg and idiv opcode:
    
    sleep(500);
  }
}


program fibNumbers trigger_on_init {
 for (int i=10; i>=0; i = i - 1) {
   printLog("fibonacci of " + i + " is " + fib(i));
   sleep(1200);
 }
}
