(*

This section responsible for package metadata
 reflection, parsing and generation.

*)
open Utils__Map
open Utils__File

type t = {
  (* for pacakage name*)
  name: string;
  version: string;
  description: string;
  src: string list list;
  (* for pacakage runtime deps*)
  deps: string list;
  (* for pacakage compile deps*)
  dev_deps: string list [@key "dev-deps"];
  buildscript: string [@key "build-script"];
  preremove: string [@key "post-install"];
  postinstall: string [@key "pre-remove"];
}[@@deriving yaml];;


(* This will hold details of source redirection*)
(* File_Types of source_url * extract_folder *)
type src_types =
  | RemoteArchive of string * string option 
  | RemoteFile of string * string option 
  | LocalFile of string * string option 
  | GitRepo of (string * string) * string option (* Repo addres and branch *)
;;

let t_to_str t =
   match Yaml.to_string (to_yaml t) with
   | Ok res -> Ok res
   | Error msg ->
      match msg with
      | `Msg res -> Error res
;;

let str_to_t t =
  let parsed_string = (match (Yaml.of_string t) with 
  | Ok h -> (of_yaml h)
  | Error e -> Error e) in

  match parsed_string with 
  | Ok res -> Ok res
  | Error msg -> 
    match msg with
    | `Msg res -> Error res
;;

let file_to_t path =
  Result.get_ok (str_to_t (read path))
;;

let evaluate_src_type src_url output =
  let remote_archive = Str.regexp {|\(\(ftp\)\|\(http\)\|\(https\)\)://.*\.\(tar\)\.\(\(gz\)\|\(xz\)\|\(bz\)\)|}in
  let remote_file = Str.regexp {|\(\(ftp\)\|\(http\)\|\(https\)\)://.*|} in
  (* let local_file = Str.regexp_string "" in *)
  let git_repo = Str.regexp {|\(git\)://.*|} in

  let matched regxp url = Str.string_match regxp url 0 in

  let find_repo git_url =
    let split_url = git_url
    |> Str.split_delim (Str.regexp "#")
    |> Array.of_list in

    if (Array.length split_url) >= 2 then GitRepo ((split_url.(0), split_url.(1)),output)
    else GitRepo ((split_url.(0), ""),output)
  in

  if (matched remote_archive src_url) then RemoteArchive (src_url,output)
  else if (matched remote_file src_url) then RemoteFile (src_url,output)
  else if (matched git_repo src_url) then (find_repo src_url)
  else LocalFile (src_url, output)
;;

let get_src t = 
  map_partial (fun src_list ->
    let src_array = Array.of_list src_list in
    match Array.length src_array with 
    | 1 -> Some (evaluate_src_type src_array.(0) None)
    | 2 -> Some (evaluate_src_type src_array.(0) (Some src_array.(1)))
    | _ -> None
  ) t.src
    (* List.map (fun m -> (m |> List.hd |> evaluate_src_type ,m |> List.rev |> List.hd)) t.src *)
;;

let filename x = 
  x 
  |> Str.split_delim (Str.regexp "/") 
  |> List.rev
  |> List.hd 
;;

let get_filename t = 
  List.map (
    fun(s: src_types) ->
      match s with
      | RemoteArchive (url,output) | RemoteFile (url,output) | LocalFile (url,output) ->  
          (url |> filename,output)
      | GitRepo (repo_url,output) -> let url,_ = repo_url in 
        (url |> filename,output)
  ) (get_src t)
;;

let inspect_t t = 
  print_endline ("name: " ^ t.name);
  print_endline ("version: " ^ t.version);
  print_endline ("description: " ^t.description);
  print_endline "src: ";
  List.iter (fun m -> ("\t" ^ (List.hd m)) |> print_endline) t.src;
  print_endline "deps: ";
  List.iter (fun m -> ("\t" ^ m) |> print_endline) t.deps;
  print_endline "dev-deps: ";
  List.iter (fun m -> ("\t" ^ m) |> print_endline) t.dev_deps;
  print_endline "build-script";
  print_endline t.buildscript;
  ()
;;