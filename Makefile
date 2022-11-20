# "make all" to compile sage and run hello world test file, sage.tb
all: test.native sage.out

test.native:
	opam exec -- \
	rm -f *.o
	ocamlbuild -use-ocamlfind test.native

.PHONY: clean
clean: 
	ocamlbuild -clean
	rm -rf _build

sage.out : test.native sage.tb
	./test.native < sage.tb > sage.out
