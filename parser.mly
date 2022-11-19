%{
open Ast
%}

%token NEWLINE LPAREN RPAREN PLUS ASSIGN TAB
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
   /* nothing */ { ([], [])                 }
 | vdecl NEWLINE decls   { (($1 :: fst $3), snd $3) }
 | fdecl decls   { (fst $2, ($1 :: snd $2)) }
 | NEWLINE decls { (fst $2, snd $2) }

/* int x */
vdecl:
  typ ID ASSIGN expr { ($1, $2, $4) }

typ:
  STRING  { String }
| INT { Int }
| FLOAT { Float }
| BOOL { Bool }

/* fdecl */
fdecl:
  typ FUNCT ID LPAREN formals_opt RPAREN COLON NEWLINE decls_inside
  {
    {
      rtyp=$1;
      fname=$3;
      formals=$5;
      locals=fst $9;
      body=snd $9
    }
  }

/* formals_opt */
formals_opt:
    /*nothing*/   { [] }
  | formals_list { $1 }

formals_list:
    parameter_decl                    { [$1] }
  | parameter_decl COMMA formals_list { $1::$3 }

parameter_decl:
  typ ID { ($1, $2) }

decls_inside:
    /* nothing */                  { ([], [])                 }
  | TAB vdecl NEWLINE decls_inside { ( ($2 :: fst $4), snd $4) }
  | TAB stmt NEWLINE decls_inside  { ( fst $4, ($2 :: snd $4)) }
  | NEWLINE decls_inside { (fst $2, snd $2) }
  | TAB NEWLINE decls_inside { (fst $3, snd $3) }

stmt:
  |  expr                                { Expr($1)  }

expr:
    ID                        { Id($1)                 }
  | ID ASSIGN expr            { Assign($1, $3)         }
  | SLIT                      { StringLit($1)          }
  | SLIT PLUS SLIT            { Binop(StringLit($1), Concat, StringLit($1))         }
  | LPAREN expr RPAREN        { $2 }
  | ID LPAREN args_opt RPAREN { Call($1, $3) }
  | ILIT                      { IntLit($1) }
  | FLIT                      { FloatLit($1) }
  | BLIT                      { BoolLit($1) }

/* args_opt*/
args_opt:
   /*nothing*/ { [] }
  | args       { $1 }

args:
    expr            { [$1] }
  | expr COMMA args { $1::$3 }
