// Timer.h

int Timer_start ();
int Timer_elapsedWallclockTime (double *wc);
int Timer_elapsedUserTime (double *ut);
int Timer_elapsedSystemTime (double *sys);
int Timer_elapsedTime (double *wc, double *us, double *sys);
