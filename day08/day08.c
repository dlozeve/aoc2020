#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>

enum operation {
  NOP,
  ACC,
  JMP,
};

struct instruction {
  enum operation op;
  int arg;
};

enum outcome {
  ERROR,
  LOOP,
  END,
};

struct result {
  enum outcome out;
  int ret;
};

size_t count_lines(FILE *fp) {
  size_t count = 0;

  for (char c = getc(fp); c != EOF; c = getc(fp)) {
    if (c == '\n') {
      count++;
    }
  }
  return count;
}

struct result execute(size_t n, struct instruction program[n]) {
  int acc = 0;
  size_t ip = 0;
  bool visited[n];
  for (size_t i = 0; i < n; ++i) {
    visited[i] = false;
  }

  while (visited[ip] == false && ip < n) {
    visited[ip] = true;
    switch (program[ip].op) {
    case NOP: {
      ip++;
      break;
    }
    case ACC: {
      acc += program[ip].arg;
      ip++;
      break;
    }
    case JMP: {
      ip += program[ip].arg;
      break;
    }
    default:
      printf("ERROR: invalid instruction %d %d in position %zu\n",
             program[ip].op, program[ip].arg, ip);
      return (struct result){.out = ERROR, .ret = 0};
    }
  }

  if (ip == n) {
    return (struct result){.out = END, .ret = acc};
  }
  return (struct result){.out = LOOP, .ret = acc};
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

  size_t n = count_lines(fp);
  struct instruction program[n];
  rewind(fp);

  char *buf = NULL;
  size_t buf_size = 0;
  size_t i = 0;
  while (getline(&buf, &buf_size, fp) != -1) {
    int arg;
    if (strncmp(buf, "nop", 3) == 0) {
      sscanf(buf, "nop %d", &arg);
      program[i] = (struct instruction){.op = NOP, .arg = arg};
    } else if (strncmp(buf, "acc", 3) == 0) {
      sscanf(buf, "acc %d", &arg);
      program[i] = (struct instruction){.op = ACC, .arg = arg};
    } else if (strncmp(buf, "jmp", 3) == 0) {
      sscanf(buf, "jmp %d", &arg);
      program[i] = (struct instruction){.op = JMP, .arg = arg};
    }
    i++;
  }
  free(buf);
  fclose(fp);

  // Part 1
  printf("Part 1: ");
  struct timeval tv1, tv2;
  gettimeofday(&tv1, NULL);

  struct result res = execute(n, program);
  if (res.out == LOOP) {
    printf("%d\n", res.ret);
  }

  gettimeofday(&tv2, NULL);
  printf("Time: %lds %ldµs\n", tv2.tv_sec - tv1.tv_sec,
         tv2.tv_usec - tv1.tv_usec);

  // Part 2 (bruteforce)
  printf("Part 2: ");
  gettimeofday(&tv1, NULL);

  bool finished = false;
  i = 0;
  while (!finished && i < n) {
    switch (program[i].op) {
    case NOP: {
      program[i].op = JMP;
      res = execute(n, program);
      if (res.out == END) {
        finished = true;
      }
      program[i].op = NOP;
      break;
    }
    case JMP: {
      program[i].op = NOP;
      res = execute(n, program);
      if (res.out == END) {
        finished = true;
      }
      program[i].op = JMP;
      break;
    }
    default:
      break;
    }
    i++;
  }
  printf("%d\n", res.ret);

  gettimeofday(&tv2, NULL);
  printf("Time: %lds %ldµs\n", tv2.tv_sec - tv1.tv_sec,
         tv2.tv_usec - tv1.tv_usec);

  return 0;
}
