/* Bruno Grohs Vergara e João Pedro Ferreira Pereira
   Prof. Lucas M. Schnorr - Compiladores - Turma B - 2024/1 */
%{
#include <stdio.h>
int yylex(void);
void yyerror (char const *mensagem);
extern int get_line_number(void);
extern void *arvore;
%}

%token TK_PR_INT
%token TK_PR_FLOAT
%token TK_PR_BOOL
%token TK_PR_IF
%token TK_PR_ELSE
%token TK_PR_WHILE
%token TK_PR_RETURN
%token TK_OC_LE
%token TK_OC_GE
%token TK_OC_EQ
%token TK_OC_NE
%token TK_OC_AND
%token TK_OC_OR
%token TK_IDENTIFICADOR
%token TK_LIT_INT
%token TK_LIT_FLOAT
%token TK_LIT_FALSE
%token TK_LIT_TRUE
%token TK_ERRO


%type<Node> program 
%type<Node> elements_list 
%type<Node> element 
%type<Node> global_declaration
%type<Node> TK_IDENTIFICADOR_list
%type<Node> function_definition
%type<Node> function_header 
%type<Node> parameters_list 
%type<Node> parameter 
%type<Node> function_body 
%type<Node> command_block
%type<Node> command
%type<Node> variable_declaration
%type<Node> attribution
%type<Node> function_call
%type<Node> arguments_list
%type<Node> argument
%type<Node> return_operation 
%type<Node> control_flow_construction
%type<Node> expression
%type<Node> expression2
%type<Node> expression3
%type<Node> expression4
%type<Node> expression5
%type<Node> expression6
%type<Node> expression7
%type<Node> expression8
%type<Node> operand
%type<Node> type
%type<Node> TK_IDENTIFICADOR
%type<Node> literal


%define parse.error verbose

