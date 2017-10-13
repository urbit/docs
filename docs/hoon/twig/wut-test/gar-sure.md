---
navhome: /docs/
sort: 11
---

# `:sure  ?>  "wutgar"`

`{$sure p/seed q/seed}`: positive assertion.

## Expands to

```
:lest  p
  !!
q
```

```
?.(p !! q)
```

## Syntax

Regular: *2-fixed*.

## Examples

```
~zod:dojo> :sure(=(3 3) %foo)
%foo
```

```
~zod:dojo> ?>(=(3 3) %foo)
%foo
```
