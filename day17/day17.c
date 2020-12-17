#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define INPUT_SIZE 8
#define SIZE 30 // = (size of the input + 6 for growth + 1 padding) * 2

bool alive3(bool state[SIZE][SIZE][SIZE], int x, int y, int z) {
  int neighbours_count = 0;
  for (int i = -1; i <= 1; ++i) {
    for (int j = -1; j <= 1; ++j) {
      for (int k = -1; k <= 1; ++k) {
        neighbours_count += state[x + i][y + j][z + k];
      }
    }
  }
  neighbours_count -= state[x][y][z];

  if (state[x][y][z]) {
    return (2 <= neighbours_count) && (neighbours_count <= 3);
  }
  return 3 == neighbours_count;
}

bool alive4(bool state[SIZE][SIZE][SIZE][SIZE], int x, int y, int z, int w) {
  int neighbours_count = 0;
  for (int i = -1; i <= 1; ++i) {
    for (int j = -1; j <= 1; ++j) {
      for (int k = -1; k <= 1; ++k) {
        for (int l = -1; l <= 1; ++l) {
          neighbours_count += state[x + i][y + j][z + k][w + l];
        }
      }
    }
  }
  neighbours_count -= state[x][y][z][w];

  if (state[x][y][z][w]) {
    return (2 <= neighbours_count) && (neighbours_count <= 3);
  }
  return 3 == neighbours_count;
}

int part1(bool input[INPUT_SIZE][INPUT_SIZE]) {
  bool state[SIZE][SIZE][SIZE] = {false};
  bool new_state[SIZE][SIZE][SIZE] = {false};

  for (int i = 0; i < INPUT_SIZE; ++i) {
    for (int j = 0; j < INPUT_SIZE; ++j) {
      state[SIZE / 2 + i][SIZE / 2 + j][SIZE / 2] = input[i][j];
    }
  }

  for (int step = 0; step < 6; ++step) {
    for (int x = 1; x < SIZE - 1; ++x) {
      for (int y = 1; y < SIZE - 1; ++y) {
        for (int z = 1; z < SIZE - 1; ++z) {
          new_state[x][y][z] = alive3(state, x, y, z);
        }
      }
    }
    memcpy(state, new_state, sizeof(state));
  }

  int active_count = 0;
  for (int x = 1; x < SIZE - 1; ++x) {
    for (int y = 1; y < SIZE - 1; ++y) {
      for (int z = 1; z < SIZE - 1; ++z) {
        active_count += state[x][y][z];
      }
    }
  }
  return active_count;
}

int part2(bool input[INPUT_SIZE][INPUT_SIZE]) {
  bool state[SIZE][SIZE][SIZE][SIZE] = {false};
  bool new_state[SIZE][SIZE][SIZE][SIZE] = {false};

  for (int i = 0; i < INPUT_SIZE; ++i) {
    for (int j = 0; j < INPUT_SIZE; ++j) {
      state[SIZE / 2 + i][SIZE / 2 + j][SIZE / 2][SIZE / 2] = input[i][j];
    }
  }

  for (int step = 0; step < 6; ++step) {
    for (int x = 1; x < SIZE - 1; ++x) {
      for (int y = 1; y < SIZE - 1; ++y) {
        for (int z = 1; z < SIZE - 1; ++z) {
          for (int w = 1; w < SIZE - 1; ++w) {
            new_state[x][y][z][w] = alive4(state, x, y, z, w);
          }
        }
      }
    }
    memcpy(state, new_state, sizeof(state));
  }

  int active_count = 0;
  for (int x = 1; x < SIZE - 1; ++x) {
    for (int y = 1; y < SIZE - 1; ++y) {
      for (int z = 1; z < SIZE - 1; ++z) {
        for (int w = 1; w < SIZE - 1; ++w) {
          active_count += state[x][y][z][w];
        }
      }
    }
  }
  return active_count;
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

  bool input[INPUT_SIZE][INPUT_SIZE] = {false};
  int i = 0;
  int j = 0;
  char c;
  while ((c = fgetc(fp)) != EOF) {
    if (c == '\n') {
      i++;
      j = 0;
    } else {
      input[i][j] = (c == '#');
      j++;
    }
  }
  fclose(fp);

  printf("%d\n", part1(input));
  printf("%d\n", part2(input));

  return 0;
}
