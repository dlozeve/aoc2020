#include "uthash.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct memcell {
  unsigned long key;
  unsigned long val;
  UT_hash_handle hh;
};

unsigned long part1(FILE *fp) {
  char *buf = NULL;
  size_t buf_size = 0;
  struct memcell *mem = NULL;
  char mask[36];

  while (getline(&buf, &buf_size, fp) != -1) {
    if (strncmp(buf, "mask", 4) == 0) {
      sscanf(buf, "mask = %s", mask);
    }

    else {
      unsigned long addr, val;
      sscanf(buf, "mem[%ld] = %ld", &addr, &val);

      for (int i = 0; i < 36; ++i) {
        if (mask[35 - i] == '1') {
          val |= 1UL << i;
        } else if (mask[35 - i] == '0') {
          val &= ~(1UL << i);
        }
      }

      struct memcell *elt = (struct memcell *)malloc(sizeof(struct memcell));
      struct memcell *prev_elt =
          (struct memcell *)malloc(sizeof(struct memcell));
      elt->key = addr;
      elt->val = val;
      HASH_REPLACE(hh, mem, key, sizeof(unsigned long), elt, prev_elt);
    }
  }

  unsigned long sum = 0;
  for (struct memcell *cell = mem; cell != NULL; cell = cell->hh.next) {
    sum += cell->val;
  }

  return sum;
}

unsigned long part2(FILE *fp) {
  char *buf = NULL;
  size_t buf_size = 0;
  struct memcell *mem = NULL;
  char mask[36];
  int xcount;

  while (getline(&buf, &buf_size, fp) != -1) {
    if (strncmp(buf, "mask", 4) == 0) {
      sscanf(buf, "mask = %s", mask);
      xcount = 0;
      for (int i = 0; i < 36; ++i) {
        if (mask[i] == 'X') {
          xcount++;
        }
      }
    }

    else {
      unsigned long addr, val;
      sscanf(buf, "mem[%ld] = %ld", &addr, &val);

      for (unsigned long m = 0; m < (1UL << xcount); ++m) {
        unsigned long new_addr = addr;
        int x_idx = 0;
        for (int i = 0; i < 36; ++i) {
          if (mask[35 - i] == '1') {
            new_addr |= 1UL << i;
          } else if (mask[35 - i] == 'X') {
            unsigned long bit = (1UL & (m >> x_idx));
            new_addr ^= (-bit ^ new_addr) & (1UL << i);
            x_idx++;
          }
        }

        struct memcell *elt = (struct memcell *)malloc(sizeof(struct memcell));
        struct memcell *prev_elt =
            (struct memcell *)malloc(sizeof(struct memcell));
        elt->key = new_addr;
        elt->val = val;
        HASH_REPLACE(hh, mem, key, sizeof(unsigned long), elt, prev_elt);
      }
    }
  }

  unsigned long sum = 0;
  for (struct memcell *cell = mem; cell != NULL; cell = cell->hh.next) {
    sum += cell->val;
  }

  return sum;
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

  printf("%lu\n", part1(fp));
  rewind(fp);
  printf("%lu\n", part2(fp));
  fclose(fp);

  return 0;
}
