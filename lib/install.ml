open System__Hq
open Utils__Process
(* open Utils__File *)
(* open Data__Metadata *)

let install_time package_name =
  let bin_archive = (map "cache_bin") ^ "/" ^ package_name in

  match Sys.is_directory bin_archive with 
  | true -> (execute_external "tar" [|"xf";(bin_archive ^ "/" ^ "bin.tar.xz")|] [||] |> ignore)
  | false -> ()
;;