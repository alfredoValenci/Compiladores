%{
#include <stdio.h>
#include <stdlib.h>

int palabras_clave = 0, identificadores = 0, numeros = 0;
%}

DIGITO   [0-9]
IDENTIFICADOR   [a-zA-Z_][a-zA-Z0-9_]*
PALABRA_CLAVE   int|return
OPERADOR   [\+\-\*/]
DELIMITADOR   [\(\)\{\}\[\];,]

%%

{PALABRA_CLAVE}    { palabras_clave++; }
{IDENTIFICADOR}    { identificadores++; }
{DIGITO}+          { numeros++; }
{OPERADOR}         { /* operador encontrado */ }
{DELIMITADOR}      { /* delimitador encontrado */ }

%%

int main() {
    yylex();
    printf("Palabras clave: %d\n", palabras_clave);
    printf("Identificadores: %d\n", identificadores);
    printf("Números: %d\n", numeros);
    return 0;
}
