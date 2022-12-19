open Ast
open Sast

module StringMap = Map.Make(String)

(* Semantic checking of the AST. Returns an SAST if successful,
   throws an exception if something is wrong.

   Check each global statement, then check each function *)

let check (globals, functions) =
  (* Verify a list of bindings has no duplicate names *)
  let check_binds (kind : string) (binds : bind_formal list) =
    List.iter (function
       (Void, b) -> raise (Failure ("illegal void " ^ kind ^ " " ^ b))
       | _ -> ()) binds;
    let rec dups = function
        [] -> ()
      |	((_,n1) :: (_,n2) :: _) when n1 = n2 ->
        raise (Failure ("duplicate " ^ kind ^ " " ^ n1))
      | _ :: t -> dups t
    in dups (List.sort (fun (_,a) (_,b) -> compare a b) binds)
  in

(*separates type and id from expr for check_binds, concats into list*)
let rec global_symbols = function
  [] -> []
  | hd::tl -> fst hd::global_symbols tl
in
(**** Check global variables ****)
ignore(check_binds "global" (global_symbols globals));

  (* Collect function declarations for built-in functions: no bodies *)
  let built_in_decls =
    let add_bind map (name, ty, rty) = StringMap.add name {
      rtyp = rty;
      fname = name;
      (*initializes the list of formals*)
      formals = List.fold_left (fun l t -> l @ [(t, "x")]) [] ty;
      body = []
    } map
    in List.fold_left add_bind StringMap.empty 
    (*put your function definitions here!*)
    [("print", [Int], Void); ("printi", [Int], Void); ("prints", [String], Void); ("printb", [Bool], Void); 
    ("concat", [String ; String], String); ("len", [String], Int); ("indexOf", [String; String], Int)]; 
  in

  (* Add function name to symbol table *)
  let add_func map fd =
    let built_in_err = "function " ^ fd.fname ^ " may not be defined"
    and dup_err = "duplicate function " ^ fd.fname
    and make_err er = raise (Failure er)
    and n = fd.fname (* Name of the function *)
    in match fd with (* No duplicate functions or redefinitions of built-ins *)
      _ when StringMap.mem n built_in_decls -> make_err built_in_err
    | _ when StringMap.mem n map -> make_err dup_err
    | _ ->  StringMap.add n fd map
  in

  (* Collect all function names into one symbol table *)
  let function_decls = List.fold_left add_func built_in_decls functions
  in

  (* Return a function from our symbol table *)
  let find_func s =
    try StringMap.find s function_decls
    with Not_found -> raise (Failure ("unrecognized function " ^ s))
  in

  let _ = find_func "main" in (* Ensure "main" is defined *)
  
  (*Moved check_expr, type_of_identifier, and check_assign outside of check_func so that
      they can also be used to check global statements, but now we need to pass in a global symbol
      table when checking statements inside of funcs*)
      
  (* Return a variable from our local symbol table *)
  let type_of_identifier s map =
    try StringMap.find s map
    with Not_found -> raise (Failure ("undeclared identifier " ^ s))
  in

  (* Raise an exception if the given rvalue type cannot be assigned to
       the given lvalue type *)
  let check_assign lvaluet rvaluet err =
    if lvaluet = rvaluet then lvaluet else 
        raise (Failure err)
  in

  let rec check_expr e map = match e with
        Id var -> (type_of_identifier var map, SId var)
      | BoolLit l -> (Bool, SBoolLit l) 
      | StringLit l -> (String, SStringLit l)
      | IntLit l -> (Int, SIntLit l)
      (* | FloatLit l -> (Float, SFloatLit l) *)
      | Noexpr -> (Void, SNoexpr)
      | Assign(var, e) as ex ->
        let lt = type_of_identifier var map
        and (rt, e') = check_expr e map in
        let err = "illegal assignment " ^ string_of_typ lt ^ " = " ^
                  string_of_typ rt ^ " in " ^ string_of_expr ex
        in
        (check_assign lt rt err, SAssign(var, (rt, e')))
      | Binop(e1, op, e2) as e ->
        let (t1, e1') = check_expr e1 map
        and (t2, e2') = check_expr e2 map in
        let err = "illegal binary operator " ^
                  string_of_typ t1 ^ " " ^ string_of_op op ^ " " ^
                  string_of_typ t2 ^ " in " ^ string_of_expr e
        in
        if t1 = t2 then
          let t = match op with
            Add | Sub | Mul | Div when t1 = Int -> Int
          | Add when t1 = String -> String
          | Equal | Neq -> Bool
          | Less | Leq | Greater | Geq when t1 = Int -> Bool
          | And | Or when t1 = Bool -> Bool
          | _ -> raise (Failure err)
        in 
        (t, SBinop ((t1,e1'), op, (t2, e2')))
      else raise (Failure err)
      | Call(fname, args) as call ->
        let fd = find_func fname in
        let param_length = List.length fd.formals in
        if List.length args != param_length then
          raise (Failure ("expecting " ^ string_of_int param_length ^
                          " arguments in " ^ string_of_expr call))
        else let check_call (ft, _) e =
               let (et, e') = check_expr e map in
               let err = "illegal argument found " ^ string_of_typ et ^
                         " expected " ^ string_of_typ ft ^ " in " ^ string_of_expr e
               in (check_assign ft et err, e')
          in
          let args' = List.map2 check_call fd.formals args
          in (fd.rtyp, SCall(fname, args'))
      | Noexpr -> (Void, SNoexpr)
      | Cast(t, e) -> match t with
          Int -> (Int, (SCast(t, check_expr e map)))
        | String -> (String, (SCast(t, check_expr e map)))
        | Bool -> (Bool, (SCast(t, check_expr e map)))
    in

  let check_func func =
    (* Make sure no formals or locals are void or duplicates *)
    check_binds "formal" func.formals;

    (* Build local symbol table of variables for this function *)
    let symbols = List.fold_left (fun m (ty, name) -> StringMap.add name ty m)
        StringMap.empty (global_symbols globals @ func.formals)
    in

    let check_bool_expr e vars =
      let (t, e') = check_expr e vars in
      match t with
      | Bool -> (t, e')
      |  _ -> raise (Failure ("expected Boolean expression in " ^ string_of_expr e))
    in

    (* Return a semantically-checked statement i.e. containing sexprs *)
    let rec check_stmt stmt vars = match stmt with
        Expr e -> (SExpr (check_expr e vars), vars)
      | Return e -> let (t,e') = check_expr e vars in
        if t = func.rtyp then (SReturn (t, e'), vars)
        else raise (
          Failure ("return gives " ^ string_of_typ t ^ ", but expected "
          ^ string_of_typ func.rtyp ^ " in " ^ string_of_expr e))
      | Block stmt_list -> 
        let bvars = StringMap.empty in
        let rec check_stmt_list stmt_list vars bvars = 
          let check s ss bvars = 
            let checked = check_stmt s vars in
            let checked_rest = check_stmt_list ss (snd checked) bvars in
            (fst checked :: fst checked_rest, snd checked_rest)
          in
          match stmt_list with
            [Return _ as s] -> ([fst (check_stmt s vars)], bvars)
          | Return _ :: _ -> raise (Failure "nothing can follow a return statement")
          | DecAssn ((ty, n), _) as s :: ss ->
            let check_decl ty n = match StringMap.find_opt n bvars with
            Some _ -> raise (Failure ("duplicate local variable " ^ n))
            | None -> ()
          in (ignore(check_decl ty n); check s ss (StringMap.add n ty bvars))
          | s :: ss -> check s ss bvars
          | [] -> ([], bvars)
        in (SBlock(fst (check_stmt_list stmt_list vars bvars)), vars)
      | DecAssn((ty, n), e) -> (SDecAssn((ty, n), check_expr e vars), StringMap.add n ty vars)
      | If(e, st1, st2) -> (SIf(check_bool_expr e vars, fst (check_stmt st1 vars), fst (check_stmt st2
         vars)), vars)
    in (* body of check_func *)
    { 
      srtyp = func.rtyp;
      sfname = func.fname;
      sformals = func.formals;
      sbody = match fst (check_stmt (Block func.body) symbols) with
        SBlock(stmt_list) -> stmt_list
      | _ -> raise (Failure ("internal error"))

    }
  in

  let check_global (binds, expr) =
    (* Build local symbol table of variables for this function *)
    let symbols = List.fold_left (fun m (ty, name) -> StringMap.add name ty m)
                StringMap.empty (global_symbols globals)
    in
    (binds, check_expr expr symbols)
  in (List.map check_global globals, List.map check_func functions)
