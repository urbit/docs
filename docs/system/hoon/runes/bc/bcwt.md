# `:pick, $?, "bucwut", {$? p/(list moss)}`

Generalized type union.

Product: a mold which tries each of the alternatives in `p`.

Note: Use `:pick` only if none of `:book` (`$%`), `:claw` (`$@`) or `:bush` (`$&`) applies.

Regular form: *running*.

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
