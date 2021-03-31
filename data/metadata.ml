
type t = {
  name: string;
  version: string;
  description: string;
  src: string list;
}[@@deriving yaml];;

let t_to_str t =
   match Yaml.to_string (to_yaml t) with
   | Ok res -> Ok res
   | Error msg ->
      match msg with
      | `Msg res -> Error res
;;

let str_to_t t =
  let parsed_string = (match (Yaml.of_string t) with 
  | Ok h -> (of_yaml h)
  | Error e -> Error e) in

  match parsed_string with 
  | Ok res -> Ok res
  | Error msg -> 
    match msg with
    | `Msg res -> Error res
;;


  