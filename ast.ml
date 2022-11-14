type bop = Add 
type typ = String

type expr =
    Id of string
  | Assign of string * expr
  | Concat of string * string
  | StringLit of string
  | Call of string * expr list
  
type stmt =
  Expr of expr

(* int x: name binding *)
type bind = typ * string

(* func_def: ret_typ fname formals locals body *)
type func_def = {
  rtyp: typ;
  fname: string;
  formals: bind list;
  body: stmt list;
}

type program = bind list * func_def list

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

let string_of_fdecl fdecl =
  string_of_typ fdecl.rtyp ^ " " ^
  "funct" ^ fdecl.fname ^ "(" ^ String.concat ", " (List.map snd fdecl.formals) ^
  ") : \n\n" ^
  String.concat "" (List.map string_of_stmt fdecl.body) ^
  "\n"

  let string_of_program (vars, funcs) =
    "\n\nParsed program: \n\n" ^
    String.concat "" (List.map string_of_vdecl vars) ^ "\n" ^
    String.concat "\n" (List.map string_of_fdecl funcs)
