# `:bank`, `$:`, "buccol", `{$bank p/(list moss)}`

The product: a mold which applies the tuple `p` to its sample.

Usage: define a record type.

Regular form: *running*.

Irregular form:
```
{a b c}     :bank(a b c)
```

Example:
```
~zod:dojo> =a :bank(p/@ud q/@tas)

~zod:dojo> (a 33 %foo)
[p=33 q=%foo]

~zod:dojo> `a`[33 %foo]
[p=33 q=%foo]

~zod:dojo> $:a
[p=0 q=%$]
```
