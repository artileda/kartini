open Utils__Map
open Data__Metadata

let find_repo_package packname =
  let repo_paths = 
    match Hq.repository_path with
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

let get_metadata package_name = 
  let repo_path = find_repo_package package_name in
  let metadata_path = (
    match repo_path |> List.length with 
      | 0 -> failwith "Package not found on KARTINI_PATH"
      | _ -> List.hd repo_path
  ) in
  file_to_t metadata_path
;;

