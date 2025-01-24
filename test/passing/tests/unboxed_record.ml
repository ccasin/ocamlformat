(* This test file is a copy of record.ml, updated to use unboxed records, and with some
   additional tests at the end. *)

type t = #{x: int; y: int}

let _ = #{x= 1; y= 2}

let _ = #{!e with a; b= c}

let _ = #{!(f e) with a; b= c}

let _ =
  #{ !looooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
    with
    a
  ; b= c }

let _ =
  #{ !looooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
    with
    aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
  ; b= c }

let _ = #{(a : t) with a; b; c}

let _ = #{(f a) with a; b; c}

let _ = #{(a ; a) with a; b; c}

let _ = #{(if x then e else e) with e1; e2}

let _ = #{(match x with x -> e) with e1; e2}

let _ = #{(x : x) with e1; e2}

let _ = #{(x :> x) with e1; e2}

let _ = #{(x#x) with e1; e2}

let f ~l:#{f; g} = e

let f ?l:(#{f; g}) = e

let _ = #{a; b = ((match b with `A -> A | `B -> B | `C -> C) : c); c}

let a () = A #{A.a = (a : t)}

let x =
  #{ aaaaaaaaaa
  (* b *); b}

let x =
  #{ aaaaaaaaaa
  (* b *)
  ; b}

type t = #{ a : (module S); b : (module S) }

let _ = #{ a = (module M : S); b = (module M : S) }

let to_string #{x; _ (* we should print y *)} = string_of_int x

let #{ x = (x : t) } = x

(* Copy of record.ml ends here *)

(* Basic field access. *)

let _ = r.#x

(* Tests adapted from unboxed_tuples.ml *)
let _ =
  #{ u = abcdefghijklmnopqrstuvwxyz
   ; w = bcdefghijklmnopqrstuvwxyz
   ; x = abcdefghijklmnopqrstuvwxyz
   ; y = abcdefghijklmnopqrstuvwxyz
   ; z = abcdefghijklmnopqrstuvwxyz }

let _ =
  match () with
  | #{ a = abcdefghijklmnopqrstuvwxyz
     ; b = abcdefghijklmnopqrstuvwxyz
     ; c = abcdefghijklmnopqrstuvwxyz
     ; d = abcdefghijklmnopqrstuvwxyz
     ; e = abcdefghijklmnopqrstuvwxyz  } ->
      ()

type t =
  #{ a : abcdefghijklmnopqrstuvwxyz
   ; b : abcdefghijklmnopqrstuvwxyz
   ; c : abcdefghijklmnopqrstuvwxyz
   ; d : abcdefghijklmnopqrstuvwxyz
   ; e : abcdefghijklmnopqrstuvwxyz }

type t = t' =
  #{ a : abcdefghijklmnopqrstuvwxyz
   ; b : abcdefghijklmnopqrstuvwxyz
   ; c : abcdefghijklmnopqrstuvwxyz
   ; d : abcdefghijklmnopqrstuvwxyz
   ; e : abcdefghijklmnopqrstuvwxyz }

let x = match foo with #{x = Some x; y = Some y} -> ()

let foo a =
  match a with
  | #{ l1 = None
     ; l2 = Some _
     ; l3 = [1; 2]
     ; l4 = 3 :: []
     ; l5 = {x: _; y: _}
     ; l6 = 42
     ; l7 = _
     ; l8 = `Baz
     ; l9 = `Bar _
     ; l10 = (1 | 2)
     ; l11 = [|1; 2|]
     ; l12 = (3 : int)
     ; l13 = (lazy _)
     ; l14 = ( module M )
     ; l15 = (exception _)
     ; l16 = [%bar baz]
     ; l17 = M.(A)
     ; l18 = M.(A 42) } ->
      false

let bar =
  #{ l1 = foo
   ; l2 = 42
   ; l3 = (let x = 18 in
           x )
   ; l4 = (function x -> x)
   ; l5 = (fun x -> x)
   ; l6 = foo 42
   ; l7 = (match () with () -> ())
   ; l8 = (try () with _ -> ())
   ; l9 = (1, 2)
   ; l10 = (~x:1, ~y:2)
   ; l11 = None
   ; l12 = Some 42
   ; l13 = `A
   ; l14 = `B 42
   ; l15 = {x= 42; z= false}
   ; l16 = foo.lbl
   ; l17 = (foo 42).lbl
   ; l18 = (foo.lbl <- 42)
   ; l19 = [|1; 2|]
   ; l20 = [:1; 2:]
   ; l21 = [1; 2]
   ; l22 = [a for a = 1 to 10]
   ; l23 = (if true then true else false)
   ; l24 = (() ; ())
   ; l25 = while true do
         ()
       done
   ; l26 = for i = 1 to 2 do
         ()
       done
   ; l27 = (42 : int)
   ; l28 = (42 :> int)
   ; l29 = (42 : int :> bool)
   ; l30 = foo#bar
   ; l31 = foo #~# bar
   ; l32 = new M.c
   ; l33 = (x <- 2)
   ; l34 = {<x = 42; y = false>}
   ; l35 = (let module M = N in
            () )
   ; l36 = (let exception Ex in
            () )
   ; l37 = assert true }

let _ =
  match w with
  | A -> #{a = []; b = A.(B (C (f x))); c = None; d = f x y; e = g y x}
  | B -> #{a; b; c; d; e}
  | C ->
      #{ a = []
       ; b = A.(B (C (this is very looooooooooooooooooooooooooooooooooooong x)))
       ; c = None
       ; d = f x y
       ; e = g y x }

let _ = [%ext #{a = 1; b = 2; c = 3}]

let _ =
  [%ext
    #{ loooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooong
     ; y = loooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooong
     ; z = 3 }]

type t = int [@@deriving #{a = 1; b = 2; c = 3}]

type t = int
[@@deriving
  #{ sexp
   ; compare
   ; x = loooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooong
   }]

let _ =
  #{ a = 1
   ; b = 2
   ; c = looooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooong
   ; looooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooong
   }

let _ = #{a = 1; b = 2; c = 3; short} ;;

#{ a = 1
 ; b = 2
 ; looooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooong
 ; d = looooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooong
 }
;;

#{a = 1; b = 2; c = 3; short}

(* make sure to not drop parens for local open. *)
let _ = A.(#{a = 1; b = 2})
