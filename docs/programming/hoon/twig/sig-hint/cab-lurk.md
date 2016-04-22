---
sort: 3
---

# `:lurk ~_ "sigcab" {$lurk p/seed q/seed}`

User-formatted tracing printf.

## Expands to

`q`.

## Convention

Shows `p` in stacktrace if `q` crashes.

## Discussion

`p` must produce a `tank` (prettyprint source).

## Examples

```
~zod:dojo> ~_([%leaf "sample error message"] !!)
"sample error message"
ford: build failed
```
