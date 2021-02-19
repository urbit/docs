+++
title = "Runes"
weight = 20
sort_by = "weight"
template = "sections/docs/chapters.html"
aliases = ["docs/reference/hoon-expressions/rune/"]
+++
Runes are a way to form expressions in Hoon.

## Non-Rune Expressions

### [Constants](@/docs/hoon/reference/rune/constants.md)

Hoon uses runes to form expressions, but not all expressions have runes in them.  First, we have constant expressions (and also expressions that would be constant, but that they allow for interpolations).

### [Limbs and Wings](@/docs/hoon/reference/limb/_index.md)

Limb and wing expressions also lack runes.

## Runes Proper

### [`. dot` (Nock)](@/docs/hoon/reference/rune/dot.md)

Runes used for carrying out Nock operations in Hoon.

### [`! zap` (wild)](@/docs/hoon/reference/rune/zap.md)

Wildcard category. Expressions that don't fit anywhere else go here.

### [`= tis` (Subject Modification)](@/docs/hoon/reference/rune/tis.md)

Runes used to modify the subject.

### [`? wut` (Conditionals)](@/docs/hoon/reference/rune/wut.md)

Runes used for branching on conditionals.

### [`| bar` (Cores)](@/docs/hoon/reference/rune/bar.md)

Runes used to produce cores.

### [`+ lus` (Arms)](@/docs/hoon/reference/rune/lus.md)

Runes used to define arms in a core.

### [`: col` (Cells)](@/docs/hoon/reference/rune/col.md)

Runes used to produce cells, which are pairs of nouns.

### [`% cen` (Calls)](@/docs/hoon/reference/rune/cen.md)

Runes used for making function calls in Hoon.

### [`^ ket` (Casts)](@/docs/hoon/reference/rune/ket.md)

Runes that let us adjust types without violating type constraints.

### [`$ buc` (Structures)](@/docs/hoon/reference/rune/buc.md)

Runes used for defining custom types.

### [`; mic` (Make)](@/docs/hoon/reference/rune/mic.md)

Miscellaneous useful macros.

### [`~ sig` (Hints)](@/docs/hoon/reference/rune/sig.md)

Runes that use Nock `11` to pass non-semantic info to the interpreter.

### [`--`, `==` (Terminators)](@/docs/hoon/reference/rune/terminators.md)

Runes used to terminate expressions.
