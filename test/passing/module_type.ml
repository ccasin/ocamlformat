module type S = sig
  val x : unit -> unit
end

let get = failwith "TODO"

let foo () =
  let module X = (val get : S) in
  X.x ()
;;

module type S = sig end

type t = (module S)

type 'a monoid_a = (module Monoid with type t = 'a)

type 'a monoid_a = (module Monoid with type F.t = 'a)

let sumi (type a) ((module A) : a monoid_a) (n : a) = A.mappend n A.mempty

module type BAR = sig
  module rec A : (FOO with type t = < b: B.t >)
  and B : FOO
end

module U :
  S
  with type ttttttttt = int
   and type uuuuuuuu = int
   and type vvvvvvvvvvv = int = struct end

module U :
  S
  with type ttttttttt = int
   and type uuuuuuu = int
  with type vvvvvvvvv = int = struct end

module U =
 (val S
  : S
  with type t = int
   and type u = int)

module U =
 (val S
  : S
  with type t = int
   and type u = int)

module S : sig
  val x : int
end = struct
  let x = 3
end
