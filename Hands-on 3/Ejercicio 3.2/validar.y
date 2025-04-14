%{
#include <stdio.h>
#include <stdlib.h>

extern int yylex(void);
extern int yyerror(const char *s);
%}

%token BOOLEAN
%left OR
%left AND
%right NOT

%%
input:
    expr '\n'        { printf("Expresión válida\n"); }
  | error '\n'       { printf("Expresión inválida\n"); yyerrok; }
;

expr:
      expr AND term
    | expr OR term
    | term
;

term:
      NOT factor
    | factor
;

factor:
      '(' expr ')'
    | BOOLEAN
;

%%

int yyerror(const char *s) {
    return 0;
}

int main(void) {
    printf("Introduce una expresión lógica:\n");

    while (1) {
        printf(">> ");
        if (yyparse() != 0) break;
    }

    return 0;
}
