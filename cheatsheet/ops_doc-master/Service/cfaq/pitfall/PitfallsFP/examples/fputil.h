/**
 * Utilities for the floating point example codes.
 */

/**
 * The bitdouble is used to get access to the bits of a double
 */
typedef union {
  unsigned int bits;
  float flt;
} bitfloat;

/**
 * The bitdouble is used to get access to the bits of a double
 */
typedef union {
  unsigned long long bits;
  double dbl;
} bitdouble;

/**
 * Positive infinity
 */

double get_pos_inf()
{
  bitdouble pos_inf_bd = { .bits = 0x7FF0000000000000 };
  return pos_inf_bd.dbl;
}

/**
 * Negative infinity
 */

double get_neg_inf()
{
  bitdouble neg_inf_bd = { .bits = 0xFFF0000000000000 };
  return neg_inf_bd.dbl;
}

double get_nan()
{
  bitdouble nan_bd = { .bits =  0x7FF1010101010101 };
  return nan_bd.dbl;
}
