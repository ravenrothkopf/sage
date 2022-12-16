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

(* int x: name binding *)
type bind_formal = typ * string

(*int x = 3: value binding*)
(*tuple, first element contains typ and ID, second is the expression*)
type bind_init = bind_formal * expr

type stmt =
    Expr of expr
  | Block of stmt list
  | DecAssn of bind_init
  | For of expr * stmt 
  | While of expr * stmt
  

(*type name_bind = typ * string*)

(* str funct main (int a): func_def *)
type func_def = {
  rtyp: typ;
  fname: string;
  formals: bind_formal list; (*type * string*)
  body: stmt list;
}

(*global decls + func decls*)
type program = bind_init list * func_def list

(* Pretty-printing functions *)

(* Need to implement these in the parser/scanner before they can be in the AST!*)
let string_of_op = function
    Concat -> "+"
  (* | Add -> '+'
  | Sub -> '-'
  | Mult -> '*'
  | Div -> '/'
  | Mod -> '%'
  | Eq -> '='
  | Neq -> "!="
  | Less -> "<"
  | Leq -> "<="
  | Greater -> ">"
  | Geq -> ">="
  | And -> "and"
  | Or -> "or"
  | Not -> "not" *)

(* let string_of_uop = function
    Pos -> '+'
  | Neg -> '-' *)

let string_of_typ = function
    String -> "str"
  | Int -> "int"
  | Float -> "float"
  | Bool -> "bool"

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

let string_of_vdecl (decl, exp) = string_of_typ (fst decl) ^ " " ^ (snd decl) ^ " = " ^ string_of_expr exp
^ "\n"

let rec string_of_stmt = function
    Expr(expr) -> string_of_expr expr ^ "\n"
  | Block(stmts) ->
      "    " ^ String.concat "" (List.map string_of_stmt stmts) ^ "\n"
  | For(e, s) -> 
    "for (" ^ string_of_expr e ^ " ) " ^ string_of_stmt s  
  | While(e, s) -> "while (" ^ string_of_expr e ^ ") " ^ string_of_stmt s
  | DecAssn(decl, expr) -> string_of_vdecl (decl, expr)

let string_of_fdecl fdecl =
  string_of_typ fdecl.rtyp ^ " " ^
  "funct " ^ fdecl.fname ^ "(" ^ String.concat ", " (List.map snd fdecl.formals) ^
  "){\n" ^
  String.concat "    " (""::List.map string_of_stmt fdecl.body) ^
  "}\n"

let string_of_program (globals, funcs) =
  "\n\nParsed program: \n\n" ^
  String.concat "\n" (List.map string_of_vdecl globals) ^
  String.concat "\n" (List.map string_of_fdecl funcs)  
