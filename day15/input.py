import sys

index = 0
with open(sys.argv[1]) as f:
    nums = [int(i) for i in f.read().split(',')]

word = 0
for index, n in enumerate(nums):
    if index % 2 == 0:
        word = n
    else:
        word |= n << 16
        sys.stdout.write('{:08x}\n'.format(word))
        word = 0
if index % 2 == 0:
    sys.stdout.write('{:08x}\n'.format(word))
