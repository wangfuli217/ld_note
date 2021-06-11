#include "Numbers.hpp"

#include <algorithm>
#include <sstream>

#include <cassert>
#include <cfloat>
#include <climits>
#include <cmath>
#include <cstring>

#include "intrinsics.h"

#include <iostream>

std::string Integer::toString(void) const {
	return std::to_string(val);
}

Integer::operator long() const {
	return val;
}

Integer::operator double() const {
	return (double) val;
}


std::string Float::toString(void) const {
	if(str.empty()) {
		std::stringstream ss;
		ss << val;
		return ss.str();
	}
	return str;
}

Float::operator long() const {
	return (long) val;
}

Float::operator double() const {
	return val;
}


BigInt::BigInt(long x) : sign(x<0 ? -1 : 1), array(sizeof(long)) {
	unsigned long u = (x == LONG_MIN) ? (LONG_MAX + 1UL) : (x<0 ? -x : x);
	size_t i = 0;
	do {
		array[i++] = u % BASE;
	} while((u /= BASE) > 0 && i < array.size());
	ndigits = i == 0 ? 1 : i;
	for(; i<array.size(); i++)
		array[i] = 0;
}

BigInt::operator long() const {
	if(array.size() == 0)
		return 0;
	long ret = sign;
	for(auto it = array.rbegin(); it!=array.rend(); it++) {
		ret *= BASE;
		ret += *it;
	}
	return ret;
}

BigInt::operator double() const {
	if(array.size() == 0)
		return 0.0;
	double ret = sign;
	for(auto it = array.rbegin(); it!=array.rend(); it++) {
		ret *= BASE;
		ret += *it;
	}
	return ret;
}

std::string BigInt::toString() const {
// BigInt::operator std::string() const {
	std::stringstream ss;
	BigInt q = *this;
	size_t n = ndigits;
	do {
		int r = q.quotient(q, 10);
		ss << "0123456789"[r];
		while (n > 1 && q[n-1] == 0)
			n--;
	} while(n > 1 && q[0] != 0);
	if(sign == -1)
		ss << "-";
	std::string s = ss.str();
	reverse(s.begin(), s.end());
	return s;
}

BigInt BigInt::operator+(const BigInt &y) const {
	if((sign ^ y.sign) == 0) {
		BigInt ret(maxDigits(*this, y)+1);
		ret.add(*this, y);
		ret.sign = ret.isZero() ? 1 : sign;
		return ret;
	}
	if(cmp(y) > 0) {
		BigInt ret(ndigits);
		ret.sub(*this, y);
		ret.sign = ret.isZero() ? 1 : sign;
		return ret;
	}
	BigInt ret(y.ndigits);
	ret.sub(y, *this);
	ret.sign = ret.isZero() ? 1 : -sign;
	return ret;
}

BigInt BigInt::operator-() const {
	BigInt ret = *this;
	ret.sign = isZero() ? 1 : -sign;
	return ret;
}

BigInt BigInt::operator-(const BigInt &y) const {
	return *this + -y;
}

BigInt BigInt::operator*(const BigInt &y) const {
	BigInt ret(ndigits + y.ndigits);
	for(size_t i=0; i<ndigits; i++) {
		unsigned int carry = 0;
		for(size_t j=0; j<y.ndigits; j++) {
			carry += array[i] * y.array[j] + ret.array[i+j];
			ret.array[i+j] = carry % BASE;
			carry /= BASE;
		}
		for(size_t j=y.ndigits; j < ndigits + y.ndigits - i; j++) {
			carry += ret.array[i+j];
			ret.array[i+j] = carry % BASE;
			carry /= BASE;
		}
	}
	ret.normalize();
	ret.sign = (ret.isZero() || ((sign ^ y.sign) == 0)) ? 1 : -1;
	return ret;
}

BigInt BigInt::operator*(const long &y) const {
	return *this * BigInt(y);
}

BigInt BigInt::operator/(const BigInt &y) const {
	BigInt q, r;
	div(y, &q, &r);
	if(((sign ^ y.sign) != 0) && !r.isZero()) {
		int carry = q.add_loop(q.array.size(), q, 1);
		assert(carry == 0);
		q.normalize();
	}
	return q;
}

BigInt BigInt::operator%(const BigInt &y) const {
	BigInt q, r;
	div(y, &q, &r);
	if(((sign ^ y.sign) != 0) && !r.isZero()) {
		int borrow = r.sub_loop(r.array.size(), r, y, 0);
		assert(borrow == 0);
		r.normalize();
	}
	return r;
}

BigInt BigInt::operator>>(unsigned long y) const {
	if(y > ndigits)
		return isPos() ? ZERO : -ONE;
	BigInt ret((ndigits - y + CHAR_BIT - 1) / CHAR_BIT);
	size_t offset = y / CHAR_BIT;
	size_t shift = y % CHAR_BIT;
	for(size_t i = 0; i+offset < array.size(); i++)
		ret[i] = array[i + offset] >> shift;
	ret.sign = sign;
	ret.normalize();
	return ret;
}

BigInt BigInt::operator>>(int y) const {
	return *this >> ((unsigned long) y);
}

bool BigInt::operator<(const BigInt &y) const {
	return (y - *this).isPos();
}

bool BigInt::operator<=(const BigInt &y) const {
	return (*this == y) || (*this < y);
}

bool BigInt::operator>(const BigInt &y) const {
	return (*this - y).isPos();
}

bool BigInt::operator>=(const BigInt &y) const {
	return (*this == y) || (*this > y);
}

BigInt BigInt::abs() const {
	BigInt ret = *this;
	ret.sign = 1;
	return ret;
}

long BigInt::signum(void) const {
	if(isZero())
		return 0;
	return sign;
}

BigInt BigInt::gcd(const BigInt &d) const {
	BigInt a = *this;
	BigInt b = d;
	while(!b.isZero()) {
		BigInt temp = b;
		b = a % b;
		a = temp;
	}
	return a;
}

