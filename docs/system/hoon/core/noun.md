---
sort: 4
---

# Data model: `noun`

A value in Hoon is called a `noun`.  A noun is either a unsigned
integer of any size (`atom`), or an ordered pair of any two
nouns (`cell`).  In other words, a noun is a binary tree whose
leaves are unsigned integers.

Nouns are a Nock concept; there is no Nock syntax; so there is no
general noun syntax.  But nouns are usually written with square
brackets associating right; `[a b c]` means `[a [b c]]`.  In Hoon
we also see `{a b c}`, a constructor (`mold`) for `[a b c]`.

Nouns are almost like Lisp's S-expressions, but S-expressions
have dynamic type tags in atoms.  Nouns can lose this feature
because they're designed to sit under a static type system.  For
the same reason, nouns tend to be tuple-centric where Lisp is
list-centric.  Lisp `(a b c)` as a noun is `[a b c 0]`; Nock `[a
b c]` is Lisp `(a . b . c)`.

Nouns are immutable and acyclic.  A naive implementation uses
reference counting and needs no tracing GC.  There is no test for
pointer equality as in Lisp.  But indirect nouns have a lazily
computed short hash, so nonduplicates have O(1) comparison cost.

All kinds of atomic values can be and are stored as atoms:
unsigned integers, signed integers (with sign bit low), dates,
floats, UTF-8 strings (LSB first), even whole files.  Again,
a static type system is essential; an atom is not usable or even
printable if we don't know what it means.
