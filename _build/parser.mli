type token =
  | LPAREN
  | RPAREN
  | LBRACKET
  | RBRACKET
  | PLUS
  | MINUS
  | TIMES
  | DIVIDE
  | POS
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
  | DEF
  | LBRACE
  | RBRACE
  | NEWLINE
  | RETURN
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
  | ARRAY
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
