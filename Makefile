# "make all" to compile sage and run hello world test file, sage.tb
.PHONY: all clean native sageexec

VPATH = ./libc/
LIBS = ./libc/

OCAMLBFLAGS 	= -use-ocamlfind -pkgs llvm
OCAMLCFLAGS 	= -w -c
# CFLAGS			=

OCAMLB 			= ocamlbuild $(OCAMLBFLAGS)
OCAMLC 			= ocamlc $(OCAMLCFLAGS)
CC				= cc

all: clean native $(LIBS)stdlibc.o sageexec

native:
	opam exec -- \
	$(OCAMLB) sage.native

%.cmo: %.ml
	$(OCAMLC) $<

%.cmi: %.mli
	$(OCAMLC) $<

stdlibc: $(LIBS)stdlibc.c $(LIBS)stdlibc.o
	$(CC) -o stdlibc -DBUILD_TEST $(LIBS)stdlibc.c

sageexec: native sage.tb
	./sage.native < sage.tb > sage.out

clean:
	$(OCAMLB) -clean
	rm -rf \
	_build ocamlllvm sage.native *.diff *.ll *.out *.o $(LIBS)*.o *.s *.exe testall.log

test: clean native
	./testall.sh