import sys
from binascii import hexlify

with open(sys.argv[1], 'rb') as f:
    while 1:
        line = f.readline()
        if not line:
            break
        sys.stdout.write('{:08x}'.format(int(line)))
        sys.stdout.write('\n')
