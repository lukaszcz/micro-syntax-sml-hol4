## Project Overview

Syntax highlighting definitions for the [micro terminal editor](https://micro-editor.github.io/): `sml.yaml` (SML'97) and `hol4.yaml` (HOL4 proof scripts). Pure YAML configuration — no build system, no dependencies, no automated tests.

Primary files:
- `sml.yaml` — SML syntax rules
- `hol4.yaml` — HOL4 syntax rules (contains HOL4-specific rules plus duplicated SML rules)
- `test/sample.sml` and `test/fooScript.sml` — manual visual verification files

## Installation

```sh
# Install syntax files
mkdir -p ~/.config/micro/syntax
cp sml.yaml hol4.yaml ~/.config/micro/syntax/
```

## Testing

```sh
# Test by opening sample files in micro
micro -config-dir dir test/sample.sml       # verify SML highlighting
micro -config-dir dir test/fooScript.sml    # verify HOL4 highlighting
# Optional: validate YAML syntax
ruby -ryaml -e "YAML.load_file('sml.yaml'); YAML.load_file('hol4.yaml')"
```

There is no automated test suite. Verification is visual — open test files in micro and inspect highlighting.

## Architecture

### Micro YAML Syntax Format

Each file contains `filetype`, `detect` (filename regex + optional signature regex), and `rules` (ordered list, **first match wins per token**).

Two rule forms:
- **Pattern**: `- group: "regex"` — single-match highlighting
- **Region**: `- group: { start: "...", end: "...", rules: [...] }` — block matching with inner rules

### Rule Ordering Is Critical

Comments and strings must come first to prevent keywords matching inside them. More specific patterns (e.g., hex literals) must precede general ones (decimal literals). Reordering rules changes behavior.

### HOL4 Extends SML

`hol4.yaml` duplicates all SML rules after its HOL4-specific rules because micro has no include/import mechanism. Changes to shared SML rules must be applied to both files.

### HOL4 Detection

Uses `filename: "Script\\.sml$"` plus `signature` regex matching HOL4 keywords in the first line, so it activates for `*Script.sml` files that look like HOL4.

### Key Design Decisions

- **Three quotation styles** in HOL4: backtick, unicode single quotes (U+2018/U+2019), unicode double quotes (U+201C/U+201D) — each with inner HOL term rules
- **`cheat` highlighted as `error`** — always visually prominent
- **Tactic highlighting**: convention-based regex coverage (`*_TAC`, `*_tac`, `*_THEN`, `*_LT`, `*_TCL`, etc.) plus explicit irregular names; includes uppercase tactics (e.g. `ACCEPT_TAC`) and apostrophe-ending identifiers (e.g. `Rewr'`, `ABB'`)
- **Token groups**: `comment`, `statement` (control flow + declarations), `preproc` (module keywords), `special` (HOL4 script forms), `constant.*`, `type`, `symbol.*`, `identifier.*`, `error`

## Reference Documentation

- `docs/quotations.md` — HOL4 quotation syntax reference
- `docs/hol4-grammar.json` — TextMate grammar used as reference
- `docs/sml.vim` — Vim SML syntax reference

## Commit Guidelines

- Commit format: `type: subject` in imperative lowercase (e.g., `feat: add tactic highlighting`).
- Keep commits focused; avoid mixing unrelated changes.

## Instructions

- When finished, test by running `micro` (unsandboxed) on relevant files in `test/` and capturing terminal output. ALWAYS verify syntax highlighting by capturing `micro` terminal output on test files.
