(* The first half of this file tests basic formatting of the [@]-based mode syntax
   in various positions to make sure we are able to handle them all, and that
   they are correctly parenthesized. The second half more thoroughly checks
   formatting when there are line breaks in various positions. *)

(* Modes on arbitrary patterns were supported in the parser during development of
   ocamlformat support for modes, but were later unsupported in the parser. Tests of
   modes on patterns have thus been moved to [test/failing/tests/modes_on_patterns.ml].
   If patterns are ever again supported in the parser, move those tests back to this
   file (and other [modes*.ml] files in this directory). *)

module Let_bindings = struct
  let x @ mode = y
  let x @ mode1 mode2 = y
  let x : typ @@ mode1 mode2 = y
  let x : typ1 typ2 @@ mode1 mode2 = y
  let x : typ1 -> typ2 @@ mode1 mode2 = y
  let x : typ1 * typ2 @@ mode1 mode2 = y

  let x @ mode = x
  and y @ mode = y
  and z : typ @@ mode = z

  let () =
    let x @ mode = y in
    let x : typ @@ mode = y in
    let x @ mode = x
    and y @ mode = y
    and z : typ @@ mode = z in
    ()
  ;;

  let () =
    let%bind x @ mode = y in
    let%map x @ mode = y in
    let%ext x : typ @@ mode = y in
    let%ext x @ mode = x
    and y @ mode = y
    and z : typ @@ mode = z in
    ()
  ;;

  external x : typ @@ mode1 mode2 = ""
  external x : typ1 typ2 @@ mode1 mode2 = ""
  external x : typ1 -> typ2 @@ mode1 mode2 = ""
  external x : typ1 * typ2 @@ mode1 mode2 = ""
end

