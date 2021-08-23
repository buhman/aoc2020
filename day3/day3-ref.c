extern const void __input;

static const short * len = (short *)&__input;
static const unsigned char * grid = (char *)(&__input + 2);

int main()
{
  int row = 0;
  int rows[2048];

  rows[row] = 0;

  int ix = 0;
  int width = 0;

  for (int i = 0; i < *len; i++) {
    switch(grid[i]) {
    case '\n':
      rows[++row] = 0;
      width = ix;
      ix = 0;
      break;
    case '#':
      rows[row] |= (1 << ix++);
      break;
    case '.':
      rows[row] |= (0 << ix++);
      break;
    }
    //assert(ix < 32);
    //assert(row < 2048);
  }

  int x = 0;
  int y = 0;
  #define dx 3
  #define dy 1
  int trees = 0;
  while (y < row) {
    trees += ((rows[y] >> x) & 1);
    x += dx;
    if (x >= width)
      x = x - width;
    y += dy;
  }
  //__asm__ ("ebreak");
  return trees;
}
