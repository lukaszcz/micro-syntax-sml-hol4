# micro-sml

Syntax highlighting for **SML'97** and **HOL4** (Trindemossen-2) in the [micro editor](https://micro-editor.github.io/).

## Files

- `sml.yaml` — Pure SML'97 syntax highlighting
- `hol4.yaml` — HOL4 proof script syntax highlighting (superset of SML)

## Installation

Install with [`just`](https://github.com/casey/just):

```sh
just install
```

Equivalent manual commands:

```sh
mkdir -p "$HOME/.config/micro/syntax"
cp sml.yaml hol4.yaml "$HOME/.config/micro/syntax/"
```

## File Detection

| File pattern | Syntax |
|---|---|
| `*.sml`, `*.sig`, `*.fun`, `*.cm` | SML |
| `*Script.sml` **and** first line matching `Theory`/`Theorem`/`Definition`/`Datatype`/`Inductive`/`CoInductive` | HOL4 |
| `*Script.sml` without that first-line match | SML |

## SML Coverage

- All SML'97 keywords (control flow, declarations, modules, fixity)
- Boolean operators (`andalso`, `orelse`) and word operators (`div`, `mod`, `not`, `o`, `abs`)
- Numeric literals: decimal, hex (`0xFF`), word (`0w42`, `0wx1F`), real (`3.14`, `1.5e10`), negative (`~7`)
- String literals with escape sequences (`\n`, `\^A`, `\065`)
- Character literals (`#"A"`, `#"\n"`)
- Type variables (`'a`, `''a`)
- Built-in types, constants, and exception names
- Module paths (`Structure.name`)
- Comments (`(* ... *)`) with TODO/FIXME markers

## HOL4 Coverage

Everything in SML, plus:

- **Script forms**: `Definition...End`, `Theorem...Proof...QED`, `Triviality...Proof...QED`, `Datatype:...End`, `Inductive...End`, `CoInductive...End`, `Quote...End`, `Overload`, `Type`
- **Modern syntax**: `Theory`, `Libs`, `Ancestors` headers
- **Quotation regions**: backtick (`` ` ``), unicode single (`‘...’`), unicode double (`“...”`) with inner HOL term highlighting
- **Unicode symbols**: `∀ ∃ λ ∧ ∨ ¬ ⇒ ⇔ ≠` highlighted as operators
- **Tactics**: convention-aware matching (`*_TAC`, `*_tac`, `*_THEN`, `*_LT`, etc.) plus irregular short forms like `rw`, `fs`, `gvs`, `drule`, `irule`, `Cases_on`, `Induct_on`, `qexists_tac`; includes uppercase tactics like `ACCEPT_TAC` and apostrophe-ending names like `Rewr'`
- **Tacticals**: symbolic (`>>`, `>>-`, `>>>`, `>|`, `>-`, `>~`, `\\\\`) and word tacticals (`THEN`, `THEN1`, `THENL`, `ORELSE`, `REPEAT`, `TRY`, `VALIDATE`, `by`, `suffices_by`)
- **`cheat`** highlighted as error

## Test Files

- `test/sample.sml` — exercises all SML syntax constructs
- `test/fooScript.sml` — exercises all HOL4 syntax constructs with modern syntax

## License

MIT. See `LICENSE`.
