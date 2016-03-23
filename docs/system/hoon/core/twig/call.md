---
sort: 7
---

# Full make (`%` runes)

We've already covered the irregular-only twigs `$wing` and
`$limb`.  These are simple forms of the *invocation* family of
twigs, `%`, whose general form is `$make`, `%=`.

## Regular forms

The rune prefix is `%`.  Suffixes: `=` for `:make`, `~` for
`:open`, `-` for `:call`, `+` for `:calt`, `^` for `:calq`, `*`
for `:calp`.

### `:make`, `%=`, "centis", `{$make p/wing q/(list (pair wing twig))}` 

Syntax: *1-fixed*, then *jogging*.

The product: `p`, modified by the change list `q`.

If `p` resolves to a leg, `q` is a list of changes to that leg.
If `p` resolves to an arm, `q` is a list of changes to the core
containing that arm.  We compute the arm on the modified core.

### `:open`, `%~`, "censig", `{$open p/wing q/twig r/twig}`

Syntax: *3-fixed*.

Expands to:

```
  :pin   q
  :make(p.+2 +6 :per(+3 r))
```

We pin `q`, making our subject `[q subject]`.  We make arm `p` on
`q`, changing leg `6` to `r` (per the original subject).

Wut?  Why?  `$open` is a general case of `$call`; see below.

### `:call`, `%-`, "cenhep", `{$call p/twig q/twig}`/

Syntax: *2-fixed*.

Expands to: `:open($ p q)`.

`$call` is a function call; `p` is the function (`gate`), `q` the
argument.  `$call` is a special case of `$open`, and a gate is a
special case of a `door` (see the [core](../core) twigs).

In a gate, the modified core has only one anonymous arm; in a
door it gets a full battery.  Intuitively, a gate defines one
algorithm it can compute upon its sample, `+6`. A door defines
many such algorithms.

In classical languages, doors correspond to groups of functions 
with the same argument list, or at least sharing a prefix.  In
Hoon, this shared sample is likely to be pulled into a door.

### `:calt`, `%+`, "cenlus", `{$calt p/twig q/twig r/twig}`

Syntax: *3-fixed*.

Expands to: `:(call p [q r])`.

### `:calq`, `%^`, "cenket", `{$cnkt p/twig q/twig r/twig s/twig}`

Syntax: *4-fixed*.

Expands to: `:(call p [q r s])`.

### `:calp`, `%*`, "centar", `{$cntr p/twig q/(list twig)}`

Syntax: *4-fixed*.

Expands to: `:(call p [q])`.

## Irregular forms

### Classic call, `(p q r s)`

Translation:

```
(p)         :per(p $)
(p q)       :call(p q)
(p q r s)   :call(p [q r s])
```

### Modified wing, `p.q(r s, t u, v w)`

Translation:

```
p.q(r s, t u, v w)    :make(p.q r s, t u, v w)
```

### Anonymous recursion, `:moar*`.

Translation:

```
:moar                   $
:moar(a b, c d, e f)    $(a b, c d, e f)
:moarr                  ^$
:moarrrr                ^^^$
```

`:moar` has tall and wide form like a regular stem, though it has
no rune and is not a regular stem.

`$` is a label like any other.  But loops, gates, and traps all
hardcode this label.  `$` thus implies recursing back to the
nearest `:loop` (`|-)`, `:gate` (`|=`), or `:trap` (`|.`).  (Or
`^$` for the second nearest, `^^$` for the third, etc.

`$` *seems* like a language primitive (eg, Clojure's `recur`), so
we made it look like one.  Keyword enthusiasts and cats who love
cheeseburgers will appreciate `:moar`. Others can use `$`.
