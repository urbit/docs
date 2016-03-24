# `:shoe, $_, "buccab", {$shoe p/twig}`

Type as a single example.

Product: a mold whose product is always `p`.

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
