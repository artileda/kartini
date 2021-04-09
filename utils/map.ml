
(* https://stackoverflow.com/questions/3202065/how-can-i-skip-a-term-with-list-map-in-ocaml*)
let map_partial f xs =
  let prepend_option x xs = match x with
  | None -> xs
  | Some x -> x :: xs in
  List.rev (List.fold_left (fun acc x -> prepend_option (f x) acc) [] xs)
;;