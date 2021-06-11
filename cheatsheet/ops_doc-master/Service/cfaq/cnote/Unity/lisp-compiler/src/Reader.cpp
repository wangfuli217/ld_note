#include "Reader.hpp"

#include <exception>
#include <functional>
#include <memory>
#include <vector>

#include "Bool.hpp"
#include "Exception.hpp"
#include "List.hpp"
#include "Numbers.hpp"
#include "String.hpp"


typedef std::function<std::shared_ptr<const lisp_object>(LineNumberIStream& /* *lisp_object opts, *lisp_object pendingForms */)> MacroFn;

static std::shared_ptr<const lisp_object> CharReader(LineNumberIStream& input /* *lisp_object opts, *lisp_object pendingForms */);
static std::shared_ptr<const lisp_object> ListReader(LineNumberIStream& input /* *lisp_object opts, *lisp_object pendingForms */);
// static std::shared_ptr<const lisp_object> VectorReader(LineNumberIStream& input /* *lisp_object opts, *lisp_object pendingForms */);
// static std::shared_ptr<const lisp_object> MapReader(LineNumberIStream& input /* *lisp_object opts, *lisp_object pendingForms */);
static std::shared_ptr<const lisp_object> StringReader(LineNumberIStream& input /* *lisp_object opts, *lisp_object pendingForms */);
static std::shared_ptr<const lisp_object> CommentReader(LineNumberIStream& input /* *lisp_object opts, *lisp_object pendingForms */);
// static std::shared_ptr<const lisp_object> MetaReader(LineNumberIStream& input /* *lisp_object opts, *lisp_object pendingForms */);

static std::shared_ptr<const lisp_object> UnmatchedParenReader(LineNumberIStream& input, char ch /* *lisp_object opts, *lisp_object pendingForms */);
// static std::shared_ptr<const lisp_object> WrappingReader(LineNumberIStream& input, char ch /* *lisp_object opts, *lisp_object pendingForms */);


class ReaderConfig {
	public:
		ReaderConfig() : eof(ReaderSentinels("EOF")), done(ReaderSentinels("DONE")), noop(ReaderSentinels("NOOP")) {
			macros['\\'] = CharReader;
			macros['"']  = StringReader;
			macros['(']  = ListReader;
			macros[')']  = std::bind(UnmatchedParenReader, std::placeholders::_1, ')');
			// macros['[']  = VectorReader;
			macros[']']  = std::bind(UnmatchedParenReader, std::placeholders::_1, ']');
			// macros['{']  = MapReader;
			macros['}']  = std::bind(UnmatchedParenReader, std::placeholders::_1, '}');
			// macros['\''] = WrappingReader;
			// macros['@']  = WrappingReader;
			macros[';']  = CommentReader;
			// macros['^'] = MetaReader;

			// macros['`'] = new SyntaxQuoteReader();
			// macros['~'] = new UnquoteReader();
			// macros['%'] = new ArgReader();
			// macros['#'] = new DispatchReader();
		};
		class ReaderSentinels : public lisp_object {
			public:
				ReaderSentinels(std::string name) : name(name) {};
				virtual std::string toString(void) const {return name;};
				virtual std::shared_ptr<const IMap> meta(void) const {return NULL;};
			private:
				std::string name;
		};
		const ReaderSentinels eof;
		const ReaderSentinels done;
		const ReaderSentinels noop;

		MacroFn macros[128];
};

static const ReaderConfig config;

static bool isMacro(int ch) {
	return ((size_t)ch < sizeof(config.macros)/sizeof(*config.macros)) && (config.macros[ch] != NULL);
}

static bool isTerminatingMacro(int ch) {
	return ch != '#' && ch != '\'' && ch != '%' && isMacro(ch);
}

static MacroFn get_macro(int ch) {
	if((size_t)ch < sizeof(config.macros)/sizeof(*config.macros))
		return config.macros[ch];
	return NULL;
}

std::shared_ptr<const lisp_object> ReadNumber(LineNumberIStream &input, char ch) {
	std::ostringstream result;
	while(ch != EOF && !isspace(ch) && !isMacro(ch)) {
		result << ch;
		ch = input.get();
	}
	input.unget(ch);

	std::istringstream number(result.str());
	long l;
	number >> l;
	if(number.eof())
		return std::make_shared<Integer>(l);

	number = std::istringstream(result.str());
	double d;
	number >> d;
	if(number.eof())
		return std::make_shared<Float>(d);

	throw NumberFormatException(result.str());
}

static std::string ReadToken(LineNumberIStream &input, char ch) {
	std::ostringstream result;
	while(ch != EOF && !isspace(ch) && !isMacro(ch)) {
		result << ch;
		ch = input.get();
	}
	input.unget(ch);

	return result.str();
}

static std::shared_ptr<const lisp_object> matchSymbol(__attribute__((unused)) std::string& token) {
	// TODO
	return NULL;
}

static std::shared_ptr<const lisp_object> interpretToken(std::string& token) {
	if("nil" == token)
		return NULL;
	if("true" == token)
		return T;
	if("false" == token)
		return F;

	const std::shared_ptr<const lisp_object> ret = matchSymbol(token);
	if(ret)
		return ret;

	throw std::runtime_error("Invalid token: " + token);
}

