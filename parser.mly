%{
open Ast
%}

%token LBRACE RBRACE NEWLINE
%token LPAREN RPAREN PLUS ASSIGN
%token STRING INT FLOAT BOOL
%token FUNCT COLON COMMA
%token <int> ILIT
%token <float> FLIT
%token <bool> BLIT

%token <string> SLIT
%token <string> ID
%token EOF
%token NoOp

%right ASSIGN
%left PLUS

%start program
%type <Ast.program> program

%%

program:
  decls EOF { $1 }

decls:
   /* nothing */ { ([] , []) }  
  // global variables outside functions
 | global decls { (($1 :: fst $2), snd $2) }
  //functions
 | fdecl decls { fst $2, ($1 :: snd $2) }
 | NEWLINE decls { (fst $2, snd $2) }

fdecl:
  typ FUNCT ID LPAREN formals_opt RPAREN LBRACE NEWLINE stmt_list RBRACE
  {
    {
      rtyp = $1;
      fname = $3;
      formals = $5;
      body = $9;
    }
  }

formals_opt:
    /* nothing */ { [] }
  | formal_list   { $1 }

formal_list:
    typ ID                   { [($1, $2)] }
  | formal_list COMMA typ ID { ($3, $4) :: $1 }

typ:
    INT { Int }
  | BOOL { Bool }
  | FLOAT { Float }
  | STRING { String }

stmt_list:
    /* nothing */  { [] }
  | stmt stmt_list { $1 :: $2 }

stmt:
  expr NEWLINE { Expr $1 }
  | LBRACE stmt_list RBRACE { Block $2 }
  | global { DecAssn $1 }  //variable initialization and assignment as it's own statement separate from exprs

global: typ ID ASSIGN expr NEWLINE { (($1, $2), $4) } //int x = 3, only expression we want to use globally and locally

expr:
    ILIT             { IntLit($1) }
  | FLIT             { FloatLit($1) }
  | SLIT             { StringLit($1) }
  | SLIT PLUS SLIT   { Binop(StringLit($1), Concat, StringLit($3)) } //need to change this, doesn't work
  | BLIT             { BoolLit($1) }
  | ID               { Id($1) }
  | ID ASSIGN expr   { Assign($1, $3) }
  | ID LPAREN args_opt RPAREN { Call($1, $3) }
  | LPAREN expr RPAREN { $2 }
  // | typ ID ASSIGN expr { DecAssn($1, $2, $4) }

args_opt:
    /* nothing */ { [] }
  | args { $1 }

args:
    expr { [$1] }
  | args COMMA expr { $3 :: $1 }
