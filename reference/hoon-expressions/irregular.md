+++
title = "Irregular forms"
weight = 7
template = "doc.html"
+++
##### `~palfun-foslup`

##### Reading guide

Headings contain runes, phonetics and tokens. Description contains a link to the docs and a short description of the rune. Both regular (R) and irregular (I) forms are given.

Want to `Ctrl-f` to find out the meaning of something weird you saw? Search for `\symbol`. ie `\?` or `\=`. It'll show you to the irregular forms that uses that symbol.

## . dot (nock)

Anything Nock can do, Hoon can do also.

### .+ dotlus

[docs](@/docs/reference/hoon-expressions/rune/dot.md) \\+
`[%dtls p=atom]`: increment an atom with Nock 4.

R: `.+(p)`
I: `+(p)`

### .= dottis

[docs](@/docs/reference/hoon-expressions/rune/dot.md) \\=
`[%dtts p=hoon q=hoon]`: test for equality with Nock 5.

R: `.=(p q)`
I: `=(p q)`

## ; mic (make)

Miscellaneous useful macros.

### ;: miccol

[docs](@/docs/reference/hoon-expressions/rune/mic.md) \\:
`[%mccl p=hoon q=(list hoon)]`: call a binary function as an n-ary function.

R: `;:(p q)`
I: `:(p q)`

## : col (cells)

The cell runes.

### :- colhep

[docs](@/docs/reference/hoon-expressions/rune/col.md)  \\[\\]\\^\\+\\\`\\~
`[%clhp p=hoon q=hoon]`: construct a cell (2-tuple).

R: `:-(p q)`
I:

```
  [a b]   ==>   :-(a b)
[a b c]   ==>   [a [b c]]
  a^b^c   ==>   [a b c]
    a/b   ==>   [%a b]
     `a   ==>   [~ a]
 ~[a b]   ==>   [a b ~]
  [a b]~  ==>   [[a b] ~]
```

## = tis (flow)

Flow hoons change the subject. All non-flow hoons (except cores) pass the subject down unchanged.

### =< tisgal

[docs](@/docs/reference/hoon-expressions/rune/tis.md) \\:
`[%tsgl p=hoon q=hoon]`: compose two hoons, inverted.

R: `=<(p q)`
I: `p:q`

## | bar (core)

[docs](@/docs/reference/hoon-expressions/rune/bar.md) \\$
Core hoons are flow hoon.

Technically not irregular syntax, but worth mentioning.

- `|= bartis`
- `|. bardot`
- `|- barhep`
- `|* bartar`

The above runes produce a core with a single arm, named `$` ("buc"). We can recompute this arm with changes, useful for recursion among other things. Commonly used with the irregular syntax for `%=`, `:make`, like so: `$()`.

## % cen (call)

The invocation family of runes.

### %= centis

[docs](@/docs/reference/hoon-expressions/rune/cen.md)  \\(\\)
`[%cnts p=wing q=(list (pair wing hoon))]`: take a wing with changes.

R: `%=(p a 1)`
I: `p(a 1)`

### %~ censig

[docs](@/docs/reference/hoon-expressions/rune/cen.md) \\~
`[%cnsg p=wing q=hoon r=hoon]`: call with multi-armed door.

R: `%~(p q r)`
I: `~(p q r)`

### %- cenhep

[docs](@/docs/reference/hoon-expressions/rune/cen.md) \\(\\)
`[%cnhp p=hoon q=hoon]`: call a gate (function).

R: `%-(p q)`
I: `(p q)`

Note: `(p)` becomes `$:p` (`=<($ p)`), which behaves as you would expect (func call w/o args).

## $ buc (mold)

A mold is a gate (function) that helps us build simple and rigorous data structures.

### $? bucwut

[docs](@/docs/reference/hoon-expressions/rune/buc.md) \\?
`[%bcwt p=(list model)]`: mold which normalizes a general union.

R: `$?(p)`
I: `?(p)`

### $_ buccab

[docs](@/docs/reference/hoon-expressions/rune/buc.md) \\_
`[%bccb p=value]`: mold which normalizes to an example.

R: `$_(p)`
I: `_p`

## ? wut (test)

Hoon has the usual branches and logical tests.

### ?! wutzap

[docs](@/docs/reference/hoon-expressions/rune/wut.md) \\!
`[%wtzp p=hoon]`: logical not.

R: `?!(p)`
I: `!(p)`

### ?& wutpam

[docs](@/docs/reference/hoon-expressions/rune/wut.md) \\&
`[%wtpm p=(list hoon)]`: logical and.

R: `?&(p)`
I: `&(p)`

### ?| wutbar

[docs](@/docs/reference/hoon-expressions/rune/wut.md) \\|
`[%wtbr p=(list hoon)]`: logical or.

R: `?|(p)`
I: `|(p)`

## ^ ket (cast)

Lets us adjust types without violating type constraints.

### ^- kethep

[docs](@/docs/reference/hoon-expressions/rune/ket.md) \\\`
`[%kthp p=model q=value]`: typecast by mold.

R: `^-(p q)`
I: `` `p`q ``

### ^= kettis

[docs](@/docs/reference/hoon-expressions/rune/ket.md) \\=
`[%ktts p=toga q=value]`: name a value.

R: `^=(p q)`
I: `p=q`

## Miscellaneous

### Trivial molds

\\*\\^\\?

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

See [%sand](@/docs/reference/hoon-expressions/rune/constants.md#warm) for other irregular definitions of atoms.

### List addressing

- `&n` nth element of a list.
- `|n` tail of list after nth element (i.e. n is the head).

### Limbs

[docs](@/docs/reference/hoon-expressions/limb/limb.md) \\+\\.\\^
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

[docs](content/docs/reference/hoon-expressions/limb/wing.md)
`[%wing p=(list limb)]`; a limb search path.
`a.b` finds limb `a` within limb `b` ("var" `a` within "var" `b`).

### Printing stuff

- `<a b c>` prints a [tape](../library/2q/#-tape).
- `>a b c<` prints a [tank](../library/2q/#-tank).

## Commentary

In our in-house examples throughout our documentation, we use irregular forms instead of regular for the sake of verbosity. But remember with irregular forms: everything is just runes! Like magic. In general, irregular forms (usually) read better, but of course regular forms provide more information about what you're doing by showing you the full rune. Of course, it's up to you, the Hoon programmer, as to whether or not you want to use these.

##### If we missed any, or if you saw something weird that's not in here, feel free to comment below!