std::shared_ptr<const lisp_object> read(LineNumberIStream &input, bool EOF_is_error, char return_on, bool isRecursive /*, *lisp_object opts, *lisp_object pendingForms */) {
	try {
		int ch = input.get();

		while(true) {
			while(isspace(ch))
				ch = input.get();

			if(ch == EOF) {
				if(EOF_is_error)
					throw std::runtime_error("EOF while reading");
				return std::shared_ptr<const lisp_object>(&config.eof);
			}

			if(ch == return_on)
				return std::shared_ptr<const lisp_object>(&config.done);

			MacroFn macro = get_macro(ch);
			if(macro) {
				std::shared_ptr<const lisp_object> ret = macro(input);
				if(ret.get() == &config.noop)
					continue;
				return ret;
			}

			if(ch == '+' || ch == '-') {
				int ch2 = input.get();
				if(isdigit(ch2)) {
					input.unget(ch2);
					return ReadNumber(input, ch);
				}
			}

			if(isdigit(ch))
				return ReadNumber(input, ch);

			std::string token = ReadToken(input, ch);
			std::shared_ptr<const lisp_object> ret = interpretToken(token);
			return ret;
		}
	}
	catch(std::exception e) {
		if(isRecursive)
			throw e;
		throw new ReaderError(input.getLineNumber(), input.getColumnNumber(), e);
	}
}

static std::shared_ptr<const lisp_object> CharReader(LineNumberIStream& input /* *lisp_object opts, *lisp_object      pendingForms */) {
	char ch = input.get();
	if(ch == EOF)
		throw std::runtime_error("EOF while reading character");

	std::string token = ReadToken(input, ch);
	if(token.size() == 1)
		return std::make_shared<Char>(token[0]);
	if(token == "newline")
		return std::make_shared<Char>('\n');
	if(token == "space")
		return std::make_shared<Char>(' ');
	if(token == "tab")
		return std::make_shared<Char>('\t');
	if(token == "backspace")
		return std::make_shared<Char>('\b');
	if(token == "formfeed")
		return std::make_shared<Char>('\f');
	if(token == "return")
		return std::make_shared<Char>('\r');

	throw std::runtime_error("Unsupported character: \\" + token);
}

static std::shared_ptr<const lisp_object> StringReader(LineNumberIStream& input /* *lisp_object opts, *lisp_object      pendingForms */) {
	std::ostringstream ret;
	for(int ch = input.get(); ch != '"'; ch = input.get()) {
		if(ch == EOF)
			throw std::runtime_error("EOF while reading string.");
		if(ch == '\\') {
			ch = input.get();
			if(ch == EOF)
				throw std::runtime_error("EOF while reading string.");

			switch(ch) {
				case 't':
					ch = '\t';
					break;
				case 'r':
					ch = '\r';
					break;
				case 'n':
					ch = '\n';
					break;
				case 'b':
					ch = '\b';
					break;
				case 'f':
					ch = '\f';
					break;
				case '\\':
					case '"':
					break;
				default:
					throw std::runtime_error("Unsupported Escape character: \\" + ch);
			}
		}
		ret << ch;
	}
	return std::make_shared<lisp_string>(ret.str());
}

static std::vector<std::shared_ptr<const lisp_object> > ReadDelimitedList(LineNumberIStream& input, char delim /* *lisp_object opts, *lisp_object pendingForms */) {
	const size_t firstLine = input.getLineNumber();
	std::vector<std::shared_ptr<const lisp_object> > ret;

	while(true) {
		std::shared_ptr<const lisp_object> form = read(input, true, delim, true);
		if(form.get() == &config.eof) {
			if(firstLine > 0)
				throw std::runtime_error("EOF while reading, starting at line "+ firstLine);
			else
				throw std::runtime_error("EOF while reading");
		}
		if(form.get() == &config.done)
			return ret;
		ret.push_back(form);
	}
}

static std::shared_ptr<const lisp_object> ListReader(LineNumberIStream& input /* *lisp_object opts, *lisp_object pendingForms */) {
	std::vector<std::shared_ptr<const lisp_object> > list = ReadDelimitedList(input, ')');
	if(list.size() == 0) return std::static_pointer_cast<const lisp_object>(List::Empty);
	std::shared_ptr<const lisp_object> s = std::static_pointer_cast<const Seqable>(std::make_shared<const List>(list));
	// size_t line = input.getLineNumber();
	// size_t column = line ? input.getColumnNumber() - 1 : 0;
	// TODO requires CreateHashMap, and withMeta
	// if(line) {
	//	const lisp_object *margs[] = {
	//		(lisp_object*) LineKW, (lisp_object*) NewInteger(line),
	//		(lisp_object*) ColumnKW, (lisp_object*) NewInteger(column),
	//	};
	//	size_t margc = sizeof(margs) / sizeof(margs[0]);
	//	return withMeta(s, (IMap*) CreateHashMap(margc, margs));
	// }
	return s;
}

static std::shared_ptr<const lisp_object> UnmatchedParenReader(LineNumberIStream&, char ch /* *lisp_object opts, *lisp_object pendingForms */) {
	throw std::runtime_error(std::string("Unmatched delimiter: ") + ch);
}

static std::shared_ptr<const lisp_object> CommentReader(LineNumberIStream& input /* *lisp_object opts, *lisp_object pendingForms */) {
	for(int ch = 0; ch != EOF && ch != '\n' && ch != '\r'; ch = input.get()) {}
	return std::shared_ptr<const lisp_object>(&config.noop);
}
