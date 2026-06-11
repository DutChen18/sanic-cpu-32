void foo(int *x) { *x = 1; }

void bar() {
  int x;
  foo(&x);
}
