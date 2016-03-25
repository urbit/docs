# `:bank, $:, "buccol", {$bank p/(list moss)}`

Tuple of molds

Product: a mold which applies the tuple `p` to its sample.

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
