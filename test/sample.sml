(* sample.sml — SML syntax highlighting test file *)
(* TODO: test TODO highlighting in comments *)

(* === Declarations === *)
val x = 42
val y : int = ~7
val pi = 3.14159
val hex = 0xFF
val word1 = 0w42
val wordhex = 0wx1F
val sci = 1.5e10
val neg_sci = ~2.0E~3

(* === Strings and characters === *)
val s = "hello world"
val esc = "tab\there\nnewline"
val ctrl = "\^A\^Z"
val numesc = "\065\066"
val unicode = "\u0041"
val ch1 = #"A"
val ch2 = #"\n"
val ch3 = #"\065"

(* === Keywords === *)
fun factorial 0 = 1
  | factorial n = n * factorial (n - 1)

val result =
    let
        val a = 10
    in
        if a > 5 then "big" else "small"
    end

fun safediv x y =
    x div y
    handle Div => 0

val _ = case result of
    "big" => true
  | _ => false

val f = fn x => x + 1

val b = true andalso false orelse true

(* === Types === *)
type point = real * real
datatype 'a tree = Leaf | Node of 'a * 'a tree * 'a tree
datatype color = Red | Green | Blue
exception NotFound of string

(* === Module system === *)
structure MyModule = struct
    val x = 42
    fun double n = n * 2
end

signature MY_SIG = sig
    val x : int
    val double : int -> int
end

functor MakePair (A : MY_SIG) = struct
    val pair = (A.x, A.double A.x)
end

(* === Operators === *)
val lst = 1 :: 2 :: 3 :: nil
val app = [1,2] @ [3,4]
val r = ref 0
val _ = r := !r + 1
val eq = (1 = 1)
val neq = (1 <> 2)
val _ = print "hello\n"

(* === Constants === *)
val n = NONE
val s = SOME 42
val c = LESS
val _ = EQUAL
val _ = GREATER

(* === Type variables === *)
fun 'a id (x : 'a) : 'a = x
fun ''a member (x : ''a) (lst : ''a list) =
    List.exists (fn y => y = x) lst

(* === Fixity === *)
infix 6 +++
fun (x +++ y) = x + y + 1

(* === Local === *)
local
    val secret = 42
in
    val revealed = secret
end

(* === Abstype === *)
abstype counter = C of int
with
    val zero = C 0
    fun inc (C n) = C (n + 1)
    fun value (C n) = n
end

(* === Open === *)
open List
val _ = null []

(* === Wildcard === *)
fun first (x, _) = x
