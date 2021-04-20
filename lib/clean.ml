open System__Hq
open Utils__Process

let clean_time () =
  Interop.wipe_dir (map "temp_dir") |> ignore
;;