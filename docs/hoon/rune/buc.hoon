/=  kids  /%  /tree-kids/
:-  :~  navhome/'/docs/'
        next/'true'
        sort/'20'
        title/'Mold $ "buc"'
    ==
;>

# Mold `$` "buc"

A _mold_ is a `gate` (function) that helps us build simple and
rigorous data structures.  (In fact, since "mold" sounds nasty,
we often call molds and mold builders "structures.")

## Overview

A correct mold is a _normalizer_: an idempotent function across
all nouns.  If the sample of a gate has type `%noun`, and its
body obeys the constraint that for any x, `=((mold x) (mold (mold
x)))`, it's a normalizer and can be used as a mold.

(Hoon is not dependently typed and so can't check idempotence
statically, so we can't actually tell if a mold matches this
definition perfectly.  This is not actually a problem.)

Twigs in the `$` family are macros designed for making molds.
But any hoon may produce a mold. (This is why `model` is a
synonym for `hoon`).

Many macros _bunt_ a mold, producing `^~(=>(mold $))`.  This
produces a constant default value.  The formal range of a mold
(the type of its bunt) is called its _icon_.

Molds have two uses: defining simple and rigorous structures, and
validating untrusted input data.  Validation, though very
important, is a rare use case.  Except for direct raw input,
it's generally a faux pas to rectify nouns at runtime -- or even
in userspace.

As a structure definition, a mold has three common uses.  One,
we bunt it for a default value (such as the sample in a gate).
Two, the product of some computation is cast to its icon, both
checking the type and regularizing it.  Three, it's used as a
building block in other molds.

In any case, since molds are just functions, we can use
functional programming to assemble interesting molds.  For
instance, `(map foo bar)` is a table from mold `foo` to mold
`bar`.  `map` is not a mold; it's a function that makes a mold.
Molds and mold builders are generally described together.

## Stems

;+  (kids %title datapath/'/docs/hoon/rune/buc/' ~)
