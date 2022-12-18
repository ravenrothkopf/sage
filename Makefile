# "make all" to compile sage and run hello world test file, sage.tb
all: sage.native
.PHONY : all
# test2.native sage.out

# test2.native:
sage.native:
	opam exec -- \
	ocamlbuild -use-ocamlfind -pkgs llvm sage.native
# ocamlbuild -use-ocamlfind test2.native

%.cmo : %.ml
	ocamlc -w -c $<

%.cmi : %.mli
	ocamlc -w -c $<

.PHONY : clean
clean :
	ocamlbuild -clean
	rm -rf ocamlllvm *.diff
	rm -rf \
	_build sage.native *.ll *.out *.o *.s *.exe testall.log
# _build test2.native *.ll *.out *.o *.s *.exe testall.log

sage.out : sage.native sage.tb
	./sage.native < sage.tb > sage.out

test : all
	tests/testall.sh