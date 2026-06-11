#include "print.h"

void putc(Stream s, char c) {
  *(volatile char*)s = c;
}

void printf(Stream s, char *c) {
  for(int i = 0; i < sizeof(c); i++) {
    putc(s, c[i]);
  }
}
