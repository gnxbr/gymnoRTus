# converts a f32 file (generated by DASYlab or by abf converter) to i16

from __future__ import division
import common.cfg as cfg
import numpy as np
import sys


MaxVoltage = 10


def main():
    infile = sys.argv[1]
    outfile = sys.argv[2]

    bits = cfg.ADBits
    ratio = (1 << (bits - 1)) / MaxVoltage

    minv = -(1 << (bits - 1)) + 2
    maxv = (1 << (bits - 1)) - 1

    inarr = np.memmap(infile, mode='r', dtype=np.float32)
    outarr = np.memmap(outfile, mode='w+', dtype=np.int16, shape=inarr.shape)

    bufsize = 1 << 25
    for i in xrange(0, len(inarr), bufsize):
        # noinspection PyTypeChecker
        np.clip(np.array(np.round(ratio * inarr[i:i+bufsize]), dtype=np.int16), minv, maxv, outarr[i:i+bufsize])

    outarr.flush()


if __name__ == '__main__':
    main()