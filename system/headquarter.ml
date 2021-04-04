(*

This for bind all path for working storage environment.

Headquarter Spec

KARTINI_PATH -> For local metadata repository
KARTINI_ROOT -> Current system to be operated
KARTINI_CACHE -> For source and binary cache storage path

*)

let sys_path = Sys.getenv_opt "KARTINI_ROOT" ;;

let repository_path = Sys.getenv_opt "KARTINI_PATH" ;;

let cache_path = Sys.getenv_opt "KARTINI_PATH" ;;

let map dest =
  (
    match dest with
      | "installed_metadata_path" -> ((sys_path |> Option.get) ^ "/var/db/kartini/installed")
      | _ -> ""
  )
;;
