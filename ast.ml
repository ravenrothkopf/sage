type bop = Add 
type typ = String

type expr =
    Id of string
  | Assign of string * expr
  | Concat of string * string
  | StringLit of string

type stmt =
  | Expr of expr

type bind = typ * string

type program = {
  locals: bind list;
  body: stmt list;
}

(* Pretty-printing functions *)
let string_of_op = function
    Add -> "+"

let rec string_of_expr = function
   Id(s) -> s
  | StringLit(s) -> s
  | Assign(v, e) -> v ^ " = " ^ string_of_expr e
  | Concat(s1, s2) -> s1 ^ s2

let rec string_of_stmt = function
  | Expr(expr) -> string_of_expr expr ^ "\n"

let string_of_typ = function
    String -> "str"

let string_of_vdecl (t, id) = string_of_typ t ^ " " ^ id ^ "\n"

let string_of_program fdecl =
  "\n\nParsed program: \n\n" ^
  String.concat "" (List.map string_of_vdecl fdecl.locals) ^
  String.concat "" (List.map string_of_stmt fdecl.body) ^
  "\n"
