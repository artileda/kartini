open Data
open Utils
let metadata_yaml = (File.read "../../../testbed/metadata.yml");;

let get_parsed = Result.get_ok (Metadata.str_to_t metadata_yaml);;


let () = Metadata.inspect_t get_parsed;;

(*

open Data__Metadata;;
open Utils__File;;

let x = read "./testbed/metadata.yml";;
let y = str_to_t x;;
let z = Result.get_ok y;;

*)