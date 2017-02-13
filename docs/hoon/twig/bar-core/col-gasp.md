---
navhome: /docs
sort: 8

---

# `:gasp  |:  "barcol"`

`{$gasp p/seed q/seed}`: form a gate with burnt sample.

## Expands to

```
:pin  :burn(p)
:trap(q)
```

```
=>  ^~  p
  |.  q
```

## Discussion

Note that `p` is a seed, not a moss; `:gasp` doesn't bunt your sample as
`:gate` does.

## Syntax

Regular: *2-fixed*.
