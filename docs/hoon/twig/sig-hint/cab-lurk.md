---
navhome: /docs/
sort: 3
---

# `:lurk  ~_  "sigcab"`

`{$lurk p/seed q/seed}`: user-formatted tracing printf.

## Expands to

`q`.

## Convention

Shows `p` in stacktrace if `q` crashes.

## Discussion

`p` must produce a `tank` (prettyprint source).

## Examples

```
~zod:dojo> :lurk([%leaf "sample error message"] !!)
"sample error message"
ford: build failed
```

```
~zod:dojo> ~_([%leaf "sample error message"] !!)
"sample error message"
ford: build failed
```
