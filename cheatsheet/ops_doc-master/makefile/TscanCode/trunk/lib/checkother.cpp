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
#include "checkother.h"
#include "astutils.h"
#include "mathlib.h"
#include "symboldatabase.h"
#include "globaltokenizer.h"

#include <cmath> // fabs()
#include <stack>
#include <algorithm> // find_if()
#include <fstream>
#include <string>
using namespace std;
//---------------------------------------------------------------------------

// Register this check class (by creating a static instance of it)
namespace {
    CheckOther instance;
}

namespace ExpressionMatch
{
	enum
	{
		OP_MATCH_TYPE_NONE = 0,
		OP_MATCH_TYPE_DOUBLE_SIDED,
		OP_MATCH_TYPE_POSITIVE,
		OP_MATCH_TYPE_REVERSE,
	};

	inline unsigned int getMatchType(const std::string op1, const std::string op2)
	{
		int opMatchType = 0;
		if (op1 == op2)
		{
			if (op1 == "==" || op1 == "!=")
			{
				opMatchType = OP_MATCH_TYPE_DOUBLE_SIDED;
			}
			else
			{
				opMatchType = OP_MATCH_TYPE_POSITIVE;
			}
		}
		else if ((op1 == ">" && op2 == "<") || (op1 == ">=" && op2 == "<=") ||
			(op1 == "<" && op2 == ">") || (op1 == "<=" && op2 == ">="))
		{
			opMatchType = OP_MATCH_TYPE_REVERSE;
		}

		return opMatchType;
	}

	void stringReplace(std::string &strBase, std::string strSrc, std::string strDes)
	{
		std::string::size_type pos = 0;
		std::string::size_type srcLen = strSrc.size();
		std::string::size_type desLen = strDes.size();
		pos = strBase.find(strSrc, pos);
		while ((pos != std::string::npos))
		{
			strBase.replace(pos, srcLen, strDes);
			pos = strBase.find(strSrc, (pos + desLen));
		}
	}

	void stringCondtionReplace(std::string &strBase, std::string strSrc, std::string strDes)
	{
		std::string::size_type pos = 0;
		std::string::size_type constStrPos1 = 0;
		std::string::size_type constStrPos2 = 0;
		std::string::size_type srcLen = strSrc.size();
		std::string::size_type desLen = strDes.size();
		constStrPos1 = strBase.find("\"", constStrPos1);
		constStrPos2 = strBase.find("", constStrPos1);
		pos = strBase.find(strSrc, pos);
		if ((constStrPos1 != std::string::npos) && (pos != std::string::npos) && (pos>constStrPos1))
		{
			constStrPos1 = strBase.find("\"", pos);
			pos = strBase.find(strSrc, constStrPos1);
		}
		if ((constStrPos2 != std::string::npos) && (pos != std::string::npos) && (pos>constStrPos2))
		{
			constStrPos2 = strBase.find("\"", pos);
			pos = strBase.find(strSrc, constStrPos2);
		}
		while ((pos != std::string::npos))
		{
			strBase.replace(pos, srcLen, strDes);
			pos = strBase.find(strSrc, (pos + desLen));
		}
	}


	void trimExpression(std::string &expression)
	{
		stringCondtionReplace(expression, " ", "");  // Debug 20151217  a==""  || a==" " is different . //Debug 20151218  condition   ( conditon==   sth || conditon==   sth    ) 

		if (expression.find("(") == 0 && expression.rfind(")") == (expression.length() - 1))
		{
			expression.erase(expression.length() - 1, 1);
			expression.erase(0, 1);
		}
	}




	bool getValidOperator(const std::string expression, std::string &op)
	{
		const char *szOps[] = { "==", "!=", ">", "<", "****", "^^^^" };
		int count = 0;

		string expTmp = expression;
		stringReplace(expTmp, "<=", "****");
		stringReplace(expTmp, ">=", "^^^^");

		for (unsigned int i = 0; i < sizeof(szOps) / sizeof(char*); i++)
		{
			std::size_t pos = expTmp.find(szOps[i]);
			if (pos != std::string::npos)
			{
				if (pos == expTmp.rfind(szOps[i]))
				{
					count++;
					op = szOps[i];
				}
				else
				{
					return false;
				}
			}
		}

		if (op == "****")
		{
			op = "<=";
		}
		else if (op == "^^^^")
		{
			op = ">=";
		}

		return (count == 1);
	}

	bool hasSameSemantic(const std::string exp1, const std::string exp2)
	{
		string expression1 = exp1;
		string expression2 = exp2;
		string op1;
		string op2;

		if (!getValidOperator(expression1, op1) || !getValidOperator(expression2, op2))
		{
			return false;
		}

		unsigned int opMatchType = getMatchType(op1, op2);
		if (OP_MATCH_TYPE_NONE == opMatchType)
		{
			return false;
		}

		trimExpression(expression1);
		trimExpression(expression2);

		std::size_t opPos1 = expression1.find(op1);
		std::size_t opPos2 = expression2.find(op2);

		string expleft1 = expression1.substr(0, opPos1);
		string expRigth1 = expression1.substr(opPos1 + op1.length());

		string expleft2 = expression2.substr(0, opPos2);
		string expRigth2 = expression2.substr(opPos2 + op2.length());

		if (OP_MATCH_TYPE_DOUBLE_SIDED == opMatchType)
		{
			return (((expleft1 == expleft2) && (expRigth1 == expRigth2)) ||
				((expleft1 == expRigth2) && (expRigth1 == expleft2)));
		}
		else if (OP_MATCH_TYPE_POSITIVE == opMatchType)
		{
			return ((expleft1 == expleft2) && (expRigth1 == expRigth2));
		}
		else if (OP_MATCH_TYPE_REVERSE == opMatchType)
		{
			return ((expleft1 == expRigth2) && (expRigth1 == expleft2));
		}
		return false;
	}
}



//----------------------------------------------------------------------------------
// The return value of fgetc(), getc(), ungetc(), getchar() etc. is an integer value.
// If this return value is stored in a character variable and then compared
// to compared to EOF, which is an integer, the comparison maybe be false.
//
// Reference:
// - Ticket #160
// - http://www.cplusplus.com/reference/cstdio/fgetc/
// - http://www.cplusplus.com/reference/cstdio/getc/
// - http://www.cplusplus.com/reference/cstdio/getchar/
// - http://www.cplusplus.com/reference/cstdio/ungetc/ ...
//----------------------------------------------------------------------------------
void CheckOther::checkCastIntToCharAndBack()
{
    if (!_settings->isEnabled("warning"))
        return;

    const SymbolDatabase *symbolDatabase = _tokenizer->getSymbolDatabase();
    const std::size_t functions = symbolDatabase->functionScopes.size();
    for (std::size_t i = 0; i < functions; ++i) {
        const Scope * scope = symbolDatabase->functionScopes[i];
        std::map<unsigned int, std::string> vars;
        for (const Token* tok = scope->classStart->next(); tok != scope->classEnd; tok = tok->next()) {
            // Quick check to see if any of the matches below have any chances
            if (!tok->isName() || !Token::Match(tok, "%var%|EOF %comp%|="))
                continue;
            if (Token::Match(tok, "%var% = fclose|fflush|fputc|fputs|fscanf|getchar|getc|fgetc|putchar|putc|puts|scanf|sscanf|ungetc (")) {
                const Variable *var = tok->variable();
                if (var && var->typeEndToken()->str() == "char" && !var->typeEndToken()->isSigned()) {
                    vars[tok->varId()] = tok->strAt(2);
                }
            } else if (Token::Match(tok, "EOF %comp% ( %var% = fclose|fflush|fputc|fputs|fscanf|getchar|getc|fgetc|putchar|putc|puts|scanf|sscanf|ungetc (")) {
                tok = tok->tokAt(3);
                const Variable *var = tok->variable();
                if (var && var->typeEndToken()->str() == "char" && !var->typeEndToken()->isSigned()) {
                    checkCastIntToCharAndBackError(tok, tok->strAt(2));
                }
            } else if (_tokenizer->isCPP() && (Token::Match(tok, "EOF %comp% ( %var% = std :: cin . get (") || Token::Match(tok, "EOF %comp% ( %var% = cin . get ("))) {
                tok = tok->tokAt(3);
                const Variable *var = tok->variable();
                if (var && var->typeEndToken()->str() == "char" && !var->typeEndToken()->isSigned()) {
                    checkCastIntToCharAndBackError(tok, "cin.get");
                }
            } else if (_tokenizer->isCPP() && (Token::Match(tok, "%var% = std :: cin . get (") || Token::Match(tok, "%var% = cin . get ("))) {
                const Variable *var = tok->variable();
                if (var && var->typeEndToken()->str() == "char" && !var->typeEndToken()->isSigned()) {
                    vars[tok->varId()] = "cin.get";
                }
            } else if (Token::Match(tok, "%var% %comp% EOF")) {
                if (vars.find(tok->varId()) != vars.end()) {
                    checkCastIntToCharAndBackError(tok, vars[tok->varId()]);
                }
            } else if (Token::Match(tok, "EOF %comp% %var%")) {
                tok = tok->tokAt(2);
                if (vars.find(tok->varId()) != vars.end()) {
                    checkCastIntToCharAndBackError(tok, vars[tok->varId()]);
                }
            }
        }
    }
}

void CheckOther::checkCastIntToCharAndBackError(const Token *tok, const std::string &strFunctionName)
{
    reportError(
        tok,
        Severity::warning, ErrorType::None,
        "checkCastIntToCharAndBack",
        "Storing "+ strFunctionName +"() return value in char variable and then comparing with EOF.\n"
        "When saving "+ strFunctionName +"() return value in char variable there is loss of precision. "
        " When "+ strFunctionName +"() returns EOF this value is truncated. Comparing the char "
        "variable with EOF can have unexpected results. For instance a loop \"while (EOF != (c = "+ strFunctionName +"());\" "
        "loops forever on some compilers/platforms and on other compilers/platforms it will stop "
        "when the file contains a matching character."
		, ErrorLogger::GenWebIdentity(tok->str()));
}


//---------------------------------------------------------------------------
// Clarify calculation precedence for ternary operators.
//---------------------------------------------------------------------------
void CheckOther::clarifyCalculation()
{
    if (!_settings->isEnabled("style"))
        return;

    const SymbolDatabase *symbolDatabase = _tokenizer->getSymbolDatabase();
    const std::size_t functions = symbolDatabase->functionScopes.size();
    for (std::size_t i = 0; i < functions; ++i) {
        const Scope * scope = symbolDatabase->functionScopes[i];
        for (const Token* tok = scope->classStart->next(); tok != scope->classEnd; tok = tok->next()) {
            // ? operator where lhs is arithmetical expression
            if (tok->str() != "?" || !tok->astOperand1() || !tok->astOperand1()->isCalculation())
                continue;
            if (!tok->astOperand1()->isArithmeticalOp() && tok->astOperand1()->tokType() != Token::eBitOp)
                continue;

            // Is code clarified by parentheses already?
            const Token *tok2 = tok->astOperand1();
            for (; tok2; tok2 = tok2->next()) {
                if (tok2->str() == "(")
                    tok2 = tok2->link();
                else if (tok2->str() == ")" || tok2->str() == "?")
                    break;
            }

            if (tok2 && tok2->str() == "?")
                clarifyCalculationError(tok, tok->astOperand1()->str());
        }
    }
}

void CheckOther::clarifyCalculationError(const Token *tok, const std::string &op)
{
    // suspicious calculation
    const std::string calc("'a" + op + "b?c:d'");

    // recommended calculation #1
    const std::string s1("'(a" + op + "b)?c:d'");

    // recommended calculation #2
    const std::string s2("'a" + op + "(b?c:d)'");

    reportError(tok,
                Severity::style, ErrorType::None,
                "clarifyCalculation",
                "Clarify calculation precedence for '" + op + "' and '?'.\n"
                "Suspicious calculation. Please use parentheses to clarify the code. "
				"The code '" + calc + "' should be written as either '" + s1 + "' or '" + s2 + "'.", ErrorLogger::GenWebIdentity(tok->str()));
}

//---------------------------------------------------------------------------
// Clarify (meaningless) statements like *foo++; with parentheses.
//---------------------------------------------------------------------------
void CheckOther::clarifyStatement()
{
    if (!_settings->isEnabled("warning"))
        return;

    const SymbolDatabase *symbolDatabase = _tokenizer->getSymbolDatabase();
    const std::size_t functions = symbolDatabase->functionScopes.size();
    for (std::size_t i = 0; i < functions; ++i) {
        const Scope * scope = symbolDatabase->functionScopes[i];
        for (const Token* tok = scope->classStart; tok && tok != scope->classEnd; tok = tok->next()) {
            if (Token::Match(tok, "* %name%") && tok->astOperand1()) {
                const Token *tok2 = tok->previous();

                while (tok2 && tok2->str() == "*")
                    tok2 = tok2->previous();

                if (tok2 && !tok2->astParent() && Token::Match(tok2, "[{};]")) {
                    tok2 = tok->astOperand1();
                    if (Token::Match(tok2, "++|-- [;,]"))
                        clarifyStatementError(tok2);
                }
            }
        }
    }
}

void CheckOther::clarifyStatementError(const Token *tok)
{
    reportError(tok, Severity::warning, ErrorType::None, "clarifyStatement", "Ineffective statement similar to '*A++;'. Did you intend to write '(*A)++;'?\n"
                "A statement like '*A++;' might not do what you intended. Postfix 'operator++' is executed before 'operator*'. "
				"Thus, the dereference is meaningless. Did you intend to write '(*A)++;'?", ErrorLogger::GenWebIdentity(tok->str()));
}

//---------------------------------------------------------------------------
// Check for suspicious occurrences of 'if(); {}'.
//---------------------------------------------------------------------------
void CheckOther::checkSuspiciousSemicolon()
{
    if (!_settings->inconclusive || !_settings->isEnabled("warning"))
        return;

    const SymbolDatabase* const symbolDatabase = _tokenizer->getSymbolDatabase();

    // Look for "if(); {}", "for(); {}" or "while(); {}"
    for (std::list<Scope>::const_iterator i = symbolDatabase->scopeList.begin(); i != symbolDatabase->scopeList.end(); ++i) {
        if (i->type == Scope::eIf || i->type == Scope::eElse || i->type == Scope::eWhile || i->type == Scope::eFor) {
            // Ensure the semicolon is at the same line number as the if/for/while statement
            // and the {..} block follows it without an extra empty line.
            if (Token::simpleMatch(i->classStart, "{ ; } {") &&
                i->classStart->previous()->linenr() == i->classStart->tokAt(2)->linenr()
                && i->classStart->linenr()+1 >= i->classStart->tokAt(3)->linenr()) {
                SuspiciousSemicolonError(i->classDef);
            }
        }
    }
}

void CheckOther::SuspiciousSemicolonError(const Token* tok)
{
	reportError(tok, Severity::warning, ErrorType::Suspicious, "suspiciousSemicolon",
                "Suscipious semicolon is used after '" + (tok ? tok->str() : std::string()) + "' statement.", 0U, true, ErrorLogger::GenWebIdentity((tok ? tok->str() : std::string())));
}


//---------------------------------------------------------------------------
// For C++ code, warn if C-style casts are used on pointer types
//---------------------------------------------------------------------------
void CheckOther::warningOldStylePointerCast()
{
    // Only valid on C++ code
    if (!_settings->isEnabled("style") || !_tokenizer->isCPP())
        return;

    const SymbolDatabase *symbolDatabase = _tokenizer->getSymbolDatabase();
    for (std::size_t i = 0; i < symbolDatabase->functionScopes.size(); ++i) {
        const Scope * scope = symbolDatabase->functionScopes[i];
        const Token* tok;
        if (scope->function && scope->function->isConstructor())
            tok = scope->classDef;
        else
            tok = scope->classStart;
        for (; tok && tok != scope->classEnd; tok = tok->next()) {
            // Old style pointer casting..
            if (!Token::Match(tok, "( const| %type% * const| ) (| %name%|%num%|%bool%|%char%|%str%"))
                continue;

            // skip first "const" in "const Type* const"
            if (tok->strAt(1) == "const")
                tok = tok->next();
            const Token* typeTok = tok->next();
            // skip second "const" in "const Type* const"
            if (tok->strAt(3) == "const")
                tok = tok->next();

            if (tok->strAt(4) == "0") // Casting nullpointers is safe
                continue;

            // Is "type" a class?
            if (typeTok->type())
                cstyleCastError(tok);
        }
    }
}

void CheckOther::cstyleCastError(const Token *tok)
{
    reportError(tok, Severity::style, ErrorType::None, "cstyleCast",
                "C-style pointer casting\n"
                "C-style pointer casting detected. C++ offers four different kinds of casts as replacements: "
                "static_cast, const_cast, dynamic_cast and reinterpret_cast. A C-style cast could evaluate to "
                "any of those automatically, thus it is considered safer if the programmer explicitly states "
				"which kind of cast is expected. See also: https://www.securecoding.cert.org/confluence/display/cplusplus/EXP05-CPP.+Do+not+use+C-style+casts.", ErrorLogger::GenWebIdentity(tok->str()));
}

//---------------------------------------------------------------------------
// float* f; double* d = (double*)f; <-- Pointer cast to a type with an incompatible binary data representation
//---------------------------------------------------------------------------

static std::string analyzeType(const Token* tok)
{
    if (tok->str() == "double") {
        if (tok->isLong())
            return "long double";
        else
            return "double";
    }
    if (tok->str() == "float")
        return "float";
    if (Token::Match(tok, "int|long|short|char|size_t"))
        return "integer";
    return "";
}

void CheckOther::invalidPointerCast()
{
    if (!_settings->isEnabled("portability"))
        return;

    const bool printInconclusive = _settings->inconclusive;
    const SymbolDatabase* const symbolDatabase = _tokenizer->getSymbolDatabase();
    const std::size_t functions = symbolDatabase->functionScopes.size();
    for (std::size_t i = 0; i < functions; ++i) {
        const Scope * scope = symbolDatabase->functionScopes[i];
        for (const Token* tok = scope->classStart->next(); tok != scope->classEnd; tok = tok->next()) {
            const Token* toTok = nullptr;
            const Token* nextTok = nullptr;
            // Find cast
            if (Token::Match(tok, "( const| %type% %type%| const| * )")) {
                toTok = tok->next();
                nextTok = tok->link()->next();
                if (nextTok && nextTok->str() == "(")
                    nextTok = nextTok->next();
            } else if (Token::Match(tok, "reinterpret_cast < const| %type% %type%| const| * > (")) {
                nextTok = tok->tokAt(5);
                while (nextTok->str() != "(")
                    nextTok = nextTok->next();
                nextTok = nextTok->next();
                toTok = tok->tokAt(2);
            }
            if (!nextTok)
                continue;
            if (toTok && toTok->str() == "const")
                toTok = toTok->next();

            if (!toTok || !toTok->isStandardType())
                continue;

            // Find casted variable
            const Variable *var = nullptr;
            bool allocation = false;
            bool ref = false;
            if (_tokenizer->isCPP() && Token::Match(nextTok, "new %type%"))
                allocation = true;
            else if (Token::Match(nextTok, "%var% !!["))
                var = nextTok->variable();
            else if (Token::Match(nextTok, "& %var%") && !Token::Match(nextTok->tokAt(2), "(|[")) {
                var = nextTok->next()->variable();
                ref = true;
            }

            const Token* fromTok = nullptr;

            if (allocation) {
                fromTok = nextTok->next();
            } else {
                if (!var || (!ref && !var->isPointer() && !var->isArray()) || (ref && (var->isPointer() || var->isArray())))
                    continue;
                fromTok = var->typeStartToken();
            }

            while (Token::Match(fromTok, "static|const"))
                fromTok = fromTok->next();
            if (!fromTok->isStandardType())
                continue;

            std::string fromType = analyzeType(fromTok);
            std::string toType = analyzeType(toTok);
            if (fromType != toType && !fromType.empty() && !toType.empty() && (toTok->str() != "char" || printInconclusive))
                invalidPointerCastError(tok, fromType, toType, toTok->str() == "char");
        }
    }
}

void CheckOther::invalidPointerCastError(const Token* tok, const std::string& from, const std::string& to, bool inconclusive)
{
    if (to == "integer") { // If we cast something to int*, this can be useful to play with its binary data representation
        if (!inconclusive)
			reportError(tok, Severity::portability, ErrorType::None, "invalidPointerCast", "Casting from " + from + "* to integer* is not portable due to different binary data representations on different platforms.", ErrorLogger::GenWebIdentity(tok->str()));
        else
            reportError(tok, Severity::portability, ErrorType::None, "invalidPointerCast", "Casting from " + from + "* to char* is not portable due to different binary data representations on different platforms.", 0U, true);
    } else
		reportError(tok, Severity::portability, ErrorType::None, "invalidPointerCast", "Casting between " + from + "* and " + to + "* which have an incompatible binary data representation.", ErrorLogger::GenWebIdentity(tok->str()));
}

