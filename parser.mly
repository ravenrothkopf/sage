/* Ocamlyacc parser for MicroC */

%{
open Ast
%}

%token NEWLINE LPAREN RPAREN PLUS ASSIGN
%token STRING
%token FUNCT COLON COMMA

%token <string> SLIT
%token <string> ID
%token EOF
%token NoOp

%start program
%type <Ast.program> program

%right ASSIGN
%left PLUS 

%%

/* add function declarations*/
program:
  decls EOF { $1}

decls:
   { ([], []) }
 | fdecl decls { (fst $2, ($1 :: snd $2)) }

/* int x */
vdecl:
  typ ID { ($1, $2) }

typ:
  STRING  { String }

/* fdecl */
fdecl:
  FUNCT vdecl LPAREN formals_opt RPAREN COLON stmt_list NoOp/*Indentation?*/
  {
    {
      rtyp=fst $2;
      fname=snd $2;
      formals=$4;
      body=$7;
    }
  }

/* formals_opt */
formals_opt:
  /*nothing*/ { [] }
  | formals_list { $1 }

formals_list:
  vdecl { [$1] }
  | vdecl COMMA formals_list { $1::$3 }

stmt_list:
  /* nothing */ { [] }
  | stmt stmt_list  { $1::$2 }

stmt:
   NEWLINE                                     { NoOp }
  |  expr NEWLINE                               { Expr $1  }
  /*| LBRACE stmt_list RBRACE                    { Block $2 } Indentation?*/

expr:
   SLIT              { StringLit($1)          }
  | ID               { Id($1)                 }
  | SLIT PLUS SLIT   { Concat($1, $3)         }
  | ID ASSIGN expr   { Assign($1, $3)         }
  | LPAREN expr RPAREN { $2 }
  /* call */
  | ID LPAREN args_opt RPAREN { Call ($1, $3)  }


/* args_opt*/
args_opt:
  /*nothing*/ { [] }
  | args { $1 }

args:
  expr  { [$1] }
  | expr COMMA args { $1::$3 }
