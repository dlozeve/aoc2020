#include <stdio.h>
#include <stdlib.h>

#define SIZE 30000000

size_t a[SIZE];

int main(int argc, char *argv[]) {
  if (argc < 2) {
    printf("Usage: %s <input list>\n", argv[0]);
    return 0;
  }

  for (size_t i = 1; i < argc - 1; ++i) {
    a[atoi(argv[i])] = i;
  }

  size_t n = atoi(argv[argc - 1]);
  for (size_t i = argc - 1; i < SIZE; ++i) {
    if (i == 2020) { // Part 1
      printf("%zu\n", n);
    }
    size_t prev_n = n;
    if (a[n] == 0) {
      n = 0;
    } else {
      n = i - a[n];
    }
    a[prev_n] = i;
  }
  printf("%zu\n", n); // Part 2

  return 0;
}
