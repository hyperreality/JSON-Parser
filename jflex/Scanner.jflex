package jsonparser;

import java_cup.runtime.SymbolFactory;
import java.lang.Exception;

%%
%cup
%unicode // Required to detect locale-specific characters like pound and euro signs
%line
%column
%class Scanner
%{
    public Scanner(java.io.InputStream r, SymbolFactory sf){
        this(r);
        this.sf=sf;
    }
    private SymbolFactory sf;;
%}
%eofval{
    return sf.newSymbol("EOF",sym.EOF);
%eofval}

// Define macros for purposes of clarity
// Regex rules corresponding to the JSON specification are listed in a tabbed column on the right

/*  A JSON char is either any Unicode character except " or \ or a control-character,	[^\\\"\u0000-\u001f]*
or it's one of the following:
    \"
    \\
    \/
    \b
    \f
    \n
    \r
    \t											\\[\"\\bfnrt\/]
    \u four-hex-digits									\\u[0-9A-Fa-f]{4}

Note that extra backslashes are required to terminate " in JFlex
*/
char = [^\\\"\u0000-\u001f]*|\\[\"\\bfnrt\/]|\\u[0-9A-Fa-f]{4}

// A string is a sequence of chars that starts and ends with a "
string = \"{char}*\"

/* A number consists of one of the following:
    int
    int frac
    int exp
    int frac exp 

Where:

int
    digit										-?[0-9]*
    digit1-9 digits									-?(0|[1-9][0-9]*)
								
frac
    . digits										\.[0-9]+
exp
    e digits										[eE][+-]?[0-9]+
digits
    digit
    digit digits
e
    e
    e+
    e-
    E
    E+
    E-
*/
number = -?(0|[1-9][0-9]*)(\.[0-9]+)?([eE][+-]?[0-9]+)?

whitespace = [ \t\r\n\f]

%%
"," { return sf.newSymbol("Comma",sym.COMMA); }
":" { return sf.newSymbol("Colon",sym.COLON); }

// Objects
"{" { return sf.newSymbol("Left Brace",sym.LBRACE); }
"}" { return sf.newSymbol("Right Brace",sym.RBRACE); }

// Arrays
"[" { return sf.newSymbol("Left Square Bracket",sym.LSQBRACKET); }
"]" { return sf.newSymbol("Right Square Bracket",sym.RSQBRACKET); }

// Booleans
"true" { return sf.newSymbol("Boolean True",sym.TRUE); }
"false" { return sf.newSymbol("Boolean False",sym.FALSE); }

// Null
"null" { return sf.newSymbol("Null",sym.NULL); }

// Number and string literal
{number} { return sf.newSymbol("Integral Number",sym.NUMBER); }
{string} { return sf.newSymbol("String",sym.STRING); }

// Whitespace
{whitespace} { /* ignore white space. */ }

// Pass error to CUP on encountering illegal characters, triggering failure exit code
. { throw new Error("Illegal character: " + yytext() + " at line " + (yyline + 1) + ", column " + (yycolumn + 1)); }
