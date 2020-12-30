#include <stdio.h>
#include <stdlib.h>

#define TEST_INPUT 389125467UL
#define TEST_RESULT_10 92658374UL
#define TEST_RESULT_100 67384529UL
#define TEST_RESULT_PART2 149245887792UL
#define INPUT 198753462UL

void print_cups(unsigned long cups[static 1], unsigned long start) {
  printf("(%lu) ", start);
  unsigned long c = cups[start];
  while (c != start) {
    printf("%lu ", c);
    if (c == 0) {
      printf("\nreached zero, abort!\n");
      return;
    }
    c = cups[c];
  }
  printf("\n");
}

unsigned long move(size_t size, unsigned long cups[size], unsigned long current) {
  /* print_cups(cups, current); */
  /* printf("current: %lu\n", current); */

  unsigned long picked_up[3] = {0};
  unsigned long c = current;
  for (int i = 0; i < 3; ++i) {
    picked_up[i] = cups[c];
    c = cups[c];
  }
  /* printf("pick up: %lu, %lu, %lu\n", picked_up[0], picked_up[1],
   * picked_up[2]); */

  unsigned long dest = current - 1;
  while ((dest == 0) || (dest == picked_up[0]) || (dest == picked_up[1]) ||
         (dest == picked_up[2])) {
    dest = (size + dest - 1) % size;
  }
  /* printf("destination: %lu\n", dest); */

  cups[current] = cups[picked_up[2]];
  cups[picked_up[2]] = cups[dest];
  cups[dest] = picked_up[0];

  return cups[current];
}

unsigned long *play(size_t size, unsigned long cups[size], unsigned long start,
                    unsigned long steps) {
  unsigned long current = start;
  for (size_t i = 0; i < steps; ++i) {
    /* printf("-- move %zu --\n", i+1); */
    current = move(size, cups, current);
  }

  return cups;
}

unsigned long *init_cups(unsigned long n, size_t size) {
  unsigned long *cups = calloc(size, sizeof(unsigned long));
  unsigned long start = n / 100000000;

  unsigned long q = n;
  unsigned long r = start;
  while (q != 0) {
    cups[q % 10] = r;
    r = q % 10;
    q = q / 10;
  }

  if (size > 10) {
    cups[n % 10] = 10;
    for (size_t i = 10; i < size - 1; ++i) {
      cups[i] = i + 1;
    }
    cups[size - 1] = start;
  }

  return cups;
}

unsigned long run_part(int part, unsigned long n, unsigned long steps) {
  size_t size = 0;
  if (part == 1) {
    size = 10;
  } else if (part == 2) {
    size = 1000001;
  }
  unsigned long *cups = init_cups(n, size);
  unsigned long start = n / 100000000;
  play(size, cups, start, steps);

  unsigned long res = 0;
  if (part == 1) {
    unsigned long c = cups[1];
    while (c != 1) {
      res = 10 * res + c;
      c = cups[c];
    }
  } else if (part == 2) {
    res = cups[1] * cups[cups[1]];
  }

  free(cups);
  return res;
}

int main(int argc, char *argv[]) {
  unsigned long res = 0;

  res = run_part(1, TEST_INPUT, 10);
  if (res != TEST_RESULT_10) {
    printf("Test 1: %lu (expected = %lu)\n", res, TEST_RESULT_10);
  }
  res = run_part(1, TEST_INPUT, 100);
  if (res != TEST_RESULT_100) {
    printf("Test 2: %lu (expected = %lu)\n", res, TEST_RESULT_100);
  }

  printf("%lu\n", run_part(1, INPUT, 100));

  res = run_part(2, TEST_INPUT, 10000000);
  if (res != TEST_RESULT_PART2) {
    printf("Test 3: %lu (expected = %lu)\n", res, TEST_RESULT_PART2);
  }

  printf("%lu\n", run_part(2, INPUT, 10000000));

  return EXIT_SUCCESS;
}
