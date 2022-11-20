type token =
  | NEWLINE
  | LPAREN
  | RPAREN
  | PLUS
  | ASSIGN
  | TAB
  | SPACE
  | STRING
  | INT
  | FLOAT
  | BOOL
  | FUNCT
  | COLON
  | COMMA
  | ILIT of (int)
  | FLIT of (float)
  | BLIT of (bool)
  | SLIT of (string)
  | ID of (string)
  | EOF
  | NoOp

open Parsing;;
let _ = parse_error;;
# 2 "parser.mly"
open Ast
# 29 "parser.ml"
let yytransl_const = [|
  257 (* NEWLINE *);
  258 (* LPAREN *);
  259 (* RPAREN *);
  260 (* PLUS *);
  261 (* ASSIGN *);
  262 (* TAB *);
  263 (* SPACE *);
  264 (* STRING *);
  265 (* INT *);
  266 (* FLOAT *);
  267 (* BOOL *);
  268 (* FUNCT *);
  269 (* COLON *);
  270 (* COMMA *);
    0 (* EOF *);
  276 (* NoOp *);
    0|]

let yytransl_block = [|
  271 (* ILIT *);
  272 (* FLIT *);
  273 (* BLIT *);
  274 (* SLIT *);
  275 (* ID *);
    0|]

let yylhs = "\255\255\
\001\000\002\000\002\000\002\000\002\000\003\000\005\000\005\000\
\005\000\005\000\004\000\007\000\007\000\009\000\009\000\010\000\
\008\000\008\000\008\000\008\000\008\000\011\000\006\000\006\000\
\006\000\006\000\006\000\006\000\006\000\006\000\006\000\012\000\
\012\000\013\000\013\000\000\000"

let yylen = "\002\000\
\002\000\000\000\003\000\002\000\002\000\004\000\001\000\001\000\
\001\000\001\000\009\000\000\000\001\000\001\000\003\000\002\000\
\000\000\004\000\004\000\002\000\003\000\001\000\001\000\003\000\
\001\000\003\000\003\000\004\000\001\000\001\000\001\000\000\000\
\001\000\001\000\003\000\002\000"

let yydefred = "\000\000\
\000\000\000\000\000\000\007\000\008\000\009\000\010\000\036\000\
\000\000\000\000\000\000\000\000\005\000\001\000\000\000\004\000\
\000\000\000\000\003\000\000\000\000\000\000\000\000\000\029\000\
\030\000\031\000\000\000\000\000\006\000\000\000\000\000\013\000\
\000\000\000\000\000\000\000\000\000\000\016\000\000\000\000\000\
\027\000\026\000\000\000\000\000\033\000\024\000\000\000\015\000\
\000\000\028\000\000\000\035\000\000\000\000\000\011\000\020\000\
\000\000\000\000\000\000\022\000\000\000\021\000\000\000\000\000\
\018\000\019\000"

let yydgoto = "\002\000\
\008\000\009\000\010\000\011\000\012\000\043\000\031\000\055\000\
\032\000\033\000\061\000\044\000\045\000"

let yysindex = "\006\000\
\046\255\000\000\046\255\000\000\000\000\000\000\000\000\000\000\
\013\000\033\255\046\255\249\254\000\000\000\000\046\255\000\000\
\003\255\039\255\000\000\049\255\021\255\050\255\021\255\000\000\
\000\000\000\000\042\255\004\255\000\000\043\255\045\255\000\000\
\038\255\060\255\047\255\021\255\021\255\000\000\051\255\050\255\
\000\000\000\000\052\255\064\255\000\000\000\000\067\255\000\000\
\021\255\000\000\044\255\000\000\044\255\009\255\000\000\000\000\
\044\255\068\255\053\255\000\000\069\255\000\000\044\255\044\255\
\000\000\000\000"

let yyrindex = "\000\000\
\071\000\000\000\071\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\071\000\000\000\000\000\000\000\071\000\000\000\
\000\000\000\000\000\000\000\000\000\000\070\255\000\000\000\000\
\000\000\000\000\028\255\029\255\000\000\000\000\000\000\000\000\
\071\255\000\000\000\000\072\255\000\000\000\000\000\000\000\000\
\000\000\000\000\073\255\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\001\000\000\000\001\000\000\000\000\000\000\000\
\001\000\000\000\000\000\000\000\000\000\000\000\001\000\001\000\
\000\000\000\000"

