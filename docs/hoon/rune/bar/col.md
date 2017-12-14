---
navhome: /docs/
next: true
sort: 8
title: |: "barcol"
---

# `|: "barcol"`

`[%brcl p=hoon q=hoon]`: form a gate with burnt sample.

## Expands to

```
=>  ^~  p
  |.  q
```

## Discussion

Note that `p` is a hoon, not a model; `|:` doesn't bunt your sample as
[`|=`](../tis) does.

## Syntax

Regular: *2-fixed*.
