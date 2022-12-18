# "make all" to compile sage and run hello world test file, sage.tb
.PHONY: all clean native sageexec

OCAMLB_FLAGS = -use-ocamlfind -pkgs llvm
OCAMLC_FLAGS = -w -c

OCAMLB = ocamlbuild $(OCAMLB_FLAGS)
OCAMLC = ocamlc $(OCAMLC_FLAGS)

all: clean native sageexec

native:
	opam exec -- \
	$(OCAMLB) sage.native

%.cmo: %.ml
	$(OCAMLC) $<

%.cmi : %.mli
	$(OCAMLC) $<

clean:
	$(OCAMLB) -clean
	rm -rf \
	_build ocamlllvm sage.native *.diff *.ll *.out *.o *.s *.exe testall.log

sageexec: native sage.tb
	./sage.native < sage.tb > sage.out

test: clean native
	./testall.sh