#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

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

  bool flag_newline = false;
  unsigned int answer_count = 0;
  unsigned int counts[26] = {0};
  unsigned int part1 = 0;
  unsigned int part2 = 0;
  for (char c = getc(fp); c != EOF; c = getc(fp)) {
    if (c == '\n' && flag_newline) {
      for (int i = 0; i < 26; ++i) {
        if (counts[i] > 0) {
          part1++;
        }
        if (counts[i] == answer_count) {
          part2++;
        }
        counts[i] = 0;
      }
      flag_newline = false;
      answer_count = 0;
    } else if (c == '\n') {
      flag_newline = true;
      answer_count++;
    } else {
      counts[c - 'a']++;
      flag_newline = false;
    }
  }

  for (int i = 0; i < 26; ++i) {
    if (counts[i] > 0) {
      part1++;
    }
    if (counts[i] == answer_count) {
      part2++;
    }
  }

  printf("%u\n", part1);
  printf("%u\n", part2);

  fclose(fp);
  return 0;
}
