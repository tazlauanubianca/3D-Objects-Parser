#Tazlauanu Bianca 334CC
scanner:lex.yy.c
	gcc lex.yy.c -o scanner

lex.yy.c:parser.l
	flex parser.l

run:scanner
	./scanner

clean:
	rm scanner lex.yy.c