const BigInt BigInt::ZERO((long)0);
const BigInt BigInt::ONE((long)1);
const BigInt BigInt::TEN((long)10);

bool BigInt::isZero(void) const {
	return ndigits == 1 && array[0] == 0;
}

BigInt BigInt::pow(BigInt y) const {
	if(isZero())
		return ZERO;
	if(y.isZero())
		return ONE;
	if(isOne())
		return BigInt((long)((y[0] & 1) ? sign : 1));
	BigInt z = *this;
	BigInt u((long)1);
	while(ONE < y) {
		if(y.isOdd())
			u = u * z;
		z = z * z;
		y = y >> 1;
	}
	return z;
}

BigInt BigInt::divide(const BigInt &y, BigInt *q) const {
	BigInt ret;
	div(y, q, &ret);
	return ret;
}

long BigInt::divide(long y, BigInt *q) const {
	if(y == 0)
		throw std::domain_error("Divide by zero error.");
	if(y < 0) {
		q->sign = -1;
		y = -y;
	}
	q->sign *= sign;
	int i = array.size() - 1;
	long ret = 0;
	while(ret / y == 0 && i >= 0) {
		ret = ret * BASE + array[i];
		i--;
	}
	if(i < 0)
		return ret;
	for(q->array = std::vector<unsigned char>(i+1); i >= 0; i--) {
		q->array[i] = ret / y;
		ret = (ret % y) * BASE + array[i];
	}
	q->normalize();
	return ret;
}

bool BigInt::isOne(void) const {
	return ndigits == 1 && array[0] == 1;
}

bool BigInt::isOdd(void) const {
	return array[0] & 1;
}

bool BigInt::isPos(void) const {
	return sign > 0;
}

size_t BigInt::maxDigits(const BigInt &x, const BigInt &y) {
	return (x.ndigits > y.ndigits) ? x.ndigits : y.ndigits;
}

void BigInt::add(const BigInt &x, const BigInt &y) {
	size_t n = y.ndigits;
	if(x.ndigits < n)
		return add(y, x);
	if(x.ndigits > n) {
		int carry = add_loop(n, x, y, 0);
		array[array.size()-1] = add_loop(n, x, carry);
	} else {
		array[n] = add_loop(n, x, y, 0);
	}
	normalize();
}

int BigInt::add_loop(size_t n, const BigInt &x, int carry) {
	for(; n<x.ndigits; n++) {
		carry += x.array[n];
		array[n] = carry % BASE;
		carry /= BASE;
	}
	return carry;
}

int BigInt::add_loop(size_t n, const BigInt &x, const BigInt &y, int carry) {
	for(size_t i=0; i<n; i++) {
		carry += x.array[i] + y.array[i];
		array[i] = carry % BASE;
		carry /= BASE;
	}
	return carry;
}

void BigInt::sub(const BigInt &x, const BigInt &y) {
	size_t n = y.ndigits;
	int borrow = sub_loop(n, x, y, 0);
	if(x.ndigits > n)
		borrow = sub_loop(n, x, borrow);
	assert(borrow == 0);
	normalize();
}

int BigInt::sub_loop(size_t n, const BigInt &x, int borrow) {
	for(; n<x.ndigits; n++) {
		int d = x.array[n] + BASE - borrow;
		array[n] = d % BASE;
		borrow = 1 - d / BASE;
	}
	return borrow;
}

int BigInt::sub_loop(size_t n, const BigInt &x, const BigInt &y, int borrow) {
	for(size_t i=0; i<n; i++) {
		int d = x.array[i] + BASE - borrow - y.array[i];
		array[i] = d % BASE;
		borrow = 1 - d / BASE;
	}
	return borrow;
}

static int product(size_t n, unsigned char *z, const std::vector<unsigned char> &x, int y) {
	unsigned int carry = 0;
	for(size_t i=0; i<n; i++) {
		carry += x[i] * y;
		z[i] = carry % BASE;
		carry /= BASE;
	}
	return carry;
}

void BigInt::div(const BigInt &y, BigInt *q, BigInt *r) const {
	*q = BigInt(ndigits, true);
	*r = BigInt(y.ndigits, true);
	std::unique_ptr<unsigned char[]> tmp(new unsigned char[ndigits + y.ndigits + 2]);
	size_t n = length();
	size_t m = y.length();
	if(m == 1) {
		if(y[0] == 0)
			throw std::domain_error("Divide by zero error.");
		r->array[0] = q->quotient(*this, y.array[0]);
		for(size_t i=1; i<r->array.size(); i++)
			r->array[i] = 0;

	} else if(m > n) {
		q->array.assign(q->array.size(), 0);
		r->array = array;
	} else {
		unsigned char *rem = &tmp[0];
		unsigned char *dq = &tmp[n + 1];
		assert(2 <= m);
		assert(m <= n);
		for(size_t i=0; i<n; i++)
			rem[i] = array[i];
		rem[n] = 0;
		for(int k=n-m; k>=0; k--) {
			assert(2 <= m);
			assert(m <= k+m);
			assert(k+m <= n);
			int km = k + m;
			unsigned long y2 = y[m-1] * BASE + y[m-2];
			unsigned long r3 = (rem[km] * BASE + rem[km-1]) * BASE + rem[km-2];
			int q_k = r3/y2;
			if (q_k >= BASE)
				q_k = BASE - 1;
			dq[m] = product(m, dq, y.array, q_k);
			size_t i;
			for (i=m; i>0; i--)
				if (rem[i+k] != dq[i])
					break;
			if (rem[i+k] < dq[i])
				dq[m] = product(m, dq, y.array, --q_k);
			q->array[k] = q_k;
			assert(0 <= k);
			assert ((unsigned int)k <= k+m);
			// int borrow = XP_sub(m + 1, &rem[k], &rem[k], dq, 0);
			// int XP_sub(int n, T z, T x, T y, int borrow) 
			int borrow = 0;
			for (i = 0; i < n; i++) {
				int d = rem[k+i] + BASE - borrow - dq[i];
				rem[k+i] = d%BASE;
				borrow = 1 - d/BASE;
			}
			assert(borrow == 0);
		}	
		for(size_t i=0; i<m; i++)
			r->array[i] = rem[i];
		for (size_t i=n-m+1; i<q->array.size(); i++)
			q->array[i] = 0;
		for (size_t i=m; i<r->array.size(); i++)
			r->array[i] = 0;
	}

	q->normalize();
	r->normalize();
	q->sign = (q->isZero() || ((sign ^ y.sign) == 0)) ? 1 : -1;
}

