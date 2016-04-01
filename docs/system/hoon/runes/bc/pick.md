# `:pick`, `$?`, "bucwut", `{$? p/(list moss)}`

The product: a mold which tries each of the alternatives in `p`.

Usage: a generalized type union.  Use `:pick` only if none of
`:book` (`$%`), `:claw` (`$@`) or `:bush` (`$&`) applies.

Regular form: *running*.

Irregular form:

```
?(a b c)  $?(a b c)
```

Example:

```
~zod:dojo> =a :pick($foo $bar $baz)

~zod:dojo> (a %baz)
%baz

~zod:dojo> (a [37 45])
%foo

~zod:dojo> $:a
$foo
```