//---------------------------------------------------------------------------
// This check detects errors on POSIX systems, when a pipe command called
// with a wrong dimensioned file descriptor array. The pipe command requires
// exactly an integer array of dimension two as parameter.
//
// References:
//  - http://linux.die.net/man/2/pipe
//  - ticket #3521
//---------------------------------------------------------------------------
void CheckOther::checkPipeParameterSize()
{
    if (!_settings->standards.posix)
        return;

    const SymbolDatabase *symbolDatabase = _tokenizer->getSymbolDatabase();
    const std::size_t functions = symbolDatabase->functionScopes.size();
    for (std::size_t i = 0; i < functions; ++i) {
        const Scope * scope = symbolDatabase->functionScopes[i];
        for (const Token* tok = scope->classStart->next(); tok != scope->classEnd; tok = tok->next()) {
            if (Token::Match(tok, "pipe ( %var% )") ||
                Token::Match(tok, "pipe2 ( %var% ,")) {
                const Token * const varTok = tok->tokAt(2);

                const Variable *var = varTok->variable();
                MathLib::bigint dim;
                if (var && var->isArray() && !var->isArgument() && ((dim=var->dimension(0U)) < 2)) {
                    const std::string strDim = MathLib::toString(dim);
                    checkPipeParameterSizeError(varTok,varTok->str(), strDim);
                }
            }
        }
    }
}

void CheckOther::checkPipeParameterSizeError(const Token *tok, const std::string &strVarName, const std::string &strDim)
{
    reportError(tok, Severity::error, ErrorType::None,
                "wrongPipeParameterSize", "Buffer '" + strVarName + "' must have size of 2 integers if used as parameter of pipe().\n"
                "The pipe()/pipe2() system command takes an argument, which is an array of exactly two integers.\n"
				"The variable '" + strVarName + "' is an array of size " + strDim + ", which does not match.", ErrorLogger::GenWebIdentity(tok->str()));
}

//---------------------------------------------------------------------------
// Detect redundant assignments: x = 0; x = 4;
//---------------------------------------------------------------------------

static bool nonLocal(const Variable* var)
{
    return !var || (!var->isLocal() && !var->isArgument()) || var->isStatic() || var->isReference();
}

static void eraseNotLocalArg(std::map<unsigned int, const Token*>& container, const SymbolDatabase* symbolDatabase)
{
    for (std::map<unsigned int, const Token*>::iterator i = container.begin(); i != container.end();) {
        const Variable* var = symbolDatabase->getVariableFromVarId(i->first);
        if (!var || nonLocal(var)) {
            container.erase(i++);
        } else
            ++i;
    }
}

static void eraseMemberAssignments(const unsigned int varId, const std::map<unsigned int, std::set<unsigned int> > &membervars, std::map<unsigned int, const Token*> &varAssignments)
{
    const std::map<unsigned int, std::set<unsigned int> >::const_iterator it = membervars.find(varId);
    if (it != membervars.end()) {
        const std::set<unsigned int>& v = it->second;
        for (std::set<unsigned int>::const_iterator vit = v.begin(); vit != v.end(); ++vit) {
            varAssignments.erase(*vit);
            if (*vit != varId)
                eraseMemberAssignments(*vit, membervars, varAssignments);
        }
    }
}

static bool checkExceptionHandling(const Token* tok)
{
    const Variable* var = tok->variable();
	if (!var)
	{
		return false;
	}
	const Scope* upperScope = tok->scope();
    if (var && upperScope == var->scope())
        return true;
    while (upperScope && upperScope->type != Scope::eTry && upperScope->type != Scope::eLambda && (!var || upperScope->nestedIn != var->scope()) && upperScope->isExecutable()) {
        upperScope = upperScope->nestedIn;
    }

    if (upperScope && upperScope->type == Scope::eTry) {
        // Check all exception han
        const Token* tok2 = upperScope->classEnd;
        while (Token::simpleMatch(tok2, "} catch (")) {
            tok2 = tok2->linkAt(2)->next();
            if (Token::findmatch(tok2, "%varid%", tok2->link(), var->declarationId()))
                return false;
            tok2 = tok2->link();
        }
    }
    return true;
}

void CheckOther::checkRedundantAssignment()
{
    const bool printPerformance = _settings->isEnabled("performance");
    const bool printWarning = _settings->isEnabled("warning");
    if (!printWarning && !printPerformance)
        return;

    const bool printInconclusive = _settings->inconclusive;
    const SymbolDatabase* symbolDatabase = _tokenizer->getSymbolDatabase();

    for (std::list<Scope>::const_iterator scope = symbolDatabase->scopeList.begin(); scope != symbolDatabase->scopeList.end(); ++scope) {
        if (!scope->isExecutable())
            continue;

        std::map<unsigned int, const Token*> varAssignments;
        std::map<unsigned int, const Token*> memAssignments;
        std::map<unsigned int, std::set<unsigned int> > membervars;
        std::set<unsigned int> initialized;
        const Token* writtenArgumentsEnd = nullptr;

        for (const Token* tok = scope->classStart->next(); tok && tok != scope->classEnd; tok = tok->next()) {
            if (tok == writtenArgumentsEnd)
                writtenArgumentsEnd = nullptr;

            if (tok->str() == "?" && tok->astOperand2()) {
                tok = Token::findmatch(tok->astOperand2(), ";|}");
                if (!tok)
                    break;
                varAssignments.clear();
                memAssignments.clear();
            } else if (tok->str() == "{" && tok->strAt(-1) != "{" && tok->strAt(-1) != "=" && tok->strAt(-4) != "case" && tok->strAt(-3) != "default") { // conditional or non-executable inner scope: Skip it and reset status
                tok = tok->link();
                varAssignments.clear();
                memAssignments.clear();
            } else if (Token::Match(tok, "for|if|while (")) {
                tok = tok->linkAt(1);
            } else if (Token::Match(tok, "break|return|continue|throw|goto|asm")) {
                varAssignments.clear();
                memAssignments.clear();
            } else if (tok->tokType() == Token::eVariable && !Token::Match(tok, "%name% (")) {
                // Set initialization flag
                if (!Token::Match(tok, "%var% ["))
                    initialized.insert(tok->varId());
                else {
                    const Token *tok2 = tok->next();
                    while (tok2 && tok2->str() == "[")
                        tok2 = tok2->link()->next();
                    if (tok2 && tok2->str() != ";")
                        initialized.insert(tok->varId());
                }

                const Token *startToken = tok;
                while (Token::Match(startToken, "%name%|::|.")) {
                    startToken = startToken->previous();
                    if (Token::Match(startToken, "%name% . %var%"))
                        membervars[startToken->varId()].insert(startToken->tokAt(2)->varId());
                }

                std::map<unsigned int, const Token*>::iterator it = varAssignments.find(tok->varId());
                if (tok->next() && tok->next()->isAssignmentOp() && Token::Match(startToken, "[;{}]")) { // Assignment
                    if (it != varAssignments.end()) {
                        bool error = true; // Ensure that variable is not used on right side
                        for (const Token* tok2 = tok->tokAt(2); tok2; tok2 = tok2->next()) {
                            if (tok2->str() == ";")
                                break;
                            else if (tok2->varId() == tok->varId()) {
                                error = false;
                                break;
                            } else if (Token::Match(tok2, "%name% (") && nonLocal(tok->variable())) { // Called function might use the variable
                                const Function* const func = tok2->function();
                                const Variable* const var = tok->variable();
                                if (!var || var->isGlobal() || var->isReference() || ((!func || func->nestedIn) && tok2->strAt(-1) != ".")) {// Global variable, or member function
                                    error = false;
                                    break;
                                }
                            }
                        }
                        if (error) {
                            if (printWarning && scope->type == Scope::eSwitch && Token::findmatch(it->second, "default|case", tok))
                                redundantAssignmentInSwitchError(it->second, tok, tok->str());
                            else if (printPerformance) {
                                const bool nonlocal = nonLocal(it->second->variable());
                                if (printInconclusive || !nonlocal) // see #5089 - report inconclusive only when requested
                                    if (_tokenizer->isC() || checkExceptionHandling(tok)) // see #6555 to see how exception handling might have an impact
                                        redundantAssignmentError(it->second, tok, tok->str(), nonlocal); // Inconclusive for non-local variables
                            }
                        }
                        it->second = tok;
                    }
                    if (!Token::simpleMatch(tok->tokAt(2), "0 ;") || (tok->variable() && tok->variable()->nameToken() != tok->tokAt(-2)))
                        varAssignments[tok->varId()] = tok;
                    memAssignments.erase(tok->varId());
                    eraseMemberAssignments(tok->varId(), membervars, varAssignments);
                } else if ((tok->next() && tok->next()->tokType() == Token::eIncDecOp) || (tok->previous()->tokType() == Token::eIncDecOp && tok->strAt(1) == ";")) { // Variable incremented/decremented; Prefix-Increment is only suspicious, if its return value is unused
                    varAssignments[tok->varId()] = tok;
                    memAssignments.erase(tok->varId());
                    eraseMemberAssignments(tok->varId(), membervars, varAssignments);
                } else if (!Token::simpleMatch(tok->tokAt(-2), "sizeof (")) { // Other usage of variable
                    if (it != varAssignments.end())
                        varAssignments.erase(it);
                    if (!writtenArgumentsEnd) // Indicates that we are in the first argument of strcpy/memcpy/... function
                        memAssignments.erase(tok->varId());
                }
            } else if (Token::Match(tok, "%name% (") && _settings->library.functionpure.find(tok->str()) == _settings->library.functionpure.end()) { // Function call. Global variables might be used. Reset their status
                const bool memfunc = Token::Match(tok, "memcpy|memmove|memset|strcpy|strncpy|sprintf|snprintf|strcat|strncat|wcscpy|wcsncpy|swprintf|wcscat|wcsncat");
                if (tok->varId()) // operator() or function pointer
                    varAssignments.erase(tok->varId());

                if (memfunc && tok->strAt(-1) != "(" && tok->strAt(-1) != "=") {
                    const Token* param1 = tok->tokAt(2);
                    writtenArgumentsEnd = param1->next();
                    if (param1->varId() && param1->strAt(1) == "," && !Token::Match(tok, "strcat|strncat|wcscat|wcsncat")) {
                        if (tok->str() == "memset" && initialized.find(param1->varId()) == initialized.end() && param1->variable() && param1->variable()->isLocal() && param1->variable()->isArray())
                            initialized.insert(param1->varId());
                        else if (memAssignments.find(param1->varId()) == memAssignments.end())
                            memAssignments[param1->varId()] = tok;
                        else {
                            const std::map<unsigned int, const Token*>::const_iterator it = memAssignments.find(param1->varId());
                            if (printWarning && scope->type == Scope::eSwitch && Token::findmatch(it->second, "default|case", tok))
                                redundantCopyInSwitchError(it->second, tok, param1->str());
                            else if (printPerformance)
                                redundantCopyError(it->second, tok, param1->str());
                        }
                    }
                } else if (scope->type == Scope::eSwitch) { // Avoid false positives if noreturn function is called in switch
                    const Function* const func = tok->function();
                    if (!func || !func->hasBody()) {
                        varAssignments.clear();
                        memAssignments.clear();
                        continue;
                    }
                    const Token* funcEnd = func->functionScope->classEnd;
                    bool noreturn;
                    if (!_tokenizer->IsScopeNoReturn(funcEnd, &noreturn) && !noreturn) {
                        eraseNotLocalArg(varAssignments, symbolDatabase);
                        eraseNotLocalArg(memAssignments, symbolDatabase);
                    } else {
                        varAssignments.clear();
                        memAssignments.clear();
                    }
                } else { // Noreturn functions outside switch don't cause problems
                    eraseNotLocalArg(varAssignments, symbolDatabase);
                    eraseNotLocalArg(memAssignments, symbolDatabase);
                }
            }
        }
    }
}

void CheckOther::redundantCopyError(const Token *tok1, const Token* tok2, const std::string& var)
{
    const std::list<const Token *> callstack = make_container< std::list<const Token *> >() << tok1 << tok2;
    reportError(callstack, Severity::performance, ErrorType::None, "redundantCopy",
                "Buffer '" + var + "' is being written before its old content has been used.");
}

void CheckOther::redundantCopyInSwitchError(const Token *tok1, const Token* tok2, const std::string &var)
{
    const std::list<const Token *> callstack = make_container< std::list<const Token *> >() << tok1 << tok2;
    reportError(callstack, Severity::warning, ErrorType::None, "redundantCopyInSwitch",
                "Buffer '" + var + "' is being written before its old content has been used. 'break;' missing?");
}

void CheckOther::redundantAssignmentError(const Token *tok1, const Token* tok2, const std::string& var, bool inconclusive)
{
    const std::list<const Token *> callstack = make_container< std::list<const Token *> >() << tok1 << tok2;
    if (inconclusive)
        reportError(callstack, Severity::warning, ErrorType::Logic, "redundantAssignment",
                    "Variable '" + var + "' is reassigned a value before the old one has been used if variable is no semaphore variable.\n"
                    "Variable '" + var + "' is reassigned a value before the old one has been used. Make sure that this variable is not used like a semaphore in a threading environment before simplifying this code.", 0U, true);
    else
		reportError(callstack, Severity::warning, ErrorType::Logic, "redundantAssignment",
                    "Variable '" + var + "' is reassigned a value before the old one has been used.");
}

void CheckOther::redundantAssignmentInSwitchError(const Token *tok1, const Token* tok2, const std::string &var)
{
    const std::list<const Token *> callstack = make_container< std::list<const Token *> >() << tok1 << tok2;
	reportError(callstack, Severity::warning, ErrorType::None, "redundantAssignInSwitch",
                "Variable '" + var + "' is reassigned a value before the old one has been used. 'break;' missing?");
}


//---------------------------------------------------------------------------
//    switch (x)
//    {
//        case 2:
//            y = a;        // <- this assignment is redundant
//        case 3:
//            y = b;        // <- case 2 falls through and sets y twice
//    }
//---------------------------------------------------------------------------
static inline bool isFunctionOrBreakPattern(const Token *tok)
{
    if (Token::Match(tok, "%name% (") || Token::Match(tok, "break|continue|return|exit|goto|throw"))
        return true;

    return false;
}

void CheckOther::checkRedundantAssignmentInSwitch()
{
    if (!_settings->isEnabled("warning"))
        return;

    const SymbolDatabase *symbolDatabase = _tokenizer->getSymbolDatabase();

    // Find the beginning of a switch. E.g.:
    //   switch (var) { ...
    for (std::list<Scope>::const_iterator i = symbolDatabase->scopeList.begin(); i != symbolDatabase->scopeList.end(); ++i) {
        if (i->type != Scope::eSwitch || !i->classStart)
            continue;

        // Check the contents of the switch statement
        std::map<unsigned int, const Token*> varsWithBitsSet;
        std::map<unsigned int, std::string> bitOperations;

        for (const Token *tok2 = i->classStart->next(); tok2 != i->classEnd; tok2 = tok2->next()) {
            if (tok2->str() == "{") {
                // Inside a conditional or loop. Don't mark variable accesses as being redundant. E.g.:
                //   case 3: b = 1;
                //   case 4: if (a) { b = 2; }    // Doesn't make the b=1 redundant because it's conditional
                if (Token::Match(tok2->previous(), ")|else {") && tok2->link()) {
                    const Token* endOfConditional = tok2->link();
                    for (const Token* tok3 = tok2; tok3 != endOfConditional; tok3 = tok3->next()) {
                        if (tok3->varId() != 0) {
                            varsWithBitsSet.erase(tok3->varId());
                            bitOperations.erase(tok3->varId());
                        } else if (isFunctionOrBreakPattern(tok3)) {
                            varsWithBitsSet.clear();
                            bitOperations.clear();
                        }
                    }
                    tok2 = endOfConditional;
                }
            }

            // Variable assignment. Report an error if it's assigned to twice before a break. E.g.:
            //    case 3: b = 1;    // <== redundant
            //    case 4: b = 2;

            if (Token::Match(tok2->previous(), ";|{|}|: %var% = %any% ;")) {
                varsWithBitsSet.erase(tok2->varId());
                bitOperations.erase(tok2->varId());
            }

            // Bitwise operation. Report an error if it's performed twice before a break. E.g.:
            //    case 3: b |= 1;    // <== redundant
            //    case 4: b |= 1;
            else if (Token::Match(tok2->previous(), ";|{|}|: %var% = %name% %or%|& %num% ;") &&
                     tok2->varId() == tok2->tokAt(2)->varId()) {
                std::string bitOp = tok2->strAt(3) + tok2->strAt(4);
                std::map<unsigned int, const Token*>::const_iterator i2 = varsWithBitsSet.find(tok2->varId());

                // This variable has not had a bit operation performed on it yet, so just make a note of it
                if (i2 == varsWithBitsSet.end()) {
                    varsWithBitsSet[tok2->varId()] = tok2;
                    bitOperations[tok2->varId()] = bitOp;
                }

                // The same bit operation has been performed on the same variable twice, so report an error
                else if (bitOperations[tok2->varId()] == bitOp)
                    redundantBitwiseOperationInSwitchError(i2->second, i2->second->str());

                // A different bit operation was performed on the variable, so clear it
                else {
                    varsWithBitsSet.erase(tok2->varId());
                    bitOperations.erase(tok2->varId());
                }
            }

            // Not a simple assignment so there may be good reason if this variable is assigned to twice. E.g.:
            //    case 3: b = 1;
            //    case 4: b++;
            else if (tok2->varId() != 0 && tok2->strAt(1) != "|" && tok2->strAt(1) != "&") {
                varsWithBitsSet.erase(tok2->varId());
                bitOperations.erase(tok2->varId());
            }

            // Reset our record of assignments if there is a break or function call. E.g.:
            //    case 3: b = 1; break;
            if (isFunctionOrBreakPattern(tok2)) {
                varsWithBitsSet.clear();
                bitOperations.clear();
            }
        }
    }
}

void CheckOther::redundantBitwiseOperationInSwitchError(const Token *tok, const std::string &varname)
{
    reportError(tok, Severity::warning, ErrorType::None,
		"redundantBitwiseOperationInSwitch", "Redundant bitwise operation on '" + varname + "' in 'switch' statement. 'break;' missing?", ErrorLogger::GenWebIdentity(tok->str()));
}


//---------------------------------------------------------------------------
// Detect fall through cases (experimental).
//---------------------------------------------------------------------------
void CheckOther::checkSwitchCaseFallThrough()
{
    if (!(_settings->isEnabled("style") && _settings->experimental))
        return;

    const SymbolDatabase* const symbolDatabase = _tokenizer->getSymbolDatabase();

    for (std::list<Scope>::const_iterator i = symbolDatabase->scopeList.begin(); i != symbolDatabase->scopeList.end(); ++i) {
        if (i->type != Scope::eSwitch || !i->classStart) // Find the beginning of a switch
            continue;

        // Check the contents of the switch statement
        std::stack<std::pair<Token *, bool> > ifnest;
        bool justbreak = true;
        bool firstcase = true;
        for (const Token *tok2 = i->classStart; tok2 != i->classEnd; tok2 = tok2->next()) {
            if (Token::simpleMatch(tok2, "if (")) {
                tok2 = tok2->next()->link()->next();
                ifnest.push(std::make_pair(tok2->link(), false));
                justbreak = false;
            } else if (Token::simpleMatch(tok2, "while (")) {
                tok2 = tok2->next()->link()->next();
                if (tok2->link()) // skip over "do { } while ( ) ;" case
                    tok2 = tok2->link();
                justbreak = false;
            } else if (Token::simpleMatch(tok2, "do {")) {
                tok2 = tok2->next()->link();
                justbreak = false;
            } else if (Token::simpleMatch(tok2, "for (")) {
                tok2 = tok2->next()->link()->next()->link();
                justbreak = false;
            } else if (Token::simpleMatch(tok2, "switch (")) {
                // skip over nested switch, we'll come to that soon
                tok2 = tok2->next()->link()->next()->link();
			}
			else if (Token::Match(tok2, "break|continue|return|exit|goto|throw|ExitProcess") || CGlobalTokenizer::Instance()->CheckIfReturn(tok2)) {
                justbreak = true;
                tok2 = Token::findsimplematch(tok2, ";");
            } else if (Token::Match(tok2, "case|default")) {
                if (!justbreak && !firstcase) {
                    switchCaseFallThrough(tok2);
                }
                tok2 = Token::findsimplematch(tok2, ":");
                justbreak = true;
                firstcase = false;
            } else if (tok2->str() == "}") {
                if (!ifnest.empty() && tok2 == ifnest.top().first) {
                    if (tok2->next()->str() == "else") {
                        tok2 = tok2->tokAt(2);
                        ifnest.pop();
                        ifnest.push(std::make_pair(tok2->link(), justbreak));
                        justbreak = false;
                    } else {
                        justbreak &= ifnest.top().second;
                        ifnest.pop();
                    }
                }
            } else if (tok2->str() != ";") {
                justbreak = false;
            }
        }
    }
}

