type token =
  | NEWLINE
  | LPAREN
  | RPAREN
  | PLUS
  | ASSIGN
  | TAB
  | SPACE
  | STRING
  | INT
  | FLOAT
  | BOOL
  | FUNCT
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
