open Cmdliner
open Kartini__Get
open Kartini__Build
open Kartini__Add
open Kartini__Remove
open System__Hq

(* Real Function *)
let add packages =
  List.iter (fun x -> 
  install_time x
  ) packages
;;

let clean_tmp () =
  print_endline "Not Implemented, yet!"
;;

let env () =
  (check_env ())
;;

let del packages =
  List.iter (fun x -> 
    remove_time x
  ) packages
;;

let build package_name =
  List.iter ( fun x -> build_time x ) package_name 
  |> ignore
;;

let get package_name =
  List.iter (fun x -> get_time x ) package_name
;;

(* Term Function *)
let add_t =
  let doc = "Adding binary archive to system" in
  let package_name = 
    Arg.(value & (pos_all string) [] & info [] ~docv:"packages name" ~doc:"package name")
  in
  Term.(const add $ package_name),
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

let del_t = 
  let package_name = 
    Arg.(value & (pos_all string) [] & info [] ~docv:"packages name" ~doc:"package name")
  in
  let doc = "Getting resource of package" in
  Term.(const del $ package_name),
  Term.info "del" ~doc
;;

let env_t =
  Term.(const env $ const ()),
  Term.info "env" ~doc:"Check environment variable required by kartini." ~exits:Term.default_exits
;;

let clean_t =
  Term.(const env $ const ()),
  Term.info "cleantmp" ~doc:"Check environment variable required by kartini." ~exits:Term.default_exits
;;

let info_t = 
  let doc = "Simple Package Administrator" in
  Term.(ret (const (fun _ -> `Help (`Pager, None)) $ const ())),
  Term.info "kartini" ~version:"0.0.1" ~doc ~exits:Term.default_exits
;;

let () = Term.(exit @@ eval_choice info_t [add_t;del_t;build_t;get_t;env_t]);;
