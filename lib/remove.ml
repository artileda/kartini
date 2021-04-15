open System__Hq
open Utils__File

let remove_time package =
  let path = ((map "target") ^ "/var/db/kartini/installed/" ^ package) in
  match Sys.is_directory path with
  | true ->
    let manifest = read (path ^ "/index") in
    let splited_manifest = Str.split_delim (Str.regexp "\n") manifest in
    List.iter (
      fun x ->
        Sys.remove ((map "target") ^ "/" ^ x)
    ) splited_manifest
    |> ignore
  | false -> ()
;;