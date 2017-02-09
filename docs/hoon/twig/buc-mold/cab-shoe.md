---
navhome: /docs/
sort: 9
---

# `:shoe  $_  "buccab"`

`{$shoe p/seed}`: mold which normalizes to an example.

## Expands to

```
:gate  *
p
```

```
|=(*  p)
```

## Syntax

Regular: *1-fixed*.

Irregular: `_foo` is `:shoe(foo)`.

## Discussion

A shoe discards the sample it's supposedly normalizing, and
produces its example instead.

## Examples

```
~zod:dojo> =foo :shoe([%foobar %moobaz])

~zod:dojo> (foo %foo %bar)
[%foobar %moobaz]

~zod:dojo> `foo`[%foobar %moobaz]
[%foobar %moobaz]

~zod:dojo $:foo
[%foobar %moobaz]
```

```
~zod:dojo> =foo $_([%foobar %moobaz])

~zod:dojo> (foo %foo %bar)
[%foobar %moobaz]

~zod:dojo> `foo`[%foobar %moobaz]
[%foobar %moobaz]

~zod:dojo $:foo
[%foobar %moobaz]
```
