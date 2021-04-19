export KARTINI_CACHE=$(shell pwd)/container
export KARTINI_PATH=$(shell pwd)/testbed/var/db/repo
export KARTINI_ROOT=$(shell pwd)/container

run:
	dune exec kartini

get:
	dune exec kartini -- get $(PACKAGES)

build:
	dune exec kartini -- build $(PACKAGES)

env:
	dune exec kartini -- env

run-test:
	dune test

repl:
	dune utop

install-deps:
	opam install dune ppx_deriving_yaml utop ocaml-lsp-server merlin cmdliner