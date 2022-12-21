# "make all" to compile sage and run hello world test file, sage.tb
.PHONY: all clean native sageexec stdlibc zip

VPATH 	= ./libc/
DLIB 	= ./libc/
DLOG 	= ./logs/
DTESTS 	= ./tests/
SRC 	= ./src/
BUILD 	= ./_build/
DEMO	= /demo/
ROOTDIR	= ./sage/

OCAMLB_FLAGS 	= -use-ocamlfind -pkgs llvm
OCAMLC_FLAGS 	= -w -c
CFLAGS			= -std=c99 -Wall -W
DBFLAGS			= -DBUILD_TEST

OCAMLB 			= ocamlbuild $(OCAMLB_FLAGS)
OCAMLC 			= ocamlc $(OCAMLC_FLAGS)
CC 				= gcc $(C_FLAGS)

all: clean native stdlibc sageexec

demo: native
	./rundemo.sh

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
	$(BUILD) ocamlllvm sage.native *.diff *.err $(DLOG)*.err \
	*.ll *.log $(DLOG)*.log parser.ml *.mli *.out *.o $(BUILD)*.o $(DLIB)*.o *.s *.exe

test: clean native testall

tests:
	./tests.sh

basic:
	./testbasic.sh

testfail:
	./testerrors.sh

testall: clean native
	./testall.sh

TARFILES = 	ast.ml irgen.ml parser.mly sage.ml sast.ml scanner.mll semant.ml \
			Makefile README.md testall.sh testbasic.sh testerrors.sh tests.sh \
			$(DLIB) $(DTESTS) $(DLOG) $(DEMO)

REPORT 	  = ast.ml irgen.ml parser.mly sage.ml sast.ml scanner.mll semant.ml \
			Makefile README.md testall.sh testbasic.sh testerrors.sh tests.sh \
			$(DLIB) $(DTESTS) $(DLOG) $(DEMO) *.pdf

# zips proj files together
zip:
	zip ../sage.tar.gz $(TARFILES)

# zips proj + report files
zipfr:
	zip ../sage.tar.gz $(REPORT)