int BigInt::quotient(const BigInt &x, int y) {
	unsigned int carry = 0;
	for(int i=x.array.size()-1; i>=0; i--) {
		carry = carry * BASE + x[i];
		array[i] = carry / y;
		carry %= y;
	}
	return carry;
}

size_t BigInt::length() const {
	size_t n = array.size();
	while(n>1 && array[n-1] == 0)
		n--;
	return n;  
}

void BigInt::normalize(void) {
	ndigits = length();
}

int BigInt::bitLengthForInt(unsigned int x) {
	return sizeof(x) - clz(x);
}

int BigInt::cmp(const BigInt &y) const {
	if(ndigits == y.ndigits) {
		size_t i = ndigits - 1;
		while(i>0 && array[i]==y.array[i])
			i--;
		return array[i]==y.array[i];
	}
	return ndigits - y.ndigits;
}

int BigInt::bitLength() {
	normalize();
	if(ndigits == 0)
		return 0;
	int magBitLength = ((ndigits - 1) << 5) + bitLengthForInt(array[ndigits - 1]);
	if (signum() < 0) {
		// Check if magnitude is a power of 2
		bool pow2 = (popcount(array[ndigits - 1]) == 1);
		for(int i=ndigits - 2; i>=0 && pow2; i--)
			pow2 = (array[i] == 0);
		return (pow2 ? magBitLength - 1 : magBitLength);
	}
	return magBitLength;
}

typedef enum {
	ROUND_UP,
	ROUND_DOWN,
	ROUND_CEILING,
	ROUND_FLOOR,
	ROUND_HALF_UP,
	ROUND_HALF_DOWN,
	ROUND_HALF_EVEN,
	ROUND_UNNECESSARY,
} roundingMode;


// BigDecimal
static const long LONG_TEN_POWERS_TABLE[] = {
	1,                     // 0 / 10^0
	10,                    // 1 / 10^1
	100,                   // 2 / 10^2
	1000,                  // 3 / 10^3
	10000,                 // 4 / 10^4
	100000,                // 5 / 10^5
	1000000,               // 6 / 10^6
	10000000,              // 7 / 10^7
	100000000,             // 8 / 10^8
	1000000000,            // 9 / 10^9
	10000000000L,          // 10 / 10^10
	100000000000L,         // 11 / 10^11
	1000000000000L,        // 12 / 10^12
	10000000000000L,       // 13 / 10^13
	100000000000000L,      // 14 / 10^14
	1000000000000000L,     // 15 / 10^15
	10000000000000000L,    // 16 / 10^16
	100000000000000000L,   // 17 / 10^17
	1000000000000000000L   // 18 / 10^18
};
static const size_t LONG_TEN_POWERS_TABLE_COUNT = sizeof(LONG_TEN_POWERS_TABLE)/sizeof(LONG_TEN_POWERS_TABLE[0]);
static const long THRESHOLDS_TABLE[] = {
	LONG_MAX,                     // 0
	LONG_MAX/10L,                 // 1
	LONG_MAX/100L,                // 2
	LONG_MAX/1000L,               // 3
	LONG_MAX/10000L,              // 4
	LONG_MAX/100000L,             // 5
	LONG_MAX/1000000L,            // 6
	LONG_MAX/10000000L,           // 7
	LONG_MAX/100000000L,          // 8
	LONG_MAX/1000000000L,         // 9
	LONG_MAX/10000000000L,        // 10
	LONG_MAX/100000000000L,       // 11
	LONG_MAX/1000000000000L,      // 12
	LONG_MAX/10000000000000L,     // 13
	LONG_MAX/100000000000000L,    // 14
	LONG_MAX/1000000000000000L,   // 15
	LONG_MAX/10000000000000000L,  // 16
	LONG_MAX/100000000000000000L, // 17
	LONG_MAX/1000000000000000000L // 18
};
static const size_t THRESHOLDS_TABLE_COUNT = sizeof(THRESHOLDS_TABLE)/sizeof(THRESHOLDS_TABLE[0]);
static_assert(LONG_TEN_POWERS_TABLE_COUNT == THRESHOLDS_TABLE_COUNT, "LONG_TEN_POWERS_TABLE and THRESHOLDS_TABLE are different sizes.");
static_assert(sizeof(long) <= 8, "LONG_TEN_POWERS_TABLE and THRESHOLDS_TABLE are not large enough.  They are only designed for up to 64 bit longs.");

class BigDecimal : public Number {
	public:
		BigDecimal(double x);
		BigDecimal(BigInt x) : intVal((intCompact != INFLATED) ? BigInt() : x),
			intCompact(compactValFor(x)) {};
		BigDecimal(BigInt x, int scale) : BigDecimal(x) {this->scale = scale;};

		static BigDecimal valueOf(long val);
		static BigDecimal valueOf(long unscaledVal, int scale);

		explicit virtual operator long() const;
		explicit virtual operator double() const;
		// virtual operator std::string() const;
		std::string toString() const;

