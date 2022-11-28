%{
open Ast
%}

%token LPAREN RPAREN PLUS ASSIGN
%token NEWLINE TAB
%token STRING INT FLOAT BOOL
%token FUNCT COLON COMMA
%token <int> ILIT
%token <float> FLIT
%token <bool> BLIT

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
   /* nothing */ { ([], []) }
 | stmt NEWLINE decls   { (($1 :: fst $3), snd $3) }
 | fdecl decls   { (fst $2, ($1 :: snd $2)) }
 | NEWLINE decls { (fst $2, snd $2) }
 | stmt decls { (($1 :: fst $2), snd $2) }

/* int x */

typ:
  STRING  { String }
| INT { Int }
| FLOAT { Float }
| BOOL { Bool }

decls_inside:
   { [] }
  | stmt NEWLINE decls_inside { $1::$3 }
  | NEWLINE decls_inside { $2 }

/* formals_opt */
formals_opt:
    /*nothing*/   { [] }
  | formals_list { $1 }

formals_list:
    parameter_decl                    { [$1] }
  | parameter_decl COMMA formals_list { $1::$3 }

parameter_decl:
  typ ID { ($1, $2) }

/* fdecl */
fdecl:
  typ FUNCT ID LPAREN formals_opt RPAREN COLON NEWLINE decls_inside
  {
    {
      rtyp=$1;
      fname=$3;
      formals=$5;
      body=$9;
    }
  }

stmt:
    expr                      { Expr($1)  }
  | TAB decls_inside          { Block($2) }

expr:
    ID                        { Id($1)                 }
  | ID ASSIGN expr            { Assign($1, $3)         }
  | SLIT                      { StringLit($1)          }
  | SLIT PLUS SLIT            { Binop(StringLit($1), Concat, StringLit($3))         }
  | LPAREN expr RPAREN        { $2 }
  | ID LPAREN args_opt RPAREN { Call($1, $3) }
  | ILIT                      { IntLit($1) }
  | FLIT                      { FloatLit($1) }
  | BLIT                      { BoolLit($1) }
  | typ ID ASSIGN expr { DecAssn($1, $2, $4) }


/* args_opt*/
args_opt:
   /*nothing*/ { [] }
  | args       { $1 }

args:
    expr            { [$1] }
  | expr COMMA args { $1::$3 }