void CheckOther::switchCaseFallThrough(const Token *tok)
{
	//后面是default且，default无逻辑时不报错
	if (Token::Match(tok, "default : ; { break|return|exit|ExitProcess|assert"))
	{
		return;
	}
	reportError(tok, Severity::style, ErrorType::Logic,
		"SwitchNoBreakUP", "Switch falls through case without comment. 'break;' missing?", ErrorLogger::GenWebIdentity(tok->str()));
}


//---------------------------------------------------------------------------
// Check for statements like case A||B: in switch()
//---------------------------------------------------------------------------
void CheckOther::checkSuspiciousCaseInSwitch()
{
    if (!_settings->inconclusive || !_settings->isEnabled("warning"))
        return;

    const SymbolDatabase *symbolDatabase = _tokenizer->getSymbolDatabase();

    for (std::list<Scope>::const_iterator i = symbolDatabase->scopeList.begin(); i != symbolDatabase->scopeList.end(); ++i) {
        if (i->type != Scope::eSwitch)
            continue;

        for (const Token* tok = i->classStart->next(); tok != i->classEnd; tok = tok->next()) {
            if (tok->str() == "case") {
                const Token* finding = nullptr;
                for (const Token* tok2 = tok->next(); tok2; tok2 = tok2->next()) {
                    if (tok2->str() == ":")
                        break;
                    if (Token::Match(tok2, "[;}{]"))
                        break;

                    if (tok2->str() == "?")
                        finding = nullptr;
                    else if (Token::Match(tok2, "&&|%oror%"))
                        finding = tok2;
                }
                if (finding)
                    suspiciousCaseInSwitchError(finding, finding->str());
            }
        }
    }
}

void CheckOther::suspiciousCaseInSwitchError(const Token* tok, const std::string& operatorString)
{
    reportError(tok, Severity::warning, ErrorType::None, "suspiciousCase",
                "Found suspicious case label in switch(). Operator '" + operatorString + "' probably doesn't work as intended.\n"
                "Using an operator like '" + operatorString + "' in a case label is suspicious. Did you intend to use a bitwise operator, multiple case labels or if/else instead?", 0U, true);
}

//---------------------------------------------------------------------------
//    if (x == 1)
//        x == 0;       // <- suspicious equality comparison.
//---------------------------------------------------------------------------
void CheckOther::checkSuspiciousEqualityComparison()
{
    if (!_settings->isEnabled("warning") || !_settings->inconclusive)
        return;

    const SymbolDatabase* symbolDatabase = _tokenizer->getSymbolDatabase();
    const std::size_t functions = symbolDatabase->functionScopes.size();
    for (std::size_t i = 0; i < functions; ++i) {
        const Scope * scope = symbolDatabase->functionScopes[i];
        for (const Token* tok = scope->classStart; tok != scope->classEnd; tok = tok->next()) {
            if (Token::simpleMatch(tok, "for (")) {
                const Token* const openParen = tok->next();
                const Token* const closeParen = tok->linkAt(1);

                // Search for any suspicious equality comparison in the initialization
                // or increment-decrement parts of the for() loop.
                // For example:
                //    for (i == 2; i < 10; i++)
                // or
                //    for (i = 0; i < 10; i == a)
                if (Token::Match(openParen->next(), "%name% =="))
                    suspiciousEqualityComparisonError(openParen->tokAt(2));
                if (Token::Match(closeParen->tokAt(-2), "== %any%"))
                    suspiciousEqualityComparisonError(closeParen->tokAt(-2));

                // Skip over for() loop conditions because "for (;running==1;)"
                // is a bit strange, but not necessarily incorrect.
                tok = closeParen;
            } else if (Token::Match(tok, "[;{}] *| %name% == %any% ;")) {

                // Exclude compound statements surrounded by parentheses, such as
                //    printf("%i\n", ({x==0;}));
                // because they may appear as an expression in GNU C/C++.
                // See http://gcc.gnu.org/onlinedocs/gcc/Statement-Exprs.html
                const Token* afterStatement = tok->strAt(1) == "*" ? tok->tokAt(6) : tok->tokAt(5);
                if (!Token::simpleMatch(afterStatement, "} )"))
                    suspiciousEqualityComparisonError(tok->next());
            }
        }
    }
}

void CheckOther::suspiciousEqualityComparisonError(const Token* tok)
{
    reportError(tok, Severity::warning, ErrorType::None, "suspiciousEqualityComparison",
                "Found suspicious equality comparison. Did you intend to assign a value instead?", 0U, true);
}


//---------------------------------------------------------------------------
// strtol(str, 0, radix)  <- radix must be 0 or 2-36
//---------------------------------------------------------------------------
void CheckOther::invalidFunctionUsage()
{
    const SymbolDatabase* symbolDatabase = _tokenizer->getSymbolDatabase();
    const std::size_t functions = symbolDatabase->functionScopes.size();
    for (std::size_t i = 0; i < functions; ++i) {
        const Scope * scope = symbolDatabase->functionScopes[i];
        for (const Token* tok = scope->classStart->next(); tok != scope->classEnd; tok = tok->next()) {
            if (!tok->isName() || !Token::Match(tok, "%name% ( !!)"))
                continue;
            const Token * const functionToken = tok;
            int argnr = 1;
            const Token *argtok = tok->tokAt(2);
            do {
                if (Token::Match(argtok,"%num% [,)]")) {
                    if (MathLib::isInt(argtok->str()) &&
                        !_settings->library.isargvalid(functionToken, argnr, MathLib::toLongNumber(argtok->str())))
                        invalidFunctionArgError(argtok,functionToken->str(),argnr,_settings->library.validarg(functionToken,argnr));
                } else {
                    const Token *top = argtok;
                    while (top->astParent() && top->astParent()->str() != "," && top->astParent() != tok->next())
                        top = top->astParent();
                    if (top->isComparisonOp() || Token::Match(top, "%oror%|&&")) {
                        if (_settings->library.isboolargbad(functionToken, argnr))
                            invalidFunctionArgBoolError(top, functionToken->str(), argnr);

                        // Are the values 0 and 1 valid?
                        else if (!_settings->library.isargvalid(functionToken, argnr, 0))
                            invalidFunctionArgError(top, functionToken->str(), argnr, _settings->library.validarg(functionToken,argnr));
                        else if (!_settings->library.isargvalid(functionToken, argnr, 1))
                            invalidFunctionArgError(top, functionToken->str(), argnr, _settings->library.validarg(functionToken,argnr));
                    }
                }
                argnr++;
                argtok = argtok->nextArgument();
            } while (argtok && argtok->str() != ")");
        }
    }
}

void CheckOther::invalidFunctionArgError(const Token *tok, const std::string &functionName, int argnr, const std::string &validstr)
{
    std::ostringstream errmsg;
    errmsg << "Invalid " << functionName << "() argument nr " << argnr;
    if (!tok)
		return;
    if (tok->isNumber())
        errmsg << ". The value is " << tok->str() << " but the valid values are '" << validstr << "'.";
    else if (tok->isComparisonOp())
        errmsg << ". The value is 0 or 1 (comparison result) but the valid values are '" << validstr << "'.";
	reportError(tok, Severity::error, ErrorType::None, "invalidFunctionArg", errmsg.str(), ErrorLogger::GenWebIdentity(tok->str()));
}

void CheckOther::invalidFunctionArgBoolError(const Token *tok, const std::string &functionName, int argnr)
{
    std::ostringstream errmsg;
    errmsg << "Invalid " << functionName << "() argument nr " << argnr << ". A non-boolean value is required.";
	reportError(tok, Severity::error, ErrorType::None, "invalidFunctionArgBool", errmsg.str(), ErrorLogger::GenWebIdentity(tok->str()));
}

//---------------------------------------------------------------------------
//    Find consecutive return, break, continue, goto or throw statements. e.g.:
//        break; break;
//    Detect dead code, that follows such a statement. e.g.:
//        return(0); foo();
//---------------------------------------------------------------------------
void CheckOther::checkUnreachableCode()
{
    if (!_settings->isEnabled("style"))
        return;
    const bool printInconclusive = _settings->inconclusive;
    const SymbolDatabase* symbolDatabase = _tokenizer->getSymbolDatabase();
    const std::size_t functions = symbolDatabase->functionScopes.size();
    for (std::size_t i = 0; i < functions; ++i) {
        const Scope * scope = symbolDatabase->functionScopes[i];

        for (const Token* tok = scope->classStart; tok && tok != scope->classEnd; tok = tok->next()) {
            const Token* secondBreak = 0;
            const Token* labelName = 0;
            if (tok->link() && Token::Match(tok, "(|[|<"))
                tok = tok->link();
            else if (Token::Match(tok, "break|continue ;"))
                secondBreak = tok->tokAt(2);
            else if (Token::Match(tok, "[;{}:] return|throw")) {
                tok = tok->next(); // tok should point to return or throw
                for (const Token *tok2 = tok->next(); tok2; tok2 = tok2->next()) {
                    if (tok2->str() == "(" || tok2->str() == "{")
                        tok2 = tok2->link();
                    if (tok2->str() == ";") {
                        secondBreak = tok2->next();
                        break;
                    }
                }
            } else if (Token::Match(tok, "goto %any% ;")) {
                secondBreak = tok->tokAt(3);
                labelName = tok->next();
            } else if (Token::Match(tok, "%name% (") && _settings->library.isnoreturn(tok) && !Token::Match(tok->next()->astParent(), "?|:")) {
                if ((!tok->function() || (tok->function()->token != tok && tok->function()->tokenDef != tok)) && tok->linkAt(1)->strAt(1) != "{")
                    secondBreak = tok->linkAt(1)->tokAt(2);
            }

            // Statements follow directly, no line between them. (#3383)
            // TODO: Try to find a better way to avoid false positives due to preprocessor configurations.
            const bool inconclusive = secondBreak && (secondBreak->linenr() - 1 > secondBreak->previous()->linenr());

            if (secondBreak && (printInconclusive || !inconclusive)) {
                if (Token::Match(secondBreak, "continue|goto|throw") ||
                    (secondBreak->str() == "return" && (tok->str() == "return" || secondBreak->strAt(1) == ";"))) { // return with value after statements like throw can be necessary to make a function compile
                    duplicateBreakError(secondBreak, inconclusive);
                    tok = Token::findmatch(secondBreak, "[}:]");
                } else if (secondBreak->str() == "break") { // break inside switch as second break statement should not issue a warning
                    if (tok->str() == "break") // If the previous was a break, too: Issue warning
                        duplicateBreakError(secondBreak, inconclusive);
                    else {
                        if (tok->scope()->type != Scope::eSwitch) // Check, if the enclosing scope is a switch
                            duplicateBreakError(secondBreak, inconclusive);
                    }
                    tok = Token::findmatch(secondBreak, "[}:]");
                } else if (!Token::Match(secondBreak, "return|}|case|default") && secondBreak->strAt(1) != ":") { // TODO: No bailout for unconditional scopes
                    // If the goto label is followed by a loop construct in which the label is defined it's quite likely
                    // that the goto jump was intended to skip some code on the first loop iteration.
                    bool labelInFollowingLoop = false;
                    if (labelName && Token::Match(secondBreak, "while|do|for")) {
                        const Token *scope2 = Token::findsimplematch(secondBreak, "{");
                        if (scope2) {
                            for (const Token *tokIter = scope2; tokIter != scope2->link() && tokIter; tokIter = tokIter->next()) {
                                if (Token::Match(tokIter, "[;{}] %any% :") && labelName->str() == tokIter->strAt(1)) {
                                    labelInFollowingLoop = true;
                                    break;
                                }
                            }
                        }
                    }

                    // hide FP for statements that just hide compiler warnings about unused function arguments
                    bool silencedCompilerWarningOnly = false;
                    const Token *silencedWarning = secondBreak;
                    for (;;) {
                        if (Token::Match(silencedWarning, "( void ) %name% ;")) {
                            silencedWarning = silencedWarning->tokAt(5);
                            continue;
                        } else if (silencedWarning && silencedWarning == scope->classEnd)
                            silencedCompilerWarningOnly = true;

                        break;
                    }
                    if (silencedWarning)
                        secondBreak = silencedWarning;

                    if (!labelInFollowingLoop && !silencedCompilerWarningOnly)
                        unreachableCodeError(secondBreak, inconclusive);
                    tok = Token::findmatch(secondBreak, "[}:]");
                } else
                    tok = secondBreak;

                if (!tok)
                    break;
                tok = tok->previous(); // Will be advanced again by for loop
            }
        }
    }
}

void CheckOther::duplicateBreakError(const Token *tok, bool inconclusive)
{
    reportError(tok, Severity::style, ErrorType::None, "duplicateBreak",
                "Consecutive return, break, continue, goto or throw statements are unnecessary.\n"
                "Consecutive return, break, continue, goto or throw statements are unnecessary. "
                "The second statement can never be executed, and so should be removed.", 0U, inconclusive);
}

void CheckOther::unreachableCodeError(const Token *tok, bool inconclusive)
{
    reportError(tok, Severity::style, ErrorType::Logic, "unreachableCode",
                "Statements following return, break, continue, goto or throw will never be executed.", 0U, inconclusive);
}

//---------------------------------------------------------------------------
// memset(p, y, 0 /* bytes to fill */) <- 2nd and 3rd arguments inverted
//---------------------------------------------------------------------------
void CheckOther::checkMemsetZeroBytes()
{
    if (!_settings->isEnabled("warning"))
        return;

    const SymbolDatabase *symbolDatabase = _tokenizer->getSymbolDatabase();
    const std::size_t functions = symbolDatabase->functionScopes.size();
    for (std::size_t i = 0; i < functions; ++i) {
        const Scope * scope = symbolDatabase->functionScopes[i];
        for (const Token* tok = scope->classStart->next(); tok != scope->classEnd; tok = tok->next()) {
            if (Token::Match(tok, "memset|bzero (")) {
				//if memset second param is 0,not report error
				if (tok->str() == "memset")
				{
					const Token* secondParamTok = tok->next()->astOperand2();
					if (secondParamTok && secondParamTok->astOperand1())
					{
						secondParamTok = secondParamTok->astOperand1()->astOperand2();
						if (secondParamTok && secondParamTok->str() == "0")
						{
							tok = tok->next()->link();
							continue;
						}
					}
				}

                const Token* lastParamTok = tok->next()->link()->previous();
				if (lastParamTok->str() == "0")
				{
					const Token* tmpTok = tok->tokAt(2);

					while (tmpTok && tmpTok->str() != ",")
					{
						tmpTok = tmpTok->next();
					}
					if (tmpTok && tmpTok->str() == ",")
					{
						tmpTok = tmpTok->previous();
					}
					if (tmpTok)
						memsetZeroBytesError(tok, tmpTok->str());
				}
            }
        }
    }
}

void CheckOther::memsetZeroBytesError(const Token *tok, const std::string &varname)
{
    const std::string summary("memset() called to fill 0 bytes of '" + varname + "'.");
    const std::string verbose(summary + " The second and third arguments might be inverted."
                              " The function memset ( void * ptr, int value, size_t num ) sets the"
                              " first num bytes of the block of memory pointed by ptr to the specified value.");
    reportError(tok, Severity::warning, ErrorType::Suspicious, "memsetZeroBytes", summary + "\n" + verbose, ErrorLogger::GenWebIdentity(varname));
}

void CheckOther::checkMemsetInvalid2ndParam()
{
    const bool printPortability = _settings->isEnabled("portability");
    const bool printWarning = _settings->isEnabled("warning");
    if (!printWarning && !printPortability)
        return;

    const SymbolDatabase *symbolDatabase = _tokenizer->getSymbolDatabase();
    const std::size_t functions = symbolDatabase->functionScopes.size();
    for (std::size_t i = 0; i < functions; ++i) {
        const Scope * scope = symbolDatabase->functionScopes[i];
        for (const Token* tok = scope->classStart->next(); tok && (tok != scope->classEnd); tok = tok->next()) {
            if (Token::simpleMatch(tok, "memset (")) {
                const Token* firstParamTok = tok->tokAt(2);
                if (!firstParamTok)
                    continue;
                const Token* secondParamTok = firstParamTok->nextArgument();
                if (!secondParamTok)
                    continue;

                // Second parameter is zero literal, i.e. 0.0f
                if (Token::Match(secondParamTok, "%num% ,") && MathLib::isNullValue(secondParamTok->str()))
                    continue;

                const Token *top = secondParamTok;
                while (top->astParent() && top->astParent()->str() != ",")
                    top = top->astParent();

                // Check if second parameter is a float variable or a float literal != 0.0f
                if (printPortability && astIsFloat(top,false)) {
                    memsetFloatError(secondParamTok, top->expressionString());
                } else if (printWarning && secondParamTok->isNumber()) { // Check if the second parameter is a literal and is out of range
                    const long long int value = MathLib::toLongNumber(secondParamTok->str());
                    if (value < -128 || value > 255)
                        memsetValueOutOfRangeError(secondParamTok, secondParamTok->str());
                }
            }
        }
    }
}

void CheckOther::memsetFloatError(const Token *tok, const std::string &var_value)
{
    const std::string message("The 2nd memset() argument '" + var_value +
                              "' is a float, its representation is implementation defined.");
    const std::string verbose(message + " memset() is used to set each byte of a block of memory to a specific value and"
                              " the actual representation of a floating-point value is implementation defined.");
	reportError(tok, Severity::portability, ErrorType::None, "memsetFloat", message + "\n" + verbose, ErrorLogger::GenWebIdentity(tok->str()));
}

void CheckOther::memsetValueOutOfRangeError(const Token *tok, const std::string &value)
{
    const std::string message("The 2nd memset() argument '" + value + "' doesn't fit into an 'unsigned char'.");
    const std::string verbose(message + " The 2nd parameter is passed as an 'int', but the function fills the block of memory using the 'unsigned char' conversion of this value.");
	reportError(tok, Severity::warning, ErrorType::None, "memsetValueOutOfRange", message + "\n" + verbose, ErrorLogger::GenWebIdentity(tok->str()));
}

//---------------------------------------------------------------------------
// Check scope of variables..
//---------------------------------------------------------------------------
void CheckOther::checkVariableScope()
{
    if (!_settings->isEnabled("style"))
        return;

    const SymbolDatabase *symbolDatabase = _tokenizer->getSymbolDatabase();

	for (std::size_t i = 1; i < symbolDatabase->getVariableListSize(); i++) {
        const Variable* var = symbolDatabase->getVariableFromVarId(i);
        if (!var || !var->isLocal() || (!var->isPointer() && !var->typeStartToken()->isStandardType()))
            continue;

        if (var->isConst())
            continue;

        bool forHead = false; // Don't check variables declared in header of a for loop
        for (const Token* tok = var->typeStartToken(); tok; tok = tok->previous()) {
            if (tok->str() == "(") {
                forHead = true;
                break;
            } else if (tok->str() == "{" || tok->str() == ";" || tok->str() == "}")
                break;
        }
        if (forHead)
            continue;

        const Token* tok = var->nameToken()->next();
        if (Token::Match(tok, "; %varid% = %any% ;", var->declarationId())) {
            tok = tok->tokAt(3);
            if (!tok->isNumber() && tok->tokType() != Token::eString && tok->tokType() != Token::eChar && !tok->isBoolean())
                continue;
        }
        bool reduce = true;
        bool used = false; // Don't warn about unused variables
        for (; tok && tok != var->scope()->classEnd; tok = tok->next()) {
            if (tok->str() == "{" && tok->scope() != tok->previous()->scope() && !tok->isExpandedMacro() && tok->scope()->type != Scope::eLambda) {
                if (used) {
                    bool used2 = false;
                    if (!checkInnerScope(tok, var, used2) || used2) {
                        reduce = false;
                        break;
                    }
                } else if (!checkInnerScope(tok, var, used)) {
                    reduce = false;
                    break;
                }

                tok = tok->link();

                // parse else if blocks..
            } else if (Token::simpleMatch(tok, "else { if (") && Token::simpleMatch(tok->linkAt(3), ") {")) {
                const Token *endif = tok->linkAt(3)->linkAt(1);
                bool elseif = false;
                if (Token::simpleMatch(endif, "} }"))
                    elseif = true;
                else if (Token::simpleMatch(endif, "} else {") && Token::simpleMatch(endif->linkAt(2),"} }"))
                    elseif = true;
                if (elseif && Token::findmatch(tok->next(), "%varid%", tok->linkAt(1), var->declarationId())) {
                    reduce = false;
                    break;
                }
            } else if (tok->varId() == var->declarationId() || tok->str() == "goto") {
                reduce = false;
                break;
            }
        }

        if (reduce && used)
            variableScopeError(var->nameToken(), var->name());
    }
}

