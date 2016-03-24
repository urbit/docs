# `:bush`, `$&`, "bucpam", `{$bush p/moss q/moss}`

The product: a mold which applies `p` if the head of its sample 
is a cell, `q` if the head of its sample is a cell.

Usage: add a default pair behavior (like "autocons" in Nock
formulas) to a tagged union type.

Regular form: *2-fixed*.

Example:
```
~zod:dojo> =a :book({$foo p/@ud q/@ud} {$bar p/@ud})

~zod:dojo> =b :bush({a a} a)

~zod:dojo> (b [[%bar 33] [%foo 19 22]])
[[%bar p=33] [%foo p=19 q=22]]

~zod:dojo> (b [%foo 19 22])
[%foo p=19 q=22]

~zod:dojo> $:b 
[%bar p=0]
```