let yygindex = "\000\000\
\000\000\038\000\023\000\000\000\237\255\235\255\000\000\207\255\
\039\000\000\000\000\000\000\000\029\000"

let yytablesize = 268
let yytable = "\029\000\
\017\000\034\000\030\000\056\000\017\000\036\000\001\000\062\000\
\037\000\057\000\023\000\018\000\014\000\065\000\066\000\046\000\
\004\000\005\000\006\000\007\000\030\000\020\000\023\000\024\000\
\025\000\026\000\027\000\028\000\025\000\023\000\025\000\023\000\
\060\000\015\000\059\000\024\000\025\000\026\000\027\000\028\000\
\013\000\025\000\023\000\021\000\053\000\035\000\003\000\039\000\
\016\000\054\000\022\000\040\000\019\000\004\000\005\000\006\000\
\007\000\004\000\005\000\006\000\007\000\038\000\041\000\047\000\
\042\000\049\000\050\000\051\000\063\000\064\000\002\000\018\000\
\012\000\014\000\032\000\034\000\058\000\052\000\048\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\017\000\017\000\017\000\017\000"

let yycheck = "\021\000\
\000\000\023\000\022\000\053\000\012\001\002\001\001\000\057\000\
\005\001\001\001\002\001\019\001\000\000\063\000\064\000\037\000\
\008\001\009\001\010\001\011\001\040\000\019\001\002\001\015\001\
\016\001\017\001\018\001\019\001\001\001\001\001\003\001\003\001\
\054\000\001\001\054\000\015\001\016\001\017\001\018\001\019\001\
\003\000\014\001\014\001\005\001\001\001\004\001\001\001\003\001\
\011\000\006\001\002\001\014\001\015\000\008\001\009\001\010\001\
\011\001\008\001\009\001\010\001\011\001\019\001\003\001\013\001\
\018\001\014\001\003\001\001\001\001\001\001\001\000\000\019\001\
\003\001\003\001\003\001\003\001\054\000\049\000\040\000\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\008\001\009\001\010\001\011\001"

let yynames_const = "\
  NEWLINE\000\
  LPAREN\000\
  RPAREN\000\
  PLUS\000\
  ASSIGN\000\
  TAB\000\
  SPACE\000\
  STRING\000\
  INT\000\
  FLOAT\000\
  BOOL\000\
  FUNCT\000\
  COLON\000\
  COMMA\000\
  EOF\000\
  NoOp\000\
  "

let yynames_block = "\
  ILIT\000\
  FLIT\000\
  BLIT\000\
  SLIT\000\
  ID\000\
  "

let yyact = [|
  (fun _ -> failwith "parser")
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'decls) in
    Obj.repr(
# 27 "parser.mly"
            ( _1 )
# 219 "parser.ml"
               : Ast.program))
