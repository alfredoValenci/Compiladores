%{
#include <stdio.h>
#include <stdlib.h>
%}

DIGITO   [0-9]
IDENTIFICADOR   [a-zA-Z_][a-zA-Z0-9_]*
PALABRA_CLAVE   int|return
COMENTARIO_UNA_LINEA   "//".*
COMENTARIO_MULTILINEA   "/\\*[^*]*\\*+([^/*][^*]*\\*+)*\\/"
CADENA   "\"[^\"]*\""

%%

{PALABRA_CLAVE}    { printf("Palabra clave: %s\n", yytext); }
{IDENTIFICADOR}    { printf("Identificador: %s\n", yytext); }
{DIGITO}+          { printf("Número: %s\n", yytext); }
{COMENTARIO_UNA_LINEA}    { printf("Comentario de una línea: %s\n", yytext); }
{COMENTARIO_MULTILINEA}   { printf("Comentario multilinea: %s\n", yytext); }
{CADENA}           { printf("Cadena de texto: %s\n", yytext); }

%%

int main() {
    yylex();
    return 0;
}