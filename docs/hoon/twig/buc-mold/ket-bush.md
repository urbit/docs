---
navhome: /docs/
sort: 6

---

# `:bush  $^  "bucket"` 

`{$bush p/moss q/moss}`: mold which normalizes a union tagged by head depth.

## Normalizes to

Default, if the sample is an atom; `p`, if the head of the sample
is an atom; `q` otherwise.

## Defaults to

The default of `p`.

## Syntax

Regular: *2-fixed*.

## Examples

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

```
~zod:dojo> =a $%({$foo p/@ud q/@ud} {$bar p/@ud})

~zod:dojo> =b $^({a a} a)

~zod:dojo> (b [[%bar 33] [%foo 19 22]])
[[%bar p=33] [%foo p=19 q=22]]

~zod:dojo> (b [%foo 19 22])
[%foo p=19 q=22]

~zod:dojo> $:b 
[%bar p=0]
```

