#ifndef NUMBERS_HPP
#define NUMBERS_HPP

#include <vector>

#include "Interfaces.hpp"

class Number : public lisp_object {
	public:
		// virtual operator char() const = 0;
		// virtual operator int() const = 0;
		// virtual operator short() const = 0;
		virtual explicit operator long() const = 0;
		// virtual operator float() const = 0;
		virtual explicit operator double() const = 0;
};

class Integer : public Number {
	public:
		Integer(long i): val(i) {};

		virtual std::string toString(void) const;
		virtual explicit operator long() const;
		virtual explicit operator double() const;
	private:
		const long val;
};

class Float : public Number {
	public:
		Float(double x): val(x), str("") {};

		virtual std::string toString(void) const;
		virtual operator long() const;
		virtual operator double() const;
	private:
		const double val;
		std::string str;
};

class BigDecimal;

#define BASE (1 << CHAR_BIT)
class BigInt : public Number {
	public:
		BigInt(long x);
		BigInt() = default;
		virtual operator long() const;
		virtual operator double() const;
		// virtual operator std::string() const;
		virtual std::string toString() const;

		bool operator==(const BigInt &y) const {return (sign == y.sign) && cmp(y);};
		BigInt operator+(const BigInt &y) const;
		BigInt operator-() const;
		BigInt operator-(const BigInt &y) const;
		BigInt operator*(const BigInt &y) const;
		BigInt operator*(const long &y) const;
		BigInt operator/(const BigInt &y) const;
		BigInt operator%(const BigInt &y) const;
		BigInt operator>>(unsigned long y) const;
		BigInt operator>>(int y) const;
		bool operator<(const BigInt &y) const;
		bool operator<=(const BigInt &y) const;
		bool operator>(const BigInt &y) const;
		bool operator>=(const BigInt &y) const;
		BigInt abs() const;

		long signum(void) const;
		BigInt gcd(const BigInt &d) const;
		bool isZero(void) const;
		bool isNull(void) const {return array.size() == 0;};
		bool isOdd(void) const;
		BigInt pow(BigInt y) const;
		BigInt divide(const BigInt &y, BigInt *q) const;
		long divide(long y, BigInt *q) const;
		BigDecimal toBigDecimal(int sign, int scale) const;
		int bitLength();

		// These should be private with Friend BigDecimal::stripZerosToMatchScale
		int cmp(const BigInt &y) const;
		unsigned char &operator[] (size_t n) {return array[n];};
		const unsigned char &operator[] (size_t n) const {return array[n];};

		static const BigInt ZERO;
		static const BigInt ONE;
		static const BigInt TEN;
	private:
		BigInt(size_t n, bool) : sign(1), ndigits(1), array(n) {};
		bool isOne(void) const;
		bool isPos(void) const;
		static size_t maxDigits(const BigInt &x, const BigInt &y);
		void add(const BigInt &x, const BigInt &y);
		int add_loop(size_t n, const BigInt &x, int carry);
		int add_loop(size_t n, const BigInt &x, const BigInt &y, int carry);
		void sub(const BigInt &x, const BigInt &y);
		int sub_loop(size_t n, const BigInt &x, int borrow);
		int sub_loop(size_t n, const BigInt &x, const BigInt &y, int borrow);
		void div(const BigInt &y, BigInt *q, BigInt *r) const;
		int quotient(const BigInt &x, int y);
		size_t length() const;
		void normalize(void);
		static int bitLengthForInt(unsigned int);

		int sign;
		size_t ndigits;
		std::vector<unsigned char> array;
};



#endif /* NUMBERS_HPP */
