open Data__Metadata
open Utils__Process
open Utils__File
open System__Hq
open System__Repository

(* Untested and unfinished *)
let grab_source t repo_path=
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
        (Interop.copy_file (repo_path ^ source) (c ^ "/" ^ (filename source)))
        |> ignore
      | _ -> ()
      ) (get_src t)
  | false -> ()

;; 

let get_time package_name = 
  let package, metadata_path = get_metadata package_name in 
  grab_source package metadata_path;
;;