bool CheckOther::checkInnerScope(const Token *tok, const Variable* var, bool& used)
{
    const Scope* scope = tok->next()->scope();
    bool loopVariable = scope->type == Scope::eFor || scope->type == Scope::eWhile || scope->type == Scope::eDo;
    bool noContinue = true;
    const Token* forHeadEnd = 0;
    const Token* end = tok->link();
    if (scope->type == Scope::eUnconditional && (tok->strAt(-1) == ")" || tok->previous()->isName())) // Might be an unknown macro like BOOST_FOREACH
        loopVariable = true;

    if (scope->type == Scope::eDo) {
        end = end->linkAt(2);
    } else if (loopVariable && tok->strAt(-1) == ")") {
        tok = tok->linkAt(-1); // Jump to opening ( of for/while statement
    } else if (scope->type == Scope::eSwitch) {
        for (std::list<Scope*>::const_iterator i = scope->nestedList.begin(); i != scope->nestedList.end(); ++i) {
            if (used) {
                bool used2 = false;
                if (!checkInnerScope((*i)->classStart, var, used2) || used2) {
                    return false;
                }
            } else if (!checkInnerScope((*i)->classStart, var, used)) {
                return false;
            }
        }
    }

    bool bFirstAssignment=false;
    for (; tok && tok != end; tok = tok->next()) {
        if (tok->str() == "goto")
            return false;
        if (tok->str() == "continue")
            noContinue = false;

        if (Token::simpleMatch(tok, "for ("))
            forHeadEnd = tok->linkAt(1);
        if (tok == forHeadEnd)
            forHeadEnd = 0;

        if (loopVariable && noContinue && tok->scope() == scope && !forHeadEnd && scope->type != Scope::eSwitch && Token::Match(tok, "%varid% =", var->declarationId())) { // Assigned in outer scope.
            loopVariable = false;
            unsigned int indent = 0;
            for (const Token* tok2 = tok->tokAt(2); tok2; tok2 = tok2->next()) { // Ensure that variable isn't used on right side of =, too
                if (tok2->str() == "(")
                    indent++;
                else if (tok2->str() == ")") {
                    if (indent == 0)
                        break;
                    indent--;
                } else if (tok2->str() == ";")
                    break;
                else if (tok2->varId() == var->declarationId()) {
                    loopVariable = true;
                    break;
                }
            }
        }

        if (loopVariable && Token::Match(tok, "%varid% !!=", var->declarationId())) // Variable used in loop
            return false;

        if (Token::Match(tok, "& %varid%", var->declarationId())) // Taking address of variable
            return false;

        if (Token::Match(tok, "%varid% = %any%", var->declarationId()))
            bFirstAssignment = true;

        if (!bFirstAssignment && Token::Match(tok, "* %varid%", var->declarationId())) // dereferencing means access to previous content
            return false;

        if (Token::Match(tok, "= %varid%", var->declarationId()) && (var->isArray() || var->isPointer())) // Create a copy of array/pointer. Bailout, because the memory it points to might be necessary in outer scope
            return false;

        if (tok->varId() == var->declarationId()) {
            used = true;
            if (scope->type == Scope::eSwitch && scope == tok->scope())
                return false; // Used in outer switch scope - unsafe or impossible to reduce scope
        }
    }

    return true;
}

void CheckOther::variableScopeError(const Token *tok, const std::string &varname)
{
    reportError(tok,
                Severity::style, ErrorType::None,
                "variableScope",
                "The scope of the variable '" + varname + "' can be reduced.\n"
                "The scope of the variable '" + varname + "' can be reduced. Warning: Be careful "
                "when fixing this message, especially when there are inner loops. Here is an "
                "example where tscancode will write that the scope for 'i' can be reduced:\n"
                "void f(int x)\n"
                "{\n"
                "    int i = 0;\n"
                "    if (x) {\n"
                "        // it's safe to move 'int i = 0;' here\n"
                "        for (int n = 0; n < 10; ++n) {\n"
                "            // it is possible but not safe to move 'int i = 0;' here\n"
                "            do_something(&i);\n"
                "        }\n"
                "    }\n"
                "}\n"
				"When you see this message it is always safe to reduce the variable scope 1 level.", ErrorLogger::GenWebIdentity(tok->str()));
}

//---------------------------------------------------------------------------
// Comma in return statement: return a+1, b++;. (experimental)
//---------------------------------------------------------------------------
void CheckOther::checkCommaSeparatedReturn()
{
    // This is experimental for now. See #5076
    if (!_settings->experimental)
        return;

    if (!_settings->isEnabled("style"))
        return;

    for (const Token *tok = _tokenizer->tokens(); tok; tok = tok->next()) {
        if (tok->str() == "return") {
            tok = tok->next();
            while (tok && tok->str() != ";") {
                if (tok->link() && Token::Match(tok, "[([{<]"))
                    tok = tok->link();

                if (!tok->isExpandedMacro() && tok->str() == "," && tok->linenr() != tok->next()->linenr())
                    commaSeparatedReturnError(tok);

                tok = tok->next();
            }
            // bailout: missing semicolon (invalid code / bad tokenizer)
            if (!tok)
                break;
        }
    }
}

void CheckOther::commaSeparatedReturnError(const Token *tok)
{
    reportError(tok,
                Severity::style, ErrorType::None,
                "commaSeparatedReturn",
                "Comma is used in return statement. The comma can easily be misread as a ';'.\n"
                "Comma is used in return statement. When comma is used in a return statement it can "
                "easily be misread as a semicolon. For example in the code below the value "
                "of 'b' is returned if the condition is true, but it is easy to think that 'a+1' is "
                "returned:\n"
                "    if (x)\n"
                "        return a + 1,\n"
                "    b++;\n"
                "However it can be useful to use comma in macros. tscancode does not warn when such a "
				"macro is then used in a return statement, it is less likely such code is misunderstood.", ErrorLogger::GenWebIdentity(tok->str()));
}

//---------------------------------------------------------------------------
// Check for constant function parameters
//---------------------------------------------------------------------------
void CheckOther::checkConstantFunctionParameter()
{
    if (!_settings->isEnabled("performance") || _tokenizer->isC())
        return;

    const SymbolDatabase * const symbolDatabase = _tokenizer->getSymbolDatabase();

	for (std::size_t i = 1; i < symbolDatabase->getVariableListSize(); i++) {
        const Variable* var = symbolDatabase->getVariableFromVarId(i);
        if (!var || !var->isArgument() || !var->isClass() || !var->isConst() || var->isPointer() || var->isArray() || var->isReference())
            continue;

        if (var->scope() && var->scope()->function->arg->link()->strAt(-1) == ".")
            continue; // references could not be used as va_start parameters (#5824)

        const Token* const tok = var->typeStartToken();
        // TODO: False negatives. This pattern only checks for string.
        //       Investigate if there are other classes in the std
        //       namespace and add them to the pattern. There are
        //       streams for example (however it seems strange with
        //       const stream parameter).
        if (var->isStlStringType()) {
            passedByValueError(tok, var->name());
        } else if (var->isStlType() && Token::Match(tok, "std :: %type% <") && !Token::simpleMatch(tok->linkAt(3), "> ::")) {
            passedByValueError(tok, var->name());
        } else if (var->type()) {  // Check if type is a struct or class.
            passedByValueError(tok, var->name());
        }
    }
}

void CheckOther::passedByValueError(const Token *tok, const std::string &parname)
{
	reportError(tok, Severity::performance, ErrorType::None, "passedByValue",
		"Function parameter '" + parname + "' should be passed by reference.\n"
		"Parameter '" + parname + "' is passed by value. It could be passed "
		"as a (const) reference which is usually faster and recommended in C++.", ErrorLogger::GenWebIdentity(tok->str()));
}

//---------------------------------------------------------------------------
// Check usage of char variables..
//---------------------------------------------------------------------------

void CheckOther::checkCharVariable()
{
    if (!_settings->isEnabled("warning"))
        return;

    const SymbolDatabase *symbolDatabase = _tokenizer->getSymbolDatabase();
    const std::size_t functions = symbolDatabase->functionScopes.size();
    for (std::size_t i = 0; i < functions; ++i) {
        const Scope * scope = symbolDatabase->functionScopes[i];
        for (const Token* tok = scope->classStart; tok != scope->classEnd; tok = tok->next()) {
            if (Token::Match(tok, "%var% [")) {
                if (!tok->variable() || !tok->variable()->isArray())
                    continue;
                const Token *index = tok->next()->astOperand2();
                if (astIsSignedChar(index) && index->getValueGE(0x80, _settings))
                    charArrayIndexError(tok);
            }
            if (Token::Match(tok, "[&|^]") && tok->astOperand2() && tok->astOperand1()) {
                bool warn = false;
                if (astIsSignedChar(tok->astOperand1())) {
                    const ValueFlow::Value *v1 = tok->astOperand1()->getValueLE(-1, _settings);
                    const ValueFlow::Value *v2 = tok->astOperand2()->getMaxValue(false);
                    if (!v1)
                        v1 = tok->astOperand1()->getValueGE(0x80, _settings);
                    if (v1 && !(tok->str() == "&" && v2 && v2->isKnown() && v2->intvalue >= 0 && v2->intvalue < 0x100))
                        warn = true;
                }
                if (!warn && astIsSignedChar(tok->astOperand2())) {
                    const ValueFlow::Value *v1 = tok->astOperand2()->getValueLE(-1, _settings);
                    const ValueFlow::Value *v2 = tok->astOperand1()->getMaxValue(false);
                    if (!v1)
                        v1 = tok->astOperand2()->getValueGE(0x80, _settings);
                    if (v1 && !(tok->str() == "&" && v2 && v2->isKnown() && v2->intvalue >= 0 && v2->intvalue < 0x100))
                        warn = true;
                }
                if (!warn)
                    continue;

                // is the result stored in a short|int|long?
                if (Token::simpleMatch(tok->astParent(), "=")) {
                    const Token *lhs = tok->astParent()->astOperand1();
                    if (lhs && lhs->valueType() && lhs->valueType()->type >= ValueType::Type::SHORT)
                        charBitOpError(tok); // This is an error..
                }
            }
        }
    }
}

void CheckOther::charArrayIndexError(const Token *tok)
{
    reportError(tok,
                Severity::warning, ErrorType::None,
                "charArrayIndex",
                "Signed 'char' type used as array index.\n"
                "Signed 'char' type used as array index. If the value "
                "can be greater than 127 there will be a buffer underflow "
				"because of sign extension.", ErrorLogger::GenWebIdentity(tok->str()));
}

void CheckOther::charBitOpError(const Token *tok)
{
    reportError(tok,
                Severity::warning, ErrorType::None,
                "charBitOp",
                "When using 'char' variables in bit operations, sign extension can generate unexpected results.\n"
                "When using 'char' variables in bit operations, sign extension can generate unexpected results. For example:\n"
                "    char c = 0x80;\n"
                "    int i = 0 | c;\n"
                "    if (i & 0x8000)\n"
                "        printf(\"not expected\");\n"
				"The \"not expected\" will be printed on the screen.",  ErrorLogger::GenWebIdentity(tok->str()));
}

//---------------------------------------------------------------------------
// Incomplete statement..
//---------------------------------------------------------------------------
void CheckOther::checkIncompleteStatement()
{
    if (!_settings->isEnabled("warning"))
        return;

    for (const Token *tok = _tokenizer->tokens(); tok; tok = tok->next()) {
        if (tok->str() == "(") {
            tok = tok->link();
            if (Token::simpleMatch(tok, ") {") && Token::simpleMatch(tok->next()->link(), "} ;"))
                tok = tok->next()->link();
        }

        else if (Token::simpleMatch(tok, "= {"))
            tok = tok->next()->link();

        // C++11 struct/array/etc initialization in initializer list
        else if (Token::Match(tok->previous(), "%name%|] {") && !Token::findsimplematch(tok,";",tok->link()))
            tok = tok->link();

        // C++11 vector initialization / return { .. }
        else if (Token::Match(tok,"> %name% {") || Token::Match(tok, "[;{}] return {"))
            tok = tok->linkAt(2);

        // C++11 initialize set in initalizer list : [,:] std::set<int>{1} [{,]
        else if (Token::simpleMatch(tok,"> {") && tok->link())
            tok = tok->next()->link();

        else if (Token::Match(tok, "[;{}] %str%|%num%")) {
            // No warning if numeric constant is followed by a "." or ","
            if (Token::Match(tok->next(), "%num% [,.]"))
                continue;

            // No warning for [;{}] (void *) 0 ;
            if (Token::Match(tok, "[;{}] 0 ;") && (tok->next()->isCast() || tok->next()->isExpandedMacro()))
                continue;

            // bailout if there is a "? :" in this statement
            bool bailout = false;
            for (const Token *tok2 = tok->tokAt(2); tok2; tok2 = tok2->next()) {
                if (tok2->str() == "?") {
                    bailout = true;
                    break;
                } else if (tok2->str() == ";")
                    break;
            }
            if (bailout)
                continue;

            // no warning if this is the last statement in a ({})
            for (const Token *tok2 = tok->next(); tok2; tok2 = tok2->next()) {
                if (tok2->str() == "(")
                    tok2 = tok2->link();
                else if (Token::Match(tok2, "[;{}]")) {
                    bailout = Token::simpleMatch(tok2, "; } )");
                    break;
                }
            }
            if (bailout)
                continue;

            constStatementError(tok->next(), tok->next()->isNumber() ? "numeric" : "string");
        }
    }
}

void CheckOther::constStatementError(const Token *tok, const std::string &type)
{
	reportError(tok, Severity::warning, ErrorType::None, "constStatement", "Redundant code: Found a statement that begins with " + type + " constant.", ErrorLogger::GenWebIdentity(tok->str()));
}

//---------------------------------------------------------------------------
// Detect division by zero.
//---------------------------------------------------------------------------
void CheckOther::checkZeroDivision()
{
    //const bool printWarnings = _settings->isEnabled("warning");
    //const bool printInconclusive = _settings->inconclusive;

    for (const Token *tok = _tokenizer->tokens(); tok; tok = tok->next()) {

		//from TSC1.0
		//bug fixed. eg.  boost::format( "SpeedCluster, select failed, ret=%d, err=%d, timeout=%d ms") % ret % err % timeout);
		if (Token::Match(tok, "format ("))
		{
			tok = tok->tokAt(1)->link();
			while (tok && tok->str() != ";")
			{
				tok = tok->next();
			}

		}
		if (Token::Match(tok, "[/%] %num%") &&
			MathLib::isInt(tok->next()->str()) &&
			MathLib::toLongNumber(tok->next()->str()) == 0L) {
			zerodivError(tok, false);
			continue;
		}
		else if (Token::Match(tok, "div|ldiv|lldiv|imaxdiv ( %num% , %num% )") &&
			MathLib::isInt(tok->strAt(4)) &&
			MathLib::toLongNumber(tok->strAt(4)) == 0L) {
			zerodivError(tok, false);
			continue;
		}

		if (Token::Match(tok, "[/%]"))
		{
			if (tok->astOperand2())
			{
				const Token* tok2 = tok->astOperand2();
				if (tok2  && tok2->getValue(0))
				{
					// Value flow..
					const ValueFlow::Value *value = tok2->getValue(0LL);
					if (!value)
						continue;
					if (value->condition == nullptr)
						zerodivError(tok, false);
					else 
						zerodivcondError(value->condition, tok, value->inconclusive);
		
					continue;
				}
			}
		}
		//end TSC1.0
        if (!Token::Match(tok, "[/%]") || !tok->astOperand1() || !tok->astOperand2())
            continue;

        if (!tok->valueType() || !tok->valueType()->isIntegral())
            continue;
        if (tok->astOperand1()->isNumber()) {
            if (MathLib::isFloat(tok->astOperand1()->str()))
                continue;
        } else if (tok->astOperand1()->isName()) {
            if (tok->astOperand1()->variable() && !tok->astOperand1()->variable()->isIntegralType())
                continue;
        } else if (!tok->astOperand1()->isArithmeticalOp()) {
            continue;
        }
        // Value flow..
        const ValueFlow::Value *value = tok->astOperand2()->getValue(0LL);
        if (!value)
            continue;
       // if (!printInconclusive && value->inconclusive)
         //   continue;
        if (value->condition == nullptr)
            zerodivError(tok, value->inconclusive);
        else 
            zerodivcondError(value->condition,tok,value->inconclusive);
    }
}

void CheckOther::zerodivError(const Token *tok, bool inconclusive)
{
	reportError(tok, Severity::error, ErrorType::Compute, "ZeroDivision", "Division by zero.", 0U, inconclusive);
}

void CheckOther::zerodivcondError(const Token *tokcond, const Token *tokdiv, bool inconclusive)
{
    std::list<const Token *> callstack;
    if (tokcond && tokdiv) {
        callstack.push_back(tokcond);
        callstack.push_back(tokdiv);
    }
    const std::string linenr(MathLib::toString(tokdiv ? tokdiv->linenr() : 0));
	reportError(callstack, Severity::warning, ErrorType::Compute, "ZeroDivision", ValueFlow::eitherTheConditionIsRedundant(tokcond) + " or there is division by zero at line " + linenr + ".", 0U, inconclusive);
}

//---------------------------------------------------------------------------
// Check for NaN (not-a-number) in an arithmetic expression, e.g.
// double d = 1.0 / 0.0 + 100.0;
//---------------------------------------------------------------------------

void CheckOther::checkNanInArithmeticExpression()
{
    for (const Token *tok = _tokenizer->tokens(); tok; tok = tok->next()) {
        if (Token::Match(tok, "inf.0 +|-") ||
            Token::Match(tok, "+|- inf.0") ||
            Token::Match(tok, "+|- %num% / 0.0")) {
            nanInArithmeticExpressionError(tok);
        }
    }
}

void CheckOther::nanInArithmeticExpressionError(const Token *tok)
{
    reportError(tok, Severity::style, ErrorType::None, "nanInArithmeticExpression",
                "Using NaN/Inf in a computation.\n"
                "Using NaN/Inf in a computation. "
				"Although nothing bad really happens, it is suspicious.", ErrorLogger::GenWebIdentity(tok->str()));
}

