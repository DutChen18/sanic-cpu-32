
int get_val(int i, int j, int k, int l, int m) {
  volatile int vol = 1;

  return i + j + k + l + m - vol;
}
