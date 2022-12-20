type token =
  | SEMC
  | DEF
  | NEWLINE
  | LPAREN
  | RPAREN
  | LBRACE
  | RBRACE
  | LBRACKET
  | RBRACKET
  | PLUS
  | MINUS
  | TIMES
  | DIVIDE
  | NEG
  | ASSIGN
  | MODULO
  | EQ
  | NEQ
  | GT
  | GEQ
  | LT
  | LEQ
  | AND
  | OR
  | NOT
  | IF
  | ELIF
  | ELSE
  | WHILE
  | FOR
  | STRING
  | INT
  | FLOAT
  | BOOL
  | VOID
  | RETURN
  | ARRAY
  | RANGE
  | IN
  | COLON
  | COMMA
  | ILIT of (int)
  | FLIT of (float)
  | BLIT of (bool)
  | SLIT of (string)
  | ID of (string)
  | EOF
  | NoOp

val program :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Ast.program
