---
navhome: /docs/
next: true
sort: 15
title: Core | "bar"
---

# Core `|` "bar"

Core hoons are flow hoons. The compiler essentially pins a Nock
formula, or battery of formulas, to the subject.

All `|` hoons are macros around `%core`. (See the `%core`
section in [`type`](../../basic#-core-p-type-q-map-term-type) above.)
`%core` uses the subject as the payload of a battery, whose arms are
compiled with the core itself as the subject.

Four of these hoons (`|=`, `|.`, `|-`, and `|*`) produce a
core with a single arm, named `$`. We can recompute this arm 
with changes, useful for recursion among other things: 

> `$()` expands to `%=($)` (["cenhep"](../cen/hep)), accepting 
> a *jogging* body containing a list of changes to the subject.

## Stems

<list dataPreview="true" className="runes"></list>
