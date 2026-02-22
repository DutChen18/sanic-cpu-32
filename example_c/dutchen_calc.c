#include <stdint.h>
void putc(unsigned char c) { *(volatile unsigned char *)0x400001 = c; }
void printi(uint32_t val) {
  char buf[10];
  uint32_t i = 0;
  while (val > 0) {
    buf[i++] = val % 10 + 48;
    val /= 10;
  }
  while (i > 0) {
    putc(buf[--i]);
  }
  putc('\n');
}
__attribute__((section(".main"))) int main(void) {
  printi(1234);
  // uint32_t a = 0;
  // uint32_t b = 1;
  //
  // uint32_t counter = 0;
  // while (1) {
  //   if (counter % 2 == 0) {
  //     a = a + b;
  //     printi(a);
  //   } else {
  //     b = a + b;
  //     printi(b);
  //   }
  //   counter++;
  // }
}
