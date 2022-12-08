{ open Parser }

let digit = ['0'-'9']
let letter = ['a'-'z' 'A'-'Z']
let frac = '.' digit*
let exp = ['e' 'E'] ['-' '+']? digit+
let float = digit* frac? exp?
let int = '-'? digit digit*

rule token = parse
  [' ' '\r' '\t']                       { token lexbuf }          (* Whitespace *)
| "#"                                   { comment lexbuf }           (* Comments *)
| "\"\"\""                              { comment2 lexbuf }
| '\n'                                  { NEWLINE }
| '('                                   { LPAREN }
| ')'                                   { RPAREN }
| '{'                                   { LBRACE }
| '}'                                   { RBRACE }
| ':'                                   { COLON }
| ','                                   { COMMA }
| '{'                                   { LBRACE }
| '}'                                   { RBRACE }
| '+'                                   { PLUS }
| '='                                   { ASSIGN }
| "str"                                 { STRING }
| "int"                                 { INT }
| "float"                               { FLOAT }
| "bool"                                { BOOL }
| "funct"                               { FUNCT }
(*All of these need to be implemented in the scanner + parser too, otherwise doesn't compile*)
(* | '-'                                   { MINUS }
| '*'                                   { TIMES }
| '/'                                   { DIVIDE }
| '%'                                   { MODULO }
| "=="                                  { EQ }
| "!="                                  { NEQ }
| '<'                                   { LT }
| "<="                                  { LEQ }
| ">"                                   { GT }
| ">="                                  { GEQ }
| "and"                                 { AND }
| "or"                                  { OR }
| "not"                                 { NOT }
| '.'                                   { DOT }
| '['                                   { LBRACK }
| ']'                                   { RBRACK }
| "if"                                  { IF }
| "elif"                                { ELIF }
| "else"                                { ELSE }
| "for"                                 { FOR }
| "while"                               { WHILE } *)
(* | "loop"                                { LOOP }
| "continue"                            { CONTINUE }
| "break"                               { BREAK }
| "in"                                  { IN }
| "&"                                   { BORROW }
| "static"                              { STATIC }
| "const"                               { CONST }
| "True"                                { TRUE }
| "False"                               { FALSE }
| "struct"                              { STRUCT }
| "void"                                { VOID }
| "return"                              { RETURN } *)
| int as lem                            { ILIT(int_of_string lem) }
| float as lem                          { FLIT(float_of_string lem) }
| letter (digit | letter | '_')* as lem { ID(lem) }
| "\""                                  {slit "" lexbuf}
| eof                                   { EOF }
| _ as char                             { raise (Failure("illegal character " ^ Char.escaped char)) }

and comment = parse
  "\n" { token lexbuf }
| _    { comment lexbuf }

and comment2 = parse
  "\"\"\"" { token lexbuf }
| _        { comment lexbuf }

and slit s = parse
 "\""                         { SLIT (s)}
| (letter | digit | ' ') as x { slit (s ^ (String.make 1 x)) lexbuf}