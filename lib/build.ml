open System__Hq
open Utils__Process
open Data__Metadata

let extract_src t = 
  let filenames = get_src t in 
  let src_cached = ((map "cache_src") ^ "/" ^ t.name) in
  let src_tmp = ((map "tmp_src") ^ "/" ^ t.name) in

  List.iter (
    fun (src: src_types) ->
      match src with 
      | RemoteArchive (url,output) -> 
          Interop.tar_extract (src_cached ^ "/" ^ (url |> filename)) (src_tmp) |> ignore
      | RemoteFile (url,output) | LocalFile (url,output) ->  
        ()
      | GitRepo (repo_url,output) -> let url,_ = repo_url in 
        ()
  ) filenames
  
;;

let set_tmp_env = ();;