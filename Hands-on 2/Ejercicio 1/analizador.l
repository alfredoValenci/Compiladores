%{
#include <stdio.h>
#include <stdlib.h>
%}

DIGITO   [0-9]
IDENTIFICADOR   [a-zA-Z_][a-zA-Z0-9_]*
PALABRA_CLAVE   int|return

%%

{PALABRA_CLAVE}    { printf("Palabra clave: %s\n", yytext); }
{IDENTIFICADOR}    { printf("Identificador: %s\n", yytext); }
{DIGITO}+          { printf("Número: %s\n", yytext); }

%%

int main() {
    yylex();
    return 0;
}
