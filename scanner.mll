{ open Parser }

let digit = ['0'-'9']
let letter = ['a'-'z' 'A'-'Z']
let frac = '.' digit*
let exp = ['e' 'E'] ['-' '+']? digit+
let float = digit* frac? exp?
let int = '-'? digit digit*

rule token = parse
  [' ' '\r' '\t']                            { print_endline "_";token lexbuf }          (* Whitespace *)
| "#"                                   { comment lexbuf }           (* Comments *)
| "\"\"\""                              { comment2 lexbuf }
| '\n'                                  { print_endline "NEWLINE"; NEWLINE }
| '\t' | "    "                                 { print_endline "TAB"; TAB }
| '('                                   { print_endline "lparen";LPAREN }
| ')'                                   { print_endline "rparen";RPAREN }
| '{'                                   { LBRACE }
| '}'                                   { RBRACE }
| '['                                   {print_endline "["; LBRACKET }
| ']'                                   { RBRACKET }
| ':'                                   { print_endline "colon";COLON }
| ','                                   { COMMA }
| '{'                                   { LBRACE }
| '}'                                   { RBRACE }
| '='                                   { print_endline "assign";ASSIGN }
| "str"                                 { print_endline "STR";STRING }
| "int"                                 { INT }
| "float"                               { FLOAT }
| "bool"                                { print_endline "BOOL";BOOL }
| "True"                                { print_endline "true";BLIT(true) }
| "False"                               { BLIT(false) }
| "+"                                   { PLUS }
| "-"                                   { MINUS }
| "*"                                   { TIMES }
| "/"                                   { DIVIDE }
| "and"                                 { AND }
| "or"                                  { OR }
| "not"                                 { NOT }
| "def"                                 { print_endline "def";DEF }
| "void"                                { print_endline "void";VOID }
| "if"                                  { IF }
| "elif"                                { ELIF }
| "else"                                { ELSE }
| "while"                               { WHILE }
| "for"                                 { FOR }
| "=="                                  { EQ }
| "!="                                  { NEQ }
| ">"                                   { GT }
| ">="                                  { GEQ }
| "<"                                   { LT }
| "<="                                  { LEQ }
| "return"                              { RETURN }
| int as lem                            { ILIT(int_of_string lem) }
| float as lem                          { FLIT(float_of_string lem) }
| letter (digit | letter | '_')* as lem { print_endline ("ID"^lem) ;ID(lem) }
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
 "\""                         { print_endline ("string"^s);SLIT (s)}
| (letter | digit | ' ') as x { slit (s ^ (String.make 1 x)) lexbuf}