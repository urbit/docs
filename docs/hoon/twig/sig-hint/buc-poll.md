---
navhome: /docs
sort: 12
---

# `:poll  ~$  "sigbuc"`

`{$poll p/term q/seed}`: profiling hit counter.

## Expands to

`q`.

## Convention

If profiling is on, adds 1 to the hit counter for `p`.

## Syntax

Regular: *2-fixed*.

## Examples

```
~zod:dojo> ~$(%foo 3)
3
```