		bool operator==(const BigDecimal &y) const;
		bool equiv(const BigDecimal &y) const;
		BigDecimal operator+(const BigDecimal &y) const;
		BigDecimal operator-() const;
		BigDecimal operator-(const BigDecimal &y) const;
		BigDecimal operator*(const BigDecimal &y) const;
		// BigDecimal operator*(const long &y) const;
		BigDecimal operator/(BigDecimal &y);
		BigDecimal operator%(BigDecimal &y);
		BigDecimal divideToIntegralValue(BigDecimal &y);
		BigDecimal divide(BigDecimal &y, int mcPrecision, roundingMode rm);
		bool operator<(BigDecimal &y);
		bool operator<=(BigDecimal &y);
		bool operator>(BigDecimal &y);
		bool operator>=(BigDecimal &y);
		BigDecimal abs() const;

		BigInt toBigInt() const;

		int signum() const;
		int getPrecision() const;
		int getScale() const;
		// int unscaledValue();

		static const BigDecimal ONE;
	private:
		BigDecimal(BigInt intVal, long val, int scale, int prec) :
		intVal(intVal), intCompact(val), scale(scale), precision(prec) { };

		BigDecimal() = default;

		BigDecimal setScale(int newscale, roundingMode rm) const;
		BigInt inflate() const;
		int checkScale(long val) const;
		BigInt bigMultiplyPowerTen(int n) const;
		BigDecimal stripZerosToMatchScale(long preferredScale);
		int compareMagnitude(const BigDecimal &val) const;
		int cmp(const BigDecimal &y) const;

		BigInt intVal;
		long intCompact;
		int scale;
		int precision;

		static long longMultiplyPowerTen(long val, int n);
		static BigInt bigTenToThe(int n);
		static BigDecimal divideAndRound(long ldividend, const BigInt bdividend, long ldivisor, const BigInt bdivisor,
		int scale, roundingMode rm, int preferredScale);
		static int longCompareMagnitude(long x, long y);
		static long compactValFor(BigInt b);
		static int longDigitLength(long x);
		static int bigDigitLength(BigInt b);
		static int saturateLong(long s);
		static BigDecimal doRound(BigDecimal &d, int mcPrecision, roundingMode rm);

		static const long INFLATED = LONG_MIN;
		static const std::vector<BigDecimal> zeroThroughTen;
		static const std::vector<BigDecimal> ZERO_SCALED_BY;

		friend BigDecimal BigInt::toBigDecimal(int sign, int scale) const;
};

const std::vector<BigDecimal> BigDecimal::zeroThroughTen({
	BigDecimal(BigInt::ZERO,  0,  0, 1),
	BigDecimal(BigInt::ONE,   1,  0, 1),
	BigDecimal(BigInt(2),     2,  0, 1),
	BigDecimal(BigInt(3),     3,  0, 1),
	BigDecimal(BigInt(4),     4,  0, 1),
	BigDecimal(BigInt(5),     5,  0, 1),
	BigDecimal(BigInt(6),     6,  0, 1),
	BigDecimal(BigInt(7),     7,  0, 1),
	BigDecimal(BigInt(8),     8,  0, 1),
	BigDecimal(BigInt(9),     9,  0, 1),
	BigDecimal(BigInt::TEN,   10, 0, 2),
});

const std::vector<BigDecimal> BigDecimal::ZERO_SCALED_BY({
	zeroThroughTen[0],
	BigDecimal(BigInt::ZERO, 0, 1, 1),
	BigDecimal(BigInt::ZERO, 0, 2, 1),
	BigDecimal(BigInt::ZERO, 0, 3, 1),
	BigDecimal(BigInt::ZERO, 0, 4, 1),
	BigDecimal(BigInt::ZERO, 0, 5, 1),
	BigDecimal(BigInt::ZERO, 0, 6, 1),
	BigDecimal(BigInt::ZERO, 0, 7, 1),
	BigDecimal(BigInt::ZERO, 0, 8, 1),
	BigDecimal(BigInt::ZERO, 0, 9, 1),
	BigDecimal(BigInt::ZERO, 0, 10, 1),
	BigDecimal(BigInt::ZERO, 0, 11, 1),
	BigDecimal(BigInt::ZERO, 0, 12, 1),
	BigDecimal(BigInt::ZERO, 0, 13, 1),
	BigDecimal(BigInt::ZERO, 0, 14, 1),
	BigDecimal(BigInt::ZERO, 0, 15, 1),
});



BigDecimal BigInt::toBigDecimal(int, int scale) const {
	if(isZero())
		return BigDecimal::valueOf(0, scale);
	if(ndigits > sizeof(long) || (ndigits == sizeof(long) && (char) array[sizeof(long) - 1] < 0))
		return BigDecimal(*this, BigDecimal::INFLATED, scale, 0);
	return BigDecimal(BigInt(), (long)*this, scale, 0);
}

#define SIGN_BIT (((uint64_t) 1) << (CHAR_BIT * sizeof(double) - 1))
#define EXPONENT_SHIFT (DBL_MANT_DIG - 1)
#define EXPONENT_MASK ((1 << (CHAR_BIT * sizeof(double) - DBL_MANT_DIG)) - 1)
#define EXPONENT(x) ((x) >> EXPONENT_SHIFT) & EXPONENT_MASK
#define EXPONENT_BIAS 1023    // This should be deducible from cfloat, but I'm not sure how.
#define FRACTION_MASK ((1L << EXPONENT_SHIFT) - 1)
#define IMPLICIT_ONE (1L << EXPONENT_SHIFT)
BigDecimal::BigDecimal(double val) {
	if(!std::isfinite(val))
		throw std::runtime_error("Infinite or Not a number");
	static_assert(sizeof(double) == 8, "Expected 64 bit doubles");
	static_assert(sizeof(long) == 8, "Expected 64 bit longs");
	uint64_t valBits;
	memcpy(&valBits, &val, sizeof(val));
	int sign = valBits & SIGN_BIT ? -1 : 1;
	int exponent = (int) EXPONENT(valBits);
	long significand = exponent==0 ? (valBits & FRACTION_MASK) << 1
		: (valBits & FRACTION_MASK) | IMPLICIT_ONE;
	exponent -= EXPONENT_BIAS + EXPONENT_SHIFT;
	// At this point, val == sign * significand * 2**exponent.

	if(significand == 0) {
		intVal = BigInt::ZERO;
		intCompact = 0;
		precision = 1;
		return;
	}

	// Normalize
	while((significand & 1) == 0) {
		significand >>= 1;
		exponent++;
	}

	long s = sign * significand;
	BigInt b;
	if (exponent < 0) {
		b = BigInt(2).pow(-exponent) * s;
		scale = -exponent;
	} else if (exponent > 0) {
		b = BigInt(2).pow(exponent) * s;
	} else {
		b = BigInt(s);
	}
	intCompact = compactValFor(b);
	intVal = (intCompact != INFLATED) ? BigInt() : b;
}

