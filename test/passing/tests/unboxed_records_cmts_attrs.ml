(* Tests making sure comments and attributes are handled reasonably by
   unboxed record printing. *)

(* Attrs around expressions *)
let y = #{a= z; b= z [@attr]}

let y = #{a= z; b= z} [@@attr]

let y = #{a= ((42 [@attr]) : int); b= 42}

let y = #{a= a [@attr]; b= 42}

(* Comments around expressions *)
let _ = (* baz *) #{x= 42; y}

let _ = #{(* baz *) x= 42; y}

let _ = #{x (* baz *)= 42; y}

let _ = #{x= 42 (* baz *); y}

let _ = #{x= 42; (* baz *) y}

let _ = #{x= 42; y (* baz *)}

let _ = #{x= 42; y} (* baz *)

let _ = (* baz *) #{z; y: int}

let _ = #{(* baz *) z; y: int}

let _ = #{z (* baz *); y: int}

let _ = #{z; (* baz *) y: int}

let _ = #{z; y: (* baz *) int}

let _ = #{z; y: (* baz *) int}

let _ = #{z; y: int (* baz *)}

let _ = #{z; y: int (* baz *)}

let _ = #{z; y: int} (* baz *)

(* Attrs around types *)
type t = #{x: (int[@attr]); y: bool}

type t = #{x: int; y: (bool[@attr])}

type t = #{x: int; y: bool [@attr]}

type t = #{x: int; y: bool} [@@attr]

(* Comments around types *)
type t = #{(* baz *) x: int; y: bool}

type t = #{(* baz *) x: int; y: bool}

type t = #{x (* baz *): int; y: bool}

type t = #{x: (* baz *) int; y: bool}

type t = #{x: int (* baz *); y: bool}

type t = #{x: int; (* baz *) y: bool}

type t = #{x: int; y (* baz *): bool}

type t = #{x: int; y: (* baz *) bool}

type t = #{x: int; y: bool (* baz *)}

type t = #{x: int; y: bool} (* baz *)

(* Attrs around patterns *)
let #{z= (z [@attr]); y} = ()

let #{z; y= (42 [@attr])} = ()

let (#{z; y= 42} [@attr]) = ()

(* Comments around patterns *)
let (* baz *) #{z; y= 42} = ()

let #{(* baz *) z; y= 42} = ()

let #{z (* baz *); y= 42} = ()

let #{z; (* baz *) y= 42} = ()

let #{z; y (* baz *)= 42} = ()

let #{z; y= (* baz *) 42} = ()

let #{z; y= 42 (* baz *)} = ()

let #{z; y= 42} (* baz *) = ()

let (* baz *) #{z= 42; y: int} = ()

let #{(* baz *) z= 42; y: int} = ()

let #{z (* baz *)= 42; y: int} = ()

let #{z= (* baz *) 42; y: int} = ()

let #{z= 42 (* baz *); y: int} = ()

let #{z= 42; (* baz *) y: int} = ()

let #{z= 42; y: (* baz *) int} = ()

let #{z= 42; y: (* baz *) int} = ()

let #{z= 42; y: (* baz *) int} = ()

let #{z= 42; y: int (* baz *)} = ()

let #{z= 42; y: int (* baz *)} = ()

let #{z= 42; y: int} (* baz *) = ()
