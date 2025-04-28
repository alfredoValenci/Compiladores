%{
#include "parser.tab.h"
#include <string.h>
#include <stdlib.h>
#define YY_DECL int yylex(void)
%}

%%
"int"                  { return INT; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.str = strdup(yytext); return ID; }
"="                    { return IGUAL; }
";"                    { return PUNTOYCOMA; }
[ \t]+                 ; // Ignora espacios y tabulaciones
\n                     { yylineno++; } // Cuenta líneas
.                      { return yytext[0]; }
%%
