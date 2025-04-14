%{
#include <stdio.h>
#include <stdlib.h>

extern int yylex(void);   // Declaración de yylex()
extern int yyerror(const char *s);  // Declaración de yyerror()
%}

%token NUMBER
%left '+' '-'
%left '*' '/'
%right UMINUS

%%
input:
    expr '\n'      { printf("Expresión válida\n"); }
  | error '\n'     { yyerror("Expresión inválida"); yyerrok; }
;

expr:
    expr '+' term
  | expr '-' term
  | term
;

term:
    term '*' factor
  | term '/' factor
  | factor
;

factor:
    '(' expr ')'
  | NUMBER
;

%%
int yyerror(const char *s) {
    fprintf(stderr, "%s\n", s);
    return 0;
}

int main(void) {
    printf("Introduce una expresión aritmética:\n");
    yyparse();
    return 0;
}
