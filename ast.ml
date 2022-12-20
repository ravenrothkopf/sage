type bop = 
    Add
  | Sub
  | Mul
  | Div
  | Mod
  | Equal
  | Neq
  | Greater
  | Geq
  | Less
  | Leq
  | And
  | Or

type typ = String | Int | Float | Bool | Void | ArrayTyp of typ

type uop = Neg | Not

type expr =
    Id of string
  | Assign of string * expr
  | Binop of expr * bop * expr
  | Unop of uop * expr
  | StringLit of string
  | IntLit of int
  | FloatLit of float
  | BoolLit of bool
  | Call of string * expr list
  | Array of expr list
  | Noexpr
  | Cast of typ * expr

(* int x: name binding *)
type bind_formal = typ * string

(*int x = 3: value binding*)
(*tuple, first element contains typ and ID, second is the expression*)
type bind_init = bind_formal * expr

(*type bind = Bind of typ * string *)

type stmt =
    Expr of expr
  | Block of stmt list
  | DecAssn of bind_init
  | If of expr * stmt * stmt
  | For of expr * expr * expr * stmt 
  (* | For of bind_formal * expr * stmt  *)
  | Range of expr * expr * stmt 
  | While of expr * stmt
  | Return of expr
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
    Add -> "+"
  | Sub -> "-"
  | Mul -> "*"
  | Div -> "/"
  | Mod -> "%"
  | Equal -> "=="
  | Neq -> "!="
  | Greater -> ">"
  | Geq -> ">="
  | Less -> "<"
  | Leq -> "<="
  | And -> "and"
  | Or -> "or"

let rec string_of_typ = function
    String -> "str"
  | Int -> "int"
  | Float -> "float"
  | Bool -> "bool"
  | Void -> "void"

let string_of_uop = function 
    Neg -> "-"
  | Not -> "not"

let rec string_of_expr = function
    Id(s) -> s
  | Assign(v, e) -> v ^ " = " ^ string_of_expr e
  | Binop(e1, op, e2) ->
    string_of_expr e1 ^ " " ^ string_of_op op ^ " " ^ string_of_expr e2
  | StringLit(s) -> s
  | Unop(o, e) -> string_of_uop o ^ string_of_expr e
  | IntLit(s) -> string_of_int s
  | FloatLit(s) -> string_of_float s
  | BoolLit(true) -> "True"
  | BoolLit(false) -> "False"
  | Call(f, el) ->
    f ^ "(" ^ String.concat ", " (List.map string_of_expr el) ^ ")"
  | Array(l) -> "[" ^ String.concat ", " (List.map string_of_expr l) ^ "]"
  | Noexpr -> ""
  | Cast (t, e)  -> string_of_typ t ^ "(" ^ string_of_expr e ^ ")"

let string_of_vdecl (decl, exp) = string_of_typ (fst decl) ^ " " ^ (snd decl) ^ " = " ^ string_of_expr exp
^ "\n"

let rec string_of_stmt = function
    Expr(expr) -> string_of_expr expr ^ "\n"
  | Block(stmts) -> "{\n" ^
      "    " ^ String.concat "   " (List.map string_of_stmt stmts) ^ "}\n"
  | DecAssn(decl, expr) -> string_of_vdecl (decl, expr)
  | If(expr, s, Block([])) -> "if (" ^ string_of_expr expr ^ ")\n" ^ "    " ^ string_of_stmt s
  | If(expr, s1, s2) ->  "if (" ^ string_of_expr expr ^ ")\n" ^ string_of_stmt s1 ^ "else\n" ^ string_of_stmt s2
  | For(e1,e2,e3, s) -> "for (" ^ string_of_expr e1 ^ " ; " ^ string_of_expr e2 ^ " ; " ^ 
    string_of_expr e3 ^ ")" ^ string_of_stmt s  
  (* | For(tn, e, stmt) -> "for " ^ string_of_typ (fst tn) ^ " " ^ (snd tn) ^ " in " ^ string_of_expr e ^ "\n" ^ string_of_stmt stmt  *)
  | Range(e1,e2, s) -> "for " ^ string_of_expr e1 ^ " in range (" ^ string_of_expr e2 ^ ")\n" ^ string_of_stmt s
  | While(expr, s) ->  "while (" ^ string_of_expr expr ^ ")\n" ^ string_of_stmt s
  | Return(expr) -> "return" ^ string_of_expr expr ^ "\n"

let string_of_fdecl fdecl =
  "def " ^ string_of_typ fdecl.rtyp ^ " " ^
  fdecl.fname ^ "(" ^ String.concat ", " (List.map snd fdecl.formals) ^
  ") {\n" ^
  String.concat "    " (""::List.map string_of_stmt fdecl.body) ^
  "}\n"

let string_of_program (globals, funcs) =
  "\n\nParsed program: \n\n" ^
  String.concat "\n" (List.map string_of_vdecl globals) ^
  String.concat "\n" (List.map string_of_fdecl funcs)