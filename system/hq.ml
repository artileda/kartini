(*

This for bind all path for working storage environment.

Headquarter Spec

KARTINI_PATH -> For local metadata repository
KARTINI_ROOT -> Current system to be operated
KARTINI_CACHE -> For source and binary cache storage path

*)

open Utils__Map

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
      | "target" -> Option.get sys_path
      | "target_metadata" -> ((sys_path |> Option.get) ^ "/var/db/kartini/installed")
      | "tmp_bin" -> ("/var/tmp/kartini/bin-" ^ current_pid)
      | "tmp_src" -> ("/var/tmp/kartini/src-" ^ current_pid)
      | "cache_src" -> ((cache_path |> Option.get) ^ "/kartini/src")
      | "cache_bin" -> ((cache_path |> Option.get) ^ "/kartini/bin")
      | _ -> ""
  )
;;


let check_installed packname =
  let i = (map "installed_metadata_path") ^ "/" ^ packname ^ "/manifest" in
  Sys.file_exists i
;;

(*
This to check is package source and binary archive are cached 
*)
let is_cached packname = 
  let src_cached = Sys.is_directory (("cache_src"|> map) ^ "/" ^ packname) in
  let bin_cached = Sys.is_directory (("cache_bin"|> map) ^ "/" ^ packname) in
  (bin_cached , src_cached)
;;

let find_repo_package packname =
  let repo_paths = 
    match repository_path with
     | Some d ->  Str.split (Str.regexp ":") d
     | None -> failwith "Repository path is unset, set KARTINI_PATH first." 
  in
  map_partial (fun m -> 
      let path = m ^ "/" ^ packname ^ "/metadata.yml" in
      match (Sys.file_exists (path)) with
        | true -> Some path 
        | false -> None
  ) repo_paths
;;