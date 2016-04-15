---
sort: 5
---

# Subject flow (`=` runes)

Flow twigs change the subject.  (Or more precisely, a flow twig
compiles at least one of its subtwigs with a different subject.)
All non-flow twigs (except cores) pass the subject down unchanged.

## Overview

The simplest way to change the subject is to compose two twigs, 
`p` and `q`.  Let `x` be `(mint subject p)`, with product span 
`p.x` and nock formula `q.x`.  Let `y` be `(mint p.x q)`.  Then
their composition is `[p.y [7 q.x q.y]]`.

This composition is the `$per` twig.  A close relative is `$pin`,
which is `$per` over `[p .]`.  The new subject is a cell of `p`
and the old subject.  `$pin` is the simplest Hoon equivalent of
"declaring a variable" (introducing new data into the subject).

Another way to change the subject is to mutate it.  With the
`$set` twig, given a wing that resolves to a leg, we can write
instead of reading, *installing* a new value at that leg.  Of
course, we are creating a copy, not modifying the original.

## Structures

### `taco`: name with optional filling

A `taco` is either a symbol or a symbol-mold cell.  The mold is a
typecheck and cast.  For instance, when "initializing a variable"
with `:var`, we can cast the inferred type of the initial value
to match an explicit `taco` mold, or just state the symbol and
use the inferred type.

The `taco` syntax is `foo` for the symbol foo, or `foo/bar` for
symbol `foo` and mold `bar`.

## Definitions

The rune prefix is `=`.  Suffixes: `>` for `:per`, `<` for
`:rap`, `+` for `:pin`, `-` for `:nip`, `|` for `:new`, `/` for
`:var`, `;` for `:rev`, `.` for `:set`, and `^` for `:sip`.

### `:per`, `=>`, "tisgar", `{$per p/twig q/twig}`, "compose"

The product: `q`, compiled against the product of `p`.

Intuitively: uses `p` as the subject of `q`.

### `:rap`, `=<`, "tisgal", `{$rap p/twig q/twig}`, "reverse compose"

Expands to: `:per(q p)`

Intuitively: reverse of `:per`.

### `:pin`, `=+`, "tislus", `{$pin p/twig q/twig}`, "work with"

Expands to: `:per(:cons(p .) q)`

Intuitively: uses `[p subject]` as the subject of `q`.

### `:nip`, `=-`, "tishep", `{$nip p/twig q/twig}`, "work over"

Expands to: `:pin(q p)`

Intuitively: reverse of `:pin`.

### `:var`, `=/`, "tisfas", `{$var p/taco q/twig r/twig}, "with variable"

Expands to: `?@(p :pin(:name(p q) r) :pin(:cast(:(coat p) q) r)`

Intuitively: uses `[p=q subject]` as the subject of `r`.  If `p`
contains a mold, cast `q` to that mold.

### `:rev`, `=;`, "tissem", `{$var p/taco q/twig r/twig}, "over variable"

Expands to: `:var(p r q)`

Intuitively: reverse of `:var`.

### `:new`, `=|`, "tisbar", `{$new p/moss q/twig}`, "with blank"
 
Expands to: `:pin(:per($ p) q)`

Intuitively: pin the default value of `p`.

### `:set`, `=.`, "tisdot", `{$set p/wing q/twig r/twig}`, "mutate"

The product: `r`, compiled against a version of the subject 
with wing `p` modified to the product of `q`.

Intuitively: `r` with `p` set to `q`.  Almost an assignment.

### `:sip`, `=^`, "tisket", `{$sip p/taco q/wing r/twig s/twig}`, "advance"

The product is `s`, compiled against a version of the subject
in which the head of `r` is bound to variable `p`, and the tail
of `r` is assigned into the wing `q`.

Intuitively: `r` produces a cell; we pin the head and install the
tail.

Whyuppose we have a state machine with a function that
produces a cell, whose head is a result and whose tail is a new
state.  We want to use the head as a new variable, and stuff the
tail back into wherever we stored the old state.  This may also 
remind you of Haskell's State monad.

## Irregular forms

### Infix colon, p:q

Not to be confused with the wing `p.q`.  Translation:
```
p:q:r   :rap(p :rap(q r))
```

## Structures

Using a mold syntax we haven't learned yet:

```
|%
++  taco
  ?@(term {term moss})
::
++  twig
  {$per p/twig q/twig}
  {$rap p/twig q/twig}

  {$pin p/twig q/twig}
  {$nip p/twig q/twig}

  {$new p/moss q/twig}
  {$var p/taco q/twig r/twig}
  {$rev p/taco q/twig r/twig}
  {$set p/wing q/twig r/twig}
  {$sip p/taco q/wing r/twig s/twig}
--
```
