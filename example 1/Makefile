input = input.txt
output = output.txt

main: lexer.l parser.y
	yacc -d parser.y
	lex lexer.l
	gcc parser.tab.c lex.yy.c
	a <$(input)> $(output)