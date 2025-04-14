%{
#include "validar.tab.h"
%}

%%
"1"      { return BOOLEAN; }
"0"      { return BOOLEAN; }
"AND"    { return AND; }
"OR"     { return OR; }
"NOT"    { return NOT; }
"("      { return '('; }
")"      { return ')'; }
[ \t]    ;           // Ignorar espacios
[\n]     { return '\n'; }
.        { return yytext[0]; }
%%

int yywrap(void) {
    return 1;
}
