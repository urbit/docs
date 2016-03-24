# `:claw`, `$@`, "bucpat", `{$claw p/moss q/moss}`

The product: a mold which applies `p` if its sample is an atom, 
`q` if its sample is a cell.

Usage: define a type which is either an atom or a cell.

Regular form: *2-fixed*.

Example:
```
~zod:dojo> =a :claw($foo :bank(p/$bar q/@ud))

~zod:dojo> (a %foo)
%foo

~zod:dojo> `a`[%bar 99]
[p=%bar q=99]

~zod:dojo> $:a
[%foo p=0 q=0]
```
