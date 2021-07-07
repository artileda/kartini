open System__Hq
open Utils__Process
open System__Repository

let install_time package_name =
  let bin_archive = (map "cache_bin") ^ "/" ^ package_name in
  let package_version = 
    let package , _ = (get_metadata package_name) in 
    package.version in
  let filesystem_path = match sys_path with 
    | Some path -> path
    | None -> failwith "KARTINI_ROOT is not setted."
  in

  (* TODO: Checking Dependecies Phase here *)

  match Sys.is_directory bin_archive with 
  | true -> (execute_external "tar" [|"xf";(bin_archive ^ "/" ^ package_version ^".tar.xz");"-C";filesystem_path|] [||] |> ignore)
  | false -> ()
;;