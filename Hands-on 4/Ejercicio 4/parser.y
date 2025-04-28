%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Declaración de la función léxica
int yylex(void);
int yyerror(char *s) { printf("Error: %s\n", s); return 0; }

// Definición de las estructuras de ámbito
#define MAX_SCOPE 10      // Número máximo de niveles de ámbito
#define MAX_ID 100        // Número máximo de identificadores por ámbito
char *ambitos[MAX_SCOPE][MAX_ID];  // Tabla de identificación por ámbito
int niveles[MAX_SCOPE];           // Número de identificadores en cada nivel
int tope = 0;                     // Índice para el nivel actual del ámbito

// Funciones para manejar los ámbitos
void entrar_ambito() {
    tope++;            // Entra a un nuevo nivel de ámbito
    niveles[tope] = 0; // Inicializa el número de variables en el nuevo ámbito
}

void salir_ambito() {
    tope--; // Sale del ámbito actual
}

void agregar_local(char *id) {
    ambitos[tope][niveles[tope]++] = strdup(id); // Agrega un nuevo identificador al ámbito
}

int buscar_local(char *id) {
    // Busca un identificador en los ámbitos desde el más interno hasta el más externo
    for (int i = tope; i >= 0; i--) {
        for (int j = 0; j < niveles[i]; j++) {
            if (strcmp(ambitos[i][j], id) == 0) {
                return 1;  // Identificador encontrado en el ámbito
            }
        }
    }
    return 0;  // No encontrado
}
%}

%union { char *str; }  // Asociación de tipo para identificadores

%token <str> ID        // Token para identificadores
%token INT             // Token para la palabra clave 'int'
%token LLAVEIZQ LLAVEDER PUNTOYCOMA // Tokens para llaves y punto y coma

%%

programa:
    bloque
;

bloque:
    LLAVEIZQ { entrar_ambito(); } instrucciones LLAVEDER { salir_ambito(); }
;

instrucciones:
    instruccion
  | instrucciones instruccion
;

instruccion:
    INT ID PUNTOYCOMA { agregar_local($2); }   // Declaración de variable
  | ID PUNTOYCOMA { 
        if (!buscar_local($1))  // Verificación de que la variable ha sido declarada
            printf("Error semántico: '%s' no está declarado\n", $1);
    }
  | bloque  // Bloque anidado
;

%%

int main() {
    return yyparse();  // Inicia el parseo
}
