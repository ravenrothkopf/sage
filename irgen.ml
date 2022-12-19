module L = Llvm
module A = Ast
open Sast

module StringMap = Map.Make(String)

(* translate : Sast.program -> Llvm.module *)
let translate (globals, functions) =
  let context    = L.global_context () in

  (* Create the LLVM compilation module into which
     we will generate code *)
  let the_module = L.create_module context "sage" in

  (* Get types from the context *)
  let i32_t      = L.i32_type    context
  and i8_t       = L.i8_type     context
  and i1_t       = L.i1_type     context 
  and void_t     = L.void_type   context 
  and i64_t      = L.i64_type    context
in

  let string_t   = L.pointer_type i8_t in

  (* Return the LLVM type for a sage type *)
  let ltype_of_typ = function
      A.Int -> i32_t
    | A.Bool  -> i1_t
    | A.String -> string_t
    | A.Void -> void_t
  in
  (*print functions*)
  let printf_t : L.lltype =
    L.var_arg_function_type i32_t [| string_t |] in
  let printf_func : L.llvalue =
    L.declare_function "printf" printf_t the_module in

  (*concatenation functions*)
  let concat_t : L.lltype =
      L.function_type string_t [| string_t ; string_t |] in
  let concat_func : L.llvalue =
      L.declare_function "concat" concat_t the_module in
    
  let len_t : L.lltype =
      L.function_type i32_t [| string_t |] in
  let len_func : L.llvalue =
      L.declare_function "len" len_t the_module in

  let indexOf_t : L.lltype =
      L.function_type i32_t [| string_t ; string_t |] in
  let indexOf_func : L.llvalue =
      L.declare_function "indexOf" indexOf_t the_module in

  (* Create a map of global variables after creating each, and evaluating the assigned expr *)
  (*constant expressions*)
  let global_vars : L.llvalue StringMap.t =
    let global_var m ((t, n), expr) =
      let rec build_global_expr ((_, e) : sexpr) = match e with
        SIntLit i -> L.const_int (ltype_of_typ t) i
      | SBoolLit b  -> L.const_int (ltype_of_typ t) (if b then 1 else 0)
      | SStringLit s -> 
        (*define_global + const_stringz returns a global constant char array (with null term) in the module 
           in the default address space*)
          let global = L.define_global ".str" (L.const_stringz context s) the_module in
          (* const ints of the char array*)
          L.const_gep global [|L.const_int i64_t 0; L.const_int i64_t 0|]
      | SNoexpr -> raise (Failure "empty global initializer")
      | SBinop (e1, op, e2) -> 
        let e1' = build_global_expr e1
        and e2' = build_global_expr e2 in
        (match op with
           A.Add     -> L.const_add
         | A.Sub     -> L.const_sub
         | A.Mul     -> L.const_mul
         | A.Div     -> L.const_sdiv
         | A.And     -> L.const_and
         | A.Or      -> L.const_or
         | A.Equal   -> L.const_icmp L.Icmp.Eq
         | A.Neq     -> L.const_icmp L.Icmp.Ne
         | A.Less    -> L.const_icmp L.Icmp.Slt
         | A.Leq     -> L.const_icmp L.Icmp.Sle
         | A.Greater -> L.const_icmp L.Icmp.Sgt
         | A.Geq     -> L.const_icmp L.Icmp.Sge
        ) e1' e2'
      (*makes sure that only operations and initalization can happen to global constants*)
      | SId(_)
      | SAssign(_,_)
      | SCall(_,_) -> raise (Failure "non-constant global initializer")
      (* let init = L.const_int (ltype_of_typ t) 0 *)
    in StringMap.add n (L.define_global n (build_global_expr expr) the_module) m 
  in
  List.fold_left global_var StringMap.empty globals in

  (* Define each function (arguments and return type) so we can
     call it even before we've created its body *)
  let function_decls : (L.llvalue * sfunc_def) StringMap.t =
    let function_decl m fdecl =
      let name = fdecl.sfname
      and formal_types =
        Array.of_list (List.map (fun (t,_) -> ltype_of_typ t) fdecl.sformals)
      in let ftype = L.function_type (ltype_of_typ fdecl.srtyp) formal_types in
      StringMap.add name (L.define_function name ftype the_module, fdecl) m in
    List.fold_left function_decl StringMap.empty functions in

  (* Fill in the body of the given function *)
  let build_function_body fdecl =
    let (the_function, _) = StringMap.find fdecl.sfname function_decls in
    let builder = L.builder_at_end context (L.entry_block the_function) in

    (*for printing*)
    let int_format_str = L.build_global_stringptr "%d\n" "fmt" builder in
    let string_format_str = L.build_global_stringptr "%s\n" "fmt" builder in

    (* Construct the function's "locals": formal arguments and locally
       declared variables.  Allocate each on the stack, initialize their
       value, if appropriate, and remember their values in the "locals" map *)
    let formal_vars =
      let add_formal m (t, n) p =
        L.set_value_name n p;
        let formal = L.build_alloca (ltype_of_typ t) n builder in
        ignore (L.build_store p formal builder);
        StringMap.add n formal m
      in List.fold_left2 add_formal StringMap.empty fdecl.sformals
      (Array.to_list (L.params the_function)) in

    (* Return the value for a variable or formal argument.
       Check local names first, then global names *)
    let lookup map n = try StringMap.find n map
      with Not_found -> StringMap.find n global_vars
    in

    (*type casting between strings, bools, and ints*)
    (*TODO: add type casting for variables*)
    let rec to_string e = 
      match e with
        (_, SIntLit i) -> (A.String, SStringLit (string_of_int i))
      | (_, SBoolLit true) -> (A.String, SStringLit "true")
      | (_, SBoolLit false) -> (A.String, SStringLit "false")
      (* | (typ, SId s) -> to_string map (typ, (snd (lookup map s))) *)
      | _ -> raise (Failure ("Failure:" ^ string_of_sexpr e ^ "type cant be cast to a string")) in
    
    let rec to_int e = 
      match e with
        (_, SBoolLit true) -> (A.Int, SIntLit 1)
      | (_, SBoolLit false) -> (A.Int, SIntLit 0)
      | (_, SStringLit s) -> 
        try (A.Int, SIntLit (int_of_string s)) 
        with Failure _ -> raise (Failure ("string cant be cast to an int"))
      (* | (typ, SId s) -> to_string map (typ, (snd (lookup map s))) *)
      | _ -> raise (Failure ("Failure:" ^ string_of_sexpr e ^ "type cant be cast to an int")) in
    
    let to_bool e =
      match e with
        (_, SIntLit(i)) when i = 0 -> (A.Bool, SBoolLit(false))
      | (_, SStringLit(s)) when s = "0" -> (A.Bool, SBoolLit(false))
      | (_, SIntLit(_))    -> (A.Bool, SBoolLit(true))
      | (_, SStringLit(_)) -> (A.Bool, SBoolLit(true)) 
      | _ -> raise (Failure ("Failure:" ^ string_of_sexpr e ^ "type cant be cast to an int")) in

    (* Construct code for an expression using a map of variables; return its value *)
    let rec build_expr builder map ((_, e) : sexpr) = match e with
        SIntLit i  -> L.const_int i32_t i
      | SBoolLit b  -> L.const_int i1_t (if b then 1 else 0)
      | SStringLit s -> L.build_global_stringptr s "str" builder
      | SId s       -> L.build_load (lookup map s) s builder
      | SAssign (s, e) -> let e' = build_expr builder map e in
        ignore(L.build_store e' (lookup map s) builder); e'
      | SNoexpr -> L.const_int i32_t 0
      (*for string concatenation!*)
      | SBinop ((A.String, _) as e1, op, e2) ->
        (match op with
           A.Add -> L.build_call concat_func [| (build_expr builder map e1); (build_expr builder map e2)|] "concat" builder
         | _ -> raise (Failure ("Can't call" ^ (A.string_of_op op) ^ "on a string!")))
      | SBinop (e1, op, e2) ->
        let e1' = build_expr builder map e1
        and e2' = build_expr builder map e2 in
        (match op with
           A.Add     -> L.build_add
         | A.Sub     -> L.build_sub
         | A.Mul     -> L.build_mul
         | A.Div     -> L.build_sdiv
         | A.And     -> L.build_and
         | A.Or      -> L.build_or
         | A.Equal   -> L.build_icmp L.Icmp.Eq
         | A.Neq     -> L.build_icmp L.Icmp.Ne
         | A.Less    -> L.build_icmp L.Icmp.Slt
         | A.Leq     -> L.build_icmp L.Icmp.Sle
         | A.Greater -> L.build_icmp L.Icmp.Sgt
         | A.Geq     -> L.build_icmp L.Icmp.Sge
        ) e1' e2' "tmp" builder
      (*calling print and concat functions*)
      | SCall ("print", [e])
      | SCall ("printi", [e]) ->
        L.build_call printf_func [| int_format_str ; (build_expr builder map e) |]
          "printf" builder
      | SCall ("prints", [e]) ->
        L.build_call printf_func [| string_format_str ; (build_expr builder map e) |]
          "printf" builder
      | SCall ("printb", [e]) ->
        L.build_call printf_func [| int_format_str ; (build_expr builder map e) |]
          "printf" builder
      | SCall ("len", [e]) ->
        L.build_call len_func [| (build_expr builder map e) |] "len" builder
      | SCall ("indexOf", [e1; e2]) ->
        L.build_call indexOf_func [|(build_expr builder map e1); (build_expr builder map e2)|] "indexOf" builder
      (*type casting hack using OCaml oooh*)
      (* | SCall ("int2str",  [e]) -> build_expr builder map (to_string map e)
      | SCall ("bool2str", [e]) -> build_expr builder map (to_string map e)
      | SCall ("str2int",  [e]) -> build_expr builder map (to_int map e)
      | SCall ("bool2int", [e]) -> build_expr builder map (to_int map e) *)
      | SCall (f, args) ->
        let (fdef, fdecl) = StringMap.find f function_decls in
        let llargs = List.rev (List.map (build_expr builder map) (List.rev args)) in
        let result = (match fdecl.srtyp with 
             A.Void -> ""
            | _ -> f ^ "_result") in
        L.build_call fdef (Array.of_list llargs) result builder
      | SCast (c_type, e) -> 
        let (ty, _) = e in
        match c_type with
          A.String -> build_expr builder map (to_string e)
        | A.Int    -> build_expr builder map (to_int e)
        | A.Bool   -> build_expr builder map (to_bool e)
    in

    (* LLVM insists each basic block end with exactly one "terminator"
       instruction that transfers control.  This function runs "instr builder"
       if the current block does not already have a terminator.  Used,
       e.g., to handle the "fall off the end of the function" case. *)
    let add_terminal builder instr =
      match L.block_terminator (L.insertion_block builder) with
        Some _ -> ()
      | None -> ignore (instr builder) in

    (* Build the code for the given statement; return the builder for
       the statement's successor (i.e., the next instruction will be built
       after the one generated by this call) *)

    let rec build_stmt (builder, vars)  = function
        SBlock sl -> 
          (fst (List.fold_left build_stmt (builder, vars) sl), vars)
      | SExpr e -> ignore(build_expr builder vars e); (builder, vars)
      | SDecAssn ((t, n), expr) -> (builder, 
        let e' = build_expr builder vars expr
        in L.set_value_name n e';
        let local_var = L.build_alloca (ltype_of_typ t) n builder
        in ignore (L.build_store e' local_var builder);
        StringMap.add n local_var vars)
      (* implement below after loop structure *)
      | SWhile (predicate, body) ->
        let while_bb = L.append_block context "while" the_function in
        let build_br_while = L.build_br while_bb in (* partial function *)
        ignore (build_br_while builder);
        let while_builder = L.builder_at_end context while_bb in
        let bool_val = build_expr while_builder vars predicate in

        let body_bb = L.append_block context "while_body" the_function in
        add_terminal (fst (build_stmt ((L.builder_at_end context body_bb), vars) body)) build_br_while;

        let end_bb = L.append_block context "while_end" the_function in

        ignore(L.build_cond_br bool_val body_bb end_bb while_builder);
        (L.builder_at_end context end_bb, vars)
       
      | SFor (expr1, expr2, body) -> 
        let for_bb = L.append_block context "for" the_function in
        let pred_bb = L.build_br for_bb in
        ignore(pred_bb builder);
        let for_builder = L.builder_at_end context for_bb in
        let first_expr = build_expr for_builder vars expr1 in
        let bool_val = build_expr for_builder vars expr2 in 
        let body_bb = L.append_block context "for_body" the_function in
        let end_bb = L.append_block context "for_end" the_function in
        add_terminal (fst (build_stmt ((L.builder_at_end context body_bb), vars) body)) pred_bb;
        ignore(L.build_cond_br bool_val body_bb end_bb for_builder); 
        (L.builder_at_end context end_bb, vars)
     (* | SRange (expr, stmt) -> *)
      | SReturn e -> ignore(match fdecl.srtyp with
          (* Special "return nothing" instr *)
            A.Void -> L.build_ret_void builder
          (* Build return statement *)
          | _ -> L.build_ret (build_expr builder vars e) builder ); (builder, vars)
      | SIf (predicate, then_stmt, else_stmt) ->
        let bool_val = build_expr builder vars predicate in

        let then_bb = L.append_block context "then" the_function in
        let else_bb = L.append_block context "else" the_function in
        
        (*for else if stmts*)
        let merge_bb = L.append_block context "merge" the_function in
        let build_br_merge = L.build_br merge_bb in
        (* let end_bb = L.append_block context "if_end" the_function in
        let build_br_end = L.build_br end_bb in partial function *)
        add_terminal (fst (build_stmt ((L.builder_at_end context then_bb), vars) then_stmt)) build_br_merge;
        add_terminal (fst (build_stmt ((L.builder_at_end context else_bb), vars) else_stmt)) build_br_merge;

        ignore(L.build_cond_br bool_val then_bb else_bb builder);
        (L.builder_at_end context merge_bb, vars)
        (* | A.Bool   -> ignore(build_expr builder vars (to_bool e)) ; (builder, vars) *)
    in
    
    (* Build the code for each statement in the function, returns only the builder
       not the map w the globals *)
    let func_builder = fst(build_stmt (builder, formal_vars) (SBlock fdecl.sbody)) in

    (* Add a return if the last block falls off the end, if type is void, dont *)
    add_terminal func_builder (match fdecl.srtyp with
        A.Void -> L.build_ret_void
      | t -> (L.build_ret (L.const_int (ltype_of_typ t) 0)))
  in

  List.iter build_function_body functions;
  the_module