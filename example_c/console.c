#include "print.h"

__attribute__((section(".main"))) 
int main() {
  printf(stdout, "This is a test");
}
