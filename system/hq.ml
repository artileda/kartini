(*

This for bind all path for working storage environment.

Headquarter Spec

KARTINI_PATH -> For local metadata repository
KARTINI_ROOT -> Current system to be operated
KARTINI_CACHE -> For source and binary cache storage path

*)

let sys_path = Sys.getenv_opt "KARTINI_ROOT" ;;

let repository_path = Sys.getenv_opt "KARTINI_PATH" ;;

let cache_path = Sys.getenv_opt "KARTINI_CACHE" ;;

(*
  This function map all operational directory
*)
let map dest =
  let current_pid = string_of_int (Unix.getpid ()) in
  (
    match dest with
      | "installed_metadata" -> ((sys_path |> Option.get) ^ "/var/db/kartini/installed")
      | "tmp_bin" -> ("/var/tmp/kartini/bin-" ^ current_pid)
      | "tmp_src" -> ("/var/tmp/kartini/src-" ^ current_pid)
      | _ -> ""
  )
;;

let check_installed packname =
  let i = (map "installed_metadata_path") ^ "/" ^ packname ^ "/manifest" in
  Sys.file_exists i
;;

let find_repo_package packname =
  let repo_paths = Str.split (Str.regexp ":") (Option.get repository_path) in 
  let founds = List.map (fun m -> (Sys.file_exists (m ^ "/" ^ packname ^ "/metadata.yml")))  repo_paths in

  List.fold_left (fun x y -> x || y) false founds
;;