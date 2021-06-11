# Example 19: Using relative tolerance epsilon to specify the number of
# correct digits required. Some examples of choosing the correct tolerance
# and a demonstration of requesting a tolerance beyond the precision
# of the machine.

from math import sqrt, fabs

def equal_rel(a, b, eps=1.0e-7):
  m = min(fabs(a), fabs(b))
  return (fabs(a - b) / m) < eps

# One correct digit is good enough to pass at 1.0e-1 but not at 1.0e-2
print "equal_rel(1.1, 1.2, 1.0e-1) is %s" % equal_rel(1.1, 1.2, 1.0e-1)
print "equal_rel(1.1, 1.2, 1.0e-2) is %s" % equal_rel(1.1, 1.2, 1.0e-2)

# Two correct digits are good enough to pass at 1.0e-2 but not at 1.0e-3
print "equal_rel(1.1, 1.11, 1.0e-2) is %s" % equal_rel(1.1, 1.11, 1.0e-2)
print "equal_rel(1.1, 1.11, 1.0e-3) is %s" % equal_rel(1.1, 1.11, 1.0e-3)

#
# . . .
#

# Fifteen correct digits are good enough to pass at 1.0e-15 but not at 1.0e-16
print "equal_rel(1.1, 1.100000000000001, 1.0e-15) is %s" % equal_rel(1.1, 1.100000000000001, 1.0e-15)
print "equal_rel(1.1, 1.100000000000001, 1.0e-16) is %s" % equal_rel(1.1, 1.100000000000001, 1.0e-16)

# Going beyond 1.0e-16 for doubles (which is used to implement the Python float
# type in CPython) is requesting more of the representation than it can provide.
# Asking for 1.0e-17 here gives True (on CPython 2.7.3, Linux x86_64) even though
# there are not 17 correct digits.
print "equal_rel(1.1, 1.1000000000000001, 1.0e-16) is %s" % equal_rel(1.1, 1.1000000000000001, 1.0e-17)
print "equal_rel(1.1, 1.1000000000000001, 1.0e-17) is %s" % equal_rel(1.1, 1.1000000000000001, 1.0e-17)
