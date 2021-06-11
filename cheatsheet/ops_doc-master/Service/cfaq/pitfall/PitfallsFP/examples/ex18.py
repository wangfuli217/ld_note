# Example 18: Relative tolerance. This avoids the need to set the tolerance
# value according to the magnitude of the numbers being compared - instead
# the epsilon value can be used to specify the approximate number of correct
# digits (see example 19).

from math import sqrt, fabs

def equal_rel(a, b, eps=1.0e-7):
  m = min(fabs(a), fabs(b))
  return (fabs(a - b) / m) < eps

print "equal_rel(1.0+2.0, 3.0) is %s" % equal_rel(1.0+2.0, 3.0)
print "equal_rel(2.0, sqrt(2.0)**2.0) is %s" % equal_rel(2.0, sqrt(2.0)**2.0)
print "equal_rel(1.0e-8, 2.0e-8) is %s" % equal_rel(1.0e-8, 2.0e-8)

