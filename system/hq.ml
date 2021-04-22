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
      | "target" -> Option.get sys_path
      | "target_metadata" -> ((sys_path |> Option.get) ^ "/var/db/kartini/installed")
      | "tmp_bin" -> ("/var/tmp/kartini/bin-" ^ current_pid)
      | "tmp_src" -> ("/var/tmp/kartini/src-" ^ current_pid)
      | "tmp_dir" -> ("/var/tmp/kartini")
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


(* 
  Still mistery, why this function need a parameter,
  but this function run when no one invoking it.*)
let check_env ()=
  match sys_path with
  | Some d -> 
      print_endline ("KARTINI_ROOT: " ^ d);
      (match repository_path with
      | Some d -> 
        print_endline ("KARTINI_PATH: " ^ d);
        (match cache_path with
        | Some d -> print_endline ("KARTINI_CACHE: " ^ d)
        | None -> failwith "KARTINI_CACHE not setted, this is for archiving package resource and it binary form." |> ignore)
        ;
      | None -> failwith "KARTINI_PATH not setted, this is path for your repository definition")
       |> ignore;
  | None -> failwith "KARTINI_ROOT not setted, this is path for your target installation."
    |> ignore;
;;

