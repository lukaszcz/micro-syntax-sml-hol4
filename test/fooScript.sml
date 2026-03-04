(*
 * fooScript.sml — HOL4 syntax highlighting test file
 *)

open HolKernel Parse boolLib bossLib;

val _ = new_theory "foo";

(* === Definition with HOL term body === *)
Definition double_def:
  double n = n + n
End

(* === Definition with Termination === *)
Definition fib_def:
  fib 0 = (0:num) /\
  fib 1 = 1 /\
  fib n = fib (n - 1) + fib (n - 2)
Termination
  wf_rel_tac `measure I` >> simp[]
End

(* === Theorem with Proof === *)
Theorem double_twice:
  !n. double (double n) = 4 * n
Proof
  rw[double_def] >> simp[]
QED

(* === Triviality === *)
Triviality simple_fact:
  T
Proof
  simp[]
QED

(* === Theorem assignment form === *)
Theorem double_zero = double_def |> SPEC ``0`` |> SIMP_RULE std_ss [];

(* === Datatype === *)
Datatype:
  tree = Leaf | Node tree num tree
End

(* === Inductive relation === *)
Inductive even:
  even 0
  /\
  (!n. even n ==> even (n + 2))
End

(* === Overload and Type === *)
Overload "myop" = ``$+``
Type mynum = ``:num``

(* === Quotations in ML context === *)
val t = ``x + 1``;
val ty = ``:num -> bool``;
val t2 = ‘x + y’;
val t3 = “p /\\ q”;

(* === Unicode HOL symbols === *)
Theorem unicode_demo:
  ∀x y. x ∧ y ⇒ y ∨ x
Proof
  rpt strip_tac >> simp[]
QED

Definition unicode_def:
  myconj p q ⇔ p ∧ q ∧ ¬(p ≠ q)
End

(* === Tactics showcase === *)
Theorem tactic_demo:
  !x y:num. x <= y ==> x <= y + 1
Proof
  rpt strip_tac >>
  irule LESS_EQ_TRANS >>
  qexists_tac `y` >>
  fs[] >>
  decide_tac
QED

(* === Tacticals === *)
Theorem tactical_demo:
  T /\ T
Proof
  CONJ_TAC THEN simp[]
QED

(* === cheat should be highlighted as error === *)
Theorem cheated:
  F
Proof
  cheat
QED

(* === Antiquotation in ML context === *)
val th = ASSUME ``P:bool``;
val goal = ``^(concl th) ==> Q``;

(* === HOL constants === *)
val _ = ``if T then F else T``;
val _ = ``EMPTY UNION UNIV``;

val _ = export_theory();
