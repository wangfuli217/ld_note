# Example 20: Attempting to use relative tolerance to compare with an
# expected value of zero, resulting in an Exception.

from math import sqrt, fabs

def equal_rel(a, b, eps=1.0e-7):
  m = min(fabs(a), fabs(b))
  return (fabs(a - b) / m) < eps

equal_rel(1.0-1.0, 0.0)
