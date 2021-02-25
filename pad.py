import sys

size = int(sys.argv[1])

buf = sys.stdin.read()
index = len(buf.split())
assert index < size, index
sys.stdout.write(buf)
while index < size:
    sys.stdout.write('aaaaaaaa\n')
    index += 1
