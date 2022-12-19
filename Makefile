# "make all" to compile sage and run hello world test file, sage.tb
.PHONY: all clean native sageexec

VPATH = ./libc/
DLIB = ./libc/
DLOG = ./logs/
SRC = ./src/
BUILD = ./_build/

OCAMLBFLAGS 	= -use-ocamlfind -pkgs llvm
OCAMLCFLAGS 	= -w -c
CFLAGS			= -std=c99 -Wall -W
DBFLAGS			= -DBUILD_TEST

OCAMLB 			= ocamlbuild $(OCAMLBFLAGS)
OCAMLC 			= ocamlc $(OCAMLCFLAGS)
CC				= gcc $(CFLAGS)

all: clean native stdlibc sageexec

native:
	opam exec -- \
	$(OCAMLB) sage.native

%.cmo: %.ml
	$(OCAMLC) $<

%.cmi: %.mli
	$(OCAMLC) $<

stdlibc: $(DLIB)stdlibc.o $(DLIB)stdlibc.c
	$(CC) -c $(DLIB)stdlibc.c -o $(BUILD)stdlibc.o

sageexec: native sage.tb
	./sage.native < sage.tb > sage.out

clean:
	$(OCAMLB) -clean
	rm -rf \
	_build ocamlllvm sage.native *.diff *.err $(DLOG)*.err \
	*.ll *.log $(DLOG)*.log *.out *.o $(BUILD)*.o *.s *.exe

test: clean native testall

testall:
	./testall.sh