; (fun __caml_parser_env ->
    Obj.repr(
# 30 "parser.mly"
                 ( ([], []) )
# 225 "parser.ml"
               : 'decls))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'vdecl) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'decls) in
    Obj.repr(
# 31 "parser.mly"
                         ( ((_1 :: fst _3), snd _3) )
# 233 "parser.ml"
               : 'decls))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'fdecl) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'decls) in
    Obj.repr(
# 32 "parser.mly"
                 ( (fst _2, (_1 :: snd _2)) )
# 241 "parser.ml"
               : 'decls))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'decls) in
    Obj.repr(
# 33 "parser.mly"
                 ( (fst _2, snd _2) )
# 248 "parser.ml"
               : 'decls))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : 'typ) in
    let _2 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 37 "parser.mly"
                     ( (_1, _2, _4) )
# 257 "parser.ml"
               : 'vdecl))
; (fun __caml_parser_env ->
    Obj.repr(
# 40 "parser.mly"
         ( String )
# 263 "parser.ml"
               : 'typ))
; (fun __caml_parser_env ->
    Obj.repr(
# 41 "parser.mly"
      ( Int )
# 269 "parser.ml"
               : 'typ))
; (fun __caml_parser_env ->
    Obj.repr(
# 42 "parser.mly"
        ( Float )
# 275 "parser.ml"
               : 'typ))
; (fun __caml_parser_env ->
    Obj.repr(
# 43 "parser.mly"
       ( Bool )
# 281 "parser.ml"
               : 'typ))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 8 : 'typ) in
    let _3 = (Parsing.peek_val __caml_parser_env 6 : string) in
    let _5 = (Parsing.peek_val __caml_parser_env 4 : 'formals_opt) in
    let _9 = (Parsing.peek_val __caml_parser_env 0 : 'decls_inside) in
    Obj.repr(
# 48 "parser.mly"
  (
    {
      rtyp=_1;
      fname=_3;
      formals=_5;
      locals=fst _9;
      body=snd _9
    }
  )
# 299 "parser.ml"
               : 'fdecl))
; (fun __caml_parser_env ->
    Obj.repr(
# 60 "parser.mly"
                  ( [] )
# 305 "parser.ml"
               : 'formals_opt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'formals_list) in
    Obj.repr(
# 61 "parser.mly"
                 ( _1 )
# 312 "parser.ml"
               : 'formals_opt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'parameter_decl) in
    Obj.repr(
# 64 "parser.mly"
                                      ( [_1] )
# 319 "parser.ml"
               : 'formals_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'parameter_decl) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'formals_list) in
    Obj.repr(
# 65 "parser.mly"
                                      ( _1::_3 )
# 327 "parser.ml"
               : 'formals_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'typ) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 68 "parser.mly"
         ( (_1, _2) )
# 335 "parser.ml"
               : 'parameter_decl))
; (fun __caml_parser_env ->
    Obj.repr(
# 71 "parser.mly"
                                   ( ([], [])                 )
# 341 "parser.ml"
               : 'decls_inside))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : 'vdecl) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : 'decls_inside) in
    Obj.repr(
# 72 "parser.mly"
                                   ( ( (_2 :: fst _4), snd _4) )
# 349 "parser.ml"
               : 'decls_inside))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : 'stmt) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : 'decls_inside) in
    Obj.repr(
# 73 "parser.mly"
                                   ( ( fst _4, (_2 :: snd _4)) )
# 357 "parser.ml"
               : 'decls_inside))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'decls_inside) in
    Obj.repr(
# 74 "parser.mly"
                         ( (fst _2, snd _2) )
# 364 "parser.ml"
               : 'decls_inside))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'decls_inside) in
    Obj.repr(
# 75 "parser.mly"
                             ( (fst _3, snd _3) )
# 371 "parser.ml"
               : 'decls_inside))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 78 "parser.mly"
                                         ( Expr(_1) )
# 378 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 81 "parser.mly"
                              ( Id(_1) )
# 385 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 82 "parser.mly"
                              ( Assign(_1, _3) )
# 393 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 83 "parser.mly"
                              ( StringLit(_1) )
# 400 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 84 "parser.mly"
                              ( Binop(StringLit(_1), Concat, StringLit(_1)) )
# 408 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'expr) in
    Obj.repr(
# 85 "parser.mly"
                              ( _2 )
# 415 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : 'args_opt) in
    Obj.repr(
# 86 "parser.mly"
                              ( Call(_1, _3) )
# 423 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 87 "parser.mly"
                              ( IntLit(_1) )
# 430 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : float) in
    Obj.repr(
# 88 "parser.mly"
                              ( FloatLit(_1) )
# 437 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : bool) in
    Obj.repr(
# 89 "parser.mly"
                              ( BoolLit(_1) )
# 444 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    Obj.repr(
# 93 "parser.mly"
               ( [] )
# 450 "parser.ml"
               : 'args_opt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'args) in
    Obj.repr(
# 94 "parser.mly"
               ( _1 )
# 457 "parser.ml"
               : 'args_opt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 97 "parser.mly"
                    ( [_1] )
# 464 "parser.ml"
               : 'args))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'args) in
    Obj.repr(
# 98 "parser.mly"
                    ( _1::_3 )
# 472 "parser.ml"
               : 'args))
(* Entry program *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
|]
let yytables =
  { Parsing.actions=yyact;
    Parsing.transl_const=yytransl_const;
    Parsing.transl_block=yytransl_block;
    Parsing.lhs=yylhs;
    Parsing.len=yylen;
    Parsing.defred=yydefred;
    Parsing.dgoto=yydgoto;
    Parsing.sindex=yysindex;
    Parsing.rindex=yyrindex;
    Parsing.gindex=yygindex;
    Parsing.tablesize=yytablesize;
    Parsing.table=yytable;
    Parsing.check=yycheck;
    Parsing.error_function=parse_error;
    Parsing.names_const=yynames_const;
    Parsing.names_block=yynames_block }
let program (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 1 lexfun lexbuf : Ast.program)
