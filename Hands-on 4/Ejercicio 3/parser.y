%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void); // Declaración de la función léxica
int yyerror(char *s) {
    printf("Error: %s\n", s);
    return 0;
}

extern int yylineno;  // Número de la línea actual

#define MAX_FUNC 100  // Número máximo de funciones
char *funciones[MAX_FUNC];  // Tabla de funciones
int aridades[MAX_FUNC];  // Tabla de aridades (número de parámetros de cada función)
int nfuncs = 0;  // Número de funciones registradas

void registrar_funcion(char *id, int n) {
    // Verifica si la función ya está registrada
    for (int i = 0; i < nfuncs; i++) {
        if (strcmp(funciones[i], id) == 0) {
            printf("Error semántico (línea %d): la función '%s' ya está declarada\n", yylineno, id);
            return;
        }
    }
    // Si no está registrada, la agrega
    funciones[nfuncs] = strdup(id);
    aridades[nfuncs++] = n;
}

int obtener_aridad(char *id) {
    for (int i = 0; i < nfuncs; i++)
        if (strcmp(funciones[i], id) == 0)
            return aridades[i];
    return -1;  // Si no se encuentra la función
}
%}

%union { char *str; int num; }

%token <str> ID
%token FUNC PARIZQ PARDER PUNTOYCOMA COMA

%type <num> lista args

%%

programa:
    declaraciones llamadas
;

declaraciones:
    FUNC ID PARIZQ lista PARDER PUNTOYCOMA { registrar_funcion($2, $4); }
  | declaraciones FUNC ID PARIZQ lista PARDER PUNTOYCOMA { registrar_funcion($3, $5); }
;

lista:
    ID             { $$ = 1; }
  | lista COMA ID  { $$ = $1 + 1; }
;

llamadas:
    ID PARIZQ args PARDER PUNTOYCOMA {
        int n = obtener_aridad($1);
        if (n == -1)
            printf("Error semántico (línea %d): función '%s' no está declarada\n", yylineno, $1);
        else if (n != $3)
            printf("Error semántico (línea %d): se esperaban %d argumentos en '%s', pero se pasaron %d\n", yylineno, n, $1, $3);
    }
  | llamadas ID PARIZQ args PARDER PUNTOYCOMA {
        int n = obtener_aridad($2);
        if (n == -1)
            printf("Error semántico (línea %d): función '%s' no está declarada\n", yylineno, $2);
        else if (n != $4)
            printf("Error semántico (línea %d): se esperaban %d argumentos en '%s', pero se pasaron %d\n", yylineno, n, $2, $4);
    }
;

args:
    ID             { $$ = 1; }
  | args COMA ID   { $$ = $1 + 1; }
  |               { $$ = 0; }
;

%%

int main() {
    yylineno = 1;  // Inicializa el número de línea
    return yyparse(); // Llama a la función de parseo
}