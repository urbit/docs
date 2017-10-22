---
navhome: /developer/docs/
sort: 22
title: Irregular forms
comments: true
---

## Irregular forms, a compilation
##### `~palfun-foslup`

<br />

*Original `fora` post* [*here*](http://urbit.org/fora/posts/~2016.12.29..19.37.08..89d5~/).

##### Reading guide
Headings contain runes, phonetics and tokens. Description contains a link to the docs and a short description of the rune. Both regular (R) and irregular (I) forms are given.

Want to `ctrl-f` to find out the meaning of something weird you saw? Search for `\symbol`. ie `\?` or `\=`. It'll show you to the irregular forms that uses that symbol.

## . dot (nock)

Anything Nock can do, Hoon can do also.

### .+ dotlus

[docs](/developer/docs/hoon/twig/dot/lus/) \\+  
`{$dtls p/atom}`: increment an atom with Nock 4.

R: `.+(p)`  
I: `+(p)`

### .= dottis

[docs](/developer/docs/hoon/twig/dot/tis/) \\=  
`{$dtts p/seed q/seed}`: test for equality with Nock 5.

R: `.=(p q)`  
I: `=(p q)`

## ; sem (make)

Miscellaneous useful macros.

### ;: semcol

[docs](/developer/docs/hoon/twig/sem/col/) \\:  
`{$smcl p/seed q/(list seed)}`: call a binary function as an n-ary function.

R: `;:(p q)`  
I: `:(p q)`

## : col (cells)

The cell twigs.

### :- colhep

[docs](/developer/docs/hoon/twig/col/hep/)  \\[\\]\\^\\+\\\`\\~  
`{$clhp p/seed q/seed}`: construct a cell (2-tuple).

R: `:-(p q)`  
I:

```
  [a b]   ==>   :-(a b)
[a b c]   ==>   [a [b c]]
  a^b^c   ==>   [a b c]
    a+b   ==>   [%a b]
     `a   ==>   [~ a]
 ~[a b]   ==>   [a b ~]
  [a b]~  ==>   [[a b] ~]
```

## = tis (flow)

Flow twigs change the subject. All non-flow twigs (except cores) pass the subject down unchanged.

### =< tisgal

[docs](/developer/docs/hoon/twig/tis/gal/) \\:  
`{$tsgl p/seed q/seed}`: compose two twigs, inverted.

R: `=<(p q)`  
I: `p:q`

## | bar (core)

[docs](/developer/docs/hoon/twig/bar/) \\$  
Core twigs are flow twigs.

Technically not irregular syntax, but worth mentioning.

* `|= bartis`
* `|. bardot`
* `|- barhep`
* `|* bartar`

The above runes produce a core with a single arm, named `$` (or `:moar`). We can recompute this arm with changes, useful for recursion among other things. Commonly used with the irregular syntax for `%=` (*centis*), like so: `$()`.

## % cen (call)

The invocation family of twigs.

### %= centis

[docs](/developer/docs/hoon/twig/cen/tis/)  \\(\\)  
`{$cnts p/wing q/(list (pair wing seed))}`: take a wing with changes.

R: `%=(p a 1)`  
I: `p(a 1)`

### %~ censig

[docs](/developer/docs/hoon/twig/cen/sig/) \\~  
`{$cnsg p/wing q/seed r/seed}`: call with multi-armed door.

R: `%~(p q r)`  
I: `~(p q r)`

### %- cenhep

[docs](https://urbit.org/~~/docs/hoon/twig/cen/hep/) \\(\\)  
`{$cnhp p/seed q/seed}`: call a gate (function).

R: `%-(p q)`  
I: `(p q)`

Note: `(p)` becomes `$:p` (`=<($ p)`), which behaves as you would expect (func call w/o args).

## $ buc (mold)

A mold is a gate (function) that helps us build simple and rigorous data structures.

### $: buccol

[docs](/developer/docs/hoon/twig/buc/col/) \\{\\}  
`{$bccl p/(list moss)}`: form a mold which recognizes a tuple.

R: `$:(p q)`  
I: `{p q}`

### $= buctis

[docs](/developer/docs/hoon/twig/buc/tis/) \\/  
`{$bcts p/@tas q/moss}`: mold which wraps a face around another mold.

R: `$=(p q)`  
I: `p/q`

### $? bucwut

[docs](/developer/docs/hoon/twig/buc/wut/) \\?  
`{$bcwt p/(list moss)}`: mold which normalizes a general union.

R: `$?(p)`  
I: `?(p)`

### $_ buccab

[docs](/developer/docs/hoon/twig/buc/cab/) \\_  
`{$bccb p/seed}`: mold which normalizes to an example.

R: `$_(p)`  
I: `_p`

## ? wut (test)

Hoon has the usual branches and logical tests.

### ?! wutzap

[docs](/developer/docs/hoon/twig/wut/zap/) \\!  
`{$wtzp p/seed}`: logical not.

R: `?!(p)`  
I: `!(p)`

### ?& wutpam

[docs](/developer/docs/hoon/twig/wut/pam/) \\&  
`{$wtpm p/(list seed)}`: logical and.

R: `?&(p)`  
I: `&(p)`

### ?& wutbar

[docs](/developer/docs/hoon/twig/wut/bar/) \\|  
`{$wtbr p/(list seed)}`: logical or.

R: `?|(p)`  
I: `|(p)`

## ^ ket (cast)

Lets us adjust spans without violating type constraints.

### ^- kethep

[docs](/developer/docs/hoon/twig/ket/hep/) \\\`  
`{$kthp p/moss q/seed}`: typecast by mold.

R: `^-(p q)`  
I: `` `p`q ``

### ^= kettis

[docs](/developer/docs/hoon/twig/ket/tis/) \\=  
`{$ktts p/toga q/seed}`: name a value.

R: `^=(p q)`  
I: `p=q`

## Miscellaneous

### Trivial molds

\\*\\^\\?

* `*` noun.
* `^` cell.
* `?` loobean.
* `$~` null.

### Values

\\~\\-\\.\\&\\|

* `~` null.
* `&` loobean true.
* `|` loobean false.
* `%a` constant `a`, where `a` can be an ((ir)regularly defined) atom or a symbol.

See [:sand](/developer/docs/hoon/twig/atom/sand/) for other irregular definitions of atoms.

### List addressing
* `&n` nth element of a list.
* `|n` tail of list after nth element (i.e. n is the head).

### Limbs :limb

[docs](/developer/docs/hoon/twig/limb/limb/) \\+\\.\\^  
`{$limb p/(each @ud {p/@ud q/@tas})}`: attribute of subject.

* `+15` is slot 15
* `.` is the whole subject (slot 1)
* `^a` is the `a` "of a higher scope", i.e. "resolve variable a, ignoring the first one found".
* `^^p` even higher, etc.
* 'Lark' syntax for slots / tree addressing:
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


### Wings :wing

[docs](https://urbit.org/~~/docs/hoon/twig/limb/wing/) \\.  
`{$wing p/(list limb)`; a limb search path.

`a.b` finds limb `a` within limb `b` ("var" `a` within "var" `b`).

### Printing stuff

* `<a b c>` prints a [tape](/developer/docs/hoon/library/2q/#-tape).
* `>a b c<` prints a [tank](/developer/docs/hoon/library/2q/#-tank).

## Commentary

 In our in-house examples throughout our documentation, we use irregular forms instead of regular for the sake of verbosity. But remember with irregular forms: everything is just runes! Like magic. In general, irregular forms (usually) read better, but of course regular forms provide more information about what you're doing by showing you the full rune. Of course, it's up to you, the Hoon programmer, as to whether or not you want to use these.

 ##### If we missed any, or if you saw something weird that's not in here, feel free to comment below!
