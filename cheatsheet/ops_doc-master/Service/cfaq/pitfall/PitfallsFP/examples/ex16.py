# Example 16: Equality with absolute tolerance. This can give more helpful
# comparisons:  numbers that have a difference less than some
# specified epsilon value are considered equal.

from math import sqrt, fabs

def equal_abs(a, b, eps=1.0e-7):
    return fabs(a - b) < eps

print "equal_abs(1.0+2.0, 3.0) is %s" % equal_abs(1.0+2.0, 3.0)

print "equal_abs(sqrt(2.0)**2.0, 2.0) is %s" % equal_abs(2.0, sqrt(2.0)**2.0)