module Expressions = struct
  let x = (expr : typ @@ mode1 mode2)
  let x = (expr : typ1 typ2 @@ mode1 mode2)
  let x = (expr : typ1 -> typ2 @@ mode1 mode2)
  let x = (expr : typ1 * typ2 @@ mode1 mode2)

  (* mode constraints in expressions *)
  let x =
    { let1 =
        (let x = (x : _ @@ mode)
         and y = (y : _ @@ mode) in
         (z : _ @@ mode))
    ; function1 =
        (function
          | x -> (x : _ @@ mode)
          | y -> (y : _ @@ mode))
    ; fun1 = (fun ?(x = (x : _ @@ mode)) () -> (y : _ @@ mode))
    ; apply1 = (x : _ @@ mode) (y : _ @@ mode)
    ; apply2 = f ~lbl:(x : _ @@ mode)
    ; apply3 = f ~x:(x : _ @@ mode)
    ; apply4 = f ?lbl:(x : _ @@ mode)
    ; apply5 = f ?x:(x : _ @@ mode)
    ; match1 =
        (match (x : _ @@ mode) with
         | y -> (y : _ @@ mode)
         | z -> (z : _ @@ mode))
    ; try1 =
        (try (x : _ @@ mode) with
         | y -> (y : _ @@ mode))
    ; tuple1 = (x : _ @@ mode), (y : _ @@ mode)
    ; tuple2 = ~x:(x : _ @@ mode), ~y:(z : _ @@ mode)
    ; construct1 = A (x : _ @@ mode)
    ; construct2 = A ((x : _ @@ mode), (y : _ @@ mode))
    ; variant1 = `A (x : _ @@ mode)
    ; variant2 = `A ((x : _ @@ mode), (y : _ @@ mode))
    ; field1 = (x : _ @@ mode).x
    ; setfield1 = (x : _ @@ mode).x <- (y : _ @@ mode)
    ; array1 = [| (x : _ @@ mode); (y : _ @@ mode) |]
    ; array2 = [: (x : _ @@ mode); (y : _ @@ mode) :]
    ; list1 = [ (x : _ @@ mode); (y : _ @@ mode) ]
    ; ite1 = (if (x : _ @@ mode) then (y : _ @@ mode) else (z : _ @@ mode))
    ; sequence1 =
        ((x : _ @@ mode);
         (y : _ @@ mode))
    ; while1 =
        while (x : _ @@ mode) do
          (y : _ @@ mode)
        done
    ; for1 =
        for i = (x : _ @@ mode) to (y : _ @@ mode) do
          (z : _ @@ mode)
        done
    ; constraint1 = ((x : _ @@ mode) : _ @@ mode)
    ; coerce1 = ((x : _ @@ mode) :> _)
    ; send1 = (x : _ @@ mode)#y
    ; setinstvar1 = x <- (x : _ @@ mode)
    ; override1 = {<x = (x : _ @@ mode); y = (y : _ @@ mode)>}
    ; letmodule1 =
        (let module M = ME in
        (x : _ @@ mode))
    ; letexception1 =
        (let exception E in
        (x : _ @@ mode))
    ; assert1 = assert (x : _ @@ mode)
    ; lazy1 = lazy (x : _ @@ mode)
    ; newtype1 = (fun (type t) -> (x : _ @@ mode))
    ; open1 = M.((x : _ @@ mode))
    ; letopen1 =
        (let open M in
         (x : _ @@ mode))
    ; letop1 =
        (let* x = (x : _ @@ mode) in
         (y : _ @@ mode))
    ; extension1 = [%ext (x : _ @@ mode)]
    ; cons1 = (x : _ @@ mode) :: (y : _ @@ mode) :: (z : _ @@ mode)
    ; prefix1 = !(x : _ @@ mode)
    ; infix1 = (x : _ @@ mode) + (y : _ @@ mode)
    }
  ;;

  (* expressions in mode constraints *)
  let x =
    { ident1 = (x : _ @@ mode)
    ; constant1 = ("" : _ @@ mode)
    ; let1 =
        (let x = y in
         z
         : _
         @@ mode)
    ; function1 =
        (function
         | x -> x
         | y -> y
         : _
         @@ mode)
    ; fun1 = (fun x -> y : _ @@ mode)
    ; apply1 = (f x : _ @@ mode)
    ; match1 =
        ((match x with
          | y -> y
          | z -> z)
         : _
         @@ mode)
    ; try1 =
        ((try x with
          | y -> y
          | z -> z)
         : _
         @@ mode)
    ; tuple1 = ((x, y) : _ @@ mode)
    ; tuple2 = ((~x, ~y) : _ @@ mode)
    ; construct1 = (A : _ @@ mode)
    ; construct2 = (A x : _ @@ mode)
    ; construct3 = (A (x, y) : _ @@ mode)
    ; construct4 = (A { x } : _ @@ mode)
    ; variant1 = (`A : _ @@ mode)
    ; variant2 = (`A x : _ @@ mode)
    ; record1 = ({ x } : _ @@ mode)
    ; field1 = (x.y : _ @@ mode)
    ; setfield1 = (x.y <- z : _ @@ mode)
    ; array1 = ([| x |] : _ @@ mode)
    ; array2 = ([: x :] : _ @@ mode)
    ; list1 = ([ x ] : _ @@ mode)
    ; ite1 = (if x then y else z : _ @@ mode)
    ; sequence1 =
        (x;
         y
         : _
         @@ mode)
    ; while1 =
        while x do
          y
        done
        @@ mode
    ; for1 =
        for x = y to z do
          a
        done
        @@ mode
    ; constraint1 = ((x : _ @@ mode) : _ @@ mode)
    ; coerce1 = ((x :> _) : _ @@ mode)
    ; send1 = (x#y : _ @@ mode)
    ; new1 = (new x : _ @@ mode)
    ; setinstvar1 = (x <- 2 : _ @@ mode)
    ; override1 = ({<y = z>} : _ @@ mode)
    ; letmodule1 =
        (let module M = ME in
         x
         : _
         @@ mode)
    ; letexception1 =
        (let exception E in
         x
         : _
         @@ mode)
    ; assert1 = (assert x : _ @@ mode)
    ; lazy1 = (lazy x : _ @@ mode)
    ; object1 = (object end : _ @@ mode)
    ; newtype1 = (fun (type t) -> x : _ @@ mode)
    ; pack1 = ((module M) : _ @@ mode)
    ; pack2 = ((module M : S) : _ @@ mode)
    ; open1 = (M.(x y) : _ @@ mode)
    ; letopen1 =
        (let open M in
         x
         : _
         @@ mode)
    ; letop1 =
        (let* x = y in
         z
         : _
         @@ mode)
    ; extension1 = ([%ext] : _ @@ mode)
    ; hole1 = (_ : _ @@ mode)
    ; cons1 = (x :: y :: z : _ @@ mode)
    ; prefix1 = (!x : _ @@ mode)
    ; infix1 = (x + y : _ @@ mode)
    }
  ;;
end

module Arrow_params = struct
  type t = lhs @ mode1 mode2 -> rhs @ mode3 mode4
  type t = arg1 @ mode1 -> lbl:arg2 @ mode2 -> ?lbl:arg3 @ mode3 -> res @ mode4

  let x : lhs @ mode1 -> rhs @ mode2 @@ mode3 = y
  let x = (expr : lhs @ mode1 -> rhs @ mode2 @@ mode3)
end

module Modalities_on_record_fields = struct
  type t =
    { x : t @@ mode1 mode2
    ; mutable x : t @@ mode1 mode2
    }

  type t = A of { x : t @@ mode1 mode2 }
end

module Modalities_on_construct_arguments = struct
  type t =
    | A of typ @@ mode1 mode2
    | B of typ1 @@ mode1 * typ2 @@ mode2

  type t =
    | A : typ @@ mode1 mode2 -> t
    | B : typ1 @@ mode1 * typ2 @@ mode2 -> t
end

module type Value_descriptions = sig
  val x : typ @@ mode1 mode2
  val x : typ1 typ2 @@ mode1 mode2
  val x : typ1 -> typ2 @@ mode1 mode2
  val x : typ1 * typ2 @@ mode1 mode2
  external x : typ @@ mode1 mode2 = ""
  external x : typ1 typ2 @@ mode1 mode2 = ""
  external x : typ1 -> typ2 @@ mode1 mode2 = ""
  external x : typ1 * typ2 @@ mode1 mode2 = ""
end

module Let_bound_functions = struct
  let (f @ mode) arg1 arg2 = x
  let (f @ mode) arg1 arg2 : typ = x
  let (f @ mode1 mode2) arg1 arg2 = x

  let (f @ mode)
    (arg @ mode)
    (arg : typ @@ mode)
    ~lbl:(arg @ mode)
    ~lbl:(arg : typ @@ mode)
    ~(arg @ mode)
    ~(arg : typ @@ mode)
    ?lbl:(arg @ mode)
    ?lbl:(arg : typ @@ mode)
    ?lbl:(arg @ mode = value)
    ?lbl:(arg : typ @@ mode = value)
    ?(arg @ mode)
    ?(arg : typ @@ mode)
    ?(arg @ mode = value)
    ?(arg : typ @@ mode = value)
    : typ
    =
    value
  ;;
end

module No_illegal_sugaring = struct
  let y = { x = (x : t @@ mode) }
  let y = { x :> t = (x : t @@ mode) }
end

module Line_breaking = struct
  module Let_bindings = struct
    let long_value_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
      @ mode1 mode2 mode3 mode4 mode5 mode6 mode7 mode8
      =
      1
    ;;

    let long_value_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
      : t @@ mode1 mode2 mode3 mode4 mode5 mode6 mode7 mode8
      =
      1
    ;;

    let long_value_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
      : long_type_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
      @@ mode1 mode2 mode3 mode4 mode5 mode6 mode7 mode8
      =
      1
    ;;
  end

  module Expressions = struct
    let x =
      (long_expr_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
       : t
       @@ mode1 mode2 mode3 mode4 mode5 mode6 mode7 mode8)
    ;;

    let x =
      (long_expr_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
       : long_type_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
       @@ mode1 mode2 mode3 mode4 mode5 mode6 mode7 mode8)
    ;;
  end

  module Arrow_params = struct
    type t =
      arg @ mode1 mode2
      -> arg @ mode1 mode2
      -> arg @ mode1 mode2
      -> arg @ mode1 mode2
      -> arg @ mode1 mode2
      -> arg @ mode1 mode2
      -> arg @ mode1 mode2

    type t =
      long_arg_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
      @ mode1 mode2 mode3 mode4 mode5 mode6 mode7 mode8
      -> label:long_arg_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
         @ mode1 mode2 mode3 mode4 mode5 mode6 mode7 mode8
      -> ?label:long_arg_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
         @ mode1 mode2 mode3 mode4 mode5 mode6 mode7 mode8
      -> long_result_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
         @ mode1 mode2 mode3 mode4 mode5 mode6 mode7 mode8

    let x
      :  arg @ mode1 mode2 -> arg @ mode1 mode2 -> arg @ mode1 mode2 -> arg @ mode1 mode2
      -> arg @ mode1 mode2 -> arg @ mode1 mode2 -> arg @ mode1 mode2
      =
      y
    ;;

    let x
      :  long_arg_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
         @ mode1 mode2 mode3 mode4 mode5 mode6 mode7 mode8
      -> label:long_arg_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
         @ mode1 mode2 mode3 mode4 mode5 mode6 mode7 mode8
      -> ?label:long_arg_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
         @ mode1 mode2 mode3 mode4 mode5 mode6 mode7 mode8
      -> long_result_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
         @ mode1 mode2 mode3 mode4 mode5 mode6 mode7 mode8
      =
      y
    ;;

    let x =
      (expr
       : arg @ mode1 mode2
         -> arg @ mode1 mode2
         -> arg @ mode1 mode2
         -> arg @ mode1 mode2
         -> arg @ mode1 mode2
         -> arg @ mode1 mode2
         -> arg @ mode1 mode2
       @@ mode1 mode2)
    ;;

    let x =
      (expr
       : long_arg_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
         @ mode1 mode2 mode3 mode4 mode5 mode6 mode7 mode8
         -> label:long_arg_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
            @ mode1 mode2 mode3 mode4 mode5 mode6 mode7 mode8
         -> ?label:long_arg_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
            @ mode1 mode2 mode3 mode4 mode5 mode6 mode7 mode8
         -> long_result_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
            @ mode1 mode2 mode3 mode4 mode5 mode6 mode7 mode8
       @@ mode1 mode2)
    ;;
  end

  module Modalities_on_record_fields = struct
    type t =
      { long_field_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa : t
        @@ mode1 mode2 mode3 mode4 mode5 mode6 mode7 mode8
      ; mutable long_field_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa : t
        @@ mode1 mode2 mode3 mode4 mode5 mode6 mode7 mode8
      ; long_field_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa :
          long_type_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
        @@ mode1 mode2 mode3 mode4 mode5 mode6 mode7 mode8
      }

    type t =
      | A of
          { long_field_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa : t
            @@ mode1 mode2 mode3 mode4 mode5 mode6 mode7 mode8
          ; mutable long_field_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa : t
            @@ mode1 mode2 mode3 mode4 mode5 mode6 mode7 mode8
          ; long_field_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa :
              long_type_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
            @@ mode1 mode2 mode3 mode4 mode5 mode6 mode7 mode8
          }
  end

  module Modalities_on_constructor_arguments = struct
    type t =
      | A of
          long_type_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
          @@ mode1 mode2 mode3 mode4 mode5 mode6 mode7 mode8
          * long_type_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
            @@ mode1 mode2 mode3 mode4 mode5 mode6 mode7 mode8
          * long_type_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
            @@ mode1 mode2 mode3 mode4 mode5 mode6 mode7 mode8
          * short_type @@ mode1 mode2

    type t =
      | A :
          long_type_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
          @@ mode1 mode2 mode3 mode4 mode5 mode6 mode7 mode8
          * long_type_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
            @@ mode1 mode2 mode3 mode4 mode5 mode6 mode7 mode8
          * long_type_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
            @@ mode1 mode2 mode3 mode4 mode5 mode6 mode7 mode8
          * short_type @@ mode1 mode2
          -> t
  end

  module type Value_descriptions = sig
    val long_value_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
      : t
      @@ mode1 mode2 mode3 mode4 mode5 mode6 mode7 mode8

    val long_value_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
      : long_type_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
      @@ mode1 mode2 mode3 mode4 mode5 mode6 mode7 mode8
  end

  module Let_bound_functions = struct
    let (long_fun_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
      @ mode1 mode2 mode3 mode4 mode5 mode6 mode7 mode8)
      (long_arg_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
        @ mode1 mode2 mode3 mode4 mode5 mode6 mode7 mode8)
      (long_arg_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa :
        t
        @@ mode1 mode2 mode3 mode4 mode5 mode6 mode7 mode8)
      (long_arg_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa :
        long_type_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
        @@ mode1 mode2 mode3 mode4 mode5 mode6 mode7 mode8)
      =
      a
    ;;
  end
end

module Interaction_with_existing_syntax = struct
  (* let bindings *)

  let local_ x @ mode1 mode2 = y
  let local_ x : typ1 typ2 @@ mode1 mode2 = y

  (* lhs/rhs of arrows *)

  type t = local_ lhs @ mode1 -> local_ mhs @ mode2 -> local_ rhs @ mode3

  let x : local_ lhs @ mode1 -> local_ rhs @ mode2 @@ mode3 = y
  let x = (expr : local_ lhs @ mode1 -> local_ rhs @ mode2 @@ mode3)

  (* modalities on record fields *)

  type t = { global_ x : t @@ mode1 mode2 }
  type t = A of { global_ x : t @@ mode1 mode2 }

  (* modalities on constructor arguments *)

  type t =
    | A of global_ typ @@ mode1 mode2
    | B of global_ typ1 @@ mode1 * global_ typ2 @@ mode2

  type t =
    | A : global_ typ @@ mode1 mode2 -> t
    | B : global_ typ1 @@ mode1 * global_ typ2 @@ mode2 -> t
end

module Regressions = struct
  let x =
    a_long_expression_that_has_its_own_line
    @ (* a long comment that comes after the [@] *)
    a_long_expression_that_comes_after_the_comment
  ;;

  let (x, y) @ mode =
    let (x, y) @ mode = x, y in
    x, y
  ;;

  let (t as t) @ mode = local_
    let (t as t) @ mode = local_ t in
    t
  ;;

  let (x, y) @ mode = local_
    let (x, y) @ mode = local_ t in
    t
  ;;

  class t =
    let (x, y) @ mode = x in
    object end
end
