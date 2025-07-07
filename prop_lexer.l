%{
#include "prop_parser.tab.h"
%}

%%

[ \t\n]           ; 忽略空白字符
"TRUE"            { return TRUE; }
"FALSE"           { return FALSE; }
"¬"               { return NOT; }
"∧"               { return AND; }
"∨"               { return OR; }
"→"               { return IMPLIES; }
"↔"               { return IFF; }
"("               { return LPAREN; }
")"               { return RPAREN; }
[a-zA-Z][a-zA-Z0-9]* { yylval.str = strdup(yytext); return ID; }
.                 { fprintf(stderr, "非法字符: %c\n", yytext[0]); exit(1); }

%%

int yywrap() {
    return 1;
}