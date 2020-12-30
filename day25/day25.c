#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#define MODULO 20201227UL
#define PUB1 3248366UL
#define PUB2 4738476UL

unsigned long modexp(unsigned long a, unsigned long b, unsigned long n) {
  if (b == 0) {
    return (n == 1) ? 0 : 1;
  }
  if (b == 1) {
    return a % n;
  }
  if (b % 2 == 0) {
    unsigned long c = modexp(a, b / 2, n);
    return (c * c) % n;
  }
  return (a * modexp(a, b - 1, n)) % n;
}

unsigned long discrete_logarithm(unsigned long a, unsigned long b,
                                 unsigned long n) {
  unsigned long m = ceil(sqrt(n));
  unsigned long *table = calloc(n, sizeof(unsigned long));

  for (size_t j = 0; j < m; ++j) {
    table[modexp(a, j, n)] = j;
  }
  unsigned long t = modexp(a, n - m - 1, n);

  unsigned long res = 0;
  unsigned long c = b;
  for (size_t i = 0; i < m; ++i) {
    if (table[c] != 0) {
      res = table[c] + i * m;
      break;
    }
    c = (c * t) % n;
  }
  free(table);
  return res;
}

int main(int argc, char *argv[]) {
  unsigned long priv1 = discrete_logarithm(7, PUB1, MODULO);
  printf("%lu\n", modexp(PUB2, priv1, MODULO));

  return EXIT_SUCCESS;
}
