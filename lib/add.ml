open System__Hq
open Utils__Process
open System__Repository
(* open Utils__File *)
(* open Utils__File *)
(* open Data__Metadata *)

let install_time package_name =
  let bin_archive = (map "cache_bin") ^ "/" ^ package_name in
  let package_version = (get_metadata package_name).version in

  match Sys.is_directory bin_archive with 
  | true -> (execute_external "tar" [|"xf";(bin_archive ^ "/" ^ package_version ^".tar.xz")|] [||] |> ignore)
  | false -> ()
;;