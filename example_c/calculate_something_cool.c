#include <stdint.h>
void putc(unsigned char c) { *(volatile unsigned char *)0x400001 = c; }
void printi(uint32_t val) {
  uint32_t divisor = 1000000000;
  while (divisor > 0) {
    if (divisor <= val) {
      uint32_t digit = (val / divisor) % 10;
      digit += 48; // Get ASCII character
      putc((unsigned char)digit);
    }
    divisor /= 10;
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
