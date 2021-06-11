# Example 17: Inappropriate tolerance choice with absolute tolerance.
# Choosing too tight a tolerance may compare numbers that are "similar enough"
# as unequal, and too loose a tolerance considers very "different" numbers
# as equals.

from math import sqrt, fabs

def equal_abs(a, b, eps=1.0e-7):
    return fabs(a - b) < eps

print "equal_abs(2.0, sqrt(2)**2, 1.0e-16) is %s" % equal_abs(2.0, sqrt(2)**2, 1.0e-16)
print "equal_abs(1.0e-8, 2.0e-8) is %s" % equal_abs(1.0e-8, 2.0e-8)

