---
navhome: /docs/
sort: 4
---

# `:same  .=  "dottis"` 

`{$same p/seed q/seed}`: test for equality with Nock `5`.

## Produces

`&`, `%.y`, `0` if `p` equals `q`; otherwise `|`, `%.n`, `1`.

## Syntax

Regular: *2-fixed*.

Irregular: `=(a b)` is `.=(a b)`.

## Discussion

Like Nock equality, `:same` tests if two nouns are the same,
ignoring invisible pointer structure.  Because in a conventional
noun implementation each noun has a lazy short hash, comparisons 
are fast unless the hash needs to be computed, or we are comparing
separate copies of identical nouns.  (Comparing large duplicates 
is a common cause of performance bugs.)

## Examples

```
~zod:dojo> :same(0 0)
%.y
~zod:dojo> :same(1 2)
%.n
```
```
~zod:dojo> =(0 0)
%.y
~zod:dojo> =(1 2)
%.n
```
