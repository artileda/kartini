open System__Hq
open Utils__Process
open Data__Metadata

let extract_src t = 
  let filenames = t.src
  |> List.map (fun x -> 
    (x 
    |> Str.split_delim (Str.regexp "/")
    |> List.rev
    |> List.hd)
    ) in 
    ()
;;

let set_tmp_env = ();;