# "make all" to compile sage and run hello world test file, sage.tb
.PHONY: all clean native sageexec stdlibc

VPATH = libs

OCAMLB_FLAGS 	= -use-ocamlfind -pkgs -libs $(LIBC) llvm
OCAMLC_FLAGS 	= -w -custom
OCMLF_FLAGS 	= ocamlopt -c -package llvm
C_FLAGS 		= -o
#OCAMLC_LIB_FLAGS = -a

OCAMLB 			= ocamlbuild $(OCAMLB_FLAGS)
OCAMLC 			= ocamlc $(OCAMLC_FLAGS)
OCAMLFIND 		= ocamlfind $(OCMLF_FLAGS)
CC 				= cc $(C_FLAGS)

all: clean native sageexec

native:
	opam exec -- \
	$(OCAMLB) sage.native

%.cmo: %.ml
	$(OCAMLC) $<

%.cmi: %.mli
	$(OCAMLC) $<

%.cmx: %.ml
	$(OCAMLFIND) $<

clean:
	$(OCAMLB) -clean
	rm -rf ocamlllvm *.diff
	rm -rf \
	_build sage.native *.out *.o *.s *.exe testall.log

sageexec: native sage.tb
	./sage.native < sage.tb > sage.out

stdlibc: stdlibc.c
	$(CC) stdlibc -DBUILD_TEST stdlibc.c

test: clean native
	./testall.sh