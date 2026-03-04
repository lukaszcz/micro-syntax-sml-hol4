# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Syntax highlighting definitions for the [micro terminal editor](https://micro-editor.github.io/): `sml.yaml` (SML'97) and `hol4.yaml` (HOL4 proof scripts). Pure YAML configuration — no build system, no dependencies, no automated tests.

## Installation / Manual Testing

```sh
# Install syntax files
mkdir -p ~/.config/micro/syntax
cp sml.yaml hol4.yaml ~/.config/micro/syntax/

# Test by opening sample files in micro
micro test/sample.sml       # verify SML highlighting
micro test/fooScript.sml    # verify HOL4 highlighting
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
- **Token groups**: `comment`, `statement` (control flow + declarations), `preproc` (module keywords), `special` (HOL4 script forms), `constant.*`, `type`, `symbol.*`, `identifier.*`, `error`

## Reference Documentation

- `docs/quotations.md` — HOL4 quotation syntax reference
- `docs/hol4-grammar.json` — TextMate grammar used as reference
- `docs/sml.vim` — Vim SML syntax reference
- `docs/plans/` — Original design and implementation plans
