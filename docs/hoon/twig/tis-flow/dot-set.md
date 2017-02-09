---
navhome: /docs/
sort: 8
---

# `:set  =.  "tisdot"` 

`{$set p/wing q/seed r/seed}`: change one leg in the subject.

## Expands to

```
:per(:keep(. p q) r)
```

```
=>(%_(. p q) r)
```

## Syntax

Regular: *3-fixed*.

## Discussion

As usual, we are not actually mutating the subject, just creating
a new subject with a changed value.  Note that the mutation uses
`:keep` (`%_`), so the type doesn't change.

## Examples

```
~zod:dojo> :pin  a=[b=1 c=2]
           :set  b.a  3
           a
[b=3 c=2]
~zod:dojo> :pin  a=[b=1 c=2]
           :set(b.a 3 a)
[b=3 c=2]
```

```
~zod:dojo> =+  a=[b=1 c=2]
           =.  b.a  3
           a
[b=3 c=2]
~zod:dojo> =+  a=[b=1 c=2]
           =.(b.a 3 a)
[b=3 c=2]
```
