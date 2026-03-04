In HOL4, the backtick character ` is used for quotations, i.e. for *embedding HOL syntax inside ML*.

In HOL4 there are two distinct “languages” in a `fooScript.sml` file:

1. **Ordinary ML** (Poly/ML), where HOL objects are built/parsed by calling HOL functions.
2. **Script-only syntax extensions** (e.g. `Theorem … Proof … QED`, `Definition … End`, `Datatype …`, `Overload …`, `Quote … End`, etc.), where parts of the file are *implicitly* treated as HOL quotations.

Backquotes/quotations are required exactly when you are in case (1), i.e. when you need to *produce a HOL `term` or `hol_type` value inside ML*.

## Term quotations: `` ` … ` ``

A pair of backticks encloses a **HOL term** and produces an ML value of type `term`.

```hol4
val t = `x + 1`;
(* t : term *)
```

Semantically, this is parsed by the HOL term parser and is equivalent to building the term via `mk_var`, `mk_comb`, etc.

## Type quotations: `` `: … ` ``

If the quotation starts with a colon, it denotes a **HOL type** and produces an ML value of type `hol_type`.

```hol4
val ty = `:num -> bool`;
(* ty : hol_type *)
```

So syntactically:

* `` `t` ``   → HOL **term**
* `` `:ty` `` → HOL **type**

The leading colon is what disambiguates the two.

## Where you need HOL quotations (backquotes / term quotes)

### A. Anywhere an ML expression expects a `term` or `hol_type`

Typical examples inside scripts:

* **Tactic arguments** (rewrite lists, `Q.SPEC_TAC`, `Cases_on`, `Induct_on`, `simp`, `rw`, `metis_tac` set-ups, etc.):

  * `rw[THEOREM_NAME]` doesn’t need quoting for the theorem name (it’s an ML identifier),
  * but **terms/types do**: `Cases_on ‘x’`, `Induct_on ‘n’`, `Q.SPEC_TAC (‘n’, ‘n’)`, etc.

* **Term/type constructors and parsers**:

  * `Term ‘p /\ q’`, `Parse.Term ‘…’`
  * `Type ‘:num -> bool’`, `Parse.Type ‘…’`
  * The documentation explicitly describes that term quotations expand to `Parse.Term …` and type quotations to `Parse.Type …`.

### B. Any time you want “HOL syntax” embedded in ML code (not a script form)

If you’re writing something like:

```hol4
val t = `x + 1`;
val ty = `:num list`;
```

you’re in ML, so you need a quotation to get a `term`/`hol_type`.

### C. Antiquotation inside quotations (`^…`)

Inside a quotation, `^x` or `^(...)` injects an ML `term` (or a `hol_type` in type quotations) into the parsed HOL syntax.
If you need to inject a **type into a term quotation**, you must wrap it with `ty_antiq` first (because term parsing only accepts antiquoted *terms*).

## Where you usually *don’t* need backquotes in `*Script.sml`

### Script “special syntactic forms”

**IMPORTANT**: In `Theorem …`, `Definition …`, `Datatype …`, etc., the *statement part* is already parsed as a HOL quotation by the script reader, so you normally write:

```hol4
Theorem foo:
  !n. P n ==> Q n
Proof
  ...
QED
```

rather than `Theorem foo: “!n. P n ==> Q n”`.

(Those constructs are exactly why the manual says script files are a *superset of ML* and have special syntax.)

## Including a literal backquote character inside a HOL quotation

Inside HOL quotations, the escape character is **caret** `^`. If you need to literally include a backquote character in the quoted text, you escape it with `^`` (caret + backquote). The manual describes this caret escaping behavior for quotations.

## Alternative quotation characters

Instead of using backtick characters, quotations can be enclosed in the unicode characters ‘ and ’. For example:
```hol4
val _ = Define ‘double n = n + n’;
```

**IMPORTANT**: In HOL4, the single quote character ' **cannot** be used for quotations.
