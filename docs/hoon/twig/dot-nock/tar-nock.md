---
navhome: /docs/
sort: 1
---

# `:nock  .*  "dottar"`

`{$nock p/seed q/seed}`: evaluate with Nock `2`.

## Produces

Nock of formula `q` and subject `p`, with span `%noun`.

## Syntax

Regular: *2-fixed*.

## Discussion

Note that `:nock` can be used to bypass the type system,
though its product contains no type information.  It's
perfectly practical to use Hoon as a typeless language.

## Examples

```
~zod:dojo> :nock([20 30] [0 2])
20
~zod:dojo> :nock(33 [4 0 1])
34
~zod:dojo> :nock(|.(50) [9 2 0 1])
50
~zod:dojo> :nock(12 [7 [`1 [4 `1]] [`2 `3 `2]])
[12 13 12]
~zod:dojo> :nock(~ [5 1^4 [4 1^3]])
0
~zod:dojo> :nock(~ [5 1^5 [4 1^3]])
1
```

```
~zod:dojo> .*([20 30] [0 2])
20
~zod:dojo> .*(33 [4 0 1])
34
~zod:dojo> .*(|.(50) [9 2 0 1])
50
~zod:dojo> .*(12 [7 [`1 [4 `1]] [`2 `3 `2]])
[12 13 12]
~zod:dojo> .*(~ [5 1^4 [4 1^3]])
0
~zod:dojo> .*(~ [5 1^5 [4 1^3]])
1
```
