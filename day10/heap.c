//100 19 36 17 3 25 1 2 7
/*
children
   2i + 1
   2i + 2
parent
   floor((n-1)/2).
*/

static int a[] = {25, 2, 19, 7, 1, 36, 17, 100, 3};

static inline void heapify(int i)
{
  int parent;
  int temp;

  while (i != 0) {
    parent = (i - 1) / 2;
    if (a[i] < a[parent])
      break;

    temp = a[i];
    a[i] = a[parent];
    a[parent] = temp;
    i = parent;
  }
}

static inline void sift_down(int end)
{
  int root = 0;
  int swap;
  int left;
  int right;
  int temp;

  while (1) {
    swap = root;
    left = ((2 * root) + 1);
    if (left >= end)
      break;

    if (a[swap] < a[left])
      swap = left;
    right = left + 1;
    if (right < end && (a[swap] < a[right]))
      swap = right;

    if (swap == root)
      break;

    temp = a[swap];
    a[swap] = a[root];
    a[root] = temp;

    root = swap;
  }
}

int main(void)
{
  int i = 1;

  while (i < 9) {
    heapify(i);
    i++;
  }

  int j = 8;
  int temp;
  while (1) {
    if (j == 1)
      break;

    temp = a[0];
    a[0] = a[j];
    a[j] = temp;

    sift_down(j);

    j--;
  }

  return 0;
}

/*
100
  36 25
        7 1  19 17
                    2 3
*/
