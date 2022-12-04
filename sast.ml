open Ast

type sexpr = typ * sx 
and sx = 
  SId of string
| SAssign of string * sexpr
| SBinop of sexpr * bop * sexpr
| SStringLit of string
| SIntLit of int
| SFloatLit of float
| SBoolLit of bool
| SCall of string * sexpr list

type sbind_formal = typ * string

type sbind_init = sbind_formal * sexpr

type sstmt = 
    SExpr of sexpr
  | SBlock of sstmt list
  | SDecAssn of sbind_init

type sfunc_def = {
  srtyp: typ;
  sfname: string;
  sformals: bind_formal list;
  sbody: sstmt list;
  }

type sprogram = bind_init list * sfunc_def list

(* Pretty-printing functions *)
let rec string_of_sexpr(t,e) =
  "(" ^ string_of_typ t ^ " : " ^ (match e with
    SId(s) -> s
  | SAssign(v, e) -> v ^ " = " ^ string_of_sexpr e
  | SBinop(e1, op, e2) ->
    string_of_sexpr e1 ^ " " ^ string_of_op op ^ " " ^ string_of_sexpr e2
  | SStringLit(s) -> s
  | SIntLit(s) -> string_of_int s
  | SFloatLit(s) -> string_of_float s
  | SBoolLit(true) -> "True"
  | SBoolLit(false) -> "False"
  | SCall(f, el) ->
    f ^ "(" ^ String.concat ", " (List.map string_of_sexpr el) ^ ")"
  ) ^ ")"  

let string_of_svdecl (decl, exp) = string_of_typ (fst decl) ^ " " ^ (snd decl) ^ " = " ^ string_of_sexpr
  exp ^ "\n"
let rec string_of_sstmt = function
   SExpr(expr) -> string_of_sexpr expr ^ "\n"
  | SBlock(stmts) ->
    "    " ^ String.concat "" (List.map string_of_sstmt stmts) ^ "\n"
  | SDecAssn(decl, expr) -> string_of_svdecl (decl, expr)

let string_of_sfdecl fdecl =
  string_of_typ fdecl.srtyp ^ " " ^
  "funct " ^ fdecl.sfname ^ "(" ^ String.concat ", " (List.map snd fdecl.sformals) ^
  ") : \n" ^
  String.concat "    " (""::List.map string_of_sstmt fdecl.sbody) ^
  "\n"

let string_of_sprogram (globals, funcs) =
  "\n\nSemantically checked program: \n\n" ^
  String.concat "\n" (List.map string_of_svdecl globals) ^
  String.concat "\n" (List.map string_of_sfdecl funcs) 