BigDecimal BigDecimal::valueOf(long val) {
	if(val != INFLATED)
		return BigDecimal(BigInt(), val, 0, 0);
	return BigDecimal(BigInt(val), val, 0, 0);
}

BigDecimal BigDecimal::valueOf(long unscaledVal, int scale) {
	if(scale == 0)
		return valueOf(unscaledVal);
	if(unscaledVal == 0)
		return BigDecimal(BigInt::ZERO, 0, scale, 1);
	return BigDecimal(unscaledVal == INFLATED ? BigInt(unscaledVal) : BigInt(), unscaledVal, scale, 0);
}

BigDecimal::operator long() const {
	return (intCompact != INFLATED && scale == 0) ?
		intCompact : (long)toBigInt();
}

BigInt BigDecimal::toBigInt() const {
	return setScale(0, ROUND_UNNECESSARY).inflate();
}

BigDecimal::operator double() const {
	if (scale == 0 && intCompact != INFLATED)
		return (double)intCompact;
	return std::stod(this->toString());
}

std::string BigDecimal::toString() const {
// BigDecimal::operator std::string() const {
	if (scale == 0)                      // zero scale is trivial
		return (intCompact != INFLATED) ? std::to_string(intCompact) : intVal.toString();
	// Get the significand as an absolute value
	std::string coeff = (intCompact != INFLATED) ? std::to_string(intCompact)
		: intVal.abs().toString();
	std::stringstream ss;
	if(signum() < 0)
		ss << "-";
	long coeffLen = coeff.length();
	if ((scale >= 0) && (coeffLen - scale >= -5)) { // plain number
		int pad = scale - coeffLen;           // count of padding zeros
		if (pad >= 0) {                       // 0.xxx form
			ss << "0.";
			for (; pad>0; pad--)
				ss << '0';
			ss << coeff;
		} else {                              // xx.xx form
			ss << coeff.substr(0, -pad) << '.';
			ss << coeff.substr(-pad);
		}
	} else {
		ss << coeff.substr(0, 1);             // first character
		if (coeffLen > 1)                     // more to come
			ss << '.' << coeff.substr(1);
	}
	return ss.str();
}

bool BigDecimal::operator==(const BigDecimal &y) const {
	if(this == &y)
		return true;
	if (scale != y.scale)
		return false;
	long s = intCompact;
	long ys = y.intCompact;
	if (s != INFLATED) {
		if (ys == INFLATED)
			ys = compactValFor(y.intVal);
		return ys == s;
	} else if (ys != INFLATED)
		return ys == compactValFor(intVal);
	return inflate() == y.inflate();
}

bool BigDecimal::equiv(const BigDecimal &y) const {
	return cmp(y) == 0;
}

BigDecimal BigDecimal::operator+(const BigDecimal &y) const {
	long xs = intCompact;
	long ys = y.intCompact;
	BigInt fst = (xs != INFLATED) ? BigInt() :   intVal;
	BigInt snd = (ys != INFLATED) ? BigInt() : y.intVal;
	int rscale = scale;

	long sdiff = (long)rscale - y.scale;
	if(sdiff != 0) {
		if(sdiff < 0) {
			int raise = checkScale(-sdiff);
			rscale = y.scale;
			if(xs == INFLATED || (xs = longMultiplyPowerTen(xs, raise)) == INFLATED)
				fst = bigMultiplyPowerTen(raise);
		} else {
			int raise = y.checkScale(sdiff);
			if(ys == INFLATED || (ys = longMultiplyPowerTen(ys, raise)) == INFLATED)
				snd = y.bigMultiplyPowerTen(raise);
		}
	}
	if(xs != INFLATED && ys != INFLATED) {
		long sum = xs + ys;
		// See "Hacker's Delight" section 2-12 for explanation of the overflow test.
		if( (((sum ^ xs) & (sum ^ ys))) >= 0L) // not overflowed
			return valueOf(sum, rscale);
	}
	if(fst.isNull())
		fst = BigInt(xs);
	if(snd.isNull())
		snd = BigInt(ys);
	BigInt sum = fst + snd;
	return (fst.signum() == snd.signum()) ?
		BigDecimal(sum, INFLATED, rscale, 0) :
		BigDecimal(sum, rscale);
}

BigDecimal BigDecimal::operator-() const {
	if (intCompact != INFLATED)
		return valueOf(-intCompact, scale);
	BigDecimal result(-intVal, scale);
	result.precision = precision;
	return result;
}

BigDecimal BigDecimal::operator-(const BigDecimal &y) const {
	return *this + -y;
}

