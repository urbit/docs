---
navhome: /docs/
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

### .+ dotlus :bump

[docs](https://urbit.org/docs/hoon/twig/dot-nock/lus-bump/) \\+  
`{$bump p/atom}`: increment an atom with Nock 4.

R: `.+(p)`  
I: `+(p)`

### .= dottis :same

[docs](https://urbit.org/docs/hoon/twig/dot-nock/tis-same/) \\=  
`{$same p/seed q/seed}`: test for equality with Nock 5.

R: `.=(p q)`  
I: `=(p q)`

## ; sem (make)

Miscellaneous useful macros.

### ;: semcol :wad

[docs](https://urbit.org/docs/hoon/twig/sem-make/col-wad/) \\:  
`{$wad p/seed q/(list seed)}`: call a binary function as an n-ary function.

R: `;:(p q)`  
I: `:(p q)`

## : col (cells)

The cell twigs.

### :- colhep :cons

[docs](https://urbit.org/docs/hoon/twig/col-cell/hep-cons/)  \\[\\]\\^\\+\\\`\\~  
`{$cons p/seed q/seed}`: construct a cell (2-tuple).

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

### =< tisgal :rap

[docs](https://urbit.org/docs/hoon/twig/tis-flow/gal-rap/) \\:  
`{$rap p/seed q/seed}`: compose two twigs, inverted.

R: `=<(p q)`  
I: `p:q`

## | bar (core)

[docs](https://urbit.org/docs/hoon/twig/bar-core/) \\$  
Core twigs are flow twigs.

Technically not irregular syntax, but worth mentioning.

* `|= bartis :gate`
* `|. bardot :trap`
* `|- barhep :loop`
* `|* bartar :gill`

The above runes produce a core with a single arm, named `$` (or `:moar`). We can recompute this arm with changes, useful for recursion among other things. Commonly used with the irregular syntax for `%=`, `:make`, like so: `$()`.

## % cen (call)

The invocation family of twigs.

### %= centis :make

[docs](https://urbit.org/docs/hoon/twig/cen-call/tis-make/)  \\(\\)  
`{$make p/wing q/(list (pair wing seed))}`: take a wing with changes.

R: `%=(p a 1)`  
I: `p(a 1)`

### %~ censig :open

[docs](https://urbit.org/docs/hoon/twig/cen-call/sig-open/) \\~  
`{$cnsg p/wing q/seed r/seed}`: call with multi-armed door.

R: `%~(p q r)`  
I: `~(p q r)`

### %- cenhep :call

[docs](https://urbit.org/~~/docs/hoon/twig/cen-call/hep-call/) \\(\\)  
`{$call p/seed q/seed}`: call a gate (function).

R: `%-(p q)`  
I: `(p q)`

Note: `(p)` becomes `$:p` (`=<($ p)`), which behaves as you would expect (func call w/o args).

## $ buc (mold)

A mold is a gate (function) that helps us build simple and rigorous data structures.

### $: buccol :bank

[docs](https://urbit.org/docs/hoon/twig/buc-mold/col-bank/) \\{\\}  
`{$bank p/(list moss)}`: form a mold which recognizes a tuple.

R: `$:(p q)`  
I: `{p q}`

### $= buctis :coat

[docs](https://urbit.org/docs/hoon/twig/buc-mold/tis-coat/) \\/  
`{$coat p/@tas q/moss}`: mold which wraps a face around another mold.

R: `$=(p q)`  
I: `p/q`

### $? bucwut :pick

[docs](https://urbit.org/docs/hoon/twig/buc-mold/wut-pick/) \\?  
`{$pick p/(list moss)}`: mold which normalizes a general union.

R: `$?(p)`  
I: `?(p)`

### $_ buccab :shoe

[docs](https://urbit.org/docs/hoon/twig/buc-mold/cab-shoe/) \\_  
`{$shoe p/seed}`: mold which normalizes to an example.

R: `$_(p)`  
I: `_p`

## ? wut (test)

Hoon has the usual branches and logical tests.

### ?! wutzap :not

[docs](https://urbit.org/docs/hoon/twig/wut-test/zap-not/) \\!  
`{$not p/seed}`: logical not.

R: `?!(p)`  
I: `!(p)`

### ?& wutpam :and

[docs](https://urbit.org/docs/hoon/twig/wut-test/pam-and/) \\&  
`{$and p/(list seed)}`: logical and.

R: `?&(p)`  
I: `&(p)`

### ?& wutbar :or

[docs](https://urbit.org/docs/hoon/twig/wut-test/bar-or/) \\|  
`{$or p/(list seed)}`: logical or.

R: `?|(p)`  
I: `|(p)`

## ^ ket (cast)

Lets us adjust spans without violating type constraints.

### ^- kethep :cast

[docs](https://urbit.org/docs/hoon/twig/ket-cast/hep-cast/) \\\`  
`{$cast p/moss q/seed}`: typecast by mold.

R: `^-(p q)`  
I: ```p`q``

### ^= kettis :name

[docs](https://urbit.org/docs/hoon/twig/ket-cast/tis-name/) \\=  
`{$name p/toga q/seed}`: name a value.

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

See [:sand](https://urbit.org/docs/hoon/twig/atom/sand/) for other irregular definitions of atoms.

### List addressing
* `&n` nth element of a list.
* `|n` tail of list after nth element (i.e. n is the head).

### Limbs :limb

[docs](https://urbit.org/docs/hoon/twig/limb/limb/) \\+\\.\\^  
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

* `<a b c>` prints a [tape](https://urbit.org/docs/hoon/library/2q/#-tape).
* `>a b c<` prints a [tank](https://urbit.org/docs/hoon/library/2q/#-tank).

## Commentary

 In our in-house examples throughout our documentation, we use irregular forms instead of regular for the sake of verbosity. But remember with irregular forms: everything is just runes! Like magic. In general, irregular forms (usually) read better, but of course regular forms provide more information about what you're doing by showing you the full rune. Of course, it's up to you, the Hoon programmer, as to whether or not you want to use these.

 ##### If we missed any, or if you saw something weird that's not in here, feel free to comment below!
