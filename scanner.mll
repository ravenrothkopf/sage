{ open Parser }

let digit = ['0'-'9']
let letter = ['a'-'z' 'A'-'Z']
let frac = '.' digit*
let exp = ['e' 'E'] ['-' '+']? digit+
let float = digit* frac? exp?
let int = '-'? digit digit*

rule token = parse
  [' ' '\r']                            { token lexbuf }          (* Whitespace *)
| "#"                                   { comment lexbuf }           (* Comments *)
| "\"\"\""                              { comment2 lexbuf }
| '\n'                                  { NEWLINE }
| '('                                   { LPAREN }
| ')'                                   { RPAREN }
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
| "True"                                { BLIT(true) }
| "False"                               { BLIT(false) }
| "and"                                 { AND }
| "or"                                  { OR }
| "not"                                 { NOT }
| "def"                                 { DEF }
| "void"                                { VOID }
| "if"                                  { IF }
| "elif"                                { ELIF }
| "else"                                { ELSE }
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
| _        { comment2 lexbuf }

and slit s = parse
 "\""                         { SLIT (s)}
| (letter | digit | ' ') as x { slit (s ^ (String.make 1 x)) lexbuf}