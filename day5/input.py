import sys


bit = {
    'F': 0, # lower half
    'B': 1, # upper half
    'L': 0, # upper half
    'R': 1  # lower half
}

size = int(sys.argv[2])

with open(sys.argv[1]) as f:
    index = 0
    for line in f:
        acc = 0
        for c in reversed(line.split()[0]):
            acc = (acc << 1) | bit[c];
        sys.stdout.write('{:08x}\n'.format(acc))
        index += 1
    assert index < size, index
    while index < size:
        sys.stdout.write('aaaaaaaa\n')
        index += 1