//---------------------------------------------------------------------------
// Detect passing wrong values to <cmath> functions like atan(0, x);
//---------------------------------------------------------------------------
void CheckOther::checkMathFunctions()
{
    const bool styleC99 = _settings->isEnabled("style") && _settings->standards.c != Standards::C89 && _settings->standards.cpp != Standards::CPP03;
    const bool printWarnings = _settings->isEnabled("warning");

    const SymbolDatabase *symbolDatabase = _tokenizer->getSymbolDatabase();
    const std::size_t functions = symbolDatabase->functionScopes.size();
    for (std::size_t i = 0; i < functions; ++i) {
        const Scope * scope = symbolDatabase->functionScopes[i];
        for (const Token* tok = scope->classStart->next(); tok != scope->classEnd; tok = tok->next()) {
            if (tok->varId())
                continue;
            if (printWarnings) {
                if (tok->strAt(-1) != "."
                    && Token::Match(tok, "log|logf|logl|log10|log10f|log10l ( %num% )")) {
                    const std::string& number = tok->strAt(2);
                    bool isNegative = MathLib::isNegative(number);
                    bool isInt = MathLib::isInt(number);
                    bool isFloat = MathLib::isFloat(number);
                    if (isNegative && isInt && MathLib::toLongNumber(number) <= 0) {
                        mathfunctionCallWarning(tok); // case log(-2)
                    } else if (isNegative && isFloat && MathLib::toDoubleNumber(number) <= 0.) {
                        mathfunctionCallWarning(tok); // case log(-2.0)
                    } else if (!isNegative && isFloat && MathLib::toDoubleNumber(number) <= 0.) {
                        mathfunctionCallWarning(tok); // case log(0.0)
                    } else if (!isNegative && isInt && MathLib::toLongNumber(number) <= 0) {
                        mathfunctionCallWarning(tok); // case log(0)
                    }
                }

                // acos( x ), asin( x )  where x is defined for interval [-1,+1], but not beyond
                else if (Token::Match(tok, "acos|acosl|acosf|asin|asinf|asinl ( %num% )")) {
                    if (std::fabs(MathLib::toDoubleNumber(tok->strAt(2))) > 1.0)
                        mathfunctionCallWarning(tok);
                }
                // sqrt( x ): if x is negative the result is undefined
                else if (Token::Match(tok, "sqrt|sqrtf|sqrtl ( %num% )")) {
                    if (MathLib::isNegative(tok->strAt(2)))
                        mathfunctionCallWarning(tok);
                }
                // atan2 ( x , y): x and y can not be zero, because this is mathematically not defined
                else if (Token::Match(tok, "atan2|atan2f|atan2l ( %num% , %num% )")) {
                    if (MathLib::isNullValue(tok->strAt(2)) && MathLib::isNullValue(tok->strAt(4)))
                        mathfunctionCallWarning(tok, 2);
                }
                // fmod ( x , y) If y is zero, then either a range error will occur or the function will return zero (implementation-defined).
                else if (Token::Match(tok, "fmod|fmodf|fmodl ( %any%")) {
                    const Token* nextArg = tok->tokAt(2)->nextArgument();
                    if (nextArg && nextArg->isNumber() && MathLib::isNullValue(nextArg->str()))
                        mathfunctionCallWarning(tok, 2);
                }
                // pow ( x , y) If x is zero, and y is negative --> division by zero
                else if (Token::Match(tok, "pow|powf|powl ( %num% , %num% )")) {
                    if (MathLib::isNullValue(tok->strAt(2)) && MathLib::isNegative(tok->strAt(4)))
                        mathfunctionCallWarning(tok, 2);
                }
            }

            if (styleC99) {
                if (Token::Match(tok, "%num% - erf (") && Tokenizer::isOneNumber(tok->str()) && tok->next()->astOperand2() == tok->tokAt(3)) {
                    mathfunctionCallWarning(tok, "1 - erf(x)", "erfc(x)");
                } else if (Token::simpleMatch(tok, "exp (") && Token::Match(tok->linkAt(1), ") - %num%") && Tokenizer::isOneNumber(tok->linkAt(1)->strAt(2)) && tok->linkAt(1)->next()->astOperand1() == tok->next()) {
                    mathfunctionCallWarning(tok, "exp(x) - 1", "expm1(x)");
                } else if (Token::simpleMatch(tok, "log (") && tok->next()->astOperand2()) {
                    const Token* plus = tok->next()->astOperand2();
                    if (plus->str() == "+" && ((plus->astOperand1() && Tokenizer::isOneNumber(plus->astOperand1()->str())) || (plus->astOperand2() && Tokenizer::isOneNumber(plus->astOperand2()->str()))))
                        mathfunctionCallWarning(tok, "log(1 + x)", "log1p(x)");
                }
            }
        }
    }
}

void CheckOther::mathfunctionCallWarning(const Token *tok, const unsigned int numParam)
{
    if (tok) {
        if (numParam == 1)
			reportError(tok, Severity::warning, ErrorType::None, "wrongmathcall", "Passing value " + tok->strAt(2) + " to " + tok->str() + "() leads to implementation-defined result.", ErrorLogger::GenWebIdentity(tok->str()));
        else if (numParam == 2)
			reportError(tok, Severity::warning, ErrorType::None, "wrongmathcall", "Passing values " + tok->strAt(2) + " and " + tok->strAt(4) + " to " + tok->str() + "() leads to implementation-defined result.", ErrorLogger::GenWebIdentity(tok->str()));
    } else
		reportError(tok, Severity::warning, ErrorType::None, "wrongmathcall", "Passing value '#' to #() leads to implementation-defined result.", ErrorLogger::GenWebIdentity(tok->str()));
}

void CheckOther::mathfunctionCallWarning(const Token *tok, const std::string& oldexp, const std::string& newexp)
{
	reportError(tok, Severity::style, ErrorType::None, "unpreciseMathCall", "Expression '" + oldexp + "' can be replaced by '" + newexp + "' to avoid loss of precision.", ErrorLogger::GenWebIdentity(tok->str()));
}

//---------------------------------------------------------------------------
// Creating instance of clases which are destroyed immediately
//---------------------------------------------------------------------------
void CheckOther::checkMisusedScopedObject()
{
    // Skip this check for .c files
    if (_tokenizer->isC())
        return;

    if (!_settings->isEnabled("style"))
        return;

    const SymbolDatabase * const symbolDatabase = _tokenizer->getSymbolDatabase();
    const std::size_t functions = symbolDatabase->functionScopes.size();
    for (std::size_t i = 0; i < functions; ++i) {
        const Scope * scope = symbolDatabase->functionScopes[i];
        for (const Token *tok = scope->classStart; tok && tok != scope->classEnd; tok = tok->next()) {
            if ((tok->next()->type() || (tok->next()->function() && tok->next()->function()->isConstructor())) // TODO: The rhs of || should be removed; It is a workaround for a symboldatabase bug
                && Token::Match(tok, "[;{}] %name% (")
                && Token::Match(tok->linkAt(2), ") ; !!}")
                && (!tok->next()->function() || // is not a function on this scope
                    tok->next()->function()->isConstructor())) { // or is function in this scope and it's a ctor
                tok = tok->next();
                misusedScopeObjectError(tok, tok->str());
                tok = tok->next();
            }
        }
    }
}

void CheckOther::misusedScopeObjectError(const Token *tok, const std::string& varname)
{
    reportError(tok, Severity::style, ErrorType::None,
		"unusedScopedObject", "Instance of '" + varname + "' object is destroyed immediately.", ErrorLogger::GenWebIdentity(tok->str()));
}

//-----------------------------------------------------------------------------
// check for duplicate code in if and else branches
// if (a) { b = true; } else { b = true; }
//-----------------------------------------------------------------------------
void CheckOther::checkDuplicateBranch()
{
    // This is inconclusive since in practice most warnings are noise:
    // * There can be unfixed low-priority todos. The code is fine as it
    //   is but it could be possible to enhance it. Writing a warning
    //   here is noise since the code is fine (see tscancode, abiword, ..)
    // * There can be overspecified code so some conditions can't be true
    //   and their conditional code is a duplicate of the condition that
    //   is always true just in case it would be false. See for instance
    //   abiword.
    if (!_settings->isEnabled("style") || !_settings->inconclusive)
        return;

    const SymbolDatabase *symbolDatabase = _tokenizer->getSymbolDatabase();

    std::list<Scope>::const_iterator scope;

    for (scope = symbolDatabase->scopeList.begin(); scope != symbolDatabase->scopeList.end(); ++scope) {
        if (scope->type != Scope::eIf)
            continue;

        // check all the code in the function for if (..) else
        if (Token::simpleMatch(scope->classEnd, "} else {")) {
            // Make sure there are no macros (different macros might be expanded
            // to the same code)
            bool macro = false;
            for (const Token *tok = scope->classStart; tok != scope->classEnd->linkAt(2); tok = tok->next()) {
                if (tok->isExpandedMacro()) {
                    macro = true;
                    break;
                }
            }
            if (macro)
                continue;

            // save if branch code
            std::string branch1 = scope->classStart->next()->stringifyList(scope->classEnd);

            if (branch1.empty())
                continue;

            // save else branch code
            std::string branch2 = scope->classEnd->tokAt(3)->stringifyList(scope->classEnd->linkAt(2));

            // check for duplicates
			if (branch1 == branch2)
			{
				// ";" ,"" ,and "do{} while(0);"
				if (branch1 != ";" && branch1 != "" && branch1 != "do { } while ( 0 ) ;")
				{
					duplicateBranchError(scope->classDef, scope->classEnd->next());
				}
			}
        }
    }
}

void CheckOther::checkDuplicateBranch1()
{
	//if (!_settings->isEnabled("style"))
	//	return;

	const SymbolDatabase *symbolDatabase = _tokenizer->getSymbolDatabase();

	std::list<Scope>::const_iterator scope;

	for (scope = symbolDatabase->scopeList.begin(); scope != symbolDatabase->scopeList.end(); ++scope) {
		if (scope->type != Scope::eIf && scope->type != Scope::eElse)
			continue;

		// check all the code in the function for if (..) else
		if (Token::simpleMatch(scope->classEnd, "} else {")) {
			// save if branch code
			std::string branch1 = scope->classStart->next()->stringifyList(scope->classEnd);

			// save else branch code
			std::string branch2 = scope->classEnd->tokAt(3)->stringifyList(scope->classEnd->linkAt(2));

			// check for duplicates
			if (branch1 == branch2)
			{
				// ";" ,"" ,and "do{} while(0);" 
				//$ means IsMacroExpanded()
				if (branch1 != "$;"  && branch1 != ";" && branch1 != "$" && branch1 != "" && branch1!="$do { } $while ( $0 ) ;" && branch1 != "do { } while ( 0 ) ;")
					duplicateBranchError(scope->classDef, scope->classEnd->next());
			}
		}
	}
}


void CheckOther::duplicateBranchError(const Token *tok1, const Token *tok2)
{
    const std::list<const Token *> toks = make_container< std::list<const Token *> >() << tok2 << tok1;

    reportError(toks, Severity::warning, ErrorType::Logic, "duplicateBranch", "Found duplicate branches for 'if' and 'else'.\n"
                "Finding the same code in an 'if' and related 'else' branch is suspicious and "
                "might indicate a cut and paste or logic error. Please examine this code "
                "carefully to determine if it is correct.", 0U, true);
}


//-----------------------------------------------------------------------------
// Check for a free() of an invalid address
// char* p = malloc(100);
// free(p + 10);
//-----------------------------------------------------------------------------
void CheckOther::checkInvalidFree()
{
    std::map<unsigned int, bool> allocatedVariables;

    const bool printInconclusive = _settings->inconclusive;
    const SymbolDatabase* symbolDatabase = _tokenizer->getSymbolDatabase();
    const std::size_t functions = symbolDatabase->functionScopes.size();
    for (std::size_t i = 0; i < functions; ++i) {
        const Scope * scope = symbolDatabase->functionScopes[i];
        for (const Token* tok = scope->classStart->next(); tok != scope->classEnd; tok = tok->next()) {

            // Keep track of which variables were assigned addresses to newly-allocated memory
            if (Token::Match(tok, "%var% = malloc|g_malloc|new")) {
                allocatedVariables.insert(std::make_pair(tok->varId(), false));
            }

            // If a previously-allocated pointer is incremented or decremented, any subsequent
            // free involving pointer arithmetic may or may not be invalid, so we should only
            // report an inconclusive result.
            else if (Token::Match(tok, "%var% = %name% +|-") &&
                     tok->varId() == tok->tokAt(2)->varId() &&
                     allocatedVariables.find(tok->varId()) != allocatedVariables.end()) {
                if (printInconclusive)
                    allocatedVariables[tok->varId()] = true;
                else
                    allocatedVariables.erase(tok->varId());
            }

            // If a previously-allocated pointer is assigned a completely new value,
            // we can't know if any subsequent free() on that pointer is valid or not.
            else if (Token::Match(tok, "%var% =")) {
                allocatedVariables.erase(tok->varId());
            }

            // If a variable that was previously assigned a newly-allocated memory location is
            // added or subtracted from when used to free the memory, report an error.
            else if (Token::Match(tok, "free|g_free|delete ( %any% +|- %any%") ||
                     Token::Match(tok, "delete [ ] ( %any% +|- %any%") ||
                     Token::Match(tok, "delete %any% +|- %any%")) {

                const int varIndex = tok->strAt(1) == "(" ? 2 :
                                     tok->strAt(3) == "(" ? 4 : 1;
                const unsigned int var1 = tok->tokAt(varIndex)->varId();
                const unsigned int var2 = tok->tokAt(varIndex + 2)->varId();
                const std::map<unsigned int, bool>::const_iterator alloc1 = allocatedVariables.find(var1);
                const std::map<unsigned int, bool>::const_iterator alloc2 = allocatedVariables.find(var2);
                if (alloc1 != allocatedVariables.end()) {
                    invalidFreeError(tok, alloc1->second);
                } else if (alloc2 != allocatedVariables.end()) {
                    invalidFreeError(tok, alloc2->second);
                }
            }

            // If the previously-allocated variable is passed in to another function
            // as a parameter, it might be modified, so we shouldn't report an error
            // if it is later used to free memory
            else if (Token::Match(tok, "%name% (") && _settings->library.functionpure.find(tok->str()) == _settings->library.functionpure.end()) {
                const Token* tok2 = Token::findmatch(tok->next(), "%var%", tok->linkAt(1));
                while (tok2 != nullptr) {
                    allocatedVariables.erase(tok2->varId());
                    tok2 = Token::findmatch(tok2->next(), "%var%", tok->linkAt(1));
                }
            }
        }
    }
}

void CheckOther::invalidFreeError(const Token *tok, bool inconclusive)
{
    reportError(tok, Severity::error, ErrorType::None, "invalidFree", "Invalid memory address freed.", 0U, inconclusive);
}


//---------------------------------------------------------------------------
// check for the same expression on both sides of an operator
// (x == x), (x && x), (x || x)
// (x.y == x.y), (x.y && x.y), (x.y || x.y)
//---------------------------------------------------------------------------

namespace {
    bool notconst(const Function* func)
    {
        return !func->isConst();
    }


    void getConstFunctions(const SymbolDatabase *symbolDatabase, std::list<const Function*> &constFunctions)
    {
        std::list<Scope>::const_iterator scope;
        for (scope = symbolDatabase->scopeList.begin(); scope != symbolDatabase->scopeList.end(); ++scope) {
            std::list<Function>::const_iterator func;
            // only add const functions that do not have a non-const overloaded version
            // since it is pretty much impossible to tell which is being called.
            typedef std::map<std::string, std::list<const Function*> > StringFunctionMap;
            StringFunctionMap functionsByName;
            for (func = scope->functionList.begin(); func != scope->functionList.end(); ++func) {
                functionsByName[func->tokenDef->str()].push_back(&*func);
            }
            for (StringFunctionMap::iterator it = functionsByName.begin();
                 it != functionsByName.end(); ++it) {
                std::list<const Function*>::const_iterator nc = std::find_if(it->second.begin(), it->second.end(), notconst);
                if (nc == it->second.end()) {
                    // ok to add all of them
                    constFunctions.splice(constFunctions.end(), it->second);
                }
            }
        }
    }
}

void CheckOther::checkDuplicateExpression()
{
    const bool styleEnabled=_settings->isEnabled("style");
    const bool warningEnabled=_settings->isEnabled("warning");
    if (!styleEnabled && !warningEnabled)
        return;

    // Parse all executing scopes..
    const SymbolDatabase *symbolDatabase = _tokenizer->getSymbolDatabase();

    std::list<Scope>::const_iterator scope;
    std::list<const Function*> constFunctions;
    const std::set<std::string> temp; // Can be used as dummy for isSameExpression()
    getConstFunctions(symbolDatabase, constFunctions);
	const std::map<std::string, struct Library::PodType> &podTypes = _settings->library.getPodTypes();
   // for (scope = symbolDatabase->scopeList.begin(); scope != symbolDatabase->scopeList.end(); ++scope) {
        // only check functions
    //    if (scope->type != Scope::eFunction)
     //       continue;

     //   for (const Token *tok = scope->classStart; tok && tok != scope->classEnd; tok = tok->next()) {
		  for (const Token *tok = _tokenizer->tokens(); tok; tok = tok->next()){
            if (tok->isOp() && tok->astOperand1() && !Token::Match(tok, "+|*|<<|>>|+=|*=|<<=|>>=")) {
                //if (Token::Match(tok, "==|!=|-") && astIsFloat(tok->astOperand1(), true))
			    if (Token::Match(tok, "==|!=|-") && astIsFloat(tok->astOperand1(), false))//unknown return false
                    continue;
                if (isSameExpression(_tokenizer->isCPP(), tok->astOperand1(), tok->astOperand2(), _settings->library.functionpure)) {
					if (tok->str() == "|"
						&& tok->astParent() 
						&& (tok->astParent()->isAssignmentOp()
						 || tok->astParent()->isArithmeticalOp()
							)
						&& tok->astOperand1()->variable()
						&& tok->astOperand1()->variable()->typeStartToken()
						&& podTypes.count(tok->astOperand1()->variable()->typeStartToken()->str()) == 0
						)
					{
						continue;
					}
					if (isWithoutSideEffects(_tokenizer->isCPP(), tok->astOperand1())) {
                        const bool assignment = tok->str() == "=";
						if (assignment && warningEnabled)
						{
							if (tok->tokAt(1) && !tok->tokAt(1)->isCast())
							{
								selfAssignmentError(tok, tok->astOperand1()->expressionString());
							}
						}
                        else {
                            if (_tokenizer->isCPP() && _settings->standards.cpp==Standards::CPP11 && tok->str() == "==") {
                                const Token* parent = tok->astParent();
                                while (parent && parent->astParent()) {
                                    parent = parent->astParent();
                                }
                                if (parent && parent->previous() && parent->previous()->str() == "static_assert") {
                                    continue;
                                }
                            }
                            if (styleEnabled)
                                duplicateExpressionError(tok, tok, tok->str());
                        }
                    }
                } else if (!Token::Match(tok, "[-/%]")) { // These operators are not associative
                    if (styleEnabled && tok->astOperand2() && tok->str() == tok->astOperand1()->str() && isSameExpression(_tokenizer->isCPP(), tok->astOperand2(), tok->astOperand1()->astOperand2(), _settings->library.functionpure) && isWithoutSideEffects(_tokenizer->isCPP(), tok->astOperand2()))
                        duplicateExpressionError(tok->astOperand2(), tok->astOperand2(), tok->str());
                    else if (tok->astOperand2()) {
                        const Token *ast1 = tok->astOperand1();
                        while (ast1 && tok->str() == ast1->str()) {
                            if (isSameExpression(_tokenizer->isCPP(), ast1->astOperand1(), tok->astOperand2(), _settings->library.functionpure) && isWithoutSideEffects(_tokenizer->isCPP(), ast1->astOperand1()))
                                // TODO: warn if variables are unchanged. See #5683
                                // Probably the message should be changed to 'duplicate expressions X in condition or something like that'.
                                ;//duplicateExpressionError(ast1->astOperand1(), tok->astOperand2(), tok->str());
							else if (styleEnabled
								&& isSameExpression(_tokenizer->isCPP(), ast1->astOperand2(), tok->astOperand2(), _settings->library.functionpure)
								&& isWithoutSideEffects(_tokenizer->isCPP(), ast1->astOperand2()))
							{
								const Token *t = tok->astOperand2();
								std::stack<const Token *> s;
								s.push(t);
								const Token *tFunc = nullptr;
								while (!s.empty())
								{
									t = s.top();
									s.pop();
									if (t->str() == "(")
									{
										tFunc = t;
										break;
									}
									if (t->astOperand1())
									{
										s.push(t->astOperand1());
									}
									if (t->astOperand2())
									{
										s.push(t->astOperand2());
									}
								}
								if (tFunc
									&& tFunc->astOperand1()
									&& tFunc->astOperand1()->str() == "."
									&& Token::Match(tFunc->astOperand1()->astOperand2(), "get|getline|read|readsome|putback|unget|good"))
								{
									break;
								}
								duplicateExpressionError(ast1->astOperand2(), tok->astOperand2(), tok->str());
							}
                            if (!isConstExpression(ast1->astOperand2(), _settings->library.functionpure))
                                break;
                            ast1 = ast1->astOperand1();
                        }
                    }
                }
            } else if (styleEnabled && tok->astOperand1() && tok->astOperand2() && tok->str() == ":" && tok->astParent() && tok->astParent()->str() == "?") {
                if (isSameExpression(_tokenizer->isCPP(), tok->astOperand1(), tok->astOperand2(), temp))
                    duplicateExpressionTernaryError(tok);
            }
        }
   // }
}

bool IsPureFunc(const Token *expr1);

