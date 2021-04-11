
let is_installed x =
  let manifest_path = (Hq.map "target_metadata") in
  match Sys.is_directory manifest_path with 
  | true -> 
      Sys.file_exists (manifest_path ^ "/" ^ x ^ "/metadata")
  | false -> false
;;