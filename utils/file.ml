(*

This section responsible as helper for any operation
 with file and filesystem manipulation utilities.

*)
let read filepath = 
  let buff = open_in filepath in
  really_input_string buff (in_channel_length buff)
;;

(* let make_dir t = 
  match Sys.is_directory t with 
  | true -> ()
  | false -> Sys.mkdir t

  t
;; *)