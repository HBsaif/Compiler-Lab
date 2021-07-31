%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	void yyerror();

	extern int lineno;
	extern int yylex();
%}


%token INT IF ELSE ELIF FOR WHILE CONTINUE BREAK PRINT DOUBLE CHAR
%token ADDOP SUBOP MULOP DIVOP EQUOP LT GT
%token LPAREN RPAREN LBRACE RBRACE SEMI ASSIGN
%token INCR DECR LTEQL GTEQL
%token ID
%token ICONST
%token FCONST
%token CCONST


%left ADDOP SUBOP
%left MULOP DIVOP
%left LT GT
%left EQUOP
%right ASSIGN

%start code

%%
code: statements;

statements: statements statement | ;

statement:    declaration
            | function
            | inc_dec
            | if_statement
            | ID ASSIGN exp SEMI
            | for_statement
            ;

function: type ID LPAREN parameter RPAREN tail ;

parameter: constant | ;

declaration: type ID SEMI
            |type ID ASSIGN exp SEMI
            ;

type: INT 
    | DOUBLE
    | CHAR
    ;

exp: ID
    |constant
    |exp ADDOP exp
    |exp SUBOP exp
    |exp MULOP exp
    |exp DIVOP exp
    |exp EQUOP exp
    |exp GTEQL exp
    |exp LTEQL exp
    |exp INCR
    |exp DECR
    |exp GT exp
    |exp LT exp
    |LPAREN exp RPAREN
    ;

inc_dec: ID INCR SEMI
        |ID DECR SEMI
        ;

constant: ICONST
        | FCONST
        | CCONST
        ;

if_statement: IF LPAREN exp RPAREN tail elif_statement;

elif_statement: ELIF LPAREN exp RPAREN tail else_statement | ;

else_statement: ELSE tail | ;

for_statement: FOR LPAREN loop RPAREN tail;

loop: loop_init loop_condition loop_incr;
loop_init: ID ASSIGN constant SEMI | ;
loop_condition: exp SEMI ;
loop_incr: exp SEMI | ;

tail: LBRACE statements RBRACE;

%%

void yyerror ()
{
	printf("Syntax error at line %d\n", lineno);
	exit(1);
}

int main (int argc, char *argv[])
{
	yyparse();
	printf("Parsing finished!\n");	
	return 0;
}