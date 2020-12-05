#include <stdio.h>
#include <limits.h>
#include <stdbool.h>

unsigned int bin_to_int(char *buf, int size) {
  unsigned int r = 0;
  for (int i = 0; i < size; ++i) {
    r = r << 1;
    if (buf[i] == 'B' || buf[i] == 'R') {
      r++;
    }
  }
  return r;
}

int main(int argc, char *argv[])
{
  if (argc < 2) {
    printf("Usage: %s <input file>\n", argv[0]);
    return 0;
  }

  FILE *fp = fopen(argv[1], "r");
  if (fp == NULL) {
    printf("Could not open file %s\n", argv[1]);
    return 1;
  }

  char buf[12];
  size_t i = 0;
  unsigned int ids[1024];
  unsigned int min_id = UINT_MAX;
  unsigned int max_id = 0;
  while (fgets(buf, sizeof(buf), fp) != NULL) {
    ids[i] = bin_to_int(buf, 10);
    if (min_id > ids[i]) {
      min_id = ids[i];
    }
    if (max_id < ids[i]) {
      max_id = ids[i];
    }
    i++;
  }
  printf("%u\n", max_id);

  fclose(fp);

  for (int id = min_id; id < max_id; ++id) {
    bool present = false;
    for (int j = 0; j < i; ++j) {
      present = present || (id == ids[j]);
    }
    if (!present) {
      printf("%u\n", id);
      break;
    }
  }

  return 0;
}
