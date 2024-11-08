module M : sig
  class \#and : object
    val mutable \#and : int

    method \#and : int
  end
end = struct
  class \#and =
    let \#and = 1 in
    object
      val mutable \#and = \#and

      method \#and = 2
    end
end

let obj = new M.\#and

module M : sig
  type \#and = int
end = struct
  type \#and = string
end

let x = (`\#let `\#and : [`\#let of [`\#and]])

let (`\#let \#rec) = x

let f g ~\#let ?\#and ?(\#for = \#and) () = g ~\#let ?\#and ()

type t = '\#let

type \#mutable = {mutable \#mutable: \#mutable}

let rec \#rec = {\#mutable= \#rec}

type \#and = ..

type \#and += Foo

let x = ( ++ )

let x = \#let

let f ~\#let ?\#and () = 1

module type A = sig
  type ('\#let, 'a) \#virtual = '\#let * 'a as '\#mutable

  val foo : '\#let 'a. 'a -> '\#let -> unit

  type foo = {\#let: int}
end

module M = struct
  let ((\#let, foo) as \#val) = (\#mutable, baz)

  let _ = fun (type \#let foo) -> 1

  let f g ~\#let ?\#and ?(\#for = \#and) () = g ~\#let ?\#and ()

  class \#let =
    object
      inherit \#val \#let as \#mutable
    end
end

type 'a \#for = 'a list

type 'a \#sig = 'a \#for

type \#true = bool

let f \#false = \#false

type t = {x: int @@ \#let}

let x @ \#let = 42

let x = (~\#let:42, ~\#and:43)

let ((~\#let, ~\#and) : \#let:int * \#and:int) = x

kind_abbrev_ \#let = \#and

type t = T : 'a list -> t

let g x =
  let (T (type \#for) (_ : \#for list)) = x in
  ()

let ( lsl ) x y = x lsl y

let \#lsl x y = x lsl y

module type \#sig = sig end

module M = struct let \#mod = 1 end

let _ = M.\#mod
