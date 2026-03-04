The task is to create comprehesive regex highlighting rules for SML
and HOL4 in the micro editor. It is CRITICAL to follow the micro YAML
format for syntax rules EXACTLY. Make sure you handle micro colorschemes
correctly.

Read https://github.com/micro-editor/micro/blob/master/runtime/syntax/README.md
and the YAML files in https://github.com/micro-editor/micro/tree/master/runtime/syntax
to understand micro syntax highlighting YAML file format.

Create two micro syntax highlighting YAML files: sml.yaml and hol4.yaml.

The file sml.yaml should contain SML regex highlighting rules suitable
for micro. Read docs/sml.vim and docs/sml-minimal-highlighter.yaml to
understand SML regex highlighting rules in general. Make sure that
the highlighting rules are COMPLETE, NOT minimal. Read online SML
documentation (https://cse.buffalo.edu/~regan/cse305/MLBNF.pdf) to make
sure you have a correct understanding of SML'97 language. Include ALL
SML'97 keywords and language constructions.

When done with sml.yaml, create hol4.yaml – comprehensive HOL4
regex syntax highlighting rules basing on the SML rules. Read
docs/hol4-grammar.json for an example of HOL4 highlighting rules. Make
sure to support modern HOL4 syntax with keywords `Theory`, `Libs`,
`Ancestors`, `Definition`, `Theorem`, etc. Support ALL HOL4 keywords
and language constructions (HOL4 version Trindemossen-2). Read
docs/quotations.md to understand quotations in modern HOL4.

The pure SML syntax highlighting rules in sml.yaml should be activated
on all `*.sml` files EXCEPT `*Script.sml` and `*.sml` files with
`Theory` header as their first line. All `*Script.sml` files should
activate HOL4 syntax highlighting rules in hol4.yaml. All `*.sml` files
with HOL4 `Theory` header should activate HOL4 rules in hol4.yaml.
