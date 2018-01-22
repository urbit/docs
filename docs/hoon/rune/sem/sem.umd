---
navhome: /docs/
next: true
sort: 3
title: ;; "semsem"
---

# `;; "semsem"`

`[%smsm p=model q=value]`: normalize with a mold, asserting fixpoint.

## Expands to

```
=+  a=(p q)
?>  =(`*`a `*`q)
a
```

> Note: the expansion implementation is hygienic -- it doesn't actually add the
> `a` face to the subject.

## Syntax

Regular: *2-fixed*.

## Examples

Fails because of auras:

```
~zod:dojo> ^-(tape ~[97 98 99])
! nest-fail
! exit
```

Succeeds because molds don't care about auras:

```
~zod:dojo> ;;(tape ~[97 98 99])
"abc"
```

Succeeds because the mold normalizes:

```
~zod:dojo> (tape [50 51 52])
"23"
```

Fails because not a fixpoint:

```
~zod:dojo> ;;(tape [50 51 52])
! exit
```
