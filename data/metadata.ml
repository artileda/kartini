
type t = {
  name: string;
  version: string;
}[@@deriving yaml];;

let t_to_str t =
  Yaml.to_string (to_yaml t)
;;
  