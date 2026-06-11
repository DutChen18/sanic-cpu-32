#include "int_types.h";
int func(void) {
  dwords result;
  result.s.high = 40;
  result.s.low = 50;
  return result.all;
}
