open Cmdliner
open Kartini__Get
open System__Hq

(* Real Function *)
let add () =
  print_endline "test"
;;
let env () =
  (check_env ())
;;

let build package_name =
  List.iter ( fun x -> print_endline x ) package_name 
  |> ignore
;;

let get package_name =
  List.iter (fun x -> get_time x ) package_name
;;

(* Term Function *)
let add_t =
  let doc = "Adding binary archive to system" in
  Term.(const add $ const ()),
  Term.info "add" ~doc
;;

let build_t =
  let doc = "To build package" in 
  let package_name = 
    Arg.(value & (pos_all string) [] & info [] ~docv:"packages name" ~doc:"package name")
  in
  Term.(const build $  package_name),
  Term.info "build" ~doc
;;

let get_t = 
  let package_name = 
    Arg.(value & (pos_all string) [] & info [] ~docv:"packages name" ~doc:"package name")
  in
  let doc = "Getting resource of package" in
  Term.(const get $ package_name),
  Term.info "get" ~doc
;;

let env_t =
  Term.(const env $ const ()),
  Term.info "env" ~doc:"Check environment variable required by kartini." ~exits:Term.default_exits
;;

let info_t = 
  let doc = "Simple Package Administrator" in
  Term.(ret (const (fun _ -> `Help (`Pager, None)) $ const ())),
  Term.info "kartini" ~version:"0.0.1" ~doc ~exits:Term.default_exits
;;

let () = Term.(exit @@ eval_choice info_t [add_t;build_t;get_t;env_t]);;
