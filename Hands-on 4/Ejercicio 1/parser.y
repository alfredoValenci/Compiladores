%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
int yyerror(char *s) { printf("Error: %s\n", s); return 0; }

#define MAX_ID 100
char *tabla[MAX_ID];
int ntabla = 0;

void agregar(char *id) {
    for (int i = 0; i < ntabla; i++)
        if (strcmp(tabla[i], id) == 0) return;
    tabla[ntabla++] = strdup(id);
}

int buscar(char *id) {
    for (int i = 0; i < ntabla; i++)
        if (strcmp(tabla[i], id) == 0) return 1;
    return 0;
}
%}

%union { char *str; }

%token <str> ID
%token INT PUNTOYCOMA

%%

programa:
    declaraciones usos
;

declaraciones:
    INT ID PUNTOYCOMA               { agregar($2); }
  | declaraciones INT ID PUNTOYCOMA { agregar($3); }
;

usos:
    ID PUNTOYCOMA {
        if (!buscar($1))
            printf("Error semántico: '%s' no está declarado\n", $1);
    }
  | usos ID PUNTOYCOMA {
        if (!buscar($2))
            printf("Error semántico: '%s' no está declarado\n", $2);
    }
;

%%

int main() {
    return yyparse();
}