BigDecimal BigDecimal::operator*(const BigDecimal &y) const {
	long xl = intCompact;
	long yl = y.intCompact;
	int productScale = checkScale((long)scale + y.scale);

	// Might be able to do a more clever check incorporating the
	// inflated check into the overflow computation.
	if (xl != INFLATED && yl != INFLATED) {
		/*
		* If the product is not an overflowed value, continue
		* to use the compact representation.  if either of x or y
		* is INFLATED, the product should also be regarded as
		* an overflow. Before using the overflow test suggested in
		* "Hacker's Delight" section 2-12, we perform quick checks
		* using the precision information to see whether the overflow
		* would occur since division is expensive on most CPUs.
		*/
		long product = xl * yl;
		long prec = getPrecision() + y.getPrecision();
		if (prec < 19 || (prec < 21 && (yl == 0 || product / yl == xl)))
			return BigDecimal::valueOf(product, productScale);
		return BigDecimal(BigInt(xl) * yl, INFLATED, productScale, 0);
	}
	BigInt rb;
	if (xl == INFLATED && yl == INFLATED)
		rb = intVal * y.intVal;
	else if (xl != INFLATED)
		rb = y.intVal * xl;
	else
		rb = intVal * yl;
	return BigDecimal(rb, INFLATED, productScale, 0);
}

BigDecimal BigDecimal::operator/(BigDecimal &divisor) {
	// Handle zero cases first.
	if (divisor.signum() == 0) {   // x/0
		if (signum() == 0)    // 0/0
			throw std::domain_error("Division undefined.");
		throw std::domain_error("Divide by zero error.");
	}
	// Calculate preferred scale
	int preferredScale = saturateLong((long)scale - divisor.scale);
	if (signum() == 0)        // 0/y
		return (preferredScale >= 0 && preferredScale < (int)ZERO_SCALED_BY.size()) ?
			ZERO_SCALED_BY[preferredScale] :
			valueOf(0, preferredScale);
	inflate();
	divisor.inflate();
	int precision = (int)std::min(getPrecision() + (long)ceil(10.0*divisor.getPrecision()/3.0),
	(long)INT_MAX);
	BigDecimal quotient;
	try {
		quotient = divide(divisor, precision, ROUND_UNNECESSARY);
	} catch (const std::runtime_error&) {
		throw std::runtime_error("Non-terminating decimal expansion; no exact representable decimal result.");
	}
	int quotientScale = quotient.scale;
	if (preferredScale > quotientScale)
		return quotient.setScale(preferredScale, ROUND_UNNECESSARY);
	return quotient;
}

BigDecimal BigDecimal::operator%(BigDecimal &y) {
	BigDecimal quotient = divideToIntegralValue(y);
	return *this - (quotient * y);
}

BigDecimal BigDecimal::divideToIntegralValue(BigDecimal &y) {
	int preferredScale = saturateLong((long)scale - y.scale);
	if (compareMagnitude(y) < 0) {
		// much faster when this << divisor
		return BigDecimal::valueOf(0, preferredScale);
	}
	if(signum() == 0 && y.signum() != 0)
		return setScale(preferredScale, ROUND_UNNECESSARY);

	int maxDigits = (int)std::min(getPrecision() + (long)std::ceil(10.0*y.getPrecision()/3.0)
			+ std::abs((long)scale - y.scale) + 2, (long)INT_MAX);
	BigDecimal quotient = divide(y, maxDigits, ROUND_DOWN);
	if (quotient.scale > 0) {
		quotient = quotient.setScale(0, ROUND_DOWN);
		quotient.stripZerosToMatchScale(preferredScale);
	}
	if (quotient.scale < preferredScale)
		quotient = quotient.setScale(preferredScale, ROUND_UNNECESSARY);
	return quotient;
}

bool BigDecimal::operator<(BigDecimal &y) {
	return cmp(y) < 0;
}

bool BigDecimal::operator<=(BigDecimal &y) {
	return cmp(y) <= 0;
}

bool BigDecimal::operator>(BigDecimal &y) {
	return cmp(y) > 0;
}

bool BigDecimal::operator>=(BigDecimal &y) {
	return cmp(y) >= 0;
}

BigDecimal BigDecimal::abs() const {
	return signum() < 0 ? -*this : *this;
}

int BigDecimal::signum() const {
	if(intCompact != INFLATED) {
		return intCompact == 0 ? 0 : intCompact > 0 ? 1 : -1;
	}
	return intVal.signum();
}

int BigDecimal::getPrecision() const {
	if(precision)
		return precision;
	long s = intCompact;
	if (s != INFLATED)
		return longDigitLength(s);
	return bigDigitLength(inflate());
}

int BigDecimal::getScale() const {
	return scale;
}

// int BigDecimal::unscaledValue() {
// 	return inflate();
// }

const BigDecimal BigDecimal::ONE = BigDecimal(BigInt::ONE, 1, 0, 1);

BigDecimal BigDecimal::setScale(int newscale, roundingMode rm) const {
	int oldscale = scale;
	if(newscale == oldscale)
		return *this;
	if(signum() == 0)
		return valueOf(0, newscale);
	long rs = intCompact;
	if(newscale > oldscale) {
		int raise = checkScale((long)newscale - oldscale);
		BigInt rb;
		if(rs == INFLATED || (rs = longMultiplyPowerTen(rs, raise)) == INFLATED)
			rb = bigMultiplyPowerTen(raise);
		return BigDecimal(rb, rs, newscale, (precision > 0) ? precision + raise : 0);
	}
	int drop = checkScale((long)oldscale - newscale);
	if(drop < (int)LONG_TEN_POWERS_TABLE_COUNT)
		return divideAndRound(rs, intVal, LONG_TEN_POWERS_TABLE[drop], BigInt(), newscale, rm, newscale);
	return divideAndRound(rs, intVal, INFLATED, bigTenToThe(drop), newscale, rm, newscale);
}

BigInt BigDecimal::inflate() const {
	if(intVal.isNull())
		return BigInt(intCompact);
	return intVal;
}

int BigDecimal::checkScale(long val) const {
	int asInt = (int)val;
	if(asInt != val) {
		asInt = val>INT_MAX ? INT_MAX : INT_MIN;
		BigInt b;
		if(intCompact && ((b = intVal).isNull() || b.signum()))
			if(asInt>0)
				throw std::underflow_error("");
		throw std::overflow_error("");
	}
	return asInt;
}

