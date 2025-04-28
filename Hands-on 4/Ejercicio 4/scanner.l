%{
#include "parser.tab.h"  // Inclusión del archivo de encabezado generado por Bison
#include <string.h>      // Para manejar cadenas de texto
#include <stdlib.h>      // Para memoria dinámica
%}

%%
"int"              { return INT; }        // Para la palabra clave 'int'
[a-zA-Z_][a-zA-Z0-9_]*  { yylval.str = strdup(yytext); return ID; } // Identificadores
";"                { return PUNTOYCOMA; } // Punto y coma
"{"                { return LLAVEIZQ; }   // Llave izquierda
"}"                { return LLAVEDER; }   // Llave derecha
[ \t\n]+           ;   // Ignora espacios, tabulaciones y saltos de línea
.                  { return yytext[0]; }   // Para otros caracteres
%%
