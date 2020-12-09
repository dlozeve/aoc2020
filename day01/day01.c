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

  int input[1024] = {0};
  int d;
  int n = 0;
  while (fscanf(fp, "%d\n", &d) == 1) {
    input[n] = d;
    n++;
  }
  fclose(fp);

  int res = -1;
  for (int i = 0; i < n && res == -1; ++i) {
    for (int j = 0; j < n && res == -1; ++j) {
      if (input[i] + input[j] == 2020) {
        res = input[i] * input[j];
        break;
      }
    }
  }
  printf("%d\n", res);

  res = -1;
  for (int i = 0; i < n && res == -1; ++i) {
    for (int j = 0; j < n && res == -1; ++j) {
      for (int k = 0; k < n && res == -1; ++k) {
        if (input[i] + input[j] + input[k] == 2020) {
          res = input[i] * input[j] * input[k];
        }
      }
    }
  }
  printf("%d\n", res);

  return 0;
}
