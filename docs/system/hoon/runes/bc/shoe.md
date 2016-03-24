# `:shoe`, `$_`, "buccab", `{$shoe p/twig}`

The product: a mold whose product is always `p`.

Usage: define a type as a single example.

Regular form: *1-fixed*.

Irregular form:
```
_%foo  :shoe(%foo)
```

Example:
```
~zod:dojo> =a :shoe([%foobar %moobaz])

~zod:dojo> (a %foo %bar)
[%foobar %moobaz]

~zod:dojo> `a`[%foobar %moobaz]
[%foobar %moobaz]

~zod:dojo $:a
[%foobar %moobaz]
```
