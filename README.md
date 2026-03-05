# micro-sml

Syntax highlighting for **SML'97** and **HOL4** (Trindemossen-2) in the [micro editor](https://micro-editor.github.io/).

## Files

- `sml.yaml` — Pure SML'97 syntax highlighting
- `hol4.yaml` — HOL4 proof script syntax highlighting (superset of SML)

## Installation

Copy the syntax files to micro's user syntax directory:

```sh
mkdir -p ~/.config/micro/syntax
cp sml.yaml hol4.yaml ~/.config/micro/syntax/
```

## File Detection

| File pattern | Syntax |
|---|---|
| `*.sml`, `*.sig`, `*.fun`, `*.cm` | SML |
| `*Script.sml` | HOL4 |
| `*.sml` with `Theory`/`Theorem`/`Definition`/... in first lines | HOL4 |

## SML Coverage

- All SML'97 keywords (control flow, declarations, modules, fixity)
- Boolean operators (`andalso`, `orelse`) and word operators (`div`, `mod`, `not`, `o`, `abs`)
- Numeric literals: decimal, hex (`0xFF`), word (`0w42`, `0wx1F`), real (`3.14`, `1.5e10`), negative (`~7`)
- String literals with escape sequences (`\n`, `\^A`, `\065`, `\u0041`)
- Character literals (`#"A"`, `#"\n"`)
- Type variables (`'a`, `''a`)
- Built-in types, constants, and exception names
- Module paths (`Structure.name`)
- Comments (`(* ... *)`) with TODO/FIXME markers

## HOL4 Coverage

Everything in SML, plus:

- **Script forms**: `Definition...End`, `Theorem...Proof...QED`, `Triviality...Proof...QED`, `Datatype:...End`, `Inductive...End`, `CoInductive...End`, `Quote...End`, `Overload`, `Type`
- **Modern syntax**: `Theory`, `Libs`, `Ancestors` headers
- **Quotation regions**: backtick (`` ` ``), unicode single (`'...'`), unicode double (`\u201C...\u201D`) with inner HOL term highlighting
- **Unicode symbols**: `\u2200 \u2203 \u03BB \u2227 \u2228 \u00AC \u21D2 \u21D4 \u2260` highlighted as operators
- **Tactics**: convention-aware matching from HOL4 docs (`*_TAC`, `*_tac`, `*_THEN`, `*_LT`, etc.) plus irregular short forms like `rw`, `fs`, `gvs`, `drule`, `irule`, `Cases_on`, `Induct_on`, `qexists_tac`
- **Tacticals**: symbolic (`>>`, `>>-`, `>>>`, `>|`, `>-`, `>~`, `\\\\`) and word tacticals (`THEN`, `THEN1`, `THENL`, `ORELSE`, `REPEAT`, `TRY`, `VALIDATE`, `by`, `suffices_by`)
- **`cheat`** highlighted as error

## Test Files

- `test/sample.sml` — exercises all SML syntax constructs
- `test/fooScript.sml` — exercises all HOL4 syntax constructs with modern syntax

## License

Public domain.
