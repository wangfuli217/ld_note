#! /usr/bin/env python

import sys
import struct

print_fmt = "boot_ind=%02x\n" \
    "head=%02x sector=%02x(%02x) cylinder=%02x(%02x)\n" \
    "sys_ind=%02x\n" \
    "end_head=%02x end_sector=%02x(%02x) end_cylinder=%02x(%02x)\n" \
    "start=%08x size=%08x\n"

class Partition:
    "store one partition information"
    def __init__(self, buf, fmt):
        self.buf = buf
        self.fmt = fmt

    def __del__(self):
        pass

    def get_partition(self):
        (self.boot_ind, \
             self.head, self.sector, self.cylinder, \
             self.sys_ind, \
             self.end_head, self.end_sector, self.end_cylinder, \
             self.start1, self.start2, self.start3, self.start4, \
             self.size1, self.size2, self.size3, self.size4) \
             = struct.unpack(self.fmt, self.buf)

        self.real_sector = self.sector & 0x3f
        self.real_cylinder = ((self.sector & 0xc0) << 2) + self.cylinder
        self.real_end_sector = self.end_sector & 0x3f
        self.real_end_cylinder = ((self.end_sector & 0xc0) << 2) + self.end_cylinder
        self.start = self.start1 + (self.start2 << 8) + (self.start3 << 16) + (self.start4 << 24)
        self.size = self.size1 + (self.size2 << 8) + (self.size3 << 16) + (self.size4 << 24)

    def show_partition(self):
        print print_fmt % (self.boot_ind, \
                               self.head, self.sector, self.real_sector, self.cylinder, self.real_cylinder, \
                               self.sys_ind, \
                               self.end_head, self.end_sector, self.real_end_sector, self.end_cylinder, self.real_end_cylinder, \
                               self.start, self.size)

partition1_fmt = '446x 16B 50x'
partition2_fmt = '462x 16B 34x'
partition3_fmt = '478x 16B 18x'
partition4_fmt = '494x 16B 2x'
magic_flag_fmt = "510x 2B"
class Mbr:
    "store all partitions information in mbr"
    def __init__(self, mbr_file):
        self.f = file(mbr_file)
        self.buf = self.f.read(512)
        self.partition1 = Partition(self.buf, partition1_fmt)
        self.partition2 = Partition(self.buf, partition2_fmt)
        self.partition3 = Partition(self.buf, partition3_fmt)
        self.partition4 = Partition(self.buf, partition4_fmt)
        self.partition1.get_partition()
        self.partition2.get_partition()
        self.partition3.get_partition()
        self.partition4.get_partition()
        (self.magic1, self.magic2) = struct.unpack(magic_flag_fmt, self.buf)

    def __del__(self):
        pass

    def show(self):
        print "partition1:"
        self.partition1.show_partition()
        print "partition2:"
        self.partition2.show_partition()
        print "partition3:"
        self.partition3.show_partition()
        print "partition4:"
        self.partition4.show_partition()
        print "magic number:"
        print "%02x %02x\n" % (self.magic1, self.magic2)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print "specific a mbr file\n"
        exit(1)
    mbr = Mbr(sys.argv[1])
    mbr.show()
    exit(0)