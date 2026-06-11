
int get_val(int val) {
  if (val > 1000) {
    return 1;
  }
  if (val < 0) {
    return 2;
  }
  if (val == 100) {
    return 3;
  }
  return 0;
}
