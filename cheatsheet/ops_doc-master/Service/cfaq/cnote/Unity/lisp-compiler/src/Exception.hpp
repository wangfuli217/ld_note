#ifndef EXCEPTION_HPP
#define EXCEPTION_HPP

class ReaderError : public std::exception {
	public:
		ReaderError(size_t line, size_t column, std::exception e) : std::exception(e), line(line), column(column) {};

		const size_t line;
		const size_t column;
};

class NumberFormatException : public std::runtime_error {
	public:
		NumberFormatException(const std::string& buf) :
			std::runtime_error("Unable to convert '" + buf + "' into a number.") {};
};

class ArityException : std::runtime_error {
	public:
		const size_t actual;
		const std::string name;

		ArityException(size_t actual, std::string name) :
			std::runtime_error("Wrong number of args (" + std::to_string(actual) + ") passed to: " + name),
			actual(actual),
			name(name) {};
};

#endif /* EXCEPTION_HPP */