void CheckOther::duplicateExpressionError(const Token *tok1, const Token *tok2, const std::string &op)
{
	//if (stream.Take() == 'u' && stream.Take() == 'l' && stream.Take() == 'l')
	const Token *tokFunc = (tok1->str() == "&&" || tok1->str() == "||") ? tok1->astOperand1() : tok1;
	if (tokFunc && tokFunc->isConstOp())
	{
		if ((tokFunc->astOperand1() && !IsPureFunc(tokFunc->astOperand1()))
			|| (tokFunc->astOperand2() && !IsPureFunc(tokFunc->astOperand2())))
		{
			return;
		}
	}
	

	//except UDKHeader^ UDKHeader;Locale^ Locale;
	if (op == "^" && tok1->astParent()==NULL && !Token::Match(tok1->tokAt(-2), "return") )
		return;
	std::string expStr = tok1->astString("~");
	//这些函数可能故意执行两次
	if (strstr(expStr.c_str(), "~read~") 
		|| strstr(expStr.c_str(), "~get~") 
		|| strstr(expStr.c_str(), "~create~") 
		|| strstr(expStr.c_str(), "~init~"))
	{
		return;
	}


	//except struct tm & tm 单独扫描不会报错，全量扫描时tokenize错误，第2个tm没识别为变量，导致误报，TODO 修改符号化,tapdID:ID： 54927835
	if (Token::Match(tok1->tokAt(-2), "struct") && op=="&" )
		return;

	//except type's name is same as variable  setvarid bug eg. A & A = xx;   func(int c,A & A) ,typedef bug.eg. func(int ,std::vector<int>& std::vector<int>)
 	if (Token::Match(tok1->tokAt(-1), "> *|&") || Token::Match(tok1->tokAt(-2), "{|; %name% *|& %name% =|;") || Token::Match(tok1->tokAt(-2), "(|, %name% *|& %name% )|,"))
		return;
	//except struct A & =struct A (typedef bug to fixed) : false positive in /data/qoc_project/project_src/100000780/src/src/profitExp.cpp 973
	if (Token::Match(tok1, "*|& struct|class"))
		return;
	// don't write the warning
	if (tok1->isExpandedMacro() || tok2->isExpandedMacro())
		return;
	if (tok1 == tok2 && tok1->astOperand1() && tok1->astOperand2() && (tok1->astOperand1()->isExpandedEnum() || tok1->astOperand2()->isExpandedEnum()))
	{
		return;
	}

	if (tok1 == tok2 && tok1->astOperand1() && tok1->astOperand2() && (tok1->astOperand1()->tokType()==Token::eNumber && tok1->astOperand2()->tokType()==Token::eNumber))
	{
		return;
	}

    const std::list<const Token *> toks = make_container< std::list<const Token *> >() << tok2 << tok1;

    reportError(toks, Severity::warning, ErrorType::Logic, "DuplicateExpression", "Same expression on both sides of \'" + op + "\'.\n"
                "Finding the same expression on both sides of an operator is suspicious and might "
                "indicate a cut and paste or logic error. Please examine this code carefully to "
                "determine if it is correct.", ErrorLogger::GenWebIdentity(op));
}

void CheckOther::duplicateExpressionTernaryError(const Token *tok)
{
	// don't write the warning
	if (tok->isExpandedMacro())
		return;

	reportError(tok, Severity::warning, ErrorType::Logic, "DuplicateExpression", "Same expression in both branches of ternary operator.\n"
                "Finding the same expression in both branches of ternary operator is suspicious as "
				"the same code is executed regardless of the condition.", ErrorLogger::GenWebIdentity(tok->str()));
}

void CheckOther::selfAssignmentError(const Token *tok, const std::string &varname)
{
	//except eg.AVCodec ff_aac_decoder = { .name = "aac",.flush= flush,};
	if (Token::Match(tok->tokAt(-2), ". %name% = %name% ,"))
	{
		return;
	}
	if ((tok->tokAt(-2) && tok->tokAt(2)) && (tok->tokAt(-2)->isExpandedEnum() || tok->tokAt(2)->isExpandedEnum() || tok->tokAt(-1)->isExpandedEnum()|| tok->tokAt(1)->isExpandedEnum()))
	{
		return;
	}
	if (tok->tokAt(-1)->isExpandedMacro() || tok->tokAt(1)->isExpandedMacro())
		return;
	/* FP bug fixed 
	int nNum = 1;
	float fTime =0.09f;
	fTime *=nNum;
	*/
	if (tok->tokAt(1)->originalName() == "*=" || tok->tokAt(1)->originalName() == "/=" || tok->tokAt(1)->originalName() == "+=" || tok->tokAt(1)->originalName() == "-=")
		return;
	if (tok->tokAt(-1)->isExpandedMacro() || tok->tokAt(1)->isExpandedMacro())
		return;

    reportError(tok, Severity::warning, ErrorType::Logic,
                "selfAssignment", "Redundant assignment of '" + varname + "' to itself.", ErrorLogger::GenWebIdentity(varname));
}

//-----------------------------------------------------------------------------
// Check is a comparison of two variables leads to condition, which is
// always true or false.
// For instance: int a = 1; if(isless(a,a)){...}
// In this case isless(a,a) always evaluates to false.
//
// Reference:
// - http://www.cplusplus.com/reference/cmath/
//-----------------------------------------------------------------------------
void CheckOther::checkComparisonFunctionIsAlwaysTrueOrFalse()
{
    if (!_settings->isEnabled("warning"))
        return;

    const SymbolDatabase *symbolDatabase = _tokenizer->getSymbolDatabase();
    const std::size_t functions = symbolDatabase->functionScopes.size();
    for (std::size_t i = 0; i < functions; ++i) {
        const Scope * scope = symbolDatabase->functionScopes[i];
        for (const Token* tok = scope->classStart->next(); tok != scope->classEnd; tok = tok->next()) {
            if (tok->isName() && Token::Match(tok, "isgreater|isless|islessgreater|isgreaterequal|islessequal ( %var% , %var% )")) {
                const unsigned int varidLeft = tok->tokAt(2)->varId();// get the left varid
                const unsigned int varidRight = tok->tokAt(4)->varId();// get the right varid
                // compare varids: if they are not zero but equal
                // --> the comparison function is calles with the same variables
                if (varidLeft == varidRight) {
                    const std::string& functionName = tok->str(); // store function name
                    const std::string& varNameLeft = tok->strAt(2); // get the left variable name
                    if (functionName == "isgreater" || functionName == "isless" || functionName == "islessgreater") {
                        // e.g.: isgreater(x,x) --> (x)>(x) --> false
                        checkComparisonFunctionIsAlwaysTrueOrFalseError(tok, functionName, varNameLeft, false);
                    } else { // functionName == "isgreaterequal" || functionName == "islessequal"
                        // e.g.: isgreaterequal(x,x) --> (x)>=(x) --> true
                        checkComparisonFunctionIsAlwaysTrueOrFalseError(tok, functionName, varNameLeft, true);
                    }
                }
            }
        }
    }
}
void CheckOther::checkComparisonFunctionIsAlwaysTrueOrFalseError(const Token* tok, const std::string &functionName, const std::string &varName, const bool result)
{
    const std::string strResult = result ? "true" : "false";
    reportError(tok, Severity::warning, ErrorType::None, "comparisonFunctionIsAlwaysTrueOrFalse",
                "Comparison of two identical variables with " + functionName + "(" + varName + "," + varName + ") always evaluates to " + strResult + ".\n"
                "The function " + functionName + " is designed to compare two variables. Calling this function with one variable (" + varName + ") "
                "for both parameters leads to a statement which is always " + strResult + ".", ErrorLogger::GenWebIdentity(varName));
}

//---------------------------------------------------------------------------
// Check testing sign of unsigned variables and pointers.
//---------------------------------------------------------------------------
void CheckOther::checkSignOfUnsignedVariable()
{
    if (!_settings->isEnabled("style"))
        return;

    const bool inconclusive = _tokenizer->codeWithTemplates();
    if (inconclusive && !_settings->inconclusive)
        return;

    const SymbolDatabase *symbolDatabase = _tokenizer->getSymbolDatabase();

    const std::size_t functions = symbolDatabase->functionScopes.size();
    for (std::size_t i = 0; i < functions; ++i) {
        const Scope * scope = symbolDatabase->functionScopes[i];
        // check all the code in the function
        for (const Token *tok = scope->classStart->next(); tok != scope->classEnd; tok = tok->next()) {
            // Quick check to see if any of the matches below have any chances
            if (!tok->varId() && tok->str() != "0")
                continue;
            if (Token::Match(tok, "%name% <|<= 0") && tok->varId() && !Token::Match(tok->tokAt(3), "+|-")) {
                // TODO: handle a[10].b , a::b , (unsigned int)x , etc
                const Token *prev = tok->previous();
                while (prev && (prev->isName() || prev->str() == "."))
                    prev = prev->previous();
                if (!Token::Match(prev, "(|&&|%oror%"))
                    continue;
                const Variable *var = tok->variable();
                if (var && var->typeEndToken()->isUnsigned())
                    //unsignedLessThanZeroError(tok, var->name(), inconclusive);
					unsignedLessThanZeroError(tok);
                else if (var && (var->isPointer() || var->isArray()))
                    pointerLessThanZeroError(tok, inconclusive);
            } else if (Token::Match(tok, "0 >|>= %name%") && tok->tokAt(2)->varId() && !Token::Match(tok->tokAt(3), "+|-|*|/") && !Token::Match(tok->previous(), "+|-|<<|>>|~")) {
                const Variable *var = tok->tokAt(2)->variable();
                if (var && var->typeEndToken()->isUnsigned())
                    //unsignedLessThanZeroError(tok, var->name(), inconclusive);
					unsignedLessThanZeroError(tok->tokAt(2));
                else if (var && var->isPointer() && !Token::Match(tok->tokAt(3), "[.[(]"))
                    pointerLessThanZeroError(tok, inconclusive);
            } else if (Token::Match(tok, "0 <= %name%") && tok->tokAt(2)->varId() && !Token::Match(tok->tokAt(3), "+|-|*|/") && !Token::Match(tok->previous(), "+|-|<<|>>|~")) {
                const Variable *var = tok->tokAt(2)->variable();
                if (var && var->typeEndToken()->isUnsigned())
                    unsignedPositiveError(tok, var->name(), inconclusive);
                else if (var && var->isPointer() && !Token::Match(tok->tokAt(3), "[.[]"))
                    pointerPositiveError(tok, inconclusive);
            } else if (Token::Match(tok, "%name% >= 0") && tok->varId() && !Token::Match(tok->previous(), "++|--|)|+|-|*|/|~|<<|>>") && !Token::Match(tok->tokAt(3), "+|-")) {
                const Variable *var = tok->variable();
                if (var && var->typeEndToken()->isUnsigned())
                    unsignedPositiveError(tok, var->name(), inconclusive);
                else if (var && var->isPointer() && tok->strAt(-1) != "*")
                    pointerPositiveError(tok, inconclusive);
            }
        }
    }
}

void CheckOther::unsignedLessThanZeroError(const Token *tok)
{
	//Debug ( var-(int)var<0 );   20151022 int转化后误报.
	if (tok->tokAt(-1) && tok->tokAt(-2) && tok->strAt(-1) == ")" &&tok->strAt(-2) == "int")
	{
		return;
	}

	// for condition: a <= 0
	if (tok->tokAt(1) && tok->strAt(1) == "<=") {
		reportError(tok, Severity::warning, ErrorType::Compute, "Unsignedlessthanzero", "This unsigned value [" + tok->str() + "] can't be less-than-zero, using == is enough.", ErrorLogger::GenWebIdentity(tok->str()));
		return;
	}
	// for condition: 0 >= a
	if (tok->tokAt(-1) && tok->strAt(-1) == ">=") {
		reportError(tok, Severity::warning, ErrorType::Compute, "Unsignedlessthanzero", "This unsigned value [" + tok->str() + "] can't be less-than-zero, using == is enough.", ErrorLogger::GenWebIdentity(tok->str()));
		return;
	}

	// for condition: a < 0 ||  0 > a 
	reportError(tok, Severity::warning, ErrorType::Compute, "Unsignedlessthanzero", "This less-than-zero comparison of an unsigned value ["+tok->str()+"] is never true.", ErrorLogger::GenWebIdentity(tok->str()));
}


void CheckOther::pointerLessThanZeroError(const Token *tok, bool inconclusive)
{
    reportError(tok, Severity::style, ErrorType::None, "pointerLessThanZero",
                "A pointer can not be negative so it is either pointless or an error to check if it is.", 0U, inconclusive);
}

void CheckOther::unsignedPositiveError(const Token *tok, const std::string &varname, bool inconclusive)
{
    if (inconclusive) {
        reportError(tok, Severity::style, ErrorType::None, "unsignedPositive",
                    "Unsigned variable '" + varname + "' can't be negative so it is unnecessary to test it.\n"
                    "The unsigned variable '" + varname + "' can't be negative so it is unnecessary to test it. "
                    "It's not known if the used constant is a "
                    "template parameter or not and therefore this message might be a false warning", 0U, true);
    } else {
        reportError(tok, Severity::style, ErrorType::None, "unsignedPositive",
			"Unsigned variable '" + varname + "' can't be negative so it is unnecessary to test it.", ErrorLogger::GenWebIdentity(tok->str()));
    }
}

void CheckOther::pointerPositiveError(const Token *tok, bool inconclusive)
{
    reportError(tok, Severity::style, ErrorType::None, "pointerPositive",
                "A pointer can not be negative so it is either pointless or an error to check if it is not.", 0U, inconclusive);
}

/* check if a constructor in given class scope takes a reference */
static bool constructorTakesReference(const Scope * const classScope)
{
    for (std::list<Function>::const_iterator func = classScope->functionList.begin(); func != classScope->functionList.end(); ++func) {
        if (func->isConstructor()) {
            const Function &constructor = *func;
            for (std::size_t argnr = 0U; argnr < constructor.argCount(); argnr++) {
                const Variable * const argVar = constructor.getArgumentVar(argnr);
                if (argVar && argVar->isReference()) {
                    return true;
                }
            }
        }
    }
    return false;
}

//---------------------------------------------------------------------------
// This check rule works for checking the "const A a = getA()" usage when getA() returns "const A &" or "A &".
// In most scenarios, "const A & a = getA()" will be more efficient.
//---------------------------------------------------------------------------
void CheckOther::checkRedundantCopy()
{
    if (!_settings->isEnabled("performance") || _tokenizer->isC() || !_settings->inconclusive)
        return;

    const SymbolDatabase *symbolDatabase = _tokenizer->getSymbolDatabase();

    for (std::size_t i = 1; i < symbolDatabase->getVariableListSize(); i++) {
        const Variable* var = symbolDatabase->getVariableFromVarId(i);

        if (!var || var->isReference() || !var->isConst() || var->isPointer() || (!var->type() && !var->isStlType())) // bailout if var is of standard type, if it is a pointer or non-const
            continue;

        const Token* startTok = var->nameToken();
        if (startTok->strAt(1) == "=") // %type% %name% = ... ;
            ;
        else if (startTok->strAt(1) == "(" && var->isClass() && var->typeScope()) {
            // Object is instantiated. Warn if constructor takes arguments by value.
            if (constructorTakesReference(var->typeScope()))
                continue;
        } else
            continue;

        const Token* tok = startTok->next()->astOperand2();
        if (!tok)
            continue;
        if (!Token::Match(tok->previous(), "%name% ("))
            continue;
        if (!Token::Match(tok->link(), ") )| ;")) // bailout for usage like "const A a = getA()+3"
            continue;

        const Function* func = tok->previous()->function();
        if (func && func->tokenDef->strAt(-1) == "&") {
            redundantCopyError(startTok, startTok->str());
        }
    }
}
void CheckOther::redundantCopyError(const Token *tok,const std::string& varname)
{
    reportError(tok, Severity::performance, ErrorType::None, "redundantCopyLocalConst",
                "Use const reference for '" + varname + "' to avoid unnecessary data copying.\n"
                "The const variable '"+varname+"' is assigned a copy of the data. You can avoid "
                "the unnecessary data copying by converting '" + varname + "' to const reference.",
                0U,
                true); // since #5618 that check became inconlusive
}

//---------------------------------------------------------------------------
// Checking for shift by negative values
//---------------------------------------------------------------------------

void CheckOther::checkNegativeBitwiseShift()
{
    const SymbolDatabase *symbolDatabase = _tokenizer->getSymbolDatabase();
    const std::size_t functions = symbolDatabase->functionScopes.size();
    for (std::size_t i = 0; i < functions; ++i) {
        const Scope * scope = symbolDatabase->functionScopes[i];
        for (const Token* tok = scope->classStart->next(); tok != scope->classEnd; tok = tok->next()) {
			
            if (tok->str() != "<<" && tok->str() != ">>")
                continue;

            if (!tok->astOperand1() || !tok->astOperand2())
                continue;

            // don't warn if lhs is a class. this is an overloaded operator then
            if (_tokenizer->isCPP()) {
                const Token *rhs = tok->astOperand1();
                while (Token::Match(rhs, "::|."))
                    rhs = rhs->astOperand2();
                if (!rhs)
                    continue;
                if (!rhs->isNumber() && !rhs->variable())
                    continue;
                if (rhs->variable() &&
                    (!rhs->variable()->typeStartToken() || !rhs->variable()->typeStartToken()->isStandardType()))
                    continue;
            }
			//don't warn if operand is string
			if (tok->astOperand1()->tokType() == Token::Type::eString || tok->astOperand2()->tokType() == Token::Type::eString)
				continue;

            // bailout if operation is protected by ?:
            bool ternary = false;
            for (const Token *parent = tok; parent; parent = parent->astParent()) {
                if (Token::Match(parent, "?|:")) {
                    ternary = true;
                    break;
                }
            }
            if (ternary)
                continue;

            // Get negative rhs value. preferably a value which doesn't have 'condition'.
            const ValueFlow::Value *value = tok->astOperand2()->getValueLE(-1LL, _settings);
            if (value)
                negativeBitwiseShiftError(tok);
        }
    }
}


void CheckOther::negativeBitwiseShiftError(const Token *tok)
{
	reportError(tok, Severity::warning, ErrorType::Compute, "NegativeBitwiseShift", "Shifting with a negative value [" + tok->astOperand2()->str() + "] leads to undefined behaviour.", ErrorLogger::GenWebIdentity(tok->str()));
}

//---------------------------------------------------------------------------
// Check for incompletely filled buffers.
//---------------------------------------------------------------------------
void CheckOther::checkIncompleteArrayFill()
{
    if (!_settings->inconclusive)
        return;
    const bool printWarning = _settings->isEnabled("warning");
    const bool printPortability = _settings->isEnabled("portability");
    if (!printPortability && !printWarning)
        return;

    const SymbolDatabase *symbolDatabase = _tokenizer->getSymbolDatabase();

    const std::size_t functions = symbolDatabase->functionScopes.size();
    for (std::size_t i = 0; i < functions; ++i) {
        const Scope * scope = symbolDatabase->functionScopes[i];
        for (const Token* tok = scope->classStart->next(); tok != scope->classEnd; tok = tok->next()) {
            if (Token::Match(tok, "memset|memcpy|memmove ( %var% ,") && Token::Match(tok->linkAt(1)->tokAt(-2), ", %num% )")) {
                const Variable *var = tok->tokAt(2)->variable();
                if (!var || !var->isArray() || var->dimensions().empty() || !var->dimension(0))
                    continue;

                if (MathLib::toLongNumber(tok->linkAt(1)->strAt(-1)) == var->dimension(0)) {
                    unsigned int size = _tokenizer->sizeOfType(var->typeStartToken());
                    if (size == 0 && var->typeStartToken()->next()->str() == "*")
                        size = _settings->sizeof_pointer;
                    if ((size != 1 && size != 100 && size != 0) || var->isPointer()) {
                        if (printWarning)
                            incompleteArrayFillError(tok, var->name(), tok->str(), false);
                    } else if (var->typeStartToken()->str() == "bool" && printPortability) // sizeof(bool) is not 1 on all platforms
                        incompleteArrayFillError(tok, var->name(), tok->str(), true);
                }
            }
        }
    }
}

void CheckOther::incompleteArrayFillError(const Token* tok, const std::string& buffer, const std::string& function, bool boolean)
{
    if (boolean)
        reportError(tok, Severity::portability, ErrorType::None, "incompleteArrayFill",
                    "Array '" + buffer + "' might be filled incompletely. Did you forget to multiply the size given to '" + function + "()' with 'sizeof(*" + buffer + ")'?\n"
                    "The array '" + buffer + "' is filled incompletely. The function '" + function + "()' needs the size given in bytes, but the type 'bool' is larger than 1 on some platforms. Did you forget to multiply the size with 'sizeof(*" + buffer + ")'?", 0U, true);
    else
        reportError(tok, Severity::warning, ErrorType::None, "incompleteArrayFill",
                    "Array '" + buffer + "' is filled incompletely. Did you forget to multiply the size given to '" + function + "()' with 'sizeof(*" + buffer + ")'?\n"
                    "The array '" + buffer + "' is filled incompletely. The function '" + function + "()' needs the size given in bytes, but an element of the given array is larger than one byte. Did you forget to multiply the size with 'sizeof(*" + buffer + ")'?", 0U, true);
}

//---------------------------------------------------------------------------
// Detect NULL being passed to variadic function.
//---------------------------------------------------------------------------