BigInt BigDecimal::bigMultiplyPowerTen(int n) const {
	if(n <= 0) {
		BigDecimal a = *this;
		return a.inflate();
	}
	if(intCompact != INFLATED)
		return bigTenToThe(n) * intCompact;
	return intVal * bigTenToThe(n);
}

BigDecimal BigDecimal::stripZerosToMatchScale(long preferredScale) {
	inflate();
	BigInt q;
	long r;
	while(intVal.cmp(BigInt::TEN) >= 0 && scale > preferredScale) {
		if(intVal[0] & 1)
			break;
		r = intVal.divide(10, &q);
		if(r != 0)
			break;
		intVal = q;
		scale = checkScale((long)scale - 1);
		if(precision > 0)
			precision--;
	}
	if(!intVal.isNull())
		intCompact = compactValFor(intVal);
	return *this;
}

BigDecimal BigDecimal::divide(BigDecimal &y, int mcPrecision, roundingMode rm) {
	if (mcPrecision == 0)
		return *this / y;
	long preferredScale = (long)scale - y.scale;
	if (y.signum() == 0) {		// x/0
		if (signum() == 0)		// 0/0
			throw std::domain_error("Division undefined.");
		throw std::domain_error("Divide by zero error.");
	}
	if (signum() == 0)			// 0/y
		return BigDecimal(BigInt::ZERO, 0, saturateLong(preferredScale), 1);
	int xscale = getPrecision();
	int yscale = y.getPrecision();
	BigDecimal dividend(dividend.intVal, dividend.intCompact, xscale, xscale);
	BigDecimal divisor (divisor.intVal,  divisor.intCompact,  yscale, yscale);
	if (dividend.compareMagnitude(divisor) > 0)		// satisfy constraint (b)
		yscale = divisor.scale -= 1;
	int scl = checkScale(preferredScale + yscale - xscale + mcPrecision);
	if (checkScale((long)mcPrecision + yscale) > xscale)
		dividend = dividend.setScale(mcPrecision + yscale, ROUND_UNNECESSARY);
	else
		divisor = divisor.setScale(checkScale((long)xscale - mcPrecision), ROUND_UNNECESSARY);
	BigDecimal quotient = divideAndRound(dividend.intCompact, dividend.intVal, divisor.intCompact,
			divisor.intVal, scl, rm, checkScale(preferredScale));
	quotient = doRound(quotient, mcPrecision, rm);
	return quotient;
}

int BigDecimal::compareMagnitude(const BigDecimal &val) const {
	long ys = val.intCompact;
	long xs = intCompact;
	if (xs == 0)
		return (ys == 0) ? 0 : -1;
	if (ys == 0)
		return 1;
	int sdiff = scale - val.scale;
	if (sdiff != 0) {
		int xae = getPrecision() - scale;           // [-1]
		int yae = val.getPrecision() - val.scale;   // [-1]
		if (xae < yae)
			return -1;
		if (xae > yae)
			return 1;
		if (sdiff < 0) {
			if( (xs == INFLATED ||
						(xs = longMultiplyPowerTen(xs, -sdiff)) == INFLATED) &&
					ys == INFLATED) {
				BigInt rb = bigMultiplyPowerTen(-sdiff);
				return rb.cmp(val.intVal);
			}
		} else { // sdiff > 0
			if( (ys == INFLATED ||
						(ys = longMultiplyPowerTen(ys, sdiff)) == INFLATED) &&
					xs == INFLATED) {
				BigInt rb = val.bigMultiplyPowerTen(sdiff);
				return intVal.cmp(rb);
			}
		}
	}

	if (xs != INFLATED)
		return (ys != INFLATED) ? longCompareMagnitude(xs, ys) : -1;
	if (ys != INFLATED)
		return 1;
	return intVal.cmp(val.intVal);
}

int BigDecimal::cmp(const BigDecimal &y) const {
	if (scale == y.scale) {
		long xs = intCompact;
		long ys = y.intCompact;
		if (xs != INFLATED && ys != INFLATED)
			return xs != ys ? ((xs > ys) ? 1 : -1) : 0;
	}

	int xsign = signum();
	int ysign = y.signum();
	if (xsign != ysign)
		return (xsign > ysign) ? 1 : -1;
	if (xsign == 0)
		return 0;
	int cmp = compareMagnitude(y);
	return (xsign > 0) ? cmp : -cmp;
}

long BigDecimal::longMultiplyPowerTen(long val, int n) {
	if (val == 0 || n <= 0)
		return val;
	if (n < (int)LONG_TEN_POWERS_TABLE_COUNT) {
		long tenpower = LONG_TEN_POWERS_TABLE[n];
		if (val == 1)
			return tenpower;
		if (::abs(val) <= THRESHOLDS_TABLE[n])
			return val * tenpower;
	}
	return INFLATED;
}

BigInt BigDecimal::bigTenToThe(int n) {
	return BigInt(10).pow(BigInt(n));
}

