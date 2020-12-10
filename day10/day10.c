#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

int compare(const void* a, const void* b) {
  unsigned int x = *(const unsigned int*)a;
  unsigned int y = *(const unsigned int*)b;

  if (x < y) return -1;
  if (x > y) return 1;
  return 0;
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

  unsigned int input[128] = {0};
  unsigned int n = 1;
  unsigned int d = 0;
  unsigned int max = 0;
  while (fscanf(fp, "%d\n", &d) == 1) {
    input[n] = d;
    n++;
    max = d > max ? d : max;
  }
  max += 3;
  input[n] = max;
  n++;
  fclose(fp);

  qsort(input, n, sizeof(unsigned int), compare);

  // Part 1
  int ones = 0;
  int threes = 0;
  for (int i = 1; i < n; ++i) {
    int diff = input[i] - input[i-1];
    ones += (diff == 1);
    threes += (diff == 3);
  }
  printf("%d\n", ones * threes);

  // Part 2
  unsigned long counts[1024] = {0};
  counts[2] = 1;
  for (int i = 1; i < n; ++i) {
    unsigned int x = input[i];
    counts[x+2] = counts[x-1] + counts[x] + counts[x+1];
  }
  printf("%lu\n", counts[max+2]);

  return 0;
}
