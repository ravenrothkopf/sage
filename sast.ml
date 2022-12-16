open Ast

type sexpr = typ * sx 
and sx = 
  SId of string
| SAssign of string * sexpr
| SBinop of sexpr * bop * sexpr
| SStringLit of string
| SIntLit of int
(* | SFloatLit of float *)
| SBoolLit of bool
| SCall of string * sexpr list
| SNoexpr

type sbind_formal = typ * string

type sbind_init = sbind_formal * sexpr

type sstmt = 
    SExpr of sexpr
  | SBlock of sstmt list
  | SDecAssn of sbind_init
  | SIf of sexpr * sstmt * sstmt

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
  (* | SFloatLit(s) -> string_of_float s *)
  | SBoolLit(true) -> "True"
  | SBoolLit(false) -> "False"
  | SCall(f, el) ->
    f ^ "(" ^ String.concat ", " (List.map string_of_sexpr el) ^ ")"
  | SNoexpr -> ""
    ) ^ ")"   

(*for printing*)
 (* let print_sstring (_, exp) = match exp with 
     SStringLit(s) ->
   | _ -> raise (Failure "only string type allowed to print") *)

let string_of_svdecl (decl, exp) = string_of_typ (fst decl) ^ " " ^ (snd decl) ^ " = " ^ string_of_sexpr
  exp ^ "\n"
let rec string_of_sstmt = function
   SExpr(expr) -> string_of_sexpr expr ^ "\n"
  | SBlock(stmts) -> "{\n" ^
    "    " ^ String.concat "    " (List.map string_of_sstmt stmts) ^ "}\n"
  | SDecAssn(decl, expr) -> string_of_svdecl (decl, expr)
  | SIf(expr, s, SBlock([])) ->
    "if (" ^ string_of_sexpr expr ^ ")\n" ^ string_of_sstmt s
  | SIf(expr, s1, s2) ->  "if (" ^ string_of_sexpr expr ^ ")\n" ^
    string_of_sstmt s1 ^ "else\n" ^ string_of_sstmt s2

let string_of_sfdecl fdecl =
  "def " ^ string_of_typ fdecl.srtyp ^ " " ^
  fdecl.sfname ^ "(" ^ String.concat ", " (List.map snd fdecl.sformals) ^
  ") {\n" ^
  String.concat "    " (""::List.map string_of_sstmt fdecl.sbody) ^
  "}\n"

let string_of_sprogram (globals, funcs) =
  "\n\nSemantically checked program: \n\n" ^
  String.concat "\n" (List.map string_of_svdecl globals) ^
  String.concat "\n" (List.map string_of_sfdecl funcs) 
