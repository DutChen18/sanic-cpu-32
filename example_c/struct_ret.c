#include <stdint.h>

uint64_t get_long(uint32_t i, uint32_t j) {
  uint64_t result = ((uint64_t)i << 32) + (uint64_t)j;
  return result;
}

uint64_t test(int a, int b, int c, int d, int e) { return get_long(0, 0); }
