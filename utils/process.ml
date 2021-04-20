(*

These section responsible for any process operation utility
such spawning, threading and interop with system binaries.

*)
open Sys

let execute_external (program: string) (program_args: string array) (env: string array) =
  let arrayJoinStr x = String.concat " " (Array.to_list x) in 

  command ((arrayJoinStr env) ^ " " ^ program ^ " " ^ (arrayJoinStr program_args))
;;

module Interop = struct

  let curl_get url output =
    (execute_external "curl" [|url;"-o";output;"-L"|] [||])
  ;;

  let wget_get url output =
    (execute_external "wget" [|url;"-o";output|] [||])
  ;;

  let tar_extract filepath dest = 
    (execute_external "tar" [|"xf";filepath;"-C";dest;"--strip-components=1"|] [||])
  ;;

  let git_clone repository_link dest = 
    (execute_external "git" [|"clone";"--depth=1";repository_link;dest|] [||])
  ;;

  let link_file src dest = 
    (execute_external "ln" [|"-s";src;dest|] [||])
  ;;

  let copy_file src dest =
    (execute_external "len" [|src;dest|] [||])
  ;;
end