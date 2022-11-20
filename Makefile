# "make all" to compile sage and run hello world test file, sage.tb
all: test2.native sage.out

test2.native:
	opam exec -- \
	rm -f *.o
	ocamlbuild -use-ocamlfind test2.native

.PHONY: clean
clean: 
	ocamlbuild -clean
	rm -rf _build

sage.out : test2.native sage.tb
	./test2.native < sage.tb > sage.out
