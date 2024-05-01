/* Bruno Grohs Vergara e João Pedro Ferreira Pereira
   Prof. Lucas M. Schnorr - Compiladores - Turma B - 2024/1 */
%{
#include "lexical_value.h"
#include "parser.tab.h"

int yylineno = 1; // No need for a separate line_number if yylineno is used directly

%}

%x BIG_COMMENT
%x LINE_COMMENT

%option yylineno
%option noyywrap

%union {
    LexicalValue *lexical_value;
}

%token <lexical_value> TK_PR_INT TK_PR_FLOAT TK_PR_BOOL TK_PR_IF TK_PR_ELSE TK_PR_WHILE TK_PR_RETURN
%token <lexical_value> TK_OC_LE TK_OC_GE TK_OC_EQ TK_OC_NE TK_OC_AND TK_OC_OR
%token <lexical_value> TK_LIT_FALSE TK_LIT_TRUE TK_IDENTIFICADOR TK_LIT_INT TK_LIT_FLOAT

%%

"int" {
    yylval.lexical_value = create_lexical_value(yylineno, LITERAL, yytext);
    return TK_PR_INT;
}
"float" {
    yylval.lexical_value = create_lexical_value(yylineno, LITERAL, yytext);
    return TK_PR_FLOAT;
}
"bool" {
    yylval.lexical_value = create_lexical_value(yylineno, LITERAL, yytext);
    return TK_PR_BOOL;
}
"if" {
    yylval.lexical_value = create_lexical_value(yylineno, LITERAL, yytext);
    return TK_PR_IF;
}
"else" {
    yylval.lexical_value = create_lexical_value(yylineno, LITERAL, yytext);
    return TK_PR_ELSE;
}
"while" {
    yylval.lexical_value = create_lexical_value(yylineno, LITERAL, yytext);
    return TK_PR_WHILE;
}
"return" {
    yylval.lexical_value = create_lexical_value(yylineno, LITERAL, yytext);
    return TK_PR_RETURN;
}

"<=" {
    yylval.lexical_value = create_lexical_value(yylineno, LITERAL, yytext);
    return TK_OC_LE;
}
">=" {
    yylval.lexical_value = create_lexical_value(yylineno, LITERAL, yytext);
    return TK_OC_GE;
}
"==" {
    yylval.lexical_value = create_lexical_value(yylineno, LITERAL, yytext);
    return TK_OC_EQ;
}
"!=" {
    yylval.lexical_value = create_lexical_value(yylineno, LITERAL, yytext);
    return TK_OC_NE;
}
"&" {
    yylval.lexical_value = create_lexical_value(yylineno, LITERAL, yytext);
    return TK_OC_AND;
}
"|" {
    yylval.lexical_value = create_lexical_value(yylineno, LITERAL, yytext);
    return TK_OC_OR;
}

[-!*/%+<>{}()=,;] {
    yylval.lexical_value = create_lexical_value(yylineno, LITERAL, yytext);
    return yytext[0];
}

"false" {
    yylval.lexical_value = create_lexical_value(yylineno, LITERAL, yytext);
    return TK_LIT_FALSE;
}
"true" {
    yylval.lexical_value = create_lexical_value(yylineno, LITERAL, yytext);
    return TK_LIT_TRUE;
}
[a-z_][0-9a-z_]* {
    yylval.lexical_value = create_lexical_value(yylineno, IDENTIFIER, yytext);
    return TK_IDENTIFICADOR;
}
[0-9]+ {
    yylval.lexical_value = create_lexical_value(yylineno, LITERAL, yytext);
    return TK_LIT_INT;
}
[0-9]*\.[0-9]+ {
    yylval.lexical_value = create_lexical_value(yylineno, LITERAL, yytext);
    return TK_LIT_FLOAT;
}

\n {++yylineno;}
[ \t]

"/*" {BEGIN(BIG_COMMENT);}
"//" {BEGIN(LINE_COMMENT);}

. {
    yylval.lexical_value = create_lexical_value(yylineno, LITERAL, yytext);
    return TK_ERRO;
}

<BIG_COMMENT>"*/" {BEGIN(INITIAL);}
<BIG_COMMENT>.

<LINE_COMMENT>.
<LINE_COMMENT>\n {BEGIN(INITIAL);}

%%

int get_line_number(void) {
    return yylineno;
}
