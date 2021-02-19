import sys


bit = {
    'F': 0, # lower half
    'B': 1, # upper half
    'L': 0, # upper half
    'R': 1  # lower half
}

with open(sys.argv[1]) as f:
    for line in f:
        acc = 0
        for c in reversed(line.split()[0]):
            acc = (acc << 1) | bit[c];
        sys.stdout.write('{:08x}\n'.format(acc))
