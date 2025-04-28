%{
#include <stdio.h> // Entrada/salida estándar
#include <stdlib.h> // Funciones de memoria
#include <string.h> // Manipulación de cadenas
int yylex(void); // Prototipo del analizador léxico
int yyerror(char *s) { printf("Error: %s\n", s); return 0; } // Manejo de errores
#define MAX_SIMB 200
typedef struct {
    char *nombre; // Nombre del identificador
    int tipo; // 0 para variable, 1 para función
    int aridad; // Número de argumentos si es función
    int ambito; // Nivel de ámbito
} Simbolo;
Simbolo tabla[MAX_SIMB]; // Tabla de símbolos
int ntabla = 0; // Contador de símbolos registrados
int ambito_actual = 0; // Nivel de ámbito actual

void entrar_ambito() { ambito_actual++; } // Aumenta el nivel de ámbito
void salir_ambito() {
    for (int i = 0; i < ntabla; i++) {
        if (tabla[i].ambito == ambito_actual) {
            tabla[i].nombre[0] = '\0'; // Marca como eliminado al salir del ámbito
        }
    }
    ambito_actual--;
}

void agregar_variable(char *id) {
    for (int i = 0; i < ntabla; i++) {
        if (strcmp(tabla[i].nombre, id) == 0 && tabla[i].ambito == ambito_actual) {
            printf("Error: redeclaración de '%s'\n", id); // Variable ya existe en el ámbito
            return;
        }
    }
    tabla[ntabla++] = (Simbolo){strdup(id), 0, 0, ambito_actual}; // Registra variable
}

void agregar_funcion(char *id, int aridad) {
    for (int i = 0; i < ntabla; i++) {
        if (strcmp(tabla[i].nombre, id) == 0 && tabla[i].ambito == 0) {
            printf("Error: función '%s' ya declarada\n", id); // Función ya declarada
            return;
        }
    }
    tabla[ntabla++] = (Simbolo){strdup(id), 1, aridad, 0}; // Registra función
}

int buscar_variable(char *id) {
    for (int a = ambito_actual; a >= 0; a--) {
        for (int i = 0; i < ntabla; i++) {
            if (strcmp(tabla[i].nombre, id) == 0 && tabla[i].tipo == 0 && tabla[i].ambito == a)
                return 1; // Variable encontrada en el ámbito
        }
    }
    return 0; // No encontrada
}

int buscar_funcion(char *id) {
    for (int i = 0; i < ntabla; i++) {
        if (strcmp(tabla[i].nombre, id) == 0 && tabla[i].tipo == 1) return tabla[i].aridad;
    }
    return -1; // No encontrada
}
%}

%union {
    char *str;  // Para identificadores y cadenas
    int num;    // Para contar parámetros y argumentos
}

%token <str> ID
%token INT FUNC RETURN IGUAL
%token PARIZQ PARDER LLAVEIZQ LLAVEDER PUNTOYCOMA COMA

%%

programa:
    declaraciones
;

declaraciones:
    declaracion
    | declaraciones declaracion
;

declaracion:
    INT ID PUNTOYCOMA { agregar_variable($2); } // Declara variable
    | FUNC ID PARIZQ parametros PARDER bloque { agregar_funcion($2, $4); } // Declara función
;

parametros:
    /* vacío */ { $$ = 0; } // Sin parámetros
    | lista_param { $$ = $1; } // Con parámetros
;

lista_param:
    ID { agregar_variable($1); $$ = 1; } // Declara parámetro
    | lista_param COMA ID { agregar_variable($3); $$ = $1 + 1; }
;

bloque:
    LLAVEIZQ { entrar_ambito(); } instrucciones LLAVEDER { salir_ambito(); }
;

instrucciones:
    instruccion
    | instrucciones instruccion
;

instruccion:
    INT ID PUNTOYCOMA { agregar_variable($2); } // Declara variable
    | ID IGUAL ID PUNTOYCOMA {
        if (!buscar_variable($1) || !buscar_variable($3)) 
            printf("Error: identificador no declarado\n"); // Verifica existencia de variables
    }
    | ID PARIZQ argumentos PARDER PUNTOYCOMA {
        int esperados = buscar_funcion($1);
        if (esperados == -1) 
            printf("Error: función '%s' no declarada\n", $1);
        else if (esperados != $3) 
            printf("Error: función '%s' espera %d argumentos\n", $1, esperados);
    }
    | RETURN ID PUNTOYCOMA { 
        if (!buscar_variable($2)) 
            printf("Error: identificador no declarado\n"); // Verifica si el valor a retornar está declarado
    }
;

argumentos:
    /* vacío */ { $$ = 0; } // Sin argumentos
    | lista_args { $$ = $1; } // Con argumentos
;

lista_args:
    ID { 
        if (!buscar_variable($1)) 
            printf("Error: identificador no declarado\n"); // Verifica si el argumento está declarado
        $$ = 1; 
    }
    | lista_args COMA ID { 
        if (!buscar_variable($3)) 
            printf("Error: identificador no declarado\n"); // Verifica si el argumento está declarado
        $$ = $1 + 1; 
    }
;

%%

int main() { return yyparse(); }
