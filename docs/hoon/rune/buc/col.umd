---
navhome: /docs/
next: true
sort: 3
title: $: "buccol"
---

# `$: "buccol"` 

`[%bccl p=(list model)]`: form a mold which recognizes a tuple.

## Normalizes

The tuple the length of `p`, normalizing each item, defaulting
where the tuple does not match.

Void if `p` is empty.

## Defaults to

The tuple the length of `p`, defaulting each items.

Crashes if `p` is empty.

## Syntax

Regular: *running*.

Irregular (noun mode): `,[a b c]` is `$:(a b c)`.
Irregular (mold mode): `[a b c]` is `$:(a b c)`.

## Examples

```
~zod:dojo> =foo $:(p=@ud q=@tas)

~zod:dojo> (foo 33 %foo)
[p=33 q=%foo]

~zod:dojo> `foo`[33 %foo]
[p=33 q=%foo]

~zod:dojo> $:foo
[p=0 q=%$]
```
