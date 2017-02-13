---
navhome: /docs
sort: 10

---

# `:port  |~  "barsig"`

`{$port p/moss q/seed}`: form an iron gate.

## Expands to

```
:iron  :gate(p q)
```

```
^|  |=(p q)
```

## Syntax

Regular: *2-fixed*.

## Discussion

See [this discussion of core variance models](../../../advanced)

## Examples

```
~zod:dojo> :per  ~  :like(:port(a/@ *@) :gate(a/* *@))
```

```
~zod:dojo> =>  ~  ^+(|~(a/@ *@) |=(a/* *@))
<1|usl {a/@ $~}>
```
