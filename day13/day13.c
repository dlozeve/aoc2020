#include <limits.h>
#include <stdio.h>
#include <stdlib.h>

long egcd(long *x, long *y, long a, long b) {
  if (b == 0) {
    *x = 1;
    *y = 0;
    return a;
  }

  long x1, y1;
  long gcd = egcd(&x1, &y1, b, a % b);
  *x = y1;
  *y = x1 - (a / b) * y1;

  return gcd;
}

long modinv(long a, long m) {
  long x, y;
  long gcd = egcd(&x, &y, a, m);
  if (gcd != 1) {
    return -1;
  }
  if (x < 0) {
    return m + x;
  }
  return x;
}

int main(int argc, char *argv[]) {
  if (argc < 2) {
    printf("Usage: %s <input file>\n", argv[0]);
    return 0;
  }

  FILE *fp = fopen(argv[1], "r");
  if (fp == NULL) {
    printf("Could not open file %s\n", argv[1]);
    return 1;
  }

  int t;
  fscanf(fp, "%d\n", &t);

  int buses[100] = {0};
  int n = 0;
  while (fscanf(fp, "%d,", &buses[n++]) == 1 || fscanf(fp, "x,") == 0)
    ;
  n--;
  fclose(fp);

  // Part 1
  int min = INT_MAX;
  int tmin = 0;
  for (int i = 0; i < n; ++i) {
    if (buses[i] == 0) {
      continue;
    }
    int x = buses[i] - t % buses[i];
    if (x < min) {
      min = x;
      tmin = i;
    }
  }
  printf("%d\n", min * buses[tmin]);

  // Part 2
  unsigned long N = 1;
  for (int i = 0; i < n; ++i) {
    if (buses[i] == 0) {
      continue;
    }
    N *= buses[i];
  }

  long x = 0;
  for (int i = 0; i < n; ++i) {
    if (buses[i] == 0) {
      continue;
    }
    long Ni = N / buses[i];
    x += (buses[i] - i) * modinv(Ni, buses[i]) * Ni;
  }
  printf("%ld\n", x % N);

  return 0;
}
