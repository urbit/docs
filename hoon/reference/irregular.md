+++
title = "Irregular forms"
weight = 20
template = "doc.html"
aliases = ["docs/reference/hoon-expressions/irregular/"]
+++

##### Reading guide

Headings contain runes, phonetics and tokens. Description contains a link to the
docs and a short description of the rune. Both regular and irregular forms are given.

Want to `Ctrl-f` to find out the meaning of something weird you saw? Search for `\symbol`. ie `\?` or `\=`. It'll show you to the irregular forms that uses that symbol.

## `.` dot (nock)

Anything Nock can do, Hoon can do also.

### `.+` dotlus

[docs](@/docs/hoon/reference/rune/dot.md#dotlus) \\+

`[%dtls p=atom]`: increment an atom with Nock 4.

Regular: `.+(p)`

Irregular: `+(p)`

### `.=` dottis

[docs](@/docs/hoon/reference/rune/dot.md#dottis) \\=

`[%dtts p=hoon q=hoon]`: test for equality with Nock 5.

Regular: `.=(p q)`

Irregular: `=(p q)`

## `;` mic (make)

Miscellaneous useful macros.

### `;:` miccol

[docs](@/docs/hoon/reference/rune/mic.md#miccol) \\:

`[%mccl p=hoon q=(list hoon)]`: call a binary function as an n-ary function.

Regular: `;:(p q)`

Irregular: `:(p q)`

## `:` col (cells)

The cell runes.

### `:-` colhep

[docs](@/docs/hoon/reference/rune/col.md#colhep)  \\[\\]\\^\\+\\\`\\~

`[%clhp p=hoon q=hoon]`: construct a cell (2-tuple).

Regular: `:-(p q)`

Irregular:

```
  [a b]   ==>   :-(a b)
[a b c]   ==>   [a [b c]]
  a^b^c   ==>   [a b c]
    a/b   ==>   [%a b]
    a+b   ==>   [%a b]
     `a   ==>   [~ a]
 ~[a b]   ==>   [a b ~]
  [a b]~  ==>   [[a b] ~]
```

## `=` tis (flow)

Flow hoons change the subject. All non-flow hoons (except cores) pass the subject down unchanged.

### `=<` tisgal

[docs](@/docs/hoon/reference/rune/tis.md#tisgal) \\:

`[%tsgl p=hoon q=hoon]`: compose two hoons, inverted.

Regular: `=<(p q)`

Irregular: `p:q`

## `|` bar (core)

[docs](@/docs/hoon/reference/rune/bar.md) \\$

Core hoons are flow hoon.

Technically not irregular syntax, but worth mentioning.

- `|= bartis`
- `|. bardot`
- `|- barhep`
- `|* bartar`

The above runes produce a core with a single arm, named `$` ("buc"). We can recompute this arm with changes, useful for recursion among other things. Commonly used with the irregular syntax for `%=`, `:make`, like so: `$()`.

## `%` cen (call)

The invocation family of runes.

### `%=` centis

[docs](@/docs/hoon/reference/rune/cen.md#centis)  \\(\\)

`[%cnts p=wing q=(list (pair wing hoon))]`: take a wing with changes.

Regular: `%=(p a 1)`

Irregular: `p(a 1)`

### `%~` censig

[docs](@/docs/hoon/reference/rune/cen.md#censig) \\~

`[%cnsg p=wing q=hoon r=hoon]`: call with multi-armed door.

Regular: `%~(p q r)`

Irregular: `~(p q r)`

### `%-` cenhep

[docs](@/docs/hoon/reference/rune/cen.md#cenhep) \\(\\)

`[%cnhp p=hoon q=hoon]`: call a gate (function).

Regular: `%-(p q)`

Irregular: `(p q)`

Note: `(p)` becomes `$:p` (`=<($ p)`), which behaves as you would expect (func call w/o args).

## `$` buc (mold)

A mold is a gate (function) that helps us build simple and rigorous data structures.

### `$?` bucwut

[docs](@/docs/hoon/reference/rune/buc.md#bucwut) \\?

`[%bcwt p=(list model)]`: mold which normalizes a general union.

Regular: `$?(p)`

Irregular: `?(p)`

### `$_` buccab

[docs](@/docs/hoon/reference/rune/buc.md#buccab) \\_

`[%bccb p=value]`: mold which normalizes to an example.

Regular: `$_(p)`

Irregular: `_p`

## `?` wut (test)

Hoon has the usual branches and logical tests.

### `?!` wutzap

[docs](@/docs/hoon/reference/rune/wut.md#wutzap) \\!

`[%wtzp p=hoon]`: logical not.

Regular: `?!(p)`

Irregular: `!(p)`

### `?&` wutpam

[docs](@/docs/hoon/reference/rune/wut.md#wutpam) \\&

`[%wtpm p=(list hoon)]`: logical and.

Regular: `?&(p)`

Irregular: `&(p)`

### `?|` wutbar

[docs](@/docs/hoon/reference/rune/wut.md#wutbar) \\|

`[%wtbr p=(list hoon)]`: logical or.

Regular: `?|(p)`

Irregular: `|(p)`

## `^` ket (cast)

Lets us adjust types without violating type constraints.

### `^:` ketcol

[docs](@/docs/hoon/reference/rune/ket.md#ketcol) \\,

`[%ktcl p=spec]`: mold gate for type `p`.

Regular: `^:(p)`

Irregular: `,p`

### `^-` kethep

[docs](@/docs/hoon/reference/rune/ket.md#kethep) \\\`

`[%kthp p=model q=value]`: typecast by mold.

Regular: `^-(p q)`

Irregular: `` `p`q ``

### `^*` kettar

[docs](@/docs/hoon/reference/rune/ket.md#kettar) \\*

`[%kttr p=spec]`: produce bunt value of mold.

Regular: `^*(p)`

Irregular: `*p`

### `^=` kettis

[docs](@/docs/hoon/reference/rune/ket.md#kettis) \\=

`[%ktts p=toga q=value]`: name a value.

Regular: `^=(p q)`

Irregular: `p=q`

## Miscellaneous

### Trivial molds

- `*` noun.
- `@` atom.
- `^` cell.
- `?` loobean.
- `~` null.


### Values

\\~\\-\\.\\&\\|

- `~` null.
- `&` loobean true.
- `|` loobean false.
- `%a` constant `a`, where `a` can be an ((ir)regularly defined) atom or a symbol.

See [%sand](@/docs/hoon/reference/rune/constants.md#warm) for other irregular definitions of atoms.

### List addressing

- `&n` nth element of a list.
- `|n` tail of list after nth element (i.e. n is the head).

### Limbs

[docs](@/docs/hoon/reference/limbs/limb.md) \\+\\.\\^

`[%limb p=(each @ud [p=@ud q=@tas])]`: attribute of subject.

- `+15` is slot 15
- `.` is the whole subject (slot 1)
- `^a` is the `a` "of a higher scope", i.e. "resolve variable a, ignoring the first one found".
- `^^p` even higher, etc.
- 'Lark' syntax for slots / tree addressing:
```
+1
+2 -
+3 +
+4 -<
+5 ->
+6 +<
+7 +>
+8 -<-
...
```


### Wings

[docs](content/docs/hoon/reference/limbs/wing.md)
`[%wing p=(list limb)]`; a limb search path.
`a.b` finds limb `a` within limb `b` ("var" `a` within "var" `b`).

### Printing stuff

- `<a b c>` prints a [tape](../library/2q/#-tape).
- `>a b c<` prints a [tank](../library/2q/#-tank).

## Commentary

In our in-house examples throughout our documentation, we use irregular forms instead of regular for the sake of verbosity. But remember with irregular forms: everything is just runes! Like magic. In general, irregular forms (usually) read better, but of course regular forms provide more information about what you're doing by showing you the full rune. Of course, it's up to you, the Hoon programmer, as to whether or not you want to use these.

