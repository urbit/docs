+++
title = "Runes"
weight = 2
sort_by = "weight"
template = "sections/docs/chapters.html"
+++
Runes are a way to form expressions in Hoon.

## Non-Rune Expressions

### [Constants](./docs/reference/hoon-expressions/rune/constants.md)

Hoon uses runes to form expressions, but not all expressions have runes in them.  First, we have constant expressions (and also expressions that would be constant, but that they allow for interpolations).

### [Limbs and Wings](./docs/reference/hoon-expressions/limb/_index.md)

Limb and wing expressions also lack runes.

## Runes Proper

### [`. dot` (Nock)](./docs/reference/hoon-expressions/rune/dot.md)

Runes used for carrying out Nock operations in Hoon.

### [`! zap` (wild)](./docs/reference/hoon-expressions/rune/zap.md)

Wildcard category. Expressions that don't fit anywhere else go here.

### [`= tis` (Subject Modification)](./docs/reference/hoon-expressions/rune/tis.md)

Runes used to modify the subject.

### [`? wut` (Conditionals)](./docs/reference/hoon-expressions/rune/wut.md)

Runes used for branching on conditionals.

### [`| bar` (Cores)](./docs/reference/hoon-expressions/rune/bar.md)

Runes used to produce cores.

### [`+ lus` (Arms)](./docs/reference/hoon-expressions/rune/lus.md)

Runes used to define arms in a core.

### [`: col` (Cells)](./docs/reference/hoon-expressions/rune/col.md)

Runes used to produce cells, which are pairs of nouns.

### [`% cen` (Calls)](./docs/reference/hoon-expressions/rune/cen.md)

Runes used for making function calls in Hoon.

### [`^ ket` (Casts)](./docs/reference/hoon-expressions/rune/ket.md)

Runes that let us adjust types without violating type constraints.

### [`$ buc` (Structures)](./docs/reference/hoon-expressions/rune/buc.md)

Runes used for defining custom types.

### [`; mic` (Make)](./docs/reference/hoon-expressions/rune/mic.md)

Miscellaneous useful macros.

### [`~ sig` (Hints)](./docs/reference/hoon-expressions/rune/sig.md)

Runes that use Nock `11` to pass non-semantic info to the interpreter.

### [`--`, `==` (Terminators)](./docs/reference/hoon-expressions/rune/terminators.md)

Runes used to terminate expressions.
