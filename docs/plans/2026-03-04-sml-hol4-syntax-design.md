# SML & HOL4 Syntax Highlighting for Micro Editor

## Goal

Create two micro editor syntax highlighting YAML files: `sml.yaml` (pure SML'97) and `hol4.yaml` (HOL4 Trindemossen-2 proof scripts). Both must follow micro's YAML syntax format exactly.

## File Detection

### sml.yaml
- `filename`: `\\.sml$|\\.sig$|\\.fun$|\\.cm$`
- No header/signature — broad match for all SML files

### hol4.yaml
- `filename`: `Script\\.sml$` — matches `*Script.sml` directly
- `signature`: `^(Theory|Theorem|Definition|Datatype|Inductive|CoInductive)\\b` — catches HOL4 files with comments before `Theory` header

Micro picks the more specific filename match, so `Script\\.sml$` wins over `\\.sml$` for HOL4 script files.

## Colorscheme Group Mapping

| Language element | Micro group | Rationale |
|---|---|---|
| Control keywords (if/then/else/case/of/fn/raise/handle/while/do) | `statement` | Control flow |
| Declaration keywords (val/fun/let/local/in/end/datatype/type/exception/...) | `statement` | Declarations |
| Module keywords (struct/sig/structure/signature/functor/open) | `preproc` | Module system |
| Operators (=>/:=/::/->/:>/div/mod/...) | `symbol.operator` | Operators |
| Booleans (true/false) | `constant.bool` | Booleans |
| Language constants (nil/NONE/SOME/LESS/EQUAL/GREATER) | `constant` | Constants |
| Built-in exceptions (Bind/Chr/Div/Domain/...) | `constant` | Exception names |
| Numeric literals | `constant.number` | Numbers |
| Strings | `constant.string` | String literals |
| String escapes | `constant.specialChar` | Escapes |
| Character literals (#"x") | `constant.string` | Characters |
| Comments | `comment` | Comments |
| TODO/FIXME in comments | `todo` | Markers |
| Type variables ('a, ''a) | `type` | Type vars |
| Built-in types (int/real/string/bool/...) | `type` | Types |
| Wildcard _ | `symbol` | Wildcard |
| Module paths (Foo.bar) | `identifier.class` | Module access |

### HOL4-specific groups

| HOL4 element | Micro group |
|---|---|
| Script form keywords (Theorem/Definition/Datatype/...) | `special` |
| Proof/QED/End terminators | `special` |
| Quotation delimiters (backticks, unicode quotes) | `constant.string` |
| HOL term content inside quotations | Inner rules within region |
| HOL binders (!/?\\/lambda) | `statement` |
| HOL connectives (/\\/\\//==>/...) | `symbol.operator` |
| HOL constants (T/F/EMPTY/UNIV) | `constant` |
| Tactics (simp/rw/fs/gvs/...) | `identifier` |
| Tacticals (>>/THEN/>-/by/...) | `statement` |
| cheat | `error` |

## SML Rules (sml.yaml)

Order (top-to-bottom, later overwrites earlier):

1. **Comment region**: `(* ... *)` with inner TODO rule
2. **String region**: `"..."` with escape inner rules
3. **Character literal**: `#"x"` pattern
4. **Control keywords**: if/then/else/case/of/fn/raise/handle/while/do
5. **Declaration keywords**: val/rec/fun/and/let/local/in/end/datatype/withtype/abstype/type/exception/with/op/as/before
6. **Module keywords**: struct/sig/structure/signature/functor/open/sharing/where/eqtype/include
7. **Fixity keywords**: infix/infixl/infixr/nonfix
8. **Boolean operators**: andalso/orelse
9. **Boolean constants**: true/false
10. **Language constants**: nil/NONE/SOME/LESS/EQUAL/GREATER
11. **Built-in exceptions**: Bind/Chr/Div/Domain/Empty/Match/Option/Overflow/Size/Span/Subscript
12. **Built-in types**: int/real/char/string/bool/unit/exn/word/list/option/ref/array/vector/order
13. **Operators**: => -> := :: :> ^ | @ o ; # ! ~ + - * / < > = <>
14. **Numeric literals**: hex, word, word-hex, real with exponent, real, decimal
15. **Type variables**: 'a, ''a
16. **Brackets**

### Complete SML'97 keyword list

Control: `if`, `then`, `else`, `case`, `of`, `fn`, `raise`, `handle`, `while`, `do`
Declaration: `val`, `rec`, `fun`, `and`, `let`, `local`, `in`, `end`, `datatype`, `withtype`, `abstype`, `type`, `exception`, `with`, `op`, `as`, `before`
Module: `struct`, `sig`, `structure`, `signature`, `functor`, `open`, `sharing`, `where`, `eqtype`, `include`
Fixity: `infix`, `infixl`, `infixr`, `nonfix`
Boolean: `andalso`, `orelse`
Operators (word): `div`, `mod`, `not`, `o`

## HOL4 Rules (hol4.yaml)

Includes all SML rules plus:

### HOL4 script form regions
- `Definition name[attrs]:` ... `End` / `Termination`
- `Theorem name[attrs]:` ... `Proof`
- `Triviality name[attrs]:` ... `Proof`
- `Proof` ... `QED`
- `Termination` ... `End`
- `Datatype:` ... `End`
- `Inductive name:` ... `End`
- `CoInductive name:` ... `End`
- `Theorem name[attrs] =` (assignment form)
- `Triviality name[attrs] =`
- `Type name[attrs] =`
- `Overload name[attrs] =`
- `Quote ...` ... `End`

### HOL4 top-level keywords (pattern)
`Theory`, `Libs`, `Ancestors`

### Quotation regions
- Backtick: `` ` ... ` `` with inner HOL term rules
- Unicode single: `' ... '` with inner HOL term rules
- Unicode double: `" ... "` with inner HOL term rules

### Inside HOL quotation regions
- HOL keywords: case/of/if/then/else/let/in
- HOL binders: `!`, `?`, `?!`, unicode variants
- HOL connectives: `/\`, `\/`, `==>`, `<=>`, `~`, unicode variants
- HOL constants: T/F/EMPTY/UNIV
- HOL special functions: IMAGE/FST/SND/LENGTH/MAP/LIST_REL/ALOOKUP/FLOOKUP/OPTREL/REVERSE
- Constructors: uppercase identifiers
- Numbers and strings (reuse SML rules)

### Tactics (in proof regions and general ML context)
simp, asm_simp, full_simp, simp_tac, rw, fs, rfs, gs, gvs, sg, gns, imp_res_tac, res_tac, metis_tac, rpt, Cases, Cases_on, Induct, Induct_on, recInduct, pop_assum, mp_tac, drule, drule_then, drule_at, drule_at_then, irule, irule_at, mp_then, strip_tac, assume_tac, strip_assume_tac, disch_then, disch_tac, qx_choose_then, qx_gen_tac, gen_tac, rewrite_tac, wf_rel_tac, CASE_TAC, TOP_CASE_TAC, PURE_CASE_TAC, PURE_TOP_CASE_TAC, CONV_TAC, ho_match_mp_tac, decide_tac, asm_rewrite_tac, once_rewrite_tac, once_asm_rewrite_tac

### Tacticals
`\\\\`, THEN, THEN1, `>>`, `>-`, `>~`, by, suffices_by

### Cheat
`cheat` highlighted as `error`

## Rule Ordering (both files)

1. Comments (region) — prevents keywords in comments from highlighting
2. Strings (region) — prevents keywords in strings from highlighting
3. Character literals (pattern)
4. HOL4 script form regions (hol4.yaml only)
5. Quotation regions (hol4.yaml only)
6. Keywords and operators (patterns)
7. Constants and numbers (patterns)
8. Type variables and identifiers (patterns)
9. Brackets and punctuation (patterns)
