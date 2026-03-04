# SML & HOL4 Syntax Highlighting Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Create two micro editor syntax highlighting YAML files — `sml.yaml` for pure SML'97 and `hol4.yaml` for HOL4 Trindemossen-2 proof scripts.

**Architecture:** Each file follows micro's YAML syntax format (filetype, detect, rules). sml.yaml covers all SML'97 language constructs. hol4.yaml duplicates SML rules and adds HOL4-specific script forms, quotation regions, tactics, and tacticals. No includes (micro doesn't support cross-file includes for syntax).

**Tech Stack:** Micro editor YAML syntax format, Go RE2-compatible regex

---

### Task 1: Create sml.yaml

**Files:**
- Create: `sml.yaml`

**Step 1: Create the complete sml.yaml file**

```yaml
filetype: sml

detect:
    filename: "\\.sml$|\\.sig$|\\.fun$|\\.cm$"

rules:
    # Comments — region must come first to prevent keyword highlighting inside
    - comment:
        start: "\\(\\*"
        end: "\\*\\)"
        rules:
            - todo: "(TODO|FIXME|XXX|HACK|NOTE):?"

    # String literals with escape sequences
    - constant.string:
        start: "\""
        end: "\""
        skip: "\\\\."
        rules:
            - constant.specialChar: "\\\\[abtnvfr\"\\\\]"
            - constant.specialChar: "\\\\\\^[@A-Z\\[\\\\\\]\\^_]"
            - constant.specialChar: "\\\\[0-9]{3}"
            - constant.specialChar: "\\\\u[0-9A-Fa-f]{4}"

    # Character literals: #"x" or #"\n" etc.
    - constant.string: "#\"(\\\\.|[^\"\\\\])\""

    # Control flow keywords
    - statement: "\\b(if|then|else|case|of|fn|raise|handle|while|do)\\b"

    # Declaration keywords
    - statement: "\\b(val|rec|fun|and|let|local|in|end|datatype|withtype|abstype|type|exception|with|op|as|before)\\b"

    # Module system keywords
    - preproc: "\\b(struct|sig|structure|signature|functor|open|sharing|where|eqtype|include)\\b"

    # Fixity keywords
    - statement: "\\b(infix|infixl|infixr|nonfix)\\b"

    # Boolean operators (short-circuit)
    - statement: "\\b(andalso|orelse)\\b"

    # Boolean constants
    - constant.bool: "\\b(true|false)\\b"

    # Language constants
    - constant: "\\b(nil|NONE|SOME|LESS|EQUAL|GREATER)\\b"

    # Built-in exception names
    - constant: "\\b(Bind|Chr|Div|Domain|Empty|Match|Option|Overflow|Size|Span|Subscript|Fail|Io)\\b"

    # Built-in types
    - type: "\\b(int|real|char|string|bool|unit|exn|word|list|option|ref|array|vector|order|substring)\\b"

    # Word operators
    - symbol.operator: "\\b(div|mod|not|o|abs)\\b"

    # Multi-char operators (order matters — longer first)
    - symbol.operator: "(=>|->|:=|::|:>|<>|>=|<=|\\.\\.\\.|;;)"

    # Single-char operators
    - symbol.operator: "[=<>@^!#~+\\-*/|]"

    # Semicolon and comma
    - symbol: "[;,]"

    # Wildcard
    - symbol: "\\b_\\b"

    # Numeric literals — order matters: most specific first
    # Hex integers
    - constant.number: "~?0x[0-9A-Fa-f]+"
    # Word hex literals
    - constant.number: "0wx[0-9A-Fa-f]+"
    # Word literals
    - constant.number: "0w[0-9]+"
    # Real with exponent
    - constant.number: "~?[0-9]+(\\.[0-9]+)?[eE]~?[0-9]+"
    # Real
    - constant.number: "~?[0-9]+\\.[0-9]+"
    # Decimal integers
    - constant.number: "~?[0-9]+"

    # Type variables: 'a, ''a (equality type var)
    - type: "'{1,2}[A-Za-z_][A-Za-z0-9_']*"

    # Brackets
    - symbol.brackets: "[(){}]|\\[|\\]"
```

**Step 2: Validate YAML is well-formed**

Run: `python3 -c "import yaml; yaml.safe_load(open('sml.yaml'))"`
Expected: No output (success)

**Step 3: Commit**

```bash
git add sml.yaml
git commit -m "feat: add SML'97 syntax highlighting for micro editor

Complete SML'97 coverage: all keywords, module system, operators,
numeric literals (hex, word, real), strings with escapes, character
literals, type variables, comments with TODO markers."
```

---

### Task 2: Create hol4.yaml

**Files:**
- Create: `hol4.yaml`

**Step 1: Create the complete hol4.yaml file**

```yaml
filetype: hol4

detect:
    filename: "Script\\.sml$"
    signature: "^(Theory|Theorem|Definition|Datatype|Inductive|CoInductive)\\b"

rules:
    # ============================================================
    # Comments — must come first
    # ============================================================
    - comment:
        start: "\\(\\*"
        end: "\\*\\)"
        rules:
            - todo: "(TODO|FIXME|XXX|HACK|NOTE):?"

    # ============================================================
    # ML String literals with escape sequences
    # ============================================================
    - constant.string:
        start: "\""
        end: "\""
        skip: "\\\\."
        rules:
            - constant.specialChar: "\\\\[abtnvfr\"\\\\]"
            - constant.specialChar: "\\\\\\^[@A-Z\\[\\\\\\]\\^_]"
            - constant.specialChar: "\\\\[0-9]{3}"
            - constant.specialChar: "\\\\u[0-9A-Fa-f]{4}"

    # Character literals: #"x" or #"\n" etc.
    - constant.string: "#\"(\\\\.|[^\"\\\\])\""

    # ============================================================
    # HOL4 script form regions
    # ============================================================

    # Definition name[attrs]: ... End/Termination
    - special:
        start: "^Definition\\b"
        end: "^(End|Termination)\\b"
        rules:
            - identifier.class: "^Definition\\b"
            - constant.number: "~?[0-9]+"
            - constant: "\\b(T|F|EMPTY|UNIV)\\b"
            - statement: "\\b(case|of|if|then|else|let|in)\\b"
            - symbol.operator: "(/\\\\|\\\\/|==>|<=>|[!?])"
            - symbol.operator: "[=<>~+\\-*/^|]"
            - identifier: "\\b[A-Z][A-Za-z0-9_']*\\b"

    # Theorem/Triviality name[attrs]: ... Proof
    - special:
        start: "^(Theorem|Triviality)\\b"
        end: "^Proof\\b"
        rules:
            - identifier.class: "^(Theorem|Triviality)\\b"
            - constant.number: "~?[0-9]+"
            - constant: "\\b(T|F|EMPTY|UNIV)\\b"
            - statement: "\\b(case|of|if|then|else|let|in)\\b"
            - symbol.operator: "(/\\\\|\\\\/|==>|<=>|[!?])"
            - symbol.operator: "[=<>~+\\-*/^|]"
            - identifier: "\\b[A-Z][A-Za-z0-9_']*\\b"

    # Proof ... QED (contains ML + tactics)
    - special:
        start: "^Proof\\b"
        end: "^QED\\b"
        rules:
            - identifier.class: "^(Proof|QED)\\b"
            - comment:
                start: "\\(\\*"
                end: "\\*\\)"
                rules:
                    - todo: "(TODO|FIXME|XXX|HACK|NOTE):?"
            - constant.string:
                start: "\""
                end: "\""
                skip: "\\\\."
                rules:
                    - constant.specialChar: "\\\\."
            # Quotation regions inside proofs — backtick
            - constant.string:
                start: "`"
                end: "`"
                rules:
                    - constant: "\\b(T|F|EMPTY|UNIV)\\b"
                    - statement: "\\b(case|of|if|then|else|let|in)\\b"
                    - symbol.operator: "(/\\\\|\\\\/|==>|<=>|[!?])"
                    - symbol.operator: "[=<>~+\\-*/^|]"
                    - constant.number: "~?[0-9]+"
            # Quotation regions — unicode single quotes
            - constant.string:
                start: "\u2018"
                end: "\u2019"
                rules:
                    - constant: "\\b(T|F|EMPTY|UNIV)\\b"
                    - statement: "\\b(case|of|if|then|else|let|in)\\b"
                    - symbol.operator: "(/\\\\|\\\\/|==>|<=>|[!?])"
                    - symbol.operator: "[=<>~+\\-*/^|]"
                    - constant.number: "~?[0-9]+"
            # Quotation regions — unicode double quotes
            - constant.string:
                start: "\u201C"
                end: "\u201D"
                rules:
                    - constant: "\\b(T|F|EMPTY|UNIV)\\b"
                    - statement: "\\b(case|of|if|then|else|let|in)\\b"
                    - symbol.operator: "(/\\\\|\\\\/|==>|<=>|[!?])"
                    - symbol.operator: "[=<>~+\\-*/^|]"
                    - constant.number: "~?[0-9]+"
            # cheat — always highlight as error
            - error: "\\bcheat\\b"
            # Tacticals
            - statement: "(>>|>-|>~|\\\\\\\\)"
            - statement: "\\b(THEN1?|by|suffices_by)\\b"
            # Tactics
            - identifier: "\\b(ho_match_mp_tac|simp|asm_simp|full_simp|asm_simp_tac|full_simp_tac|simp_tac|rw|fs|rfs|gs|gvs|sg|gns|imp_res_tac|res_tac|metis_tac|decide_tac|asm_rewrite_tac|once_rewrite_tac|once_asm_rewrite_tac|rpt|Cases|Cases_on|Induct|Induct_on|recInduct|completeInduct_on|pop_assum|mp_tac|drule|drule_then|drule_at|drule_at_then|irule|irule_at|mp_then|strip_tac|assume_tac|strip_assume_tac|disch_then|disch_tac|qx_choose_then|qx_gen_tac|gen_tac|rewrite_tac|wf_rel_tac|CASE_TAC|TOP_CASE_TAC|PURE_CASE_TAC|PURE_TOP_CASE_TAC|CONV_TAC|first_x_assum|last_x_assum|qexists_tac|qspec_then|qspecl_then|rename1|ntac|rev_drule|goal_assum|first_assum|last_assum|qpat_x_assum|qpat_assum|qabbrev_tac|Abbr|qunabbrev_tac|AP_TERM_TAC|AP_THM_TAC|SUBGOAL_THEN|MATCH_MP_TAC|EXISTS_TAC|FULL_SIMP_TAC|ASM_SIMP_TAC|REWRITE_TAC|ONCE_REWRITE_TAC|STRIP_TAC|DISCH_TAC|DISCH_THEN|UNDISCH_TAC|CONJ_TAC|EQ_TAC|DISJ1_TAC|DISJ2_TAC|RW_TAC|SRW_TAC)\\b"
            # ML keywords inside proofs
            - statement: "\\b(val|fun|let|local|in|end|fn|if|then|else|case|of|raise|handle|andalso|orelse|and|op)\\b"
            - preproc: "\\b(open|structure)\\b"
            - constant.bool: "\\b(true|false)\\b"
            - constant: "\\b(nil|NONE|SOME)\\b"
            - symbol.operator: "\\b(div|mod|o)\\b"
            - constant.number: "~?[0-9]+"
            - symbol.operator: "(=>|->|:=|::|<>|>=|<=)"
            - symbol.operator: "[=<>@^!#~+\\-*/|]"

    # Termination ... End (contains ML + tactics, same as Proof...QED)
    - special:
        start: "^Termination\\b"
        end: "^End\\b"
        rules:
            - identifier.class: "^(Termination|End)\\b"
            - comment:
                start: "\\(\\*"
                end: "\\*\\)"
                rules:
                    - todo: "(TODO|FIXME|XXX|HACK|NOTE):?"
            - error: "\\bcheat\\b"
            - statement: "(>>|>-|>~|\\\\\\\\)"
            - statement: "\\b(THEN1?|by|suffices_by)\\b"
            - identifier: "\\b(wf_rel_tac|simp|rw|fs|gvs|decide_tac|CONV_TAC|CASE_TAC|metis_tac|irule|drule|strip_tac)\\b"
            - statement: "\\b(val|fun|let|local|in|end|fn|if|then|else|case|of)\\b"
            - constant.number: "~?[0-9]+"
            - symbol.operator: "(=>|->|:=|::|<>)"
            - symbol.operator: "[=<>@^!#~+\\-*/|]"

    # Datatype: ... End
    - special:
        start: "^Datatype\\s*:"
        end: "^End\\b"
        rules:
            - identifier.class: "^Datatype\\b"
            - constant.number: "~?[0-9]+"
            - type: "\\b(num|bool|string|char|int|real|word|unit)\\b"
            - symbol.operator: "[=|;]"
            - identifier: "\\b[A-Z][A-Za-z0-9_']*\\b"

    # Inductive/CoInductive name: ... End
    - special:
        start: "^(Co)?Inductive\\b"
        end: "^End\\b"
        rules:
            - identifier.class: "^(Co)?Inductive\\b"
            - constant.number: "~?[0-9]+"
            - constant: "\\b(T|F|EMPTY|UNIV)\\b"
            - statement: "\\b(case|of|if|then|else|let|in)\\b"
            - symbol.operator: "(/\\\\|\\\\/|==>|<=>|[!?])"
            - symbol.operator: "[=<>~+\\-*/^|]"
            - identifier: "\\b[A-Z][A-Za-z0-9_']*\\b"

    # Theorem/Triviality/Type/Overload assignment form (single-line pattern)
    - special: "^(Theorem|Triviality|Type|Overload)\\b"

    # ============================================================
    # HOL4 top-level script keywords (pattern)
    # ============================================================
    - special: "^(Theory|Libs|Ancestors)\\b"
    - special: "^(End|QED|Proof|Termination)\\b"

    # ============================================================
    # HOL4 quotation regions (outside script forms, in ML context)
    # ============================================================

    # Backtick quotations
    - constant.string:
        start: "`"
        end: "`"
        rules:
            - constant: "\\b(T|F|EMPTY|UNIV)\\b"
            - statement: "\\b(case|of|if|then|else|let|in)\\b"
            - symbol.operator: "(/\\\\|\\\\/|==>|<=>|[!?])"
            - symbol.operator: "[=<>~+\\-*/^|]"
            - constant.number: "~?[0-9]+"
            - identifier: "\\b[A-Z][A-Za-z0-9_']*\\b"

    # Unicode single-quote quotations (LEFT/RIGHT SINGLE QUOTATION MARK)
    - constant.string:
        start: "\u2018"
        end: "\u2019"
        rules:
            - constant: "\\b(T|F|EMPTY|UNIV)\\b"
            - statement: "\\b(case|of|if|then|else|let|in)\\b"
            - symbol.operator: "(/\\\\|\\\\/|==>|<=>|[!?])"
            - symbol.operator: "[=<>~+\\-*/^|]"
            - constant.number: "~?[0-9]+"
            - identifier: "\\b[A-Z][A-Za-z0-9_']*\\b"

    # Unicode double-quote quotations (LEFT/RIGHT DOUBLE QUOTATION MARK)
    - constant.string:
        start: "\u201C"
        end: "\u201D"
        rules:
            - constant: "\\b(T|F|EMPTY|UNIV)\\b"
            - statement: "\\b(case|of|if|then|else|let|in)\\b"
            - symbol.operator: "(/\\\\|\\\\/|==>|<=>|[!?])"
            - symbol.operator: "[=<>~+\\-*/^|]"
            - constant.number: "~?[0-9]+"
            - identifier: "\\b[A-Z][A-Za-z0-9_']*\\b"

    # ============================================================
    # cheat in ML context — always error
    # ============================================================
    - error: "\\bcheat\\b"

    # ============================================================
    # Tacticals (in ML context outside proof regions)
    # ============================================================
    - statement: "(>>|>-|>~|\\\\\\\\)"
    - statement: "\\b(THEN1?|by|suffices_by)\\b"

    # ============================================================
    # Tactics (in ML context outside proof regions)
    # ============================================================
    - identifier: "\\b(ho_match_mp_tac|simp|asm_simp|full_simp|asm_simp_tac|full_simp_tac|simp_tac|rw|fs|rfs|gs|gvs|sg|gns|imp_res_tac|res_tac|metis_tac|decide_tac|asm_rewrite_tac|once_rewrite_tac|once_asm_rewrite_tac|rpt|Cases|Cases_on|Induct|Induct_on|recInduct|completeInduct_on|pop_assum|mp_tac|drule|drule_then|drule_at|drule_at_then|irule|irule_at|mp_then|strip_tac|assume_tac|strip_assume_tac|disch_then|disch_tac|qx_choose_then|qx_gen_tac|gen_tac|rewrite_tac|wf_rel_tac|CASE_TAC|TOP_CASE_TAC|PURE_CASE_TAC|PURE_TOP_CASE_TAC|CONV_TAC|first_x_assum|last_x_assum|qexists_tac|qspec_then|qspecl_then|rename1|ntac|rev_drule|goal_assum|first_assum|last_assum|qpat_x_assum|qpat_assum|qabbrev_tac|Abbr|qunabbrev_tac|AP_TERM_TAC|AP_THM_TAC|SUBGOAL_THEN|MATCH_MP_TAC|EXISTS_TAC|FULL_SIMP_TAC|ASM_SIMP_TAC|REWRITE_TAC|ONCE_REWRITE_TAC|STRIP_TAC|DISCH_TAC|DISCH_THEN|UNDISCH_TAC|CONJ_TAC|EQ_TAC|DISJ1_TAC|DISJ2_TAC|RW_TAC|SRW_TAC)\\b"

    # ============================================================
    # SML keywords (same as sml.yaml)
    # ============================================================

    # Control flow keywords
    - statement: "\\b(if|then|else|case|of|fn|raise|handle|while|do)\\b"

    # Declaration keywords
    - statement: "\\b(val|rec|fun|and|let|local|in|end|datatype|withtype|abstype|type|exception|with|op|as|before)\\b"

    # Module system keywords
    - preproc: "\\b(struct|sig|structure|signature|functor|open|sharing|where|eqtype|include)\\b"

    # Fixity keywords
    - statement: "\\b(infix|infixl|infixr|nonfix)\\b"

    # Boolean operators
    - statement: "\\b(andalso|orelse)\\b"

    # Boolean constants
    - constant.bool: "\\b(true|false)\\b"

    # Language constants
    - constant: "\\b(nil|NONE|SOME|LESS|EQUAL|GREATER)\\b"

    # Built-in exception names
    - constant: "\\b(Bind|Chr|Div|Domain|Empty|Match|Option|Overflow|Size|Span|Subscript|Fail|Io)\\b"

    # Built-in types
    - type: "\\b(int|real|char|string|bool|unit|exn|word|list|option|ref|array|vector|order|substring)\\b"

    # Word operators
    - symbol.operator: "\\b(div|mod|not|o|abs)\\b"

    # Multi-char operators
    - symbol.operator: "(=>|->|:=|::|:>|<>|>=|<=|\\.\\.\\.|;;)"

    # Single-char operators
    - symbol.operator: "[=<>@^!#~+\\-*/|]"

    # Semicolon and comma
    - symbol: "[;,]"

    # Wildcard
    - symbol: "\\b_\\b"

    # ============================================================
    # Numeric literals
    # ============================================================
    - constant.number: "~?0x[0-9A-Fa-f]+"
    - constant.number: "0wx[0-9A-Fa-f]+"
    - constant.number: "0w[0-9]+"
    - constant.number: "~?[0-9]+(\\.[0-9]+)?[eE]~?[0-9]+"
    - constant.number: "~?[0-9]+\\.[0-9]+"
    - constant.number: "~?[0-9]+"

    # Type variables
    - type: "'{1,2}[A-Za-z_][A-Za-z0-9_']*"

    # Brackets
    - symbol.brackets: "[(){}]|\\[|\\]"
```

**Step 2: Validate YAML is well-formed**

Run: `python3 -c "import yaml; yaml.safe_load(open('hol4.yaml'))"`
Expected: No output (success)

**Step 3: Commit**

```bash
git add hol4.yaml
git commit -m "feat: add HOL4 syntax highlighting for micro editor

Complete HOL4 Trindemossen-2 coverage: script forms (Definition,
Theorem, Triviality, Datatype, Inductive, CoInductive), quotation
regions (backtick and unicode), HOL term syntax inside quotations,
tactics, tacticals, cheat-as-error, plus full SML'97 base."
```

---

### Task 3: Create test sample files and verify

**Files:**
- Create: `test/sample.sml` (SML test file)
- Create: `test/fooScript.sml` (HOL4 test file)

**Step 1: Create SML sample file**

```sml
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
```

**Step 2: Create HOL4 sample file**

```sml
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
val t2 = \u2018x + y\u2019;
val t3 = \u201Cp /\\ q\u201D;

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
```

**Step 3: Verify both files open correctly in micro**

Run: `micro test/sample.sml` — verify SML highlighting works
Run: `micro test/fooScript.sml` — verify HOL4 highlighting works

Check for:
- Comments appear in comment color
- Strings appear in string color
- Keywords are highlighted
- Numbers are highlighted
- HOL4 script forms (Definition...End, Theorem...Proof...QED) are highlighted
- Quotation content is highlighted
- Tactics are highlighted
- `cheat` appears in error color

**Step 4: Commit test files**

```bash
git add test/
git commit -m "test: add SML and HOL4 sample files for syntax verification"
```

---

### Task 4: Final review and cleanup

**Step 1: Review sml.yaml against SML'97 keyword list**

Verify all keywords from the BNF are present:
- Control: if, then, else, case, of, fn, raise, handle, while, do
- Declaration: val, rec, fun, and, let, local, in, end, datatype, withtype, abstype, type, exception, with, op, as, before
- Module: struct, sig, structure, signature, functor, open, sharing, where, eqtype, include
- Fixity: infix, infixl, infixr, nonfix
- Boolean: andalso, orelse
- Word operators: div, mod, not, o, abs

**Step 2: Review hol4.yaml against HOL4 keyword/tactic list**

Verify:
- Script forms: Definition, Theorem, Triviality, Datatype, Inductive, CoInductive, Overload, Type
- Terminators: End, QED, Proof, Termination
- Top-level: Theory, Libs, Ancestors
- All tactics from design doc are present
- Quotation regions work for backtick, unicode single, unicode double

**Step 3: Fix any issues found and commit**

```bash
git add sml.yaml hol4.yaml
git commit -m "fix: address review findings in syntax files"
```
