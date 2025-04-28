%{
#include "parser.tab.h"  // Para compartir la interfaz con Bison
#include <string.h>
#include <stdlib.h>
#define YY_DECL int yylex(void)
extern int yylineno; // Para rastrear las líneas
%}

%%
"func"          { return FUNC; }
"("             { return PARIZQ; }
")"             { return PARDER; }
";"             { return PUNTOYCOMA; }
","             { return COMA; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.str = strdup(yytext); return ID; }
[ \t]+          ;   // Ignorar espacios y tabulaciones
\n              { yylineno++; }  // Contabilizar líneas
.               { return yytext[0]; } // Para otros caracteres
%%
