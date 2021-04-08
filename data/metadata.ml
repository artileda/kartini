(*

This section responsible for package metadata
 reflection, parsing and generation.

*)

type t = {
  (* for pacakage name*)
  name: string;
  version: string;
  description: string;
  src: string list;
  (* for pacakage runtime deps*)
  deps: string list;
  (* for pacakage compile deps*)
  dev_deps: string list [@key "dev-deps"];
  buildscript: string [@key "build-script"];
  preremove: string [@key "post-install"];
  postinstall: string [@key "pre-remove"];
}[@@deriving yaml];;

type src_types =
  | RemoteArchive of string
  | RemoteFile of string
  | LocalFile of string
  | GitRepo of (string * string) (* Repo addres and branch *)
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

let evaluate_src_type src_url =
  let remote_archive = Str.regexp {|\(\(ftp\)\|\(http\)\|\(https\)\)://.*\.\(tar\)\.\(\(gz\)\|\(xz\)\|\(bz\)\)|}in
  let remote_file = Str.regexp {|\(\(ftp\)\|\(http\)\|\(https\)\)://.*|} in
  (* let local_file = Str.regexp_string "" in *)
  let git_repo = Str.regexp {|\(git\)://.*|} in

  let matched regxp url = Str.string_match regxp url 0 in

  let find_repo git_url =
    let split_url = git_url
    |> Str.split_delim (Str.regexp "#")
    |> Array.of_list in

    if (Array.length split_url) >= 2 then GitRepo (split_url.(0), split_url.(1))
    else GitRepo (split_url.(0), "")
  in

  if (matched remote_archive src_url) then RemoteArchive src_url
  else if (matched remote_file src_url) then RemoteFile src_url
  else if (matched git_repo src_url) then (find_repo src_url)
  else LocalFile src_url
;;

let get_src t = 
    List.map (fun m -> (evaluate_src_type m)) t.src
;;

let get_filename t = 
  let filename x = 
    x 
    |> Str.split_delim (Str.regexp "/") 
    |> List.rev
    |> List.hd 
  in
  List.map (
    fun (x: src_types) ->
      match x with
      | RemoteArchive url | RemoteFile url | LocalFile url ->  url |> filename
      | GitRepo x -> let url,_ = x in 
        url |> filename
  ) (get_src t)
;;

let inspect_t t = 
  print_endline ("name: " ^ t.name);
  print_endline ("version: " ^ t.version);
  print_endline ("description: " ^t.description);
  print_endline "src: ";
  List.iter (fun m -> ("\t" ^ m) |> print_endline) t.src;
  print_endline "deps: ";
  List.iter (fun m -> ("\t" ^ m) |> print_endline) t.deps;
  print_endline "dev-deps: ";
  List.iter (fun m -> ("\t" ^ m) |> print_endline) t.dev_deps;
  print_endline "build-script";
  print_endline t.buildscript;
  ()
;;