open Data__Metadata
open Utils__Process
open System__Hq

(* Untested and unfinished *)
let grab_source t =
  let c = ((map "cache_src") ^ "/" ^ t.name) in 

  Sys.mkdir c 0555;
  
  match Sys.is_directory c with 
  | true ->
    List.iter (fun (x: src_types) -> 
      match x with
      | RemoteArchive (source,_) -> 
        (Interop.wget_get source (c ^ "/" ^ (filename source)) ) 
        |> ignore
      | RemoteFile (source,_) -> 
        (Interop.wget_get source (c ^ "/" ^ (filename source)) ) 
        |> ignore
      | LocalFile (source,_) -> 
        (Interop.copy_file source (c ^ "/" ^ (filename source)))
        |> ignore
      | _ -> ()
      ) (get_src t)
  | false -> ()

;; 

