open Data__Metadata
open Utils__Process
open Utils__File
open System__Hq

(* Untested and unfinished *)
let grab_source t =
  let c = ((map "cache_src") ^ "/" ^ t.name) in 

  mkdir_p c;
  
  match Sys.is_directory c with 
  | true ->
    List.iter (fun (x: src_types) -> 
      match x with
      | RemoteArchive (source,_) -> 
        (Interop.curl_get source (c ^ "/" ^ (filename source)) ) 
        |> ignore
      | RemoteFile (source,_) -> 
        (Interop.curl_get source (c ^ "/" ^ (filename source)) ) 
        |> ignore
      | LocalFile (source,_) -> 
        (Interop.copy_file source (c ^ "/" ^ (filename source)))
        |> ignore
      | _ -> ()
      ) (get_src t)
  | false -> ()

;; 

let get_time package_name = 
  let repo_path = find_repo_package package_name in
  let metadata_path = (
    match repo_path |> List.length with 
      | 0 -> failwith "Package not found on KARTINI_PATH"
      | _ -> List.hd repo_path
  ) in
  let descriptor = file_to_t metadata_path in 

  grab_source descriptor
;;