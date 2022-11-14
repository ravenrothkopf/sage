(* example Ocamllex scanner *)

{ open Parser }

let digit = ['0'-'9']
let letter = ['a'-'z' 'A'-'Z']

rule token = parse
  [' ' '\t' '\r'] { token lexbuf } (* Whitespace *)
| "#"     { comment lexbuf }           (* Comments *)
| "\"\"\"" { comment2 lexbuf }
| "\n"     { NEWLINE }
| '('      { LPAREN }
| ')'      { RPAREN }
| ':'      { COLON }
| ','      { COMMA }
| '+'      { PLUS }
| '='      { ASSIGN }
| "str"    { STRING }
| "funct"  { FUNCT }
| letter (digit | letter | '_')* as lem { ID(lem) }
| "\"([^\"\\\\]|\\\\.)*\"" as lem { SLIT (lem) } (**String literal**)
| eof { EOF }
| _ as char { raise (Failure("illegal character " ^ Char.escaped char)) }

and comment = parse
  "\n" { token lexbuf }
| _    { comment lexbuf }

and comment2 = parse
  "\"\"\"" { token lexbuf }
| _    { comment lexbuf }


