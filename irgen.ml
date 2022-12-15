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
  and void_t     = L.void_type   context in
  
  let string_t   = L.pointer_type i8_t in

  (* Return the LLVM type for a sage type *)
  let ltype_of_typ = function
      A.Int -> i32_t
    | A.Bool  -> i1_t
    | A.String -> string_t
    | A.Void -> void_t
  in

  (* Create a map of global variables after creating each, and evaluating the assigned expr *)
  let global_vars : L.llvalue StringMap.t =
    let global_var m ((t, n), expr) =
      let rec build_global_expr ((_, e) : sexpr) = match e with
        SIntLit i -> L.const_int (ltype_of_typ t) i
      | SBoolLit b  -> L.const_int (ltype_of_typ t) (if b then 1 else 0)
      | SStringLit s -> L.const_stringz context s
      | SNoexpr -> raise (Failure "empty global initializer")
      | SBinop (e1, op, e2) -> 
        let e1' = build_global_expr e1
        and e2' = build_global_expr e2 in
        (match op with
           A.Add     -> L.const_add
         (* | A.Sub     -> L.const_sub
         | A.And     -> L.const_and
         | A.Or      -> L.const_or
         | A.Equal   -> L.const_icmp L.Icmp.Eq
         | A.Neq     -> L.const_icmp L.Icmp.Ne
         | A.Less    -> L.const_icmp L.Icmp.Slt *)
        ) e1' e2'
      | SId(_)
      | SAssign(_,_)
      | SCall(_,_) -> raise (Failure "non-constant global initializer")
      (* let init = L.const_int (ltype_of_typ t) 0 *)
    in StringMap.add n (L.define_global n (build_global_expr expr) the_module) m 
  in
  List.fold_left global_var StringMap.empty globals in
  
  let printf_t : L.lltype =
    L.var_arg_function_type i32_t [| string_t |] in
  let printf_func : L.llvalue =
    L.declare_function "printf" printf_t the_module in

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

      (* (* Allocate space for any locally declared variables and add the
       * resulting registers to our map *)
      and add_local m (t, n) =
        let local_var = L.build_alloca (ltype_of_typ t) n builder
        in StringMap.add n local_var m
      in

      let formals = List.fold_left2 add_formal StringMap.empty fdecl.sformals
          (Array.to_list (L.params the_function)) in
      List.fold_left add_local formals fdecl.slocals
    in *)

    (* Return the value for a variable or formal argument.
       Check local names first, then global names *)
    let lookup map n = try StringMap.find n map
      with Not_found -> StringMap.find n global_vars
    in

    (*matching types for printing*)
    let i32_t_pt = L.string_of_lltype i32_t in
    let i1t_pt = L.string_of_lltype i1_t in
    let i8_t_pt = L.string_of_lltype i8_t in

    let match_typ ty = 
      let t_pt = L.string_of_lltype ty in
      if t_pt = i8_t_pt then A.String else
        if t_pt = i32_t_pt then A.Int else
          if t_pt = i1t_pt then A.Int else
            raise (Failure ("cant match type: " ^ t_pt))
          in

    let rec find_type map expr = match expr with
        SIntLit _ -> A.Int
      | SBoolLit _ -> A.Int
      | SStringLit _ -> A.String
      (* TODO: | SBinop((_, e_x, op, _) -> if ) *)
      | SNoexpr -> raise (Failure "Unmatched Noexpr")
      | SId v -> match_typ (L.element_type (L.element_type (L.type_of (lookup map v))))
      (* TODO: | SCall(f, _) *)
    in

    let find_str_typ = function
        A.Int -> int_format_str
      | A.Bool -> int_format_str
      | A.String -> string_format_str
      | _ -> raise (Failure "Invalid type")
    in

    (* Construct code for an expression; return its value *)
    let rec build_expr builder map ((_, e) : sexpr) = match e with
        SIntLit i  -> L.const_int i32_t i
      | SBoolLit b  -> L.const_int i1_t (if b then 1 else 0)
      | SStringLit s -> L.build_global_stringptr s "str" builder
      | SId s       -> L.build_load (lookup map s) s builder
      | SAssign (s, e) -> let e' = build_expr builder map e in
        ignore(L.build_store e' (lookup map s) builder); e'
      | SNoexpr -> L.const_int i32_t 0
      | SBinop (e1, op, e2) ->
        let e1' = build_expr builder map e1
        and e2' = build_expr builder map e2 in
        (match op with
           A.Add     -> L.build_add
         (* | A.Sub     -> L.build_sub
         | A.And     -> L.build_and
         | A.Or      -> L.build_or
         | A.Equal   -> L.build_icmp L.Icmp.Eq
         | A.Neq     -> L.build_icmp L.Icmp.Ne
         | A.Less    -> L.build_icmp L.Icmp.Slt *)
        ) e1' e2' "tmp" builder
      | SCall ("print", [e]) ->
        let (_, ex) = e in
        let e_typ = find_type map ex in
        L.build_call printf_func [| (find_str_typ e_typ) ; (build_expr builder map e) |]
          "printf" builder
      | SCall (f, args) ->
        let (fdef, fdecl) = StringMap.find f function_decls in
        let llargs = List.rev (List.map (build_expr builder map) (List.rev args)) in
        let result = (match fdecl.srtyp with 
             A.Void -> ""
            | _ -> f ^ "_result") in
        L.build_call fdef (Array.of_list llargs) result builder
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
      (* | SReturn e -> ignore(L.build_ret (build_expr builder e) builder); builder *)
      | SDecAssn ((t, n), expr) -> (builder, 
        let e' = build_expr builder vars expr
        in L.set_value_name n e';
        let local_var = L.build_alloca (ltype_of_typ t) n builder
        in ignore (L.build_store e' local_var builder);
        StringMap.add n local_var vars)
      | SIf (predicate, then_stmt, else_stmt) ->
        let bool_val = build_expr builder vars predicate in

        let then_bb = L.append_block context "then" the_function in
        ignore (fst (build_stmt ((L.builder_at_end context then_bb), vars) then_stmt));
        let else_bb = L.append_block context "else" the_function in
        ignore (fst (build_stmt ((L.builder_at_end context then_bb), vars) else_stmt));

        let end_bb = L.append_block context "if_end" the_function in
        let build_br_end = L.build_br end_bb in (* partial function *)
        add_terminal (L.builder_at_end context then_bb) build_br_end;
        add_terminal (L.builder_at_end context else_bb) build_br_end;

        ignore(L.build_cond_br bool_val then_bb else_bb builder);
        (L.builder_at_end context end_bb, vars)

      (* | SWhile (predicate, body) ->
        let while_bb = L.append_block context "while" the_function in
        let build_br_while = L.build_br while_bb in (* partial function *)
        ignore (build_br_while builder);
        let while_builder = L.builder_at_end context while_bb in
        let bool_val = build_expr while_builder predicate in

        let body_bb = L.append_block context "while_body" the_function in
        add_terminal (build_stmt (L.builder_at_end context body_bb) body) build_br_while;

        let end_bb = L.append_block context "while_end" the_function in

        ignore(L.build_cond_br bool_val body_bb end_bb while_builder);
        L.builder_at_end context end_bb *)

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