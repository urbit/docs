---
sort: 11
---

# Intrinsics (`.` runes)

Anything Nock can do, Hoon can do.

## Regular forms

### `:bump`, `.+`, "dotlus", `{$bump p/twig}`

Syntax: *1-fixed*

The product: the product of `p`, which must be an atom, plus 1.

### `:same`, `.=`, "dottis", `{$same p/twig q/twig}`

Syntax: *2-fixed*.

The product: yes iff `p` and `q` produce the same value.  The span
of `p` must nest within the span of `q`, or vice versa.

### `:nock`, `.*`, "dottar", `{$nock p/twig q/twig}`

The product: Nock of the formula produced by `q`, with the
subject produced by `p`.  Typeless.

### `:wish`, `.^`, "dotket", `{$wish p/moss q/twig}`

The product: the noun `q` dereferenced in the Urbit global
namespace.  The product must nest within the icon of `p`.

Only available in user-level code.  Not blocking except in
dojo-level code (blocks for a generator, fails if it would block
for an app).
