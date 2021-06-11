#include <istream>
#include <fstream>
#include <sstream>

#include "Interfaces.hpp"


class LineNumberIStream : public std::istream {
	public:
		LineNumberIStream(std::istream &is);
		LineNumberIStream(const char *filename);
		LineNumberIStream(std::string &buffer);
		size_t getLineNumber(void) const;
		size_t getColumnNumber(void) const;
		int get(void);
		void unget(int);
	private:
		std::unique_ptr<std::istream> is_buf;
		std::istream &is;
		size_t line;
		size_t column;
		bool atLineStart;
		bool prevAtLineStart;
};
