(*

This section responsible as helper for any operation
 with file and filesystem manipulation utilities.

*)

open Process

let read filepath = 
  let buff = open_in filepath in
  really_input_string buff (in_channel_length buff)
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
  let rec loop result = function
    (* welp need help to always include link file
    | f::fs when not (Sys.file_exists f) -> loop (f::result) fs *)
    | f::fs when Sys.is_directory f ->
          Sys.readdir f
          |> Array.to_list
          |> List.map (Filename.concat f)
          |> List.append fs
          |> loop result
    | f::fs -> loop (f::result) fs
    | []    -> result
  in
    loop [] [dir]
  
;;

let mkdir_p path =
  (execute_external "mkdir" [|"-p";path|] [||]) |> ignore
;;