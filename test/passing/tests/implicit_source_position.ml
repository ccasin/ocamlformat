(* This file is the test case for erasing "implicit source position"
   arguments.

   The test output for this file can be found in
   [implicit_source_position_erased.ml.ref]. The options for this test can be
   found in [implicit_source_position_erased.ml.opts]. *)
let punned_pattern ~(call_pos : [%call_pos]) () = call_pos

let ignored_pattern ~call_pos:(_ : [%call_pos]) () = 1

let destructured_pattern ~call_pos:({pos_fname; _} : [%call_pos]) () = ()

let in_a_type : call_pos:[%call_pos] -> unit -> Lexing.position =
  punned_pattern

let in_an_expression = [%src_pos]

let with_locals ~(local_ call_pos : [%call_pos]) () = ()
