# "make all" to compile sage and run hello world test file, sage.tb
.PHONY: all clean native sageexec

VPATH = ./libc/
DLIB = ./libc/
DLOG = ./logs/
DTESTS = ./tests/
BASICTESTS = ./tests/basic/
TESTFILES = ./tests/tests/
FAILTESTS = ./tests/checkfail/
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
	*.ll *.log $(DLOG)*.log parser.ml parser.mli *.out *.o $(BUILD)*.o $(DLIB)*.o *.s *.exe

test: clean native testall

testall:
	./testall.sh

basic: clean
	./testbasic.sh

# basicdir = ./tests/basic 
# basic-tests := $(addsuffix .test, $(basename $(wildcard *.test-in)))


# ./testall.sh $(DTESTS)

# .PHONY : test all %.test

# BC := /usr/bin/bc

# test : $(all-tests)

# %.test : %.test-in %.test-cmp $(BC)
#     @$(BC) <$< 2>&1 | diff -q $(word 2, $?) - >/dev/null || \
#     (echo "Test $@ failed" && exit 1)

# all : test
#     @echo "Success, all tests passed."