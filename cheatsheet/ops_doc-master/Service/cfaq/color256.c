#include <stdio.h>


int main(void) {
  for (int color = 0; color < 255; color++) {
    printf("\e[38;5;%dm Hello \e[0m", color);
  }
  for (int color = 0; color < 255; color++) {
    printf("\e[48;5;%dm Hello \e[0m", color);
  }
}