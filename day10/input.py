import sys

size = int(sys.argv[2])

with open(sys.argv[1]) as f:
    index = 0
    acc = 0
    for i, line in enumerate(f):
        if (i % 4) == 0:
            acc = 0
        # a little endian packing, not that it matters for this
        acc |= int(line) << (8 * (i % 4))
        if (i % 4) == 3:
            sys.stdout.write('{:08x}\n'.format(acc))
            index += 1
    if (i % 4) != 3:
        sys.stdout.write('{:08x}\n'.format(acc))
        index += 1

    assert index < size, index
    while index < size:
        sys.stdout.write('aaaaaaaa\n')
        index += 1
