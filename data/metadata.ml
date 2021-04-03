(*

This section responsible for package metadata
 reflection, parsing and generation.

*)

type t = {
  name: string;
  version: string;
  description: string;
  src: string list;
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
  