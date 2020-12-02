#include <stdbool.h>
#include <stdio.h>

bool is_valid_part1(int lower, int upper, char key, char *pass) {
  int count = 0;
  for (char *c = pass; *c != 0; ++c) {
    if (*c == key) {
      count++;
    }
  }
  return (count >= lower) && (count <= upper);
}

bool is_valid_part2(int pos1, int pos2, char key, char *pass) {
  return (pass[pos1 - 1] == key) ^ (pass[pos2 - 1] == key);
}

int main(int argc, char *argv[]) {
  if (argc < 2) {
    printf("Usage: %s <input file>\n", argv[0]);
    return 0;
  }
  FILE *input = fopen(argv[1], "r");

  int lower, upper;
  char key;
  char pass[256];

  int count1 = 0;
  int count2 = 0;

  while (fscanf(input, "%d-%d %c: %s", &lower, &upper, &key, pass) == 4) {
    if (is_valid_part1(lower, upper, key, pass)) {
      count1++;
    }
    if (is_valid_part2(lower, upper, key, pass)) {
      count2++;
    }
  }

  printf("Part 1: %d\n", count1);
  printf("Part 2: %d\n", count2);

  return 0;
}
