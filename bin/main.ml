open Cmdliner


(* Real Function *)
let add =
  ""
;;

(* Term Function *)
let add_t = 
  let doc = "Adding binary archive to system" in
  Term.(const add),
  Term.info "add" ~doc
;;


let info_t = 
  let doc = "Simple Package Administrator" in
  Term.(ret (const (fun _ -> `Help (`Pager, None)) $ const ())),
  Term.info "kartini" ~version:"0.0.1" ~doc ~exits:Term.default_exits
;;

let () = Term.(exit @@ eval_choice info_t [add_t]);;
