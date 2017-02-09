---
navhome: /docs/
sort: 3

---

# `:coat  $=  "buctis"`

`{$coat p/@tas q/moss}`: mold which wraps a face around another mold.

## Expands to

```
:gate  *
:name(p :call(q +6))
```

```
|=  *
^=(p %-(q +6))
```

## Syntax

Regular: *2-fixed*.

Irregular: `foo/bar` is `:coat(foo bar)`.

## Discussion

Note that the Hoon compiler is at least slightly clever about
compiling molds, and almost never has to actually put in a gate
layer (as seen in the expansion above) to apply a coat.

## Examples

```
~zod:dojo> =a :coat(p $foo)

~zod:dojo> (a %bar)
p=%foo
```

```
~zod:dojo> =a $=(p $foo)

~zod:dojo> (a %bar)
p=%foo
```
