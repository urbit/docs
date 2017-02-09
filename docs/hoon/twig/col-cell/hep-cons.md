---
navhome: /docs/
sort: 1
---

# `:cons  :- "colhep"`

`{$cons p/seed q/seed}`: construct a cell (2-tuple).

## Produces

The cell of `p` and `q`.

## Syntax

Regular: *2-fixed*.

Irregular: `[a b]` is `:cons(a b)`.

Irregular: `[a b c]` is `[a [b c]]`.

Irregular: `a^b^c` is `[a b c]`.

Irregular: `a+b` is `[%a b]`.

Irregular: `` `a`` is `[~ a]`.

Irregular: `~[a b]` is `[a b ~]`.

Irregular: `[a b c]~` is `[[a b c] ~]`.

## Discussion

Hoon twigs actually use the same "autocons" pattern as Nock 
formulas.  If you're assembling twigs (which usually only the
compiler does), `[a b]` is the same as `[%cons a b]`.

## Examples

```
~zod:dojo> :cons(1 2)
[1 2]
~zod:dojo> :-(1 2)
[1 2]
~zod:dojo> 1^2
[1 2]
~zod:dojo> 1+2
[%1 2]
~zod:dojo> `1
[~ 1]
```
