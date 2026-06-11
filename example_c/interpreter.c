const TTY_ADDR = 0x400001;
const KB_ADDR = 0x400002;

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

char *scanf(char *prompt) {
  printf(prompt);
  char input_char = '';
  char *built_string = "";
  while (input_char != '\n') {
    input_char = (char)*(volatile int *)KB_ADDR;
    if (input_char == 0 || input_char == '\n')
      continue;
    char *new_string = malloc(sizeof(built_string) + sizeof(char));
    *new_string = built_string;
    int new_char_index = (sizeof(new_string) / sizeof(char)) - 1;
    new_string[new_char_index] = input_char;
    built_string = new_string;
  }
  return built_string;
}
void sc32printf(char *buff) {
  for (int i = 0; i < sizeof(buff * (char *)) - 1; i++) {
    putc(buff[i]);
  }
}
int ascii_to_binary(char *buff) {
  int result = 0;
  int string_size = sizeof(buff) / sizeof(char);
  for (int i = 0; i < string_size; i++) {
    result *= 10;
    result += (buff[i] - 48);
  }
  return result;
}

int main() {
  while (1) {
    char *input = scanf("> ");
    if (strcmp(input, "add") == 0) {
      char *number_one = scanf("Enter first number: ");
      int first_num = ascii_to_binary(number_one);
      char *number_two = scanf("Enter second number: ");
      int second_num = ascii_to_binary(number_two);
      int binary_answer = first_num + second_num;

    } else if (input == "sub") {

    } else if (input == "mul") {

    } else if (input == "div") {
    }
  }
}
