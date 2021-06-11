/*
 * TscanCode - A tool for static C/C++ code analysis
 * Copyright (C) 2017 TscanCode team.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */


//---------------------------------------------------------------------------
#include "checksizeof.h"
#include "symboldatabase.h"
#include <algorithm>
#include <cctype>
#include "globaltokenizer.h"
//---------------------------------------------------------------------------

// Register this check class (by creating a static instance of it)
namespace {
    CheckSizeof instance;
}

//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
void CheckSizeof::checkSizeofForNumericParameter()
{
    if (!_settings->isEnabled("warning"))
        return;

    const SymbolDatabase *symbolDatabase = _tokenizer->getSymbolDatabase();
    const std::size_t functions = symbolDatabase->functionScopes.size();
    for (std::size_t i = 0; i < functions; ++i) {
        const Scope * scope = symbolDatabase->functionScopes[i];
        for (const Token* tok = scope->classStart->next(); tok != scope->classEnd; tok = tok->next()) {
            if (Token::Match(tok, "sizeof ( %num% )"))  {
                sizeofForNumericParameterError(tok->tokAt(2));
            }
			else if (Token::Match(tok, "sizeof %num%"))
			{
				sizeofForNumericParameterError(tok->tokAt(1));
			}
        }
    }
}

void CheckSizeof::sizeofForNumericParameterError(const Token *tok)
{
    reportError(tok, Severity::warning, ErrorType::Compute,
                "SizeofForNumericParameter", "Suspicious usage of 'sizeof' with a numeric constant as parameter.\n"
                "It is unusual to use a constant value with sizeof. For example, 'sizeof(10)'"
                " returns 4 (in 32-bit systems) or 8 (in 64-bit systems) instead of 10. 'sizeof('A')'"
				" and 'sizeof(char)' can return different results.", ErrorLogger::GenWebIdentity(tok->str()));
}


//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
void CheckSizeof::checkSizeofForArrayParameter()
{
    if (!_settings->isEnabled("warning"))
        return;
    const SymbolDatabase *symbolDatabase = _tokenizer->getSymbolDatabase();
    const std::size_t functions = symbolDatabase->functionScopes.size();
    for (std::size_t i = 0; i < functions; ++i) {
        const Scope * scope = symbolDatabase->functionScopes[i];
        for (const Token* tok = scope->classStart->next(); tok != scope->classEnd; tok = tok->next()) {
            if (Token::Match(tok, "sizeof ( %var% )") ||
                Token::Match(tok, "sizeof %var% !![")) {
                const Token* varTok = tok->next();
                if (varTok->str() == "(") {
                    varTok = varTok->next();
                }

                const Variable *var = varTok->variable();
                if (var && var->isArray() && var->isArgument() && !var->isReference())
					sizeofForArrayParameterError(varTok);
            }
        }
    }
}

void CheckSizeof::sizeofForArrayParameterError(const Token *tok)
{
    reportError(tok, Severity::warning, ErrorType::Compute,
                "SizeofForArrayParameter", "Using 'sizeof' on array given as function argument "
                "returns size of a pointer.\n"
                "Using 'sizeof' for array given as function argument returns the size of a pointer. "
                "It does not return the size of the whole array in bytes as might be "
                "expected. For example, this code:\n"
                "     int f(char a[100]) {\n"
                "         return sizeof(a);\n"
                "     }\n"
                "returns 4 (in 32-bit systems) or 8 (in 64-bit systems) instead of 100 (the "
                "size of the array in bytes)."
				, ErrorLogger::GenWebIdentity(tok->str()));
}

