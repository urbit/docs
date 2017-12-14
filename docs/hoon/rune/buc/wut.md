---
navhome: /docs/
next: true
sort: 4
title: $? "bucwut"
---

# `$? "bucwut"`

`[%bcwt p=(list model)]`: mold which normalizes a general union.

## Normalizes to

The first item in `p` which normalizes the sample to itself;
otherwise, default.

Void, if `p` is empty.

## Defaults to

The first item in `p`. 

## Syntax

Regular: *running*.

Irregular: `?(%foo %bar)` is `$?(%foo %bar)`.

## Discussion

For a union of atoms, a `$?` ("bucwut") is fine.  For more complex nouns,
always try to use a [`$%` ("buccen")](../cen/), [`$@` ("bucpat")](../pat/) or 
[`$^` ("bucket")](../ket/), at least if you expect your mold to be used as a 
normalizer.

## Examples

```
~zod:dojo> =a ?(%foo %bar %baz)

~zod:dojo> (a %baz)
%baz

~zod:dojo> (a [37 45])
%baz

~zod:dojo> $:a
%baz
```
