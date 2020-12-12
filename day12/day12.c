#include <complex.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#define PI

struct instruction {
  char action;
  int value;
};

struct state {
  double complex pos;
  double complex dir;
};

void step1(struct state *st, struct instruction instr) {
  switch (instr.action) {
  case 'N': {
    st->pos += instr.value * I;
    break;
  }
  case 'S': {
    st->pos -= instr.value * I;
    break;
  }
  case 'E': {
    st->pos += instr.value;
    break;
  }
  case 'W': {
    st->pos -= instr.value;
    break;
  }
  case 'F': {
    st->pos += instr.value * st->dir;
    break;
  }
  case 'R': {
    st->dir *= cexp(-instr.value * I * M_PI / 180);
    break;
  }
  case 'L': {
    st->dir *= cexp(instr.value * I * M_PI / 180);
    break;
  }
  default:
    printf("Invalid instruction %c %d\n", instr.action, instr.value);
    break;
  }
}

void step2(struct state *st, struct instruction instr) {
  switch (instr.action) {
  case 'N': {
    st->dir += instr.value * I;
    break;
  }
  case 'S': {
    st->dir -= instr.value * I;
    break;
  }
  case 'E': {
    st->dir += instr.value;
    break;
  }
  case 'W': {
    st->dir -= instr.value;
    break;
  }
  case 'F': {
    st->pos += instr.value * st->dir;
    break;
  }
  case 'R': {
    st->dir *= cexp(-instr.value * I * M_PI / 180);
    break;
  }
  case 'L': {
    st->dir *= cexp(instr.value * I * M_PI / 180);
    break;
  }
  default:
    printf("Invalid instruction %c %d\n", instr.action, instr.value);
    break;
  }
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

  struct instruction in[1024];
  int n = 0;
  while (fscanf(fp, "%c%d\n", &in[n].action, &in[n].value) == 2) {
    n++;
  }
  fclose(fp);

  struct state st1 = {.pos = 0, .dir = 1};
  struct state st2 = {.pos = 0, .dir = 10 + I};
  for (int i = 0; i < n; ++i) {
    step1(&st1, in[i]);
    step2(&st2, in[i]);
  }
  printf("%d\n", (int)round(fabs(creal(st1.pos)) + fabs(cimag(st1.pos))));
  printf("%d\n", (int)round(fabs(creal(st2.pos)) + fabs(cimag(st2.pos))));

  return 0;
}