void CheckSizeof::checkSizeofForPointerSize()
{
    if (!_settings->isEnabled("warning"))
        return;

    const SymbolDatabase *symbolDatabase = _tokenizer->getSymbolDatabase();
    const std::size_t functions = symbolDatabase->functionScopes.size();
    for (std::size_t i = 0; i < functions; ++i) {
        const Scope * scope = symbolDatabase->functionScopes[i];
        for (const Token* tok = scope->classStart; tok != scope->classEnd; tok = tok->next()) {
            const Token* tokSize;
            const Token* tokFunc;
            const Token *variable = nullptr;
            const Token *variable2 = nullptr;

            // Find any function that may use sizeof on a pointer
            // Once leaving those tests, it is mandatory to have:
            // - variable matching the used pointer
            // - tokVar pointing on the argument where sizeof may be used
            if (Token::Match(tok, "%var% = malloc|alloca (")) {
                variable = tok;
                tokSize = tok->tokAt(4);
                tokFunc = tok->tokAt(2);
            } else if (Token::Match(tok, "%var% = calloc (")) {
                variable = tok;
                tokSize = tok->tokAt(4)->nextArgument();
                tokFunc = tok->tokAt(2);
            } else if (Token::Match(tok, "return malloc|alloca (")) {
                tokSize = tok->tokAt(3);
                tokFunc = tok->next();
            } else if (Token::simpleMatch(tok, "return calloc (")) {
                tokSize = tok->tokAt(3)->nextArgument();
                tokFunc = tok->next();
            } else if (Token::simpleMatch(tok, "memset (") && tok->strAt(-1) != ".") {
                variable = tok->tokAt(2);
                tokSize = variable->nextArgument();
                if (tokSize)
                    tokSize = tokSize->nextArgument();
                tokFunc = tok;
            } else if (Token::Match(tok, "memcpy|memcmp|memmove|strncpy|strncmp|strncat (") && tok->strAt(-1) != ".") {
                variable = tok->tokAt(2);
                variable2 = variable->nextArgument();
                if (!variable2)
                    continue;
                tokSize = variable2->nextArgument();
                tokFunc = tok;
            } else {
                continue;
            }

            if (tokFunc && tokSize) {
                for (const Token* tok2 = tokSize; tok2 != tokFunc->linkAt(1); tok2 = tok2->next()) {
                    if (Token::simpleMatch(tok2, "/ sizeof"))
                        divideBySizeofError(tok2, tokFunc->str());
                }
            }

            if (!variable || !tokSize)
                continue;

            while (Token::Match(variable, "%var% ::|."))
                variable = variable->tokAt(2);

            // Ensure the variables are in the symbol database
            // Also ensure the variables are pointers
            // Only keep variables which are pointers
            const Variable *var = variable->variable();
            if (!var || !var->isPointer() || var->isArray()) {
                variable = 0;
            }

            if (variable2) {
                var = variable2->variable();
                if (!var || !var->isPointer() || var->isArray()) {
                    variable2 = 0;
                }
            }

            // If there are no pointer variable at this point, there is
            // no need to continue
            if (variable == 0 && variable2 == 0) {
                continue;
            }

            // Jump to the next sizeof token in the function and in the parameter
            // This is to allow generic operations with sizeof
            for (; tokSize && tokSize->str() != ")" && tokSize->str() != "," && tokSize->str() != "sizeof"; tokSize = tokSize->next()) {}

            if (tokSize->str() != "sizeof")
                continue;

            if (Token::simpleMatch(tokSize, "sizeof ( &"))
                tokSize = tokSize->tokAt(3);
            else if (Token::Match(tokSize, "sizeof (|&"))
                tokSize = tokSize->tokAt(2);
            else
                tokSize = tokSize->next();

            while (Token::Match(tokSize, "%var% ::|."))
                tokSize = tokSize->tokAt(2);

            if (Token::Match(tokSize, "%var% [|("))
                continue;

            // Now check for the sizeof usage. Once here, everything using sizeof(varid) or sizeof(&varid)
            // looks suspicious
            // Do it for first variable
            if (variable && tokSize->varId() == variable->varId())
                sizeofForPointerError(variable, variable->str());
            if (variable2 && tokSize->varId() == variable2->varId())
                sizeofForPointerError(variable2, variable2->str());
        }
    }
}

void CheckSizeof::checkSizeofForPointerSize2()
{

	//if (!_settings->isEnabled("style"))
	//	return;
	const SymbolDatabase *symbolDatabase = _tokenizer->getSymbolDatabase();
	for (const Token *tok = _tokenizer->tokens(); tok; tok = tok->next())
	{
		if (Token::Match(tok, "sizeof ( %var% )") && symbolDatabase)
		{
			const Token* sizeTok = tok;
			tok = tok->tokAt(2);
			const Variable *var = symbolDatabase->getVariableFromVarId(tok->varId());
			if (var != NULL && var->isPointer() && !var->isArray())
			{
				if (sizeTok->previous() && Token::Match(sizeTok->previous(), ";|,|=|==|>|<|<=|>=|)|return|{|[") && sizeTok->tokAt(4) && Token::Match(sizeTok->tokAt(4), ";|,|=|==|>|<|<=|>=|)|return|{|["))
				{
					// ignore func(&p, sizeof(p));
					if (Token::Match(sizeTok->tokAt(-3), "& %varid% ,", sizeTok->varId()))
					{
						continue;
					}
					sizeofForPointerError(tok, tok->str());
				}
			}
		}
		else if (Token::Match(tok, "sizeof ( & %var% "))
		{
			const Token* tok2 = NULL;
			std::string varname;
			for (tok2 = tok->tokAt(2); tok2 && tok2 != tok->linkAt(1); tok2 = tok2->next())
			{
				varname += tok2->str();
			}

			if (tok2)
			{
				tok = tok2->previous();
				sizeofForPointerError(tok, varname);
			}
		}
	}
}


