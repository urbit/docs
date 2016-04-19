---
sort: 6
---

# Cores (`|` runes)

Core twigs are flow twigs.  The compiler essentially pins a Nock
formula, or battery of formulas, to the subject.

All `|` twigs are macros around `$core`.  (See the `$core`
section in [`span`](../span) above.)  `$core` uses the subject as
the payload of a battery, whose arms are compiled with the core
itself as the subject.

## Regular forms

The rune prefix is `|`.  Suffixes: `%` for `:core`, `=` for
`:gate`, `-` for `:loop`, `.` for `:trap`, `_` for `:door`.

### `:core`, `|%`, "barcen", `{$core p/(map term twig)}`

Syntax: *battery*

The product: a core with battery `p`.  Payload is the subject.

### `:gate`, `|=`, "bartis", `{$gate p/moss q/twig}

Syntax: *2-fixed*.

Expands to: 

```
:new   p
:core
++  $
  q
--
```

A `$gate` produces a function from `p` to `q`.  `p` is the
*sample*, or argument.  The core has one formula, named `$` (the
empty name).  The payload is of the form `{sample context}`,
where `context` is the subject of the gate.

### `:loop`, `|-`, "barhep", `{$loop p/twig}`

Syntax: *1-fixed*.

Expands to:

```
  :rap  $
  :core
  ++  $  
     p
  --
```

A `$loop` makes a core with one anonymous arm `p`, then takes
that arm.

### `:trap`, `|.`, "bardot", `{$trap p/twig}`

Syntax: *1-fixed*.

Expands to:

```
  :core
  ++  $  p
  --
``` 

A `$trap` is a deferred value.

### `:door`, `|_`, "barcab", `{$door p/moss q/(map term twig)}`

Syntax: *1-fixed*, then *battery*.

Expands to:

```
    :new  p
    :core 
      q
    ==
```

A `gate` is a function; a `door` is the general case of a
function.  Wut?  We'll look at this again from the caller's side.
