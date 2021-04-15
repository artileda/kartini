KARTINI_CACHE=$(pwd)/../container
KARTINI_PATH="$(pwd)/../tesbed" 

run:
	dune exec kartini

run-test:
	dune test

install-deps:
	opam install dune ppx_deriving_yaml utop ocaml-lsp-server merlin cmdliner