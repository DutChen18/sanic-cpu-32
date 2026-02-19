#include <stdint.h>

uint32_t test(uint32_t a, uint32_t b) {
  return ((uint64_t)a * (uint64_t)b) >> 32;
} 
