export KARTINI_CACHE=$(shell pwd)/container
export KARTINI_PATH=$(shell pwd)/testbed/var/db/musl-repo
export KARTINI_ROOT=/media/elsa/1#$(shell pwd)/root-musl/#
# replace with you target filesystem mounting directory

# Musl option
cc="musl-gcc"
ldd="musl-ldd"

run:
	dune exec kartini

get:
	dune exec kartini -- get $(PACKAGES)

build:
	dune exec kartini -- build $(PACKAGES)

add:
	dune exec kartini -- add $(PACKAGES)

del:
	dune exec kartini -- del $(PACKAGES)

env:
	dune exec kartini -- env

run-test:
	dune test

repl:
	dune utop

install-deps:
	opam install dune ppx_deriving_yaml utop ocaml-lsp-server merlin cmdliner core