%%

    program:
    {
        $$ = NULL; 
        arvore = NULL;
    }

    program: elements_list
    {
        $$ = 1;
        arvore = $$;
    }

    elements_list: elements_list element 
    {
        $$ = 2;
        addChild($$, $1)
    }

    element: global_declaration
    {
        $$ = $1;
    }

    element: function_definition
    {
        $$ = $1;
    }

    global_declaration: type TK_IDENTIFICADOR_list ','
    {
        $$ = $1;
        addChild($$, $2)
        freeLexicalValue($3)
    }

    TK_IDENTIFICADOR_list: TK_IDENTIFICADOR 
    {
        $$ = $1;
    }

    TK_IDENTIFICADOR_list: TK_IDENTIFICADOR_list ';' TK_IDENTIFICADOR
    {
        $$ = $3;
        freeLexicalValue($2)
        addChild($$, $1)
    }

    function_definition: function_header function_body
    {
        $$ = $1;
        addChild($$, $2)
    }


    function_header: '(' parameters_list ')' TK_OC_OR type '/' TK_IDENTIFICADOR
    {
        $$ = createNode($7);
        freeLexicalValue($1);
        addChild($$, $2);
        freeLexicalValue($3);
        freeLexicalValue($6);
    }

    
    parameters_list: parameters_list ';' type TK_IDENTIFICADOR
    {
        $$ = NULL;
        freeLexicalValue($2);
        freeLexicalValue($4);
    }

    parameters_list: type TK_IDENTIFICADOR
    {
        $$ = NULL; 
        freeLexicalValue($2);
    }

    function_body: '{' command_block '}'
    {
        freeLexicalValue($1);
        $$ = $2;
        freeLexicalValue($3);
    }

    function_body: '{' '}'
    {
        freeLexicalValue($1);
        freeLexicalValue($2);
    }

    command_block: command_block command ','
    {
        addChild($1);
        $$ = $1;
        freeLexicalValue($2);
    }

    command_block: command ','
    {
        $$ = $1;
        freeLexicalValue($2)
    }

    command: variable_declaration
    {
        $$ = $1;
    }

    command: attribution
    {
        $$ = $1;
    }

    command: control_flow_construction
    {
        $$ = $1;
    }

    command: return_operation
    {
        $$ = $1;
    }

    command: '{' command_block '}'
    {
        freeLexicalValue($1);
        $$ = $1;
        freeLexicalValue($2);
    }


    variable_declaration: type TK_IDENTIFICADOR_list
    {
        $$ = $2;
    }

    attribution: TK_IDENTIFICADOR '=' expression
    {
        $$ = createNode($2); 
        addChild($$, createNode($1));
        addChild($$, $3);
    }

    function_call: TK_IDENTIFICADOR '('arguments_list')'
    {
        $$ = createNodeToFunctionCall($1);
        freeLexicalValue($2);
        addChild($$, $3);
        freeLexicalValue($4);
    }

    arguments_list: arguments_list ';' argument
    {
        addChild($1);
        freeLexicalValue($2);
        $$ = $3;
    }

    arguments_list: argument
    {
        $$ = 1;
    }

    argument: expression
    {
        $$ = 1;
    }

    return_operation: TK_PR_RETURN expression
    {
        $$ = createNode($1);
        addChild($$, $2);
    }

    control_flow_construction: TK_PR_IF '(' expression ')' '{' command_block '}'
    {
        $$ = createNode($1);
        freeLexicalValue($2);
        addChild($$, $3);
        freeLexicalValue($4);
        freeLexicalValue($5);
        addChild($$, $6);
        freeLexicalValue($7);
    }

    control_flow_construction: TK_PR_IF '(' expression ')' '{' command_block '}' TK_PR_ELSE '{' command_block '}'
    {
        $$ = createNode($1);
        freeLexicalValue($2);
        addChild($$, $3);
        freeLexicalValue($4);
        freeLexicalValue($5);
        addChild($$, $6);
        freeLexicalValue($7);
        freeLexicalValue($8);
        freeLexicalValue($9);
        addChild($$, $10);
        freeLexicalValue($11);
    }


    control_flow_construction: TK_PR_WHILE '(' expression ')' '{' command_block '}'
    {
        $$ = createNode($1);
        freeLexicalValue($2);
        addChild($$, $3);
        freeLexicalValue($4);
        freeLexicalValue($5);
        addChild($$, $6);
        freeLexicalValue($7);
    }


    expression: expression TK_OC_OR expression2
    {
        $$ = createNode($2)
        addChild($$, $1)
        addChild($$, $3)
    }


    expression: expression2
    {
        $$ = $1
    }

    
    expression2: expression2 TK_OC_AND expression3
    {
        $$ = createNode($2)
        addChild($$, $1)
        addChild($$, $3)
    }

    expression2: expression3
    {
        $$ = $1
    }

    expression3: expression3 TK_OC_EQ expression4
    {
        $$ = createNode($2)
        addChild($$, $1)
        addChild($$, $3)
    }

    expression3: expression3 TK_OC_NE expression4
    {
        $$ = createNode($2)
        addChild($$, $1)
        addChild($$, $3)
    }

    expression3: expression4 
    {
        $$ = $1
    }
    expression5: expression5 '+' expression6
    {
        $$ = createNode($2)
        addChild($$, $1)
        addChild($$, $3)
    }

    expression5: expression5 '-' expression6
    {
        $$ = createNode($2)
        addChild($$, $1)
        addChild($$, $3)
    }
    expression5: expression6 
    {
        $$ = $1
    }
    expression6: expression6 '*' expression7
    {
        $$ = createNode($2)
        addChild($$, $1)
        addChild($$, $3)
    }
    expression6: expression6 '/' expression7
    {
        $$ = createNode($2)
        addChild($$, $1)
        addChild($$, $3)
    }
    expression6: expression6 '%' expression7
    {
        $$ = createNode($2)
        addChild($$, $1)
        addChild($$, $3)
    }
    expression6: expression7
    {
        $$ = $1
    }
    expression7: '!' expression8
    {
        $$ = createNode($2)
        addChild($$, $1)
        addChild($$, $3)
    }
    expression7: '-' expression8
    {
        $$ = createNode($1)
        addChild($$, $2)
    }
    expression7: expression8
    {
        $$ = $1
    }
    expression8: '(' expression ')'
    {
        freeLexicalValue($1);
        $$ = $2;
        freeLexicalValue($3);
    }

    expression8: operand
    {
        $$ = $1;
    }

    operand: TK_IDENTIFICADOR
    {
        $$ = createNode($1);
    }

    operand: literal
    {
        $$ = 1;
    }

    operand: function_call
    {
        $$ = 1;
    }

    type: TK_PR_INT
    {
        $$ = NULL; 
        freeLexicalValue($1);
    }

    type: TK_PR_FLOAT
    {
        $$ = NULL; 
        freeLexicalValue($1);
    }
    type: TK_PR_BOOL
    {
        $$ = NULL; 
        freeLexicalValue($1);
    }
    literal: TK_LIT_INT
    {
        $$ = createNode($1);
    }

    literal: TK_LIT_FLOAT
    {
        $$ = createNode($1);
    }
    literal: TK_LIT_TRUE
    {
        $$ = createNode($1);
    }
    literal: TK_LIT_FALSE
    {
        $$ = createNode($1);
    }

%%

void yyerror (char const *mensagem)
{
    printf("%s at line %d!", mensagem, get_line_number());
}