BigDecimal BigDecimal::divideAndRound(long ldividend, const BigInt bdividend, long ldivisor, const BigInt bdivisor,
		int scale, roundingMode rm, int preferredScale) {
	bool isRemainderZero;   // record remainder is zero or not
	int qsign;              // quotient sign
	long q, r;              // store quotient & remainder in long
	BigInt mq;              // store quotient
	BigInt mr;              // store remainder
	BigInt mdivisor;
	BigInt mdividend;
	bool isLongDivision = (ldividend != INFLATED && ldivisor != INFLATED);
	if(isLongDivision) {
		q = ldividend / ldivisor;
		if(rm == ROUND_DOWN && scale == preferredScale)
			return BigDecimal(BigInt(), q, scale, 0);
		r = ldividend % ldivisor;
		isRemainderZero = (r == 0);
		qsign = ((ldividend < 0) == (ldivisor < 0)) ? 1 : -1;
	} else {
		mdividend = bdividend.isNull() ? BigInt(ldividend) : bdividend;
		if (ldivisor != INFLATED) {
			r = mdividend.divide(ldivisor, &mq);
			isRemainderZero = (r == 0);
			qsign = (ldivisor < 0) ? -bdividend.signum() : bdividend.signum();
		} else {
			mdivisor = bdivisor;
			mr = mdividend.divide(mdivisor, &mq);
			isRemainderZero = mr.isZero();
			qsign = (bdividend.signum() != bdivisor.signum()) ? -1 : 1;
		}
	}
	bool increment = false;
	if(!isRemainderZero) {
		switch(rm) {
			case ROUND_UNNECESSARY:
				throw std::runtime_error("Rounding necessary");
			case ROUND_UP:
				increment = true;
				break;
			case ROUND_DOWN:
				increment = false;
				break;
			case ROUND_CEILING:
				increment = (qsign > 0);
				break;
			case ROUND_FLOOR:
				increment = (qsign < 0);
				break;
			default: {
				 int cmpFracHalf;
				 if(isLongDivision || ldivisor != INFLATED) {
					 if(r <= LONG_MIN >> 1 || r >= LONG_MAX >> 1)
						 cmpFracHalf = 1;
					 else
						 cmpFracHalf = longCompareMagnitude(2 * r, ldivisor);
				 } else {
					 cmpFracHalf = (mr - (mdivisor >> 1)).signum();
				 }
				 if (cmpFracHalf < 0)
					 increment = false;     // We're closer to higher digit
				 else if (cmpFracHalf > 0)  // We're closer to lower digit
					 increment = true;
				 else if (rm == ROUND_HALF_UP)
					 increment = true;
				 else if (rm == ROUND_HALF_DOWN)
					 increment = false;
				 else  // rm == ROUND_HALF_EVEN, true iff quotient is odd
					 increment = isLongDivision ? (q & 1L) != 0L : mq.isOdd();
				 break;
			}
		}
	}
	BigDecimal res;
	if(isLongDivision)
		res = BigDecimal(BigInt(), (increment ? q + qsign : q), scale, 0);
	else {
		if(increment)
			mq = mq + BigInt::ONE;
		res = mq.toBigDecimal(qsign, scale);
	}
	if (isRemainderZero && preferredScale != scale)
		res.stripZerosToMatchScale(preferredScale);
	return res;
}

int BigDecimal::longCompareMagnitude(long x, long y) {
	if(x < 0)
		x = -x;
	if(y < 0)
		y = -y;
	return (x < y) ? -1 : (x == y) ? 0 : 1;
}

long BigDecimal::compactValFor(BigInt b) {
	long lb = (long) b;
	if(b == BigInt(lb))
		return lb;
	return INFLATED;
}

int BigDecimal::longDigitLength(long x) {
	assert(x != INFLATED);
	if (x < 0)
		x = -x;
	if (x < 10) // must screen for 0, might as well 10
		return 1;
	size_t n = sizeof(long) * CHAR_BIT;
	long y = x;
	size_t rshift = 0;
	for(size_t lshift = n >> 1; lshift > 1; lshift >>= 1) {
		rshift += lshift;
		if((y >> rshift) == 0) {
			n -= lshift;
			y <<= lshift;
		}
	}
	// log 10 of x is within 1 of (1233/4096)* (1 + integer log 2 of x)
	int r = (((y >> (rshift + 1)) + n) * 1233) >> 12;
	// if r >= length, must have max possible digits for long
	return (r >= (int)LONG_TEN_POWERS_TABLE_COUNT || x < LONG_TEN_POWERS_TABLE[r])? r : r+1;
}

int BigDecimal::bigDigitLength(BigInt b) {
	/*
	 * Same idea as the long version, but we need a better
	 * approximation of log10(2). Using 646456993/2^31
     * is accurate up to max possible reported bitLength.
	*/
	if (b.signum() == 0)
		return 1;
	int r = (int)((((long)b.bitLength() + 1) * 646456993) >> 31);
	return b.cmp(bigTenToThe(r)) < 0 ? r : r + 1;
}

int BigDecimal::saturateLong(long s) {
	int i = (int)s;
	return (s == i) ? i : (s < 0 ? INT_MIN : INT_MAX);
}

BigDecimal BigDecimal::doRound(BigDecimal &d, int mcPrecision, roundingMode rm) {
	int drop;
	// This might (rarely) iterate to cover the 999=>1000 case
	while ((drop = d.getPrecision() - mcPrecision) > 0) {
		int newScale = d.checkScale((long)d.scale - drop);
		if(drop < (int)LONG_TEN_POWERS_TABLE_COUNT)
			d = divideAndRound(d.intCompact, d.intVal, LONG_TEN_POWERS_TABLE[drop], BigInt(), newScale, rm, newScale);
		else
			d = divideAndRound(d.intCompact, d.intVal, INFLATED, bigTenToThe(drop), newScale, rm, newScale);
	}
	return d;
}


// Ratio
class Ratio : public Number {
	public:
		Ratio(BigInt numerator, BigInt denominator) : numerator(numerator), denominator(denominator) {};
		const BigInt numerator;
		const BigInt denominator;

		virtual operator long();
		virtual operator double() const;
		virtual operator std::string() const;
		BigInt toBigInt() const;
		BigDecimal toBigDecimal() const;
		BigDecimal toBigDecimal(int precision, roundingMode rm) const;
};

Ratio::operator long() {
	return (long)toBigInt();
}

Ratio::operator double() const {
	return (double)toBigDecimal(16, ROUND_HALF_EVEN);
}

Ratio::operator std::string() const {
	return numerator.toString() + "/" + denominator.toString();
}

BigInt Ratio::toBigInt() const {
	return numerator / denominator;
}

BigDecimal Ratio::toBigDecimal() const {
	return toBigDecimal(0, ROUND_HALF_UP);
}

BigDecimal Ratio::toBigDecimal(int precision, roundingMode rm) const {
	BigDecimal numerator(this->numerator);
	BigDecimal denominator(this->denominator);

	return numerator.divide(denominator, precision, rm);
}