void CheckSizeof::sizeofForPointerError(const Token *tok, const std::string &varname)
{
    reportError(tok, Severity::warning, ErrorType::Compute, "SizeofForPointerSize",
                "Use sizeof data of '" + varname + "' instead of sizeof the pointer.\n"
                "This is likely to lead to a buffer overflow. You probably intend to "
                "write 'sizeof(*" + varname + ")'.", ErrorLogger::GenWebIdentity(varname));
}

void CheckSizeof::divideBySizeofError(const Token *tok, const std::string &memfunc)
{
    reportError(tok, Severity::warning, ErrorType::None, "sizeofDivisionMemfunc",
                "Division by result of sizeof(). " + memfunc + "() expects a size in bytes, did you intend to multiply instead?",
		ErrorLogger::GenWebIdentity(memfunc));
}

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
void CheckSizeof::sizeofsizeof()
{
    if (!_settings->isEnabled("warning"))
        return;

    for (const Token *tok = _tokenizer->tokens(); tok; tok = tok->next()) {
        if (Token::Match(tok, "sizeof (| sizeof")) {
            sizeofsizeofError(tok);
            tok = tok->next();
        }
    }
}

void CheckSizeof::sizeofsizeofError(const Token *tok)
{
    reportError(tok, Severity::warning, ErrorType::Compute,
                "sizeofsizeof", "Suspicious calling 'sizeof' on 'sizeof'.\n"
                "Calling sizeof for 'sizeof looks like a suspicious code and "
                "most likely there should be just one 'sizeof'. The current "
				"code is equivalent to 'sizeof(size_t)'", ErrorLogger::GenWebIdentity(tok->str()));
}

//-----------------------------------------------------------------------------

void CheckSizeof::sizeofCalculation()
{
    if (!_settings->isEnabled("warning"))
        return;

    const bool printInconclusive = _settings->inconclusive;

    for (const Token *tok = _tokenizer->tokens(); tok; tok = tok->next()) {
        if (Token::simpleMatch(tok, "sizeof (")) {

            // ignore if the `sizeof` result is cast to void inside a macro, i.e. the calculation is
            // expected to be parsed but skipped, such as in a disabled custom ASSERT() macro
            if (tok->isExpandedMacro() && tok->previous()) {
                const Token *cast_end = (tok->previous()->str() == "(") ? tok->previous() : tok;
                if (Token::simpleMatch(cast_end->tokAt(-3), "( void )") ||
                    Token::simpleMatch(cast_end->tokAt(-1), "static_cast<void>")) {
                    continue;
                }
            }

            const Token *argument = tok->next()->astOperand2();
            if (argument && argument->isCalculation() && (!argument->isExpandedMacro() || printInconclusive))
                sizeofCalculationError(argument, argument->isExpandedMacro());
        }
    }
}

void CheckSizeof::sizeofCalculationError(const Token *tok, bool inconclusive)
{
    reportError(tok, Severity::warning, ErrorType::None,
                "sizeofCalculation", "Found calculation inside sizeof().", 0U, inconclusive);
}

//-----------------------------------------------------------------------------
// Check for code like sizeof()*sizeof() or sizeof(ptr)/value
//-----------------------------------------------------------------------------
void CheckSizeof::suspiciousSizeofCalculation()
{
    if (!_settings->isEnabled("warning") || !_settings->inconclusive)
        return;

    // TODO: Use AST here. This should be possible as soon as sizeof without brackets is correctly parsed
    for (const Token *tok = _tokenizer->tokens(); tok; tok = tok->next()) {
        if (Token::simpleMatch(tok, "sizeof (")) {
            const Token* const end = tok->linkAt(1);
            const Variable* var = end->previous()->variable();
            if (end->strAt(-1) == "*" || (var && var->isPointer() && !var->isArray())) {
                if (end->strAt(1) == "/")
                    divideSizeofError(tok);
            } else if (Token::simpleMatch(end, ") * sizeof") && end->next()->astOperand1() == tok->next())
                multiplySizeofError(tok);
        }
    }
}

void CheckSizeof::multiplySizeofError(const Token *tok)
{
    reportError(tok, Severity::warning, ErrorType::None,
                "multiplySizeof", "Multiplying sizeof() with sizeof() indicates a logic error.", 0U, true);
}

void CheckSizeof::divideSizeofError(const Token *tok)
{
    reportError(tok, Severity::warning, ErrorType::None,
                "divideSizeof", "Division of result of sizeof() on pointer type.\n"
                "Division of result of sizeof() on pointer type. sizeof() returns the size of the pointer, "
                "not the size of the memory area it points to.", 0U, true);
}

