
#ifndef HEADERFILE_H
#define HEADERFILE_H
int complicated1(int input);
int complicated2(int input);
inline int timestwo(int input) {
  return input * 2;
}
inline int plusfive(int input) {
  return input + 5;
}
#endif