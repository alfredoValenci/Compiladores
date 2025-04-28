%{
#include "parser.tab.h" // Inclusión del archivo generado por Bis
#include <string.h> // Para funciones como strdup
#include <stdlib.h> // Para uso de memoria dinámica
%}
%%
"int" { return INT; } // Palabra clave pa
"func" { return FUNC; } // Palabra clave pa
"return" { return RETURN; } // Palabra clave pa
[a-zA-Z_][a-zA-Z0-9_]* { yylval.str = strdup(yytext); return ID; } // Identif
"(" { return PARIZQ; } // Paréntesis izqui
")" { return PARDER; } // Paréntesis derec
"{" { return LLAVEIZQ; } // Llave de apertur
"}" { return LLAVEDER; } // Llave de cierre
";" { return PUNTOYCOMA; } // Punto y coma
"," { return COMA; } // Coma
"=" { return IGUAL; } // Operador de asig
[ \t\n]+ ; // Ignorar espacio
. { return yytext[0]; } // Otros caracteres
%%