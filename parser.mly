%{
open Ast
%}

%token LPAREN RPAREN LBRACKET RBRACKET PLUS MINUS TIMES DIVIDE POS NEG ASSIGN TAB
%token EQ NEQ GT GEQ LT LEQ AND OR NOT
%token DEF LBRACE RBRACE NEWLINE RETURN IF ELIF ELSE WHILE FOR STRING INT FLOAT BOOL VOID
%token COLON COMMA
%token <int> ILIT
%token <float> FLIT
%token <bool> BLIT
%token <string> SLIT
%token <string> ID
%token EOF

%nonassoc NOELSE
%nonassoc ELSE
%right ASSIGN
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
   /* nothing */   { ([], []) }
 | global decls    { (($1 :: fst $2), snd $2) }
 | fdecl decls     { (fst $2, ($1 :: snd $2)) }
 | NEWLINE decls   { (fst $2, snd $2) }

fdecl:
  DEF typ ID LPAREN formals_opt RPAREN COLON stmt_list
  { 
    {
      rtyp = $2;
      fname = $3;
      formals = $5;
      body = $8;
    }
  }

formals_opt:
    /* nothing */ { [] }
  | formal_list   { $1 }

formal_list:
    typ ID                   { [($1, $2)] }
  | formal_list COMMA typ ID { ($3, $4) :: $1 }

typ:
    INT      { Int }
  | BOOL     { Bool }
  // | FLOAT { Float }
  | STRING   { String }
  | VOID     { Void }
  //TODO: add array type + implementation

stmt_block:
  | NEWLINE           /* nothing */  { [] }
  | NEWLINE TAB TAB stmt stmt_block  { ($4 :: $5) }
  
stmt_list:
  //  /* nothing */  { [] }
  | NEWLINE stmt_list            {$2}
  | NEWLINE                      { [] }
  | NEWLINE TAB stmt_list        {$3}
  | NEWLINE TAB stmt stmt_list   { $3 :: $4 }
  // | NEWLINE TAB stmt_list        { $3 }
  // | NEWLINE TAB stmt NEWLINE     { [$3] }
  // | stmt_blank stmt_list         { $2 }

// stmt_blank:
//   | NEWLINE TAB
  // | NEWLINE 


stmt:
    expr                                     { Expr $1 }
  | COLON stmt_block                         { Block $2 }
 // | LBRACE stmt_list RBRACE                  { Block $2 }
  | global                                   { DecAssn $1 }  //variable initialization and assignment as its own statement separate from exprs
  | IF LPAREN expr RPAREN stmt %prec NOELSE  { If($3, $5, Block([])) }
  | IF LPAREN expr RPAREN stmt ELSE stmt     { If($3, $5, $7) }
  | WHILE LPAREN expr RPAREN stmt            { While($3, $5) }
  | RETURN expr                              { Return($2) }
  // | typ LPAREN expr RPAREN NEWLINE { Cast($1, $3) }

//TODO: fix if stmts so that they work with more than just one line? def has to do with the NEWLINES
// if_stmt:
//     IF LPAREN expr RPAREN stmt %prec NOELSE { If($3, $5, Block([])) }
//   | IF LPAREN expr RPAREN stmt ELSE stmt { If($3, $5, $7) }
// TODO: add elif stmts
// elif_stmt:
//     ELIF expr LBRACE NEWLINE stmt_list RBRACE { [($2, $5)] }
//   | elif ELIF expr LBRACE NEWLINE stmt_list RBRACE { ($3, $6) :: $1 }
  

global:
    typ ID ASSIGN expr { (($1, $2), $4) } //int x = 3, only expression we want to use globally and locally

expr:
    ILIT                       { IntLit($1) }
  // | FLIT             { FloatLit($1) }
  | SLIT                       { StringLit($1) }
  | BLIT                       { BoolLit($1) }
  | ID                         { Id($1) }
  | ID ASSIGN expr             { Assign($1, $3) }
  | ID LPAREN args_opt RPAREN  { Call($1, $3) }
  | typ LPAREN expr RPAREN     { Cast($1, $3) }
  // | LPAREN expr RPAREN { $2 }
  | expr PLUS expr             { Binop ($1, Add, $3) }
  | expr MINUS expr            { Binop ($1, Sub, $3) }
  | expr TIMES expr            { Binop ($1, Mul, $3) }
  | expr DIVIDE expr           { Binop ($1, Div, $3) }
  | expr EQ expr               { Binop ($1, Equal, $3) }
  | expr NEQ expr              { Binop ($1, Neq, $3) }
  | expr GT expr               { Binop ($1, Greater, $3) }
  | expr GEQ expr              { Binop ($1, Geq, $3) }
  | expr LT expr               { Binop ($1, Less, $3) }
  | expr LEQ expr              { Binop ($1, Leq, $3) }
  | expr AND expr              { Binop ($1, And, $3) }
  | expr OR expr               { Binop ($1, Or, $3) }
  | MINUS expr %prec NEG       { Unop(Neg, $2) }
  | PLUS expr %prec POS        { Unop(Pos, $2) }
  | arr                        { $1 }

arr:
  LBRACKET arr_elems RBRACKET { Array($2) }

arr_elems:
    {[]}
  | expr { [$1] }
  | expr COMMA arr_elems { $1 :: $3 }

args_opt:
    /* nothing */ { [] }
  | args          { $1 }

args:
    expr            { [$1] }
  | args COMMA expr { $3 :: $1 }
