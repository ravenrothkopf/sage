# "make all" to compile sage and run hello world test file, sage.tb
.PHONY: all clean native sageexec

VPATH = ./libc/
DLIB = ./libc/
DLOG = ./logs/
SRC = ./src/
DTEMP = ./tests/

OCAMLBFLAGS 	= -use-ocamlfind -pkgs llvm
OCAMLCFLAGS 	= -w -c
# CFLAGS			=

OCAMLB 			= ocamlbuild $(OCAMLBFLAGS)
OCAMLC 			= ocamlc $(OCAMLCFLAGS)
CC				= cc

all: clean native $(DLIB)stdlibc.o sageexec

native:
	opam exec -- \
	$(OCAMLB) sage.native

%.cmo: %.ml
	$(OCAMLC) $<

%.cmi: %.mli
	$(OCAMLC) $<

stdlibc: $(DLIB)stdlibc.c $(DLIB)stdlibc.o
	$(CC) -o stdlibc -DBUILD_TEST $(DLIB)stdlibc.c

sageexec: native sage.tb
	./sage.native < sage.tb > sage.out

clean:
	$(OCAMLB) -clean
	rm -rf \
	_build ocamlllvm sage.native *.diff *.err $(DLOG)*.err \
	*.ll *.log $(DLOG)*.log *.out *.o $(DLIB)*.o *.s *.exe

test: clean native
	./testall.sh