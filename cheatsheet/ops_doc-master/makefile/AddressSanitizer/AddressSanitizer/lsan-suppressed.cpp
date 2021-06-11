// $ clang++ lsan-suppressed.cc -fsanitize=address
// $ ASAN_OPTIONS=detect_leaks=1 LSAN_OPTIONS=suppressions=suppr.txt ./a.out

#include <stdlib.h>

void FooBar() {
  malloc(7);
}

void Baz() {
  malloc(5);
}

int main() {
  FooBar();
  Baz();
  return 0;
}