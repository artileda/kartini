(*

This section responsible as helper for any operation
 with file and filesystem manipulation utilities.

*)

open Process

let read filepath =
  match Sys.file_exists filepath with 
  | true ->
    let buff = open_in filepath in
    let len = in_channel_length buff in
    really_input_string buff len
  | false -> ""
;;

let write content filepath =
  let _file = open_out filepath in
  Printf.fprintf _file "%s" content;
  close_out _file;
;;

(* https://gist.github.com/lindig/be55f453026c65e761f4e7012f8ab9b5 *)
(* Thank you @lindig *)
let scan_dir dir =
  print_endline "Scanning";
  let memo : string list ref = ref [] in
  let rec loop = function
    (* welp need help to always include link file *)
    | [] -> memo
    | f::fs when Sys.is_directory f ->
        Sys.readdir f
          |> Array.to_list
          |> List.map (Filename.concat f)
          |> List.append fs
          |> loop
    | f::fs when not (Sys.file_exists f) -> 
      memo := (f::!memo);
      loop fs 
    | f::fs ->  
      memo := (f::!memo);
      loop fs
  in
  !(loop [dir])
;;
 

let mkdir_p path =
  (execute_external "mkdir" [|"-p";path|] [||]) |> ignore
;;