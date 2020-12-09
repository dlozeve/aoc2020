#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

bool in_state(unsigned int m, unsigned int state[m][m], unsigned int x) {
  for (int i = 0; i < m; ++i) {
    for (int j = i + 1; j < m; ++j) {
      if (state[i][j] == x) {
        return true;
      }
    }
  }
  return false;
}

void print_state(unsigned int m, unsigned int state[m][m]) {
  for (int i = 0; i < m; ++i) {
    for (int j = 0; j < m; ++j) {
      printf("%u ", state[i][j]);
    }
    printf("\n");
  }
}

void update_state(unsigned int m, unsigned int state[m][m], unsigned int *input,
                  unsigned int k) {
  for (int i = k - m +1; i < k; ++i) {
    state[k % m][i % m] = input[i] + input[k];
    state[i % m][k % m] = input[i] + input[k];
  }
}

int main(int argc, char *argv[]) {
  if (argc < 3) {
    printf("Usage: %s <input file> <preamble size>\n", argv[0]);
    return 0;
  }

  FILE *fp = fopen(argv[1], "r");
  if (fp == NULL) {
    printf("Could not open file %s\n", argv[1]);
    return 1;
  }

  unsigned int m;
  sscanf(argv[2], "%d", &m);

  unsigned int input[1024] = {0};
  unsigned int n = 0;
  unsigned int d;
  while (fscanf(fp, "%d\n", &d) == 1) {
    input[n] = d;
    n++;
  }
  fclose(fp);

  // Part 1
  unsigned int state[m][m];
  for (int i = 0; i < m; ++i) {
    for (int j = 0; j < m; ++j) {
      if (i != j) {
	state[i][j] = input[i] + input[j];
      } else {
	state[i][j] = 0;
      }
    }
  }

  unsigned int k = m;
  while (in_state(m, state, input[k])) {
    update_state(m, state, input, k);
    k++;
  }

  printf("%u\n", input[k]);

  // Part 2
  unsigned int invalid_number = input[k];
  for (int width = 2; width < n; ++width) {
    for (int i = 0; i < n - width; ++i) {
      unsigned int sum = 0;
      unsigned int min = UINT_MAX;
      unsigned int max = 0;
      for (int j = 0; j < width; ++j) {
	sum += input[i + j];
	min = (input[i + j] < min) ? input[i + j] : min;
	max = (input[i + j] > max) ? input[i + j] : max;
      }
      if (sum == invalid_number) {
	printf("%u\n", min + max);
	return 0;
      }
    }
  }

  return 0;
}