void CheckOther::checkVarFuncNullUB()
{
    if (!_settings->isEnabled("portability"))
        return;

    const SymbolDatabase *symbolDatabase = _tokenizer->getSymbolDatabase();
    const std::size_t functions = symbolDatabase->functionScopes.size();
    for (std::size_t i = 0; i < functions; ++i) {
        const Scope * scope = symbolDatabase->functionScopes[i];
        for (const Token* tok = scope->classStart; tok != scope->classEnd; tok = tok->next()) {
            // Is NULL passed to a function?
            if (Token::Match(tok,"[(,] NULL [,)]")) {
                // Locate function name in this function call.
                const Token *ftok = tok;
                std::size_t argnr = 1;
                while (ftok && ftok->str() != "(") {
                    if (ftok->str() == ")")
                        ftok = ftok->link();
                    else if (ftok->str() == ",")
                        ++argnr;
                    ftok = ftok->previous();
                }
                ftok = ftok ? ftok->previous() : nullptr;
                if (ftok && ftok->isName()) {
                    // If this is a variadic function then report error
                    const Function *f = ftok->function();
                    if (f && f->argCount() <= argnr) {
                        const Token *tok2 = f->argDef;
                        tok2 = tok2 ? tok2->link() : nullptr; // goto ')'
                        if (tok2 && Token::simpleMatch(tok2->tokAt(-3), ". . ."))
                            varFuncNullUBError(tok);
                    }
                }
            }
        }
    }
}

void CheckOther::varFuncNullUBError(const Token *tok)
{
    reportError(tok,
                Severity::portability, ErrorType::None,
                "varFuncNullUB",
                "Passing NULL after the last typed argument to a variadic function leads to undefined behaviour.\n"
                "Passing NULL after the last typed argument to a variadic function leads to undefined behaviour.\n"
                "The C99 standard, in section 7.15.1.1, states that if the type used by va_arg() is not compatible with the type of the actual next argument (as promoted according to the default argument promotions), the behavior is undefined.\n"
                "The value of the NULL macro is an implementation-defined null pointer constant (7.17), which can be any integer constant expression with the value 0, or such an expression casted to (void*) (6.3.2.3). This includes values like 0, 0L, or even 0LL.\n"
                "In practice on common architectures, this will cause real crashes if sizeof(int) != sizeof(void*), and NULL is defined to 0 or any other null pointer constant that promotes to int.\n"
                "To reproduce you might be able to use this little code example on 64bit platforms. If the output includes \"ERROR\", the sentinel had only 4 out of 8 bytes initialized to zero and was not detected as the final argument to stop argument processing via va_arg(). Changing the 0 to (void*)0 or 0L will make the \"ERROR\" output go away.\n"
                "#include <stdarg.h>\n"
                "#include <stdio.h>\n"
                "\n"
                "void f(char *s, ...) {\n"
                "    va_list ap;\n"
                "    va_start(ap,s);\n"
                "    for (;;) {\n"
                "        char *p = va_arg(ap,char*);\n"
                "        printf(\"%018p, %s\\n\", p, (long)p & 255 ? p : \"\");\n"
                "        if(!p) break;\n"
                "    }\n"
                "    va_end(ap);\n"
                "}\n"
                "\n"
                "void g() {\n"
                "    char *s2 = \"x\";\n"
                "    char *s3 = \"ERROR\";\n"
                "\n"
                "    // changing 0 to 0L for the 7th argument (which is intended to act as sentinel) makes the error go away on x86_64\n"
                "    f(\"first\", s2, s2, s2, s2, s2, 0, s3, (char*)0);\n"
                "}\n"
                "\n"
                "void h() {\n"
                "    int i;\n"
                "    volatile unsigned char a[1000];\n"
                "    for (i = 0; i<sizeof(a); i++)\n"
                "        a[i] = -1;\n"
                "}\n"
                "\n"
                "int main() {\n"
                "    h();\n"
                "    g();\n"
                "    return 0;\n"
				"}", ErrorLogger::GenWebIdentity(tok->str()));
}

//---------------------------------------------------------------------------
// Check for ignored return values.
//---------------------------------------------------------------------------
void CheckOther::checkIgnoredReturnValue()
{
    if (!_settings->isEnabled("warning"))
        return;

    const SymbolDatabase *symbolDatabase = _tokenizer->getSymbolDatabase();
    const std::size_t functions = symbolDatabase->functionScopes.size();
    for (std::size_t i = 0; i < functions; ++i) {
        const Scope * scope = symbolDatabase->functionScopes[i];
        for (const Token* tok = scope->classStart->next(); tok != scope->classEnd; tok = tok->next()) {
            if (tok->varId() || !Token::Match(tok, "%name% (") || tok->strAt(-1) == ".")
                continue;

            if (!tok->scope()->isExecutable()) {
                tok = tok->scope()->classEnd;
                continue;
            }

            const Token* parent = tok;
            while (parent->astParent() && parent->astParent()->str() == "::")
                parent = parent->astParent();
            if (tok->next()->astOperand1() != parent)
                continue;

            if (!tok->next()->astParent() && (!tok->function() || !Token::Match(tok->function()->retDef, "void %name%")) && _settings->library.isUseRetVal(tok))
                ignoredReturnValueError(tok, tok->str());
        }
    }
}

void CheckOther::ignoredReturnValueError(const Token* tok, const std::string& function)
{
    reportError(tok, Severity::warning, ErrorType::None, "ignoredReturnValue",
                "Return value of function " + function + "() is not used.", 0U, false);
}

void CheckOther::checkRedundantPointerOp()
{
    if (!_settings->isEnabled("style"))
        return;

    const SymbolDatabase *symbolDatabase = _tokenizer->getSymbolDatabase();
    for (const Token *tok = _tokenizer->tokens(); tok; tok = tok->next()) {
        if (tok->str() == "&") {
            // bail out for logical AND operator
            if (tok->astOperand2())
                continue;

            // pointer dereference
            const Token *astTok = tok->astOperand1();
            if (!astTok || astTok->str() != "*")
                continue;

            // variable
            const Token *varTok = astTok->astOperand1();
            if (!varTok || varTok->isExpandedMacro() || varTok->varId() == 0)
                continue;

            const Variable *var = symbolDatabase->getVariableFromVarId(varTok->varId());
            if (!var || !var->isPointer())
                continue;

            redundantPointerOpError(tok, var->name(), false);
        }
    }
}

void CheckOther::redundantPointerOpError(const Token* tok, const std::string &varname, bool inconclusive)
{
    reportError(tok, Severity::style, ErrorType::None, "redundantPointerOp",
                "Redundant pointer operation on " + varname + " - it's already a pointer.", 0U, inconclusive);
}

void CheckOther::checkLibraryMatchFunctions()
{
    if (!_settings->checkLibrary || !_settings->isEnabled("information"))
        return;

    for (const Token *tok = _tokenizer->tokens(); tok; tok = tok->next()) {
        if (Token::Match(tok, "%name% (") &&
            !Token::Match(tok, "for|if|while|switch|sizeof|catch|asm|return") &&
            !tok->function() &&
            !tok->varId() &&
            !tok->type() &&
            !tok->isStandardType() &&
            tok->linkAt(1)->strAt(1) != "(" &&
            tok->astParent() == tok->next() &&
            _settings->library.isNotLibraryFunction(tok)) {
            reportError(tok,
                        Severity::information,
						ErrorType::None,
                        "checkLibraryFunction",
						"--check-library: There is no matching configuration for function " + tok->str() + "()", ErrorLogger::GenWebIdentity(tok->str()));
        }
    }
}

void CheckOther::checkInterlockedDecrement()
{
    if (!_settings->isWindowsPlatform()) {
        return;
    }

    for (const Token *tok = _tokenizer->tokens(); tok; tok = tok->next()) {
        if (tok->isName() && Token::Match(tok, "InterlockedDecrement ( & %name% ) ; if ( %name%|!|0")) {
            const Token* interlockedVarTok = tok->tokAt(3);
            const Token* checkStartTok =  interlockedVarTok->tokAt(5);
            if ((Token::Match(checkStartTok, "0 %comp% %name% )") && checkStartTok->strAt(2) == interlockedVarTok->str()) ||
                (Token::Match(checkStartTok, "! %name% )") && checkStartTok->strAt(1) == interlockedVarTok->str()) ||
                (Token::Match(checkStartTok, "%name% )") && checkStartTok->str() == interlockedVarTok->str()) ||
                (Token::Match(checkStartTok, "%name% %comp% 0 )") && checkStartTok->str() == interlockedVarTok->str())) {
                raceAfterInterlockedDecrementError(checkStartTok);
            }
        }
    }
}

void CheckOther::raceAfterInterlockedDecrementError(const Token* tok)
{
    reportError(tok, Severity::error, ErrorType::None, "raceAfterInterlockedDecrement",
		"Race condition: non-interlocked access after InterlockedDecrement(). Use InterlockedDecrement() return value instead.", ErrorLogger::GenWebIdentity(tok->str()));
}

void CheckOther::checkUnusedLabel()
{
    if (!_settings->isEnabled("style"))
        return;

    const SymbolDatabase *symbolDatabase = _tokenizer->getSymbolDatabase();
    const std::size_t functions = symbolDatabase->functionScopes.size();
    for (std::size_t i = 0; i < functions; ++i) {
        const Scope * scope = symbolDatabase->functionScopes[i];

        for (const Token* tok = scope->classStart; tok != scope->classEnd; tok = tok->next()) {
            if (!tok->scope()->isExecutable())
                tok = tok->scope()->classEnd;

            if (Token::Match(tok, "{|}|; %name% :") && tok->strAt(1) != "default") {
                if (!Token::findsimplematch(scope->classStart->next(), ("goto " + tok->strAt(1)).c_str(), scope->classEnd->previous()))
                    unusedLabelError(tok->next());
            }
        }
    }
}

void CheckOther::unusedLabelError(const Token* tok)
{
    reportError(tok, Severity::style, ErrorType::None, "unusedLabel",
		"Label '" + (tok ? tok->str() : emptyString) + "' is not used.", ErrorLogger::GenWebIdentity(tok ? tok->str() : emptyString));
}

#pragma region From TSC 1.0

static bool isUnsigned(const Variable* var)
{
	return(var && var->typeStartToken()->isUnsigned() && !var->isPointer() && !var->isArray());
}

static bool isSigned(const Variable* var)
{
	return(var && !var->typeStartToken()->isUnsigned() && Token::Match(var->typeEndToken(), "int|char|short|long") && !var->isPointer() && !var->isArray());
}

void CheckOther::udivError(const Token *tok)
{
	reportError(tok, Severity::warning, ErrorType::Compute, "UnsignedDivision", "Division with signed and unsigned operators. The result might be wrong.", ErrorLogger::GenWebIdentity(tok->str()));
}

void CheckOther::checkUnsignedDivision()
{
	const SymbolDatabase* symbolDatabase = _tokenizer->getSymbolDatabase();
	//bool style = _settings->isEnabled("style");
	bool style = true;

	const Token* ifTok = 0;
	// Check for "ivar / uvar" and "uvar / ivar"
	for (const Token *tok = _tokenizer->tokens(); tok; tok = tok->next()) {
		if (Token::Match(tok, "[).]")) // Don't check members or casted variables
			continue;

		if (Token::Match(tok->next(), "%var% / %num%")) {
			if (tok->strAt(3)[0] == '-' && isUnsigned(symbolDatabase->getVariableFromVarId(tok->next()->varId()))) {
				udivError(tok->next()/*, false*/);
			}
		}
		else if (Token::Match(tok->next(), "%num% / %var%")) {
			if (tok->strAt(1)[0] == '-' && isUnsigned(symbolDatabase->getVariableFromVarId(tok->tokAt(3)->varId()))) {
				udivError(tok->next()/*, false*/);
			}
		}
		else if (Token::Match(tok->next(), "%var% / %var%") && _settings->inconclusive && style && !ifTok) {
			const Variable* var1 = symbolDatabase->getVariableFromVarId(tok->next()->varId());
			const Variable* var2 = symbolDatabase->getVariableFromVarId(tok->tokAt(3)->varId());
			if ((isUnsigned(var1) && isSigned(var2)) || (isUnsigned(var2) && isSigned(var1))) {
				udivError(tok->next()/*, true*/);
			}
		}
		else if (!ifTok && Token::simpleMatch(tok, "if ("))
			ifTok = tok->next()->link()->next()->link();
		else if (ifTok == tok)
			ifTok = 0;
	}
}

//-----------------------------------------------------------------------------
// check for duplicate expressions in if statements
// if (a) { } else if (a) { }
//-----------------------------------------------------------------------------
static bool expressionHasSideEffects(const Token *first, const Token *last)
{
	if (!last)
		return false;
	for (const Token *tok = first; tok != last->next() && tok; tok = tok->next()) {
		// check for assignment
		if (tok->isAssignmentOp())
			return true;

		// check for inc/dec
		else if (tok->tokType() == Token::eIncDecOp)
			return true;

		// check for function call
		else if (Token::Match(tok, "%var% (") &&
			!(Token::Match(tok, "c_str|string") || tok->isStandardType()))
			return true;
	}

	return false;
}

bool IsMacroExpanded(const Token* tok, const Token* end)
{
	while (tok && tok != end)
	{
		if (tok->isExpandedMacro())
		{
			return true;
		}
		tok = tok->next();
	}
	return false;
}

void CheckOther::checkDuplicateIf()
{
	//if (!_settings->isEnabled("style"))
	//return;

	const SymbolDatabase *symbolDatabase = _tokenizer->getSymbolDatabase();

	for (std::list<Scope>::const_iterator scope = symbolDatabase->scopeList.begin(); scope != symbolDatabase->scopeList.end(); ++scope) {
		const Token* const tok = scope->classDef;
		// only check if statements
		if (scope->type != Scope::eIf || !tok)
			continue;

		std::map<std::string, const Token*> expressionMap;

		// get the expression from the token stream
		std::string expression = tok->tokAt(2)->stringifyList(tok->next()->link());

		bool bMacro = IsMacroExpanded(tok->tokAt(2), tok->next()->link());
		if (!bMacro)
		{
			// save the expression and its location
			expressionMap.insert(std::make_pair(expression, tok));
		}

		// find the next else if (...) statement
		const Token *tok1 = scope->classEnd;

		// check all the else if (...) statements
		while (tok1 && Token::simpleMatch(tok1, "} else { if (") &&
			Token::simpleMatch(tok1->linkAt(4), ") {")) {
			// get the expression from the token stream
			expression = tok1->tokAt(5)->stringifyList(tok1->linkAt(4));
			
			bMacro = IsMacroExpanded(tok1->tokAt(5), tok1->linkAt(4));

			if (bMacro)
			{
				tok1 = tok1->linkAt(4)->next()->link();
				continue;
			}
			// try to look up the expression to check for duplicates
			std::map<std::string, const Token *>::iterator it = expressionMap.find(expression);
			bool hasMatchedExp = (it != expressionMap.end());


			if (!hasMatchedExp) // kylekang:加入表达式匹配逻辑
			{
				for (it = expressionMap.begin(); it != expressionMap.end(); it++)
				{
					if (ExpressionMatch::hasSameSemantic(expression, it->first))
					{
						hasMatchedExp = true;
						break;
					}
				}
			}


			// found a duplicate
			if (hasMatchedExp) { //if (it != expressionMap.end()) {
								 // check for expressions that have side effects and ignore them
				if (!expressionHasSideEffects(tok1->tokAt(5), tok1->linkAt(4)->previous()))
					duplicateIfError(it->second, tok1->next());
			}

			// not a duplicate expression so save it and its location
			else
				expressionMap.insert(std::make_pair(expression, tok1->next()));

			// find the next else if (...) statement
			tok1 = tok1->linkAt(4)->next()->link();
		}
	}
}

struct releaseinfo
{
	const Token *tok;
	int level;
	int id;
	std::string releasestr;
};

bool finddoublerelease(releaseinfo info, std::vector<releaseinfo> releaselist, std::vector<int> returnlist, std::string::size_type id)
{
	std::vector<releaseinfo>::iterator itr;
	for (itr = releaselist.begin(); itr != releaselist.end(); itr++)
	{
		if (itr->releasestr == info.releasestr)
		{
			if (info.level != itr->level)
			{
				std::vector<int>::iterator result = find(returnlist.begin(), returnlist.end(), itr->level); //查找3
				if (info.level<itr->level)
				{
					if (result == returnlist.end())
					{
						return true;
					}
					else
					{
						if (returnlist.size()<id)
						{
							return true;
						}
					}
				}
				else
				{
					if (result == returnlist.end())
					{
						return true;
					}
				}
			}
			else
			{
				if (itr->id == info.id)
				{
					std::vector<int>::iterator result = find(returnlist.begin(), returnlist.end(), itr->level); //查找3
					if (result == returnlist.end())
					{
						return true;
					}
				}
			}
		}
	}
	return false;
}

void findcallstr(const Token *tok, std::string &str)
{
	const Token* left = tok->astOperand1();
	const Token* right = tok->astOperand2();
	if (right)
	{
		str = str + right->str();
	}
	if (left)
	{
		str = str + left->str();
		findcallstr(left, str);
	}
	//add release's param
	const Token* paramStart = tok->tokAt(2);
	const Token* paramEnd = NULL;
	if (paramStart && paramStart->str() == "(")
	{
		paramEnd = paramStart->link();

		while (paramStart && paramStart != paramEnd)
		{
			str = str + paramStart->str();
			paramStart = paramStart->next();
		}

	}
}

void CheckOther::checkCocosdoublefree()
{
	const SymbolDatabase *symbolDatabase = _tokenizer->getSymbolDatabase();
	for (std::list<Scope>::const_iterator scope = symbolDatabase->scopeList.begin(); scope != symbolDatabase->scopeList.end(); ++scope)
	{
		if (scope->type != Scope::eFunction)
		{
			continue;
		}
		const Token* tok = scope->classStart;
		if (tok)
		{
			tok = tok->next();
		}
		std::vector<releaseinfo> releaselist;
		std::vector<int> returnlist;
		int level = 0;
		int id = 0;
		for (; tok&&tok != scope->classEnd; tok = tok->next())
		{
			if (Token::Match(tok, "{"))
			{
				level++;
				//Todo: check eElseIf
				if (tok->scope()->type == Scope::eIf /*|| tok->scope()->type == Scope::eElseIf*/ || tok->scope()->type == Scope::eElse)
				{
					id++;
				}
			}
			if (Token::Match(tok, "return|goto"))
			{
				returnlist.push_back(level);
			}
			if (Token::Match(tok, "case : | default:"))
			{
				id++;
			}
			if (Token::Match(tok, "}"))
			{
				level--;
			}
			if (Token::Match(tok, ". release ("))
			{
				std::string releaseStr = "";
				findcallstr(tok, releaseStr);
				releaseinfo tempinfo;
				tempinfo.level = level;
				if (tok->scope()->type == Scope::eFunction)
				{
					tempinfo.id = 0;
				}
				else
				{
					tempinfo.id = id;
				}

				tempinfo.tok = tok;
				tempinfo.releasestr = releaseStr;
				if (finddoublerelease(tempinfo, releaselist, returnlist, id))
				{
					reportError(tok, Severity::warning, ErrorType::Suspicious, "Cocosdoublefree", "cocos2d: redundant release().", ErrorLogger::GenWebIdentity(tok->str()));
				}
				releaselist.push_back(tempinfo);
			}
		}
	}
}

const std::string ErrorErrorVarStr(std::map<unsigned int, const Token *>::iterator iterVar, bool checkLocal)
{

	if (Token::Match(iterVar->second->astParent(), ".|::|["))
	{
		const Token *t = iterVar->second->astParent();
		while (Token::Match(t, ".|["))
		{
			t = t->astOperand1();
		}
		if (!t)
		{
			return emptyString;
		}
		if (!t->variable() && t->str() != "::")
		{
			return emptyString;
		}
		if (checkLocal && t->variable() && (t->variable()->isLocal() || t->variable()->isArgument()))
		{
			return emptyString;
		}
		//do not report iterator
		if (t->variable() && Token::Match(t->variable()->typeEndToken(), "iterator|const_iterator"))
		{
			return emptyString;
		}
		return iterVar->second->astParent()->astString2();
	}
	if (iterVar->second->variable())
	{
		const Variable *var = iterVar->second->variable();
		if (checkLocal && (var->isLocal() || var->isArgument()))
		{
			return emptyString;
		}
		return iterVar->second->str();
	}
	return emptyString;
}


