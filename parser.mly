%{
open Ast
%}

%token LBRACE RBRACE LBRACKET RBRACKET NEWLINE RETURN
%token LPAREN RPAREN PLUS ASSIGN MINUS TIMES DIVIDE POS NEG
%token STRING INT FLOAT BOOL VOID
%token IF ELIF ELSE EQ NEQ GT GEQ LT LEQ WHILE FOR
%token AND OR NOT
%token DEF COLON COMMA
%token <int> ILIT
%token <float> FLIT
%token <bool> BLIT

%token <string> SLIT
%token <string> ID
%token EOF
%token NoOp

%nonassoc NOELSE
%nonassoc ELSE
%right ASSIGN PLUSEQ MINEQ TIMEQ DIVEQ
%left OR
%left AND
%left EQ NEQ
%left LT GT LEQ GEQ
%left PLUS MINUS
%left TIMES DIVIDE
%right NOT NEG POS

%start program
%type <Ast.program> program

%%

program:
  decls EOF { $1 }

decls:
   /* nothing */ { ([], []) }
  // global variables outside functions
 | global decls { (($1 :: fst $2), snd $2) }
  //functions
 | fdecl decls { (fst $2, ($1 :: snd $2)) }
 | NEWLINE decls { (fst $2, snd $2) }

fdecl:
  DEF typ ID LPAREN formals_opt RPAREN LBRACE NEWLINE stmt_list RBRACE
  {
    {
      rtyp = $2;
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
  // | FLOAT { Float }
  | STRING { String }
  | VOID { Void }
  //TODO: add array type + implementation

stmt:
    expr NEWLINE { Expr $1 }
  | LBRACE stmt_list RBRACE { Block $2 }
  | global { DecAssn $1 }  //variable initialization and assignment as its own statement separate from exprs
  | if_stmt { $1 }
  | NEWLINE stmt { $2 }


stmt_list:
    /* nothing */  { [] }
  | stmt stmt_list { $1 :: $2 }
 
//TODO: fix if stmts so that they work with more than just one line? def has to do with the NEWLINES
if_stmt:
    IF LPAREN expr RPAREN stmt %prec NOELSE { If($3, $5, Block([])) }
  | IF LPAREN expr RPAREN stmt ELSE stmt { If($3, $5, $7) }
  | WHILE LPAREN expr RPAREN stmt { While($3, $5) }
  | RETURN expr { Return($2) }
// TODO: add elif stmts
// elif_stmt:
//     ELIF expr LBRACE NEWLINE stmt_list RBRACE { [($2, $5)] }
//   | elif ELIF expr LBRACE NEWLINE stmt_list RBRACE { ($3, $6) :: $1 }

global:
    typ ID ASSIGN expr NEWLINE { (($1, $2), $4) } //int x = 3, only expression we want to use globally and locally

expr:
    ILIT             { IntLit($1) }
  // | FLIT             { FloatLit($1) }
  | SLIT             { StringLit($1) }
  | BLIT             { BoolLit($1) }
  | ID               { Id($1) }
  | ID ASSIGN expr   { Assign($1, $3) }
  | ID PLUSEQ expr { Assign([$1], Binop ($1, Add, $3))}
  | ID MINEQ  expr { Assign([$1], Binop ($1, Sub, $3))}
  | ID MULTEQ expr { Assign([$1], Binop ($1, Mult, $3))}
  | ID DIVEQ expr { Assign([$1], Binop ($1, Div, $3))}
  | ID LPAREN args_opt RPAREN { Call($1, $3) }
  | LPAREN expr RPAREN { $2 }
  | expr PLUS expr { Binop ($1, Add, $3) }
  | expr MINUS expr { Binop ($1, Sub, $3) }
  | expr TIMES expr { Binop ($1, Mul, $3) }
  | expr DIVIDE expr { Binop ($1, Div, $3) }
  | expr EQ expr { Binop ($1, Equal, $3) }
  | expr NEQ expr { Binop ($1, Neq, $3) }
  | expr GT expr { Binop ($1, Greater, $3) }
  | expr GEQ expr { Binop ($1, Geq, $3) }
  | expr LT expr { Binop ($1, Less, $3) }
  | expr LEQ expr { Binop ($1, Leq, $3) }
  | expr AND expr { Binop ($1, And, $3) }
  | expr OR expr { Binop ($1, Or, $3) }
  | MINUS expr %prec NEG { Unop(Neg, $2) }
  | PLUS expr %prec POS { Unop(Pos, $2) }
  | arr { $1 }

arr:
  LBRACKET arr_elems RBRACKET { Array($2) }

arr_elems:
    {[]}
  | expr { [$1] }
  | expr COMMA arr_elems { $1 :: $3 }

args_opt:
    /* nothing */ { [] }
  | args { $1 }

args:
    expr { [$1] }
  | args COMMA expr { $3 :: $1 }
