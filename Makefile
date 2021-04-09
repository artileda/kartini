run:
	dune exec kartini

run-test:
	dune test

install-deps:
	opam install dune ppx_deriving_yaml utop ocaml-lsp-server merlin