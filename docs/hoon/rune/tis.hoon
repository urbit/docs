---
navhome: /docs/
next: true
sort: 13
title: Flow = ("tis")
---

# Flow `=` ("tis")

Flow hoons change the subject.  (Or more precisely, a flow hoon
compiles at least one of its subhoons with a different subject.)
All non-flow hoons (except cores) pass the subject down unchanged.

## Overview

The simplest way to change the subject is to compose two hoons, 
`p` and `q`.  Let `x` be `(mint subject p)`, with product type 
`p.x` and nock formula `q.x`.  Let `y` be `(mint p.x q)`.  Then
their composition is `[p.y [7 q.x q.y]]`.

This composition is the `=>` ("tisgar") rune.  A close relative is 
`=+` ("tislus"), which is `=>` over `[p .]`.  The new subject is a 
cell of `p` and the old subject.  `=+` is the simplest Hoon equivalent of
"declaring a variable" (introducing new data into the subject).

Another way to change the subject is to mutate it.  With the
`=.` ("tisdot") rune, given a wing that resolves to a leg, we can write
instead of reading, *installing* a new value at that leg.  Of
course, we are creating a copy, not modifying the original.

There are many flow stems, all small variations on these three.

## Twigs

<list dataPreview="true" className="runes"></list>
