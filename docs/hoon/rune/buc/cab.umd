---
navhome: /docs/
next: true
sort: 9
title: $_ "buccab"
---

# `$_ "buccab"`

`[%bccb p=hoon]`: mold which normalizes to an example.

## Expands to

```
|=(* p)
```

## Syntax

Regular: *1-fixed*.

Irregular: `_foo` is `$_(foo)`.

## Discussion

`$_` ("buccab") discards the sample it's supposedly normalizing 
and produces its *example* instead.

## Examples

```
~zod:dojo> =foo $_([%foobar %moobaz])

~zod:dojo> (foo %foo %bar)
[%foobar %moobaz]

~zod:dojo> `foo`[%foobar %moobaz]
[%foobar %moobaz]

~zod:dojo $:foo
[%foobar %moobaz]
```
