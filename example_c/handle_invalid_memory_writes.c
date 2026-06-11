#include <stdint.h>
void putc(char c) { *(volatile unsigned char *)0x400001 = c; }
void print(unsigned char *data, uint32_t size) {
  for (int i = 0; i < size; i++) {
    putc(data[i]);
  }
}
int write_mem(uintptr_t addr, uint8_t *bytes, uint32_t size) {
  if (addr < 0x400001) {
    // Invalid memory
    unsigned char data[] = "Attempted to write to invalid memory";
    print(data, sizeof(data));
    return 1;
  }
  for (uint32_t i = 0; i < size; i++) {
    *(volatile unsigned char *)(addr + i) = bytes[i];
  }
  return 0;
}

int main(void) {
  unsigned char data[] = "1234";
  write_mem(0x0, data, sizeof(data));
}
