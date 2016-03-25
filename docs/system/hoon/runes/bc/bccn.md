# `:book, $%, "buctis", {$book p/(list moss)}`

Tagged union

Product: a mold producing the tagged union of the molds in
`p`, all of which must be of the form `:bank(stem bulb)`, where
`stem` is an atomic mold.

Regular form: *running*.

Examples:

```
~zod:dojo> =a :book({$foo p/@ud q/@ud} {$bar p/@ud})

~zod:dojo> (a [%bar 37])
[%bar p=37]

~zod:dojo> $:a
[%foo p=0 q=0]~
```
