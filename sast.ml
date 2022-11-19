open Ast

type sexpr = typ * sx 
and sx = 
  SId of string
| SAssign of string * sexpr
| SBinop of sexpr * bop * sexpr
| StringLit of string
| SIntLit of int
| SFloatLit of float
| SBoolLit of bool
| SCall of string * sexpr list

type sstmt = 
  | SExpr of sexpr

type sfunc_def = {
  srtyp: typ;
  sfname: string;
  sformals: name_bind list;
  slocals: val_bind list;
  sbody: sstmt list;
  }

type sprogram = val_bind list * sfunc_def list

(* Pretty-printing functions *)
let rec string_of_sexpr = function
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

let rec string_of_sstmt = function
  | SExpr(expr) -> string_of_sexpr expr ^ "\n"

let string_of_sfdecl fdecl =
  string_of_typ fdecl.srtyp ^ " " ^
  "funct " ^ fdecl.sfname ^ "(" ^ String.concat ", " (List.map snd fdecl.sformals) ^
  ") : \n" ^
  String.concat "    " (""::List.map string_of_vdecl fdecl.slocals) ^
  String.concat "    " (""::List.map string_of_sstmt fdecl.sbody) ^
  "\n"

let string_of_program (vars, funcs) =
  "\n\nSemantically checked program: \n\n" ^
  String.concat "" (List.map string_of_vdecl vars) ^ "\n" ^
  String.concat "\n" (List.map string_of_sfdecl funcs)
