open System__Hq
open Utils__Process
open Data__Metadata

let extract_src t = 
  let filenames = get_src t in 
  let src_cached = ((map "cache_src") ^ "/" ^ t.name) in
  let src_tmp = ((map "tmp_src") ^ "/" ^ t.name) in

  Sys.mkdir src_tmp 0555;

  match ((Sys.is_directory src_cached) && (Sys.is_directory src_tmp)) with 
  | true ->
      List.iter (
        fun (src: src_types) ->
          match src with 
          | RemoteArchive (url,_) -> 
            Interop.tar_extract (src_cached ^ "/" ^ (url |> filename)) (src_tmp) |> ignore
          | RemoteFile (url,_) ->
            Interop.copy_file (src_cached ^ "/" ^ (url |> filename)) (src_tmp) |> ignore
          | LocalFile (url,_) ->  
            Interop.copy_file (src_cached ^ "/" ^ (url |> filename)) (src_tmp) |> ignore
          | GitRepo (repo_url,_) -> let _,_ = repo_url in 
            ()
      ) filenames
   | false -> ()
;;

let set_tmp_env = ();;