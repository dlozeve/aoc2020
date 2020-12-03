#include <stdbool.h>
#include <stdio.h>

int count_lines(FILE *fp) {
  int count = 0;

  for (char c = getc(fp); c != EOF; c = getc(fp)) {
    if (c == '\n') {
      count++;
    }
  }
  return count;
}

int line_length(FILE *fp) {
  int count = 0;

  for (char c = getc(fp); c != '\n'; c = getc(fp)) {
    count++;
  }

  return count;
}

int count_trees(int n, int m, int grid[n][m], int down_offset, int right_offset) {
  int count = 0;

  for (int i = 0; i < n / down_offset; ++i) {
    count += grid[i * down_offset][i * right_offset % m];
  }

  return count;
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

  int n = count_lines(fp);
  rewind(fp);
  int m = line_length(fp);
  rewind(fp);

  printf("Grid size: %d×%d\n", n, m);

  int grid[n][m];
  char c;
  for (int i = 0; i < n; ++i) {
    for (int j = 0; j < m; ++j) {
      c = getc(fp);
      if (c == '\n' || c == EOF) {
	c = getc(fp);
      }
      grid[i][j] = (c == '#');
    }
  }
  fclose(fp);

  printf("%d\n", count_trees(n, m, grid, 1, 3));

  int total = 1;
  int down_offsets[] = {1, 1, 1, 1, 2};
  int right_offsets[] = {1, 3, 5, 7, 1};
  for (int i = 0; i < 5; ++i) {
    total *= count_trees(n, m, grid, down_offsets[i], right_offsets[i]);
  }
  printf("%d\n", total);

  return 0;
}
