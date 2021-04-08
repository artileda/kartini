open Data__Metadata
open Utils__Process
open System__Hq

(* Untested and unfinished *)
let grab_source t =
  let cwd = ((map "cache_src") ^ "/" ^ t.name) in
  let sources = get_src t in 
  (* let length = List.length sources in *)
  let get_filename src_url = src_url 
  |> Str.split_delim (Str.regexp "/")
  |> List.rev
  |> List.hd in 
  
  List.iter (fun x -> 
    match x with
    | RemoteArchive d -> 
      (Interop.wget_get d (cwd ^ "/" ^ (get_filename d)) ) 
      |> ignore
    | RemoteFile d -> 
      (Interop.wget_get d (cwd ^ "/" ^ (get_filename d)) ) 
      |> ignore
    | _ ->  ()
    ) sources 
;; 

