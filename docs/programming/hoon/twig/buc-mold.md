---
sort: 7
next: true
---

# Molds (`$` runes).

A *mold* is a `gate` (function) that helps us build simple and
rigorous data structures.  (In fact, since "mold" sounds nasty,
molds are often called "structures.")

## Overview

While Hoon can't check this property statically, a proper mold 
is a *normalizer*: an idempotent function across all nouns.  If
the sample of a gate has span `%noun`, and its body obeys the
constraint that for any x, `=((mold x) (mold (mold x)))`, it's a
rectifier and can be used as a mold.

Twigs in the `$` family are macros designed for making molds.
But any Hoon twig may produce a mold.  (This is why `moss` is a
synonym for `twig`).

Many macros *bunt* a mold, producing `:per(mold $)`.  This value,
simply the result of executing the gate on the default sample,
is a constant by definition and normally can be compiled as such.
The range of a mold (the span of its bunt) is called its *icon*.

Molds have two uses: defining simple and rigorous structures, and
validating untrusted input data.  Validation, though very
important, is a rare use case.  Except for direct raw input,
it's generally a faux pas to rectify nouns at runtime -- or even
in userspace.

As a structure definition, a mold has three common uses.  One,
its bunt is a default value (such as the sample in a gate.)  Two,
the product of some computation is cast to its icon, both
checking the type and regularizing it.  Three, it's used as a
building block in other molds.

## Twigs

<list dataPreview="true" className="runes" linkToFragments="true"></list>

<kids className="runes"></kids>
