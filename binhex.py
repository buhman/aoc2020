import sys
from binascii import hexlify

with open(sys.argv[1], 'rb') as f:
    while ((buf := f.read(4)) != b''):
        sys.stdout.write(hexlify(bytes(reversed(buf))).decode('utf-8'))
        sys.stdout.write('\n')
