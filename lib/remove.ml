open System__Hq
open Utils__File

let remove_time package =
  let path = ((map "target") ^ "/var/db/kartini/installed/" ^ package) in
  match Sys.is_directory path with
  | true ->
    let manifest = read (path ^ "/manifest") in
    let splited_manifest = Str.split_delim (Str.regexp "\n") manifest in
    List.iter (
      fun x ->
        let path = (map "target") ^ "/" ^ x in
          if not (Sys.file_exists path) then ()
          else if not (Sys.is_directory path) then Sys.remove path
    ) splited_manifest
    |> ignore
  | false -> ()
;;