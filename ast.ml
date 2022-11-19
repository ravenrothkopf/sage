type bop = Concat
type typ = String | Int | Float | Bool

type expr =
    Id of string
  | Assign of string * expr
  | Binop of expr * bop * expr
  | StringLit of string
  | IntLit of int
  | FloatLit of float
  | BoolLit of bool
  | Call of string * expr list

type stmt =
  | Expr of expr

(* int x = 3: value binding *)
type val_bind = typ * string * expr

(* int x: name binding - used as parameters *)
type name_bind = typ * string

(* str funct main (int a): func_def *)
type func_def = {
  rtyp: typ;
  fname: string;
  formals: name_bind list;
  locals: val_bind list;
  body: stmt list;
}

type program = val_bind list * func_def list

(* Pretty-printing functions *)
let string_of_op = function
    Concat -> "+"

let rec string_of_expr = function
    Id(s) -> s
  | Assign(v, e) -> v ^ " = " ^ string_of_expr e
  | Binop(e1, op, e2) ->
    string_of_expr e1 ^ " " ^ string_of_op op ^ " " ^ string_of_expr e2
  | StringLit(s) -> s
  | IntLit(s) -> string_of_int s
  | FloatLit(s) -> string_of_float s
  | BoolLit(true) -> "True"
  | BoolLit(false) -> "False"
  | Call(f, el) ->
    f ^ "(" ^ String.concat ", " (List.map string_of_expr el) ^ ")"

let rec string_of_stmt = function
  | Expr(expr) -> string_of_expr expr ^ "\n"

let string_of_typ = function
    String -> "str"
  | Int -> "int"
  | Float -> "float"
  | Bool -> "bool"

let string_of_vdecl (t, id, e) = string_of_typ t ^ " " ^ id ^ " = " ^  string_of_expr e ^ "\n"

let string_of_fdecl fdecl =
  string_of_typ fdecl.rtyp ^ " " ^
  "funct " ^ fdecl.fname ^ "(" ^ String.concat ", " (List.map snd fdecl.formals) ^
  ") : \n" ^
  String.concat "    " (""::List.map string_of_vdecl fdecl.locals) ^
  String.concat "    " (""::List.map string_of_stmt fdecl.body) ^
  "\n"

let string_of_program (vars, funcs) =
  "\n\nParsed program: \n\n" ^
  String.concat "" (List.map string_of_vdecl vars) ^ "\n" ^
  String.concat "\n" (List.map string_of_fdecl funcs)
