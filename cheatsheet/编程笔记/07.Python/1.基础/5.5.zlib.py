
# 压缩与解压字符串
import zlib
message = 'abcd1234'
compressed = zlib.compress(message)
decompressed = zlib.decompress(compressed)

print 'original:', repr(message)
print 'compressed:', repr(compressed)
print 'decompressed:', repr(decompressed)

# 压缩与解压文件
import zlib
def compress(infile, dst, level=9):
    infile = open(infile, 'rb')
    dst = open(dst, 'wb')
    compress = zlib.compressobj(level)
    data = infile.read(1024)
    while data:
        dst.write(compress.compress(data))
        data = infile.read(1024)
    dst.write(compress.flush())

def decompress(infile, dst):
    infile = open(infile, 'rb')
    dst = open(dst, 'wb')
    decompress = zlib.decompressobj()
    data = infile.read(1024)
    while data:
        dst.write(decompress.decompress(data))
        data = infile.read(1024)
    dst.write(decompress.flush())

if __name__ == "__main__":
    compress('in.txt', 'out.txt')
    decompress('out.txt', 'out_decompress.txt')