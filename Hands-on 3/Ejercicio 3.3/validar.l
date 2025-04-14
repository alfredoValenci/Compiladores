%{
#include "validar.tab.h"
%}

%%
"1"       { return BOOL; }
"0"       { return BOOL; }
[0-9]+    { return NUMBER; }
"AND"     { return AND; }
"OR"      { return OR; }
"NOT"     { return NOT; }
"("       { return '('; }
")"       { return ')'; }
[\n]      { return '\n'; }
[ \t\r]+  ;   // Ignorar espacios y tabulaciones
.         { return yytext[0]; }
%%

int yywrap(void) {
    return 1;
}