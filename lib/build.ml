open System__Hq
open System__Repository
open Utils__Process
open Utils__File
open Data__Metadata

let extract_src t = 
  let filenames = get_src t in 
  let src_cached = ((map "cache_src") ^ "/" ^ t.name) in
  let src_tmp = ((map "tmp_src") ^ "/" ^ t.name) in

  mkdir_p src_tmp;

  match ((Sys.is_directory src_cached) && (Sys.is_directory src_tmp)) with 
  | true ->
      List.iter (
        fun (src: src_types) ->
          match src with 
          | RemoteArchive (url,_) -> 
            (* print_endline (src_cached ^ "/" ^ (url |> filename)); *)
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

let build_time package_name =

  (* Need Refactor*)
  let repo_path = find_repo_package package_name in
  let metadata_path = (
    match repo_path |> List.length with 
      | 0 -> failwith "Package not found on KARTINI_PATH"
      | _ -> List.hd repo_path
  ) in
  let t = file_to_t metadata_path in 

  let bin_tmp = ((map "tmp_bin") ^ "/" ^ t.name) 
  and src_tmp = ((map "tmp_src") ^ "/" ^ t.name) 
  and cache_bin = ((map "cache_bin") ^ "/" ^ t.name) in

  print_endline "[*] Extracting source packages...";
  extract_src t |> ignore ;
  Sys.chdir src_tmp;

  print_endline "[*] Building source packages...";
  (* Write build script to temprorary source path*)
  write t.buildscript (src_tmp ^ "/build.sh");
  execute_external "sh" [|(src_tmp ^ "/build.sh");bin_tmp|] [||] |> ignore;

  (* TODO: making manifest *)
  mkdir_p bin_tmp;
  let manifest_home = (bin_tmp ^ "/var/db/kartini/installed/" ^ t.name) in
  let manifest = (List.map (
      fun x -> 
        Str.replace_first (Str.regexp bin_tmp) "" x 
    ) ((scan_dir bin_tmp)) @ [(manifest_home ^ "/manifest");(manifest_home ^ "/version")]) in
  
  
  mkdir_p manifest_home;
  match (Sys.is_directory manifest_home) with 
    | true ->
      let arrayJoinStr x = String.concat "\n" x in 
      write (t.version) (manifest_home ^ "/version") |> ignore;
      write (arrayJoinStr manifest) (manifest_home ^ "/manifest") |> ignore;

      print_endline "[*] Archiiving the system ";
      (* Making binary archive*)
      mkdir_p cache_bin;
      (match ((Sys.is_directory cache_bin) && (Sys.is_directory bin_tmp)) with 
        | true -> execute_external "tar" [|"cJf";(cache_bin ^ "/" ^ t.version ^ ".tar.xz");"-C";bin_tmp;"."|] [||] |> ignore;
        | false -> print_endline "Error");
    | false -> failwith "error" |> ignore;
;;