static bool CheckPointerScope(const Token *tokDel, const Token *tokUse)
{
	if (!tokDel->scope() || !tokUse->scope())
	{
		return true;
	}
	if (tokDel->scope() == tokUse->scope())
	{
		return true;
	}
	const Scope *sDel = tokDel->scope();
	const Scope *sUse = tokUse->scope();
	while (sUse && sUse->GetScopeType() != Scope::eElse)
	{
		if (sUse->isFunction())
		{
			break;
		}
		sUse = sUse->nestedIn;
	}
	if (!sUse || (sUse->GetScopeType() != Scope::eElse && sUse->GetScopeType() != Scope::eFunction))
	{
		return false;
	}
	while (sDel && !(sDel->GetScopeType() == Scope::eIf && Token::simpleMatch(sDel->classEnd, "} else")))
	{
		if (sDel->isFunction())
		{
			break;
		}
		sDel = sDel->nestedIn;
	}
	if (!sDel || (sDel->GetScopeType() != Scope::eIf && sDel->GetScopeType() != Scope::eFunction))
	{
		return false;
	}
	if (sDel->classEnd && sDel->classEnd->next() == sUse->classDef)
	{
		return false;
	}
	return true;
}

void CheckOther::CheckDanglingPtr()
{
	const SymbolDatabase *const base = _tokenizer->getSymbolDatabase();
	std::map<unsigned int, const Token *> delVar;
	std::map<unsigned int, const Token *>::iterator iterVar;
	std::map<unsigned int, const Token *>::iterator endVar = delVar.end();
	for (std::size_t ii = 0, nSize = base->functionScopes.size(); ii < nSize; ++ii)
	{
		const Scope *scope = base->functionScopes[ii];
		if (scope->function && scope->function->type == Function::eDestructor)
		{
			continue;
		}
		if (scope->className == "Destroy" || scope->className == "main")
		{
			continue;
		}
		bool bHasReturn = false;
		for (const Token *tok = scope->classStart, *end = scope->classEnd;
			tok && tok != end; tok = tok->next())
		{
			if (tok->str() == "delete")
			{
				if (tok->isExpandedMacro())
				{
					continue;
				}
				const Token *tDel = nullptr;
				if (tok->astOperand1())
				{
					tDel = tok->astOperand1();
					if (tDel->str() == "." || tDel->str() == "::")
					{
						tDel = tDel->astOperand2();
					}
				}
				else if (tok->next())
				{
					tDel = tok->next();
					if (Token::simpleMatch(tDel, "[ ]"))
					{
						tDel = tDel->next()->next();
					}
				}
				if (tDel && Token::simpleMatch(tDel->next(), ";") && tDel->varId() > 0)
				{
					delVar[tDel->varId()] = tDel;
				}
			}
			else if (tok->isAssignmentOp() && tok->astOperand1())
			{
				if (Token::Match(tok->astOperand1(), ".|::"))
				{
					const Token *t = tok->astOperand1()->astOperand2();
					if (t && t->varId() > 0)
					{
						delVar.erase(t->varId());
					}
				}
				else if (tok->astOperand1()->varId() > 0)
				{
					delVar.erase(tok->astOperand1()->varId());
				}
			}
			else if (tok->variable() && (iterVar = delVar.find(tok->varId())) != endVar && tok->astParent())
			{
				if ((Token::simpleMatch(tok->astParent(), "[|*")
					|| (tok->astParent()->str() == "." 
						&& tok->astParent()->originalName() == "->"
						&& tok->astUnderTokenLeft(tok->astParent())
						)
					)
					&& CheckPointerScope(iterVar->second, tok)
					)
				{
					const std::string errorVar = ErrorErrorVarStr(iterVar, bHasReturn);//if return meet, never report local var
					if (!errorVar.empty())
					{
						reportError(iterVar->second, Severity::style, ErrorType::Suspicious, "Danglingpointer",
							"Dangling pointer[" + errorVar + "] found. You forget to assign this var with nullptr after delete",
							ErrorLogger::GenWebIdentity(errorVar));
					}
					delVar.erase(tok->varId());
				}
			}
			//remove all deleted local var
			else if (!bHasReturn && (tok->str() == "return" || CGlobalTokenizer::Instance()->CheckIfReturn(tok)))
			{
				bHasReturn = true;
			}
		}
		for (iterVar = delVar.begin(); iterVar != endVar; ++iterVar)
		{
			const std::string errorVar = ErrorErrorVarStr(iterVar, true);
			if (errorVar.empty())
			{
				continue;
			}
			reportError(iterVar->second, Severity::style, ErrorType::Suspicious, "Danglingpointer",
				"Dangling pointer[" + errorVar + "] found. You forget to assign this var with nullptr after delete",
				ErrorLogger::GenWebIdentity(errorVar));
		}
	}
}


void CheckOther::duplicateIfError(const Token *tok1, const Token *tok2)
{
	std::list<const Token *> toks;
	toks.push_back(tok2);
	toks.push_back(tok1);
	reportError(toks, Severity::warning, ErrorType::Logic, "duplicateIf", "Duplicate conditions in 'if' and related 'else if'.\n"
		"Duplicate conditions in 'if' and related 'else if'. This is suspicious and might indicate "
		"a cut and paste or logic error. Please examine this code carefully to determine "
		"if it is correct.");
}

//---------------------------------------------------------------------------
//    int x = 1;
//    x = x;            // <- redundant assignment to self
//
//    int y = y;        // <- redundant initialization to self
//---------------------------------------------------------------------------
static bool isTypeWithoutSideEffects(const Tokenizer *tokenizer, const Variable* var)
{
	return ((var && (!var->isClass() || var->isPointer() || Token::simpleMatch(var->typeStartToken(), "std ::"))) || (tokenizer && !tokenizer->isCPP()));
}

void CheckOther::checkSelfAssignment()
{
	if (!_settings->isEnabled("style"))
		return;

	const SymbolDatabase* symbolDatabase = _tokenizer->getSymbolDatabase();

	const char selfAssignmentPattern[] = "%var% = %var% ;|=|)";
	const Token *tok = Token::findmatch(_tokenizer->tokens(), selfAssignmentPattern);
	while (tok ) {
		if (Token::Match(tok->previous(), "[;{}.]") &&
			tok->varId() && tok->varId() == tok->tokAt(2)->varId() &&
			isTypeWithoutSideEffects(_tokenizer, symbolDatabase->getVariableFromVarId(tok->varId()))) {
			bool err = true;

			// no false positive for 'x = x ? x : 1;'
			// it is simplified to 'if (x) { x=x; } else { x=1; }'. The simplification
			// always write all tokens on 1 line (even if the statement is several lines), so
			// check if the linenr is the same for all the tokens.
			if (Token::Match(tok->tokAt(-2), ") { %var% = %var% ; } else { %varid% =", tok->varId())) {
				// Find the 'if' token
				const Token *tokif = tok->linkAt(-2)->previous();

				// find the '}' that terminates the 'else'-block
				const Token *else_end = tok->linkAt(6);

				if (tokif && else_end && tokif->linenr() == else_end->linenr())
					err = false;
			}

			//
			if (Token::Match(tok->tokAt(3), "; }"))
			{
				const Token* tok2 = tok->tokAt(4);
				if (tok2->link())
				{
					tok2 = tok2->link()->previous();
					if (tok2 && tok2->str() == ";")
					{
						tok2 = tok2->previous();
						if (tok2 && tok2->str() == tok->str())
							err = false;
					}
				}
			}


			// if the expression is expanded from macros, don't report error
			const Token* tokEnd = tok->tokAt(3);
			for (const Token* tokM = tok; tokM && tokM != tokEnd; tokM = tokM->next())
			{
				if (Token::Match(tokM, ";|{|}"))
				{
					break;
				}
				if (tokM->isExpandedMacro())
				{
					err = false;
					break;
				}
			}

			if (err)
			{
				if (tok->tokAt(2) && !tok->tokAt(2)->isCast())
				{
					selfAssignmentError(tok, tok->str());
				}
			}
		}

		tok = Token::findmatch(tok->next(), selfAssignmentPattern);
	}
}

namespace {
	struct ExpressionTokens {
		const Token *start;
		const Token *end;
		int count;
		bool inconclusiveFunction;
		ExpressionTokens(const Token *s, const Token *e) : start(s), end(e), count(1), inconclusiveFunction(false) {}
	};

	struct FuncFilter {
		FuncFilter(const Scope *scope, const Token *tok) : _scope(scope), _tok(tok) {}

		bool operator()(const Function* func) const {
			if (!func)
				return false;
			bool matchingFunc = func->type == Function::eFunction && _tok &&
				_tok->str() == func->token->str();
			// either a class function, or a global function with the same name
			return (_scope && _scope == func->nestedIn && matchingFunc) ||
				(!_scope && matchingFunc);
		}
		const Scope *_scope;
		const Token *_tok;
	};

	bool inconclusiveFunctionCall(const SymbolDatabase *symbolDatabase,
		const std::list<const Function*> &constFunctions,
		const ExpressionTokens &tokens)
	{
		const Token *start = tokens.start;
		const Token *end = tokens.end;
		// look for function calls between start and end...
		for (const Token *tok = start; tok && tok != end; tok = tok->next()) {
			if (tok != start && tok->str() == "(") {
				// go back to find the function call.
				const Token *prev = tok->previous();
				if (!prev)
					continue;
				if (prev->str() == ">") {
					// ignore template functions like boo<double>()
					return true;
				}
				if (prev->isName()) {
					const Variable *v = 0;
					if (Token::Match(prev->tokAt(-2), "%var% .")) {
						const Token *scope = prev->tokAt(-2);
						if (scope && symbolDatabase)
						{
							v = symbolDatabase->getVariableFromVarId(scope->varId());
						}
					}
					// hard coded list of safe, no-side-effect functions
					if (v == 0 && Token::Match(prev, "strcmp|strncmp|strlen|memcmp|strcasecmp|strncasecmp"))
						return false;
					std::list<const Function*>::const_iterator it = std::find_if(constFunctions.begin(),
						constFunctions.end(),
						FuncFilter(v ? v->typeScope() : 0, prev));
					if (it == constFunctions.end())
						return true;
				}
			}
		}
		return false;
	}

	class Expressions {
	public:
		Expressions(const SymbolDatabase *symbolDatabase, const
			std::list<const Function*> &constFunctions)
			: _start(0),
			_lastTokens(0),
			_symbolDatabase(symbolDatabase),
			_constFunctions(constFunctions) { }

		void endExpr(const Token *end) {
			const std::string &e = _expression.str();
			if (!e.empty()) {
				std::map<std::string, ExpressionTokens>::iterator it = _expressions.find(e);
				bool lastInconclusive = _lastTokens && _lastTokens->inconclusiveFunction;
				bool hasMatchedExp = (it != _expressions.end());

				if (!hasMatchedExp) // kylekang：加入表达式匹配逻辑
				{
					for (it = _expressions.begin(); it != _expressions.end(); it++)
					{
						if (ExpressionMatch::hasSameSemantic(e, it->first))
						{
							hasMatchedExp = true;
							break;
						}
					}
				}

				if (!hasMatchedExp) { //if (it == _expressions.end()) {
					ExpressionTokens exprTokens(_start, end);
					exprTokens.inconclusiveFunction = lastInconclusive || inconclusiveFunctionCall(
						_symbolDatabase, _constFunctions, exprTokens);
					_expressions.insert(std::make_pair(e, exprTokens));
					_lastTokens = &_expressions.find(e)->second;
				}
				else {
					if (it != _expressions.end())
					{
						ExpressionTokens &expr = it->second;
						expr.count += 1;
						expr.inconclusiveFunction = expr.inconclusiveFunction || lastInconclusive;
						_lastTokens = &expr;
					}
				}
			}
			_expression.str("");
			_start = 0;
		}

		void append(const Token *tok) {
			if (!_start)
				_start = tok;
			if (tok)
			{
				if (tok->str() == "0" || tok->str() == ".")
				{
					_expression << tok->originalName();
				}
				else
				{
					_expression << tok->str();
				}
				
			}
		}

		std::map<std::string, ExpressionTokens> &getMap() {
			return _expressions;
		}

	private:
		std::map<std::string, ExpressionTokens> _expressions;
		std::ostringstream _expression;
		const Token *_start;
		ExpressionTokens *_lastTokens;
		const SymbolDatabase *_symbolDatabase;
		const std::list<const Function*> &_constFunctions;
	};

}


void CheckOther::checkExpressionRange(const std::list<const Function*> &constFunctions,
	const Token *start,
	const Token *end,
	const std::string &toCheck)
{
	if (!start || !end)
		return;
	Expressions expressions(_tokenizer->getSymbolDatabase(), constFunctions);
	std::string opName;
	int level = 0;
	for (const Token *tok = start->next(); tok && tok != end; tok = tok->next()) {
		if (tok->isExpandedMacro() 
			|| (tok->isName() && (tok->originalName() != tok->str()) && (tok->originalName() != emptyString)))
		{
			return;
		}
		if (tok->str() == ")")
			level--;
		else if (tok->str() == "(")
			level++;

		if (level == 0 && Token::Match(tok, toCheck.c_str()) && !tok->link()) {
			opName = tok->str();
			expressions.endExpr(tok);
		}
		else {
			expressions.append(tok);
		}
	}
	expressions.endExpr(end);
	std::map<std::string, ExpressionTokens>::const_iterator it = expressions.getMap().begin();
	for (; it != expressions.getMap().end(); ++it) {
		// check expression..
		bool valid = true;
		unsigned int parenthesis = 0;  // ()
		unsigned int brackets = 0;     // []

		// taking address?
		if (Token::Match(it->second.end->previous(), "%op% &")) {
			continue;
		}

		for (const Token *tok = it->second.start; tok && tok != it->second.end; tok = tok->next()) {
			if (tok->str() == "(") {
				++parenthesis;
			}
			else if (tok->str() == ")") {
				if (parenthesis == 0) {
					valid = false;
					break;
				}
				--parenthesis;
			}
			else if (tok->str() == "[") {
				++brackets;
			}
			else if (tok->str() == "]") {
				if (brackets == 0) {
					valid = false;
					break;
				}
				--brackets;
			}
			else if (tok->tokType() == Token::eIncDecOp) {
				valid = false;
				break;
			}
		}

		if (!valid || parenthesis != 0 || brackets != 0)
			continue;

		const ExpressionTokens &expr = it->second;
		if (expr.count > 1/* && !expr.inconclusiveFunction*/) {
			/* FP bug fixed
			do {
			} while (*(ushf*)(scan+=2) == *(ushf*)(match+=2) &&
			*(ushf*)(scan+=2) == *(ushf*)(match+=2) &&
			*(ushf*)(scan+=2) == *(ushf*)(match+=2) &&
			*(ushf*)(scan+=2) == *(ushf*)(match+=2) &&
			scan < strend);
			*/

			bool flag = true;
			const Token* toktmp = expr.start;
			while (toktmp && toktmp != expr.end)
			{
				//这些函数可能故意执行两次
				if (Token::Match(toktmp,"read|get|create|init"))
				{
					flag = false;
					break;
				}
				if (Token::Match(toktmp->next(), ". get|getline|read|readsome|putback|unget|good"))
				{
					flag = false;
					break;
				}
				if (!IsPureFunc(toktmp))
				{
					flag = false;
					break;
				}

				if (toktmp->str() == "+=" || toktmp->str() == "-=" || toktmp->str() == "*=" || toktmp->str() == "/=" || toktmp->str() == "%=")
				{
					flag = false;
					break;
				}
				toktmp = toktmp->next();
			}
			if (flag && opName == "|" && expr.start && expr.start->next() && expr.start->next()->str() == "|")
			{
				const Token *t = expr.start->next()->astParent();
				if (t && (t->isAssignmentOp() || t->isArithmeticalOp())
					&& t->previous()->variable()
					&& t->previous()->variable()->typeStartToken()
					&& _settings->library.podtype(t->previous()->variable()->typeStartToken()->str()) == nullptr)
				{
					continue;
				}
			}
			if (flag)
			  duplicateExpressionError(expr.start, expr.start, opName);
		}
	}
}

void CheckOther::complexDuplicateExpressionCheck(const std::list<const Function*> &constFunctions,
	const Token *classStart,
	const std::string &toCheck,
	const std::string &alt)
{
	std::string statementStart(",|=|?|:|return");
	if (!alt.empty())
		statementStart += "|" + alt;
	std::string statementEnd(";|,|?|:");
	if (!alt.empty())
		statementEnd += "|" + alt;

	for (const Token *tok = classStart; tok && classStart && tok != classStart->link(); tok = tok->next()) {
		if (!Token::Match(tok, toCheck.c_str()) || tok->link())
			continue;

		// look backward for the start of the statement
		const Token *start = 0;
		int level = 0;
		for (const Token *tok1 = tok->previous(); tok1 && tok1 != classStart; tok1 = tok1->previous()) {
			if (tok1->str() == ")")
				level++;
			else if (tok1->str() == "(")
				level--;

			if (level < 0 || (level == 0 && Token::Match(tok1, statementStart.c_str()))) {
				start = tok1;
				break;
			}
		}
		const Token *end = 0;
		level = 0;
		// look for the end of the statement
		for (const Token *tok1 = tok->next(); tok1 && tok1 != classStart->link(); tok1 = tok1->next()) {
			if (tok1->str() == ")")
				level--;
			else if (tok1->str() == "(")
				level++;

			if (level < 0 || (level == 0 && Token::Match(tok1, statementEnd.c_str()))) {
				end = tok1;
				break;
			}
		}
		checkExpressionRange(constFunctions, start, end, toCheck);
	}
}

//---------------------------------------------------------------------------
// check for the same expression on both sides of an operator
// (x == x), (x && x), (x || x)
// (x.y == x.y), (x.y && x.y), (x.y || x.y)
//---------------------------------------------------------------------------
void CheckOther::checkDuplicateExpression1()
{
	//if (!_settings->isEnabled("style"))
	//	return;

	// Parse all executing scopes..
	const SymbolDatabase *symbolDatabase = _tokenizer->getSymbolDatabase();

	std::list<Scope>::const_iterator scope;
	std::list<const Function*> constFunctions;
	getConstFunctions(symbolDatabase, constFunctions);

	for (scope = symbolDatabase->scopeList.begin(); scope != symbolDatabase->scopeList.end(); ++scope) {
		// only check functions
		if (scope->type != Scope::eFunction)
			continue;

		complexDuplicateExpressionCheck(constFunctions, scope->classStart, ">", "&&|%oror%");
		complexDuplicateExpressionCheck(constFunctions, scope->classStart, "<", "&&|%oror%");
		complexDuplicateExpressionCheck(constFunctions, scope->classStart, ">=", "&&|%oror%");
		complexDuplicateExpressionCheck(constFunctions, scope->classStart, "<=", "&&|%oror%");
		complexDuplicateExpressionCheck(constFunctions, scope->classStart, "%or%", "");
		complexDuplicateExpressionCheck(constFunctions, scope->classStart, "%oror%", "");
		complexDuplicateExpressionCheck(constFunctions, scope->classStart, "&", "%oror%|%or%");
		complexDuplicateExpressionCheck(constFunctions, scope->classStart, "&&", "%oror%|%or%");

		for (const Token *tok = scope->classStart; tok && tok != scope->classStart->link(); tok = tok->next()) {
			if (Token::Match(tok, ",|=|return|(|&&|%oror% %var% ==|!=|<=|>=|<|>|- %var% )|&&|%oror%|;|,") &&
				tok->strAt(1) == tok->strAt(3)) {
				// float == float and float != float are valid NaN checks
				if (Token::Match(tok->tokAt(2), "==|!=") && tok->next()->varId()) {
					const Variable * var = symbolDatabase->getVariableFromVarId(tok->next()->varId());
					if (var && var->typeStartToken() == var->typeEndToken()) {
						if (Token::Match(var->typeStartToken(), "float|double"))
							continue;
					}
				}

				// If either variable token is an expanded macro then
				// don't write the warning
				if (tok->next()->isExpandedMacro() || tok->tokAt(3)->isExpandedMacro())
					continue;

				duplicateExpressionError(tok->next(), tok->tokAt(3), tok->strAt(2));
			}
			else if (Token::Match(tok, ",|=|return|(|&&|%oror% %var% . %var% ==|!=|<=|>=|<|>|- %var% . %var% )|&&|%oror%|;|,") &&
				tok->strAt(1) == tok->strAt(5) && tok->strAt(3) == tok->strAt(7)) {

				// If either variable token is an expanded macro then
				// don't write the warning
				if (tok->next()->isExpandedMacro() || tok->tokAt(6)->isExpandedMacro())
					continue;

				duplicateExpressionError(tok->next(), tok->tokAt(6), tok->strAt(4));
			}
		}
	}
}



#pragma endregion From TSC 1.0

