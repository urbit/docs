---
navhome: /docs/
next: true
sort: 8
title: ?= "wuttis"
---

# `?= "wuttis"`

`[%wtts p=model q=wing]`: test pattern match.

## Produces

`&` (yes) if the noun at `q` is in the icon of `p`;
`|` (no) otherwise.

## Syntax

Regular: *2-fixed*.

## Discussion

`?=` ("wuttis") is not as powerful as it might seem.  For instance, it
can't generate a loop -- you cannot (and should not) use it to 
test whether a `*` is a `(list @)`.  Nor can it validate atomic 
auras.

Patterns should be as weak as possible.  Unpack one layer of
union at a time.  Don't confirm things the type system knows.

For example, when matching a book containing a page `[%foo p=@
q=[@ @]]`, the proper pattern is `[%foo *]`.  You have one
question, which is whether the head of the noun is `%foo`.

A common error is `find.$`, meainng `p` is not a mold.

## Examples

```
~zod:dojo> =bar [%foo %bar %baz]
~zod:dojo> ?=([%foo *] bar)
%.y
```