void CheckSizeof::sizeofVoid()
{
    if (!_settings->isEnabled("portability"))
        return;

    for (const Token *tok = _tokenizer->tokens(); tok; tok = tok->next()) {
        if (Token::simpleMatch(tok, "sizeof ( )")) { // "sizeof(void)" gets simplified to sizeof ( )
            sizeofVoidError(tok);
        } else if (Token::Match(tok, "sizeof ( * %var% )") && tok->tokAt(3)->variable() &&
                   (Token::Match(tok->tokAt(3)->variable()->typeStartToken(), "void * !!*")) &&
                   (!tok->tokAt(3)->variable()->isArray())) { // sizeof(*p) where p is of type "void*"
            sizeofDereferencedVoidPointerError(tok, tok->strAt(3));
        } else if (Token::Match(tok, "%name% +|-|++|--") ||
                   Token::Match(tok, "+|-|++|-- %name%")) { // Arithmetic operations on variable of type "void*"
            const int index = (tok->isName()) ? 0 : 1;
            const Variable* var = tok->tokAt(index)->variable();
            if (var && !var->isArray() && Token::Match(var->typeStartToken(), "void * !!*")) {
                std::string varname = tok->strAt(index);
                // In case this 'void *' var is a member then go back to the main object
                const Token* tok2 = tok->tokAt(index);
                if (index == 0) {
                    bool isMember = false;
                    while (Token::simpleMatch(tok2->previous(), ".")) {
                        isMember = true;
                        if (Token::simpleMatch(tok2->tokAt(-2), ")"))
                            tok2 = tok2->linkAt(-2);
                        else if (Token::simpleMatch(tok2->tokAt(-2), "]"))
                            tok2 = tok2->linkAt(-2)->previous();
                        else
                            tok2 = tok2->tokAt(-2);
                    }
                    if (isMember) {
                        // Get 'struct.member' complete name (without spaces)
                        varname = tok2->stringifyList(tok->next());
                        varname.erase(std::remove_if(varname.begin(), varname.end(),
                                                     static_cast<int (*)(int)>(std::isspace)), varname.end());
                    }
                }
                // Check for cast on operations with '+|-'
                if (Token::Match(tok, "%name% +|-")) {
                    // Check for cast expression
                    if (Token::simpleMatch(tok2->previous(), ")") && !Token::Match(tok2->previous()->link(), "( const| void *"))
                        continue;
                    if (tok2->strAt(-1) == "&") // Check for reference operator
                        continue;
                }
                arithOperationsOnVoidPointerError(tok, varname,
                                                  var->typeStartToken()->stringifyList(var->typeEndToken()->next()));
            }
        }
    }
}

void CheckSizeof::sizeofVoidError(const Token *tok)
{
    const std::string message = "Behaviour of 'sizeof(void)' is not covered by the ISO C standard.";
    const std::string verbose = message + " A value for 'sizeof(void)' is defined only as part of a GNU C extension, which defines 'sizeof(void)' to be 1.";
	reportError(tok, Severity::portability, ErrorType::None, "sizeofVoid", message + "\n" + verbose, ErrorLogger::GenWebIdentity(tok->str()));
}

void CheckSizeof::sizeofDereferencedVoidPointerError(const Token *tok, const std::string &varname)
{
    const std::string message = "'*" + varname + "' is of type 'void', the behaviour of 'sizeof(void)' is not covered by the ISO C standard.";
    const std::string verbose = message + " A value for 'sizeof(void)' is defined only as part of a GNU C extension, which defines 'sizeof(void)' to be 1.";
	reportError(tok, Severity::portability, ErrorType::None, "sizeofDereferencedVoidPointer", message + "\n" + verbose, ErrorLogger::GenWebIdentity(tok->str()));
}

void CheckSizeof::arithOperationsOnVoidPointerError(const Token* tok, const std::string &varname, const std::string &vartype)
{
    const std::string message = "'" + varname + "' is of type '" + vartype + "'. When using void pointers in calculations, the behaviour is undefined.";
    const std::string verbose = message + " Arithmetic operations on 'void *' is a GNU C extension, which defines the 'sizeof(void)' to be 1.";
	reportError(tok, Severity::portability, ErrorType::None, "arithOperationsOnVoidPointer", message + "\n" + verbose, ErrorLogger::GenWebIdentity(tok->str()));
}

void CheckSizeof::runAnalysis(const Tokenizer* tokenizer, const Settings* settings, ErrorLogger* errorLogger)
{
    //CGlobalTokenizeData& data = CGlobalTokenizer::Instance()->GetGlobalData(errorLogger);
}

void CheckSizeof::checkForTest()
{
	auto sdb = _tokenizer->getSymbolDatabase();
	for (std::vector<const Scope *>::const_iterator I = sdb->functionScopes.begin(), E = sdb->functionScopes.end(); I != E; ++I)
	{
		const Scope* scope = *I;
		for (const Token* tok = scope->classStart; tok && tok != scope->classEnd; tok = tok->next())
		{
			if (Token::Match(tok, "%name% ("))
			{
				CGlobalTokenizer::Instance()->CheckFuncReturnNull(tok);
			}
		}
		
	}
}
