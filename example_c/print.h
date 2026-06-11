typedef enum {
  stdout = 0x400001,
} Stream;

void putc(Stream s, char c);
void printf(Stream s, char* text);
