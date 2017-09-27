---
navhome: /docs/
sort: 5

---

# Core, `|` ("bar")

Core twigs are flow twigs.  The compiler essentially pins a Nock
formula, or battery of formulas, to the subject.

All `|` twigs are macros around `$core`. (See the `$core`
section in [`span`](../../basic#-core-p-span-q-map-term-span) above.)
`$core` uses the subject as the payload of a battery, whose arms are
compiled with the core itself as the subject.

Four of these twigs (`:gate`, `:trap`, `:loop`, and `:gill`) produce a
core with a single arm, named `$`. We can recompute this arm with changes,
useful for recursion among other things: 

> `:moar()` expands to `:make($)`, accepting a *jogging* body
> containing a list of changes to the subject.

> `$()` expands to `%=($)`, accepting a *jogging* body
> containing a list of changes to the subject.


## Stems

<list dataPreview="true" className="runes"></list>
