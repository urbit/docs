---
navhome: /docs/
next: true
sort: 10
title: =. "tisdot"
---

# `=. "tisdot"` 

`[%tsdt p=wing q=hoon r=hoon]`: change one leg in the subject.

## Expands to

```
=>(%_(. p q) r)
```

## Syntax

Regular: *3-fixed*.

## Discussion

As usual, we are not actually mutating the subject, just creating
a new subject with a changed value.  Note that the mutation uses
[`%_` ("cencab")](../../cen/cab/), so the type doesn't change.

## Examples

```
~zod:dojo> =+  a=[b=1 c=2]
           =.  b.a  3
           a
[b=3 c=2]

~zod:dojo> =+  a=[b=1 c=2]
           =.(b.a 3 a)
[b=3 c=2]
```
