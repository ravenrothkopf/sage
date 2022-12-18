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
%token NoOp




%right TAB
%left NEWLINE
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
   /* nothing */ { ([], []) }
  // global variables outside functions
 | global decls { print_endline "GLOBAL";(($1 :: fst $2), snd $2) }
  //functions
 | fdecl decls { (fst $2, ($1 :: snd $2)) }
 | NEWLINE decls { (fst $2, snd $2) }

fdecl:
  DEF typ ID LPAREN formals_opt RPAREN COLON stmt_list NEWLINE
  {
    print_endline "AEE";
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
    INT { Int }
  | BOOL { Bool }
  // | FLOAT { Float }
  | STRING { String }
  | VOID { Void }
  //TODO: add array type + implementation

stmt_list:
    /* nothing */  { [] }
  // | TAB stmt stmt_list { $2 :: $3 }
  // | stmt stmt_list { $1 :: $2 }
  | NEWLINE TAB stmt stmt_list { print_endline "List"; $3 :: $4 }
  | NEWLINE TAB stmt NEWLINE{ print_endline "oneline"; [$3] }

stmt:
    expr { print_endline "exr";Expr $1 }
  | LBRACE stmt_list RBRACE  { print_endline"A" ;Block $2 }
  | global { print_endline ("stmt global"); DecAssn $1 }  //variable initialization and assignment as its own statement separate from exprs
  | IF LPAREN expr RPAREN stmt %prec NOELSE { print_endline"B" ;If($3, $5, Block([])) }
  | IF LPAREN expr RPAREN stmt ELSE stmt { print_endline"C" ;If($3, $5, $7) }
  | WHILE LPAREN expr RPAREN stmt {print_endline"D" ; While($3, $5) }
  | RETURN expr { Return($2) }
  // | stmt {print_endline"HERE" ;$1 }


 
//TODO: fix if stmts so that they work with more than just one line? def has to do with the NEWLINES
// if_stmt:
//     IF LPAREN expr RPAREN stmt %prec NOELSE { If($3, $5, Block([])) }
//   | IF LPAREN expr RPAREN stmt ELSE stmt { If($3, $5, $7) }
// TODO: add elif stmts
// elif_stmt:
//     ELIF expr LBRACE NEWLINE stmt_list RBRACE { [($2, $5)] }
//   | elif ELIF expr LBRACE NEWLINE stmt_list RBRACE { ($3, $6) :: $1 }

global:
    typ ID ASSIGN expr { print_endline ("GLOBEE"^$2); (($1, $2), $4) } //int x = 3, only expression we want to use globally and locally

expr:
    ILIT             { print_endline"ilit" ;IntLit($1) }
  // | FLIT             { FloatLit($1) }
  | SLIT             { print_endline"slit" ;StringLit($1) }
  | BLIT             { print_endline"blit" ;BoolLit($1) }
  | ID               { print_endline"id" ;Id($1) }
  | ID ASSIGN expr   { print_endline"id assign" ;Assign($1, $3) }
  | ID LPAREN args_opt RPAREN { print_endline "CALL"; Call($1, $3) }
  | LPAREN expr RPAREN { print_endline "()";$2 }
  | expr PLUS expr { print_endline"+" ;Binop ($1, Add, $3) }
  | expr MINUS expr { Binop ($1, Sub, $3) }
  | expr TIMES expr { Binop ($1, Mul, $3) }
  | expr DIVIDE expr { Binop ($1, Div, $3) }
  | expr EQ expr { print_endline"K" ;Binop ($1, Equal, $3) }
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
    /* nothing */ { print_endline "emp";[] }
  | args { print_endline "ARS"; $1 }

args:
    expr { print_endline "arg expr";[$1] }
  | args COMMA expr { $3 :: $1 }
