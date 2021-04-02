open Data
open Utils
let metadata_yaml = (File.read "../../../testbed/metadata.yml");;

let get_parsed = Result.get_ok (Metadata.str_to_t metadata_yaml);;



let () = match (Metadata.str_to_t metadata_yaml) with 
  | Ok res -> 
     (match (Metadata.t_to_str res) with 
     | Ok d -> print_endline d
     | Error d -> print_endline d)
  | Error d -> print_endline d
;;