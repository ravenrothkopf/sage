%{ open Ast %}

%token NEWLINE LPAREN RPAREN PLUS ASSIGN
%token STRING
%token <string> ID
%token EOF

%start program_rule
%type <Ast.program> program_rule

%right ASSIGN
%left PLUS

%%

program_rule:
  vdecl_list_rule stmt_list_rule EOF { {locals=$1; body=$2} }

vdecl_list_rule:
  /*nothing*/                   { []       }
  | vdecl_rule vdecl_list_rule  { $1 :: $2 }

vdecl_rule:
  typ_rule ID NEWLINE { ($1, $2) }

typ_rule:
  STRING { String  }

stmt_list_rule:
    /* nothing */               { []     }
    | stmt_rule stmt_list_rule  { $1::$2 }

stmt_rule:
  expr_rule NEWLINE               { Expr $1         }

expr_rule:
  | STRING                        { String $1                }
  | ID                            { Id $1                 }
  | STRING PLUS STRING            { Concat ($1, $3)   }
  | ID ASSIGN expr_rule           { Assign ($1, $3)       }
  | LPAREN expr_rule RPAREN       { $2                    }
