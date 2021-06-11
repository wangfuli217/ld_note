// A 'hack' to print a string from script.. send it via a 'setint' on the player as the name..
void printLog(string msg) {
  setint(TYPE_PLY, msg, 2, 0);
}

program helloWorld trigger_on_init {
  printLog("Hello world from PxdScript!");
}