open Cmdliner
open Kartini__Get

(* Real Function *)
let add =
  ()
;;

let get package_name =
  List.iter (fun x -> get_time x ) package_name
;;

(* Term Function *)
let add_t =
  let doc = "Adding binary archive to system" in
  Term.(const add),
  Term.info "add" ~doc
;;

let get_t = 
  let package_name = 
    Arg.(value & (pos_all string) [] & info [] ~docv:"packages name" ~doc:"package name")
  in
  let doc = "Getting resource of package" in
  Term.(const get $ package_name),
  Term.info "get" ~doc
;;

let info_t = 
  let doc = "Simple Package Administrator" in
  Term.(ret (const (fun _ -> `Help (`Pager, None)) $ const ())),
  Term.info "kartini" ~version:"0.0.1" ~doc ~exits:Term.default_exits
;;

let () = Term.(exit @@ eval_choice info_t [add_t;get_t]);;
