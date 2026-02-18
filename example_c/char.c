unsigned char test(int addr, char c) {
  unsigned char val = *(volatile unsigned char*)addr;
  *(volatile char*)(addr+1) = c; 
  return val;
}
