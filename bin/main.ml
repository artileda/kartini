open Data

let x : Metadata.t = {name="UwU"};;
let read filepath = 
  let buff = open_in filepath in
  really_input_string buff (in_channel_length buff)
;;


let () = match Metadata.t_to_str x with
  | Ok d -> print_endline d
  | Error _ -> print_endline ""
;;
