---
sort: 9
---

# Tests (`?` runes)
 
Hoon has the usual branches and logical tests.  For pattern
matching, it also has a `$fits` twig that tests whether a value
matches the icon of a mold.  And it has branch inference,
learning from `$fits` tests in the condition of `:if` twigs.

## Overview

All `?` runes expand to `$if` (`?:`) and/or `$fits` (`?=`).

If the condition of an `$if` is a `$fits`, *and* the `$fits` is
testing a leg of the subject, the compile specializes the subject
span for the branches of the `$if`.  Branch inference also works
for twigs which expand to `$if`.

The test does not have to be a single `$fits`; the compiler can
analyze arbitrary boolean logic (`$and`, `$or`, `$not`) with full 
short-circuiting.  Equality tests (`=`) are *not* analyzed.

If the compiler detects that the branch is degenerate (only one
side is taken), it fails with an error.

## Regular forms

The rune prefix is `?`.  Suffixes: `=` for `:fits`, `:` for
`:if`, `.` for `:lest`, `-` for `:case`, `+` for `:deft`, `|` for
`:or`, `&` for `:and`, `!` for `:not`, `>` for `$sure`, `<` for
`$deny`, `^` for `:ifcl`, `@` for `:ifat`, `~` for `:ifno`.

### `:fits`, `?=`, "wuttis", `{$fits p/moss q/twig}`

Syntax: *2-fixed*.

The product: `&` if the product of `q` is in the icon of `p`,
`|` otherwise.

The icon of `p` must be finite / nonrecursive.  In general,
always match one layer of a data structure at a time.

### `:if`, `?:`, "wutcol", `{$if p/twig q/twig r/twig}`

Syntax: *3-fixed*.

The product: `q` if `p` has the value `&` (0), `r` for `|` (1).
`p` must be statically boolean.

### `:lest`, `?.`, "wutdot", `{$lest p/twig q/twig r/twig}`

Syntax: *3-fixed*.

Expands to: `:if(p r q)`.

### `:case`, `?-`, "wuthep", `{$case p/twig q/(list (pair moss twig))}`

Syntax: *1-fixed*, then *jogging*.

Expands by: 

```
|-(?~(q [%lost p] [%if [%fits p.i.q p] q.i.q $(q t.q)]))
```

A pattern-matching switch.  Fails to compile if the pattern is
incomplete or irrelevant.

### `:deft`, `?+`, "wutlus", `{$case p/twig q/twig r/(list (pair moss twig))}`

Syntax: *1-fixed*, then *jogging*.

Expands by: `[%case p (weld r [[%base %noun] q])]`

A pattern-matching switch, with default.

### `:or`, `?|`, "wutbar", `{$or p/(list twig)}`

Syntax: *running*.

Expands by: `|-(?~(p [%rock %f |] [%if i.p [%rock %f &]] $(p t.p)))`

Logical or (`&` (`0`) is yes, `|` (`1`) is no).

### `:and`, `?&`, "wutpam", `{$and p/(list twig)}`

Syntax: *running*.

Expands by: `|-(?~(p [%rock %f &] [%if i.p $(p t.p) [%rock %f |]]))`

Logical and (`&` (`0`) is yes, `|` (`1`) is no).

### `:not`, `?!`, "wutzap", `{$not p/twig}`

Syntax: *1-fixed*.

Expands to: `:if(p %| %&)`.

Logical not (`&` (`0`) is yes, `|` (`1`) is no).

### `:sure`, `?>`, "wutgar", `{$sure p/twig q/twig}`

Expands to: `:if(p q !!)`.

An assertion.

### `:deny`, `?<`, "wutgal", `{$deny p/twig q/twig}`

Expands to: `:if(p !! q)`.

A negative assertion.

### `:ifno`, `?~`, "wutsig", `{$ifno p/twig q/twig r/twig}`

Expands to: `:if(:fits($~ p) q r)`.

Branches on whether `p` is null.

### `:ifat`, `?@`, "wutpat", `{$ifat p/twig q/twig r/twig}`

Expands to: `:if(:fits(@ p) q r)`.

Branches on whether `p` is atomic.

### `:ifcl`, `?^`, "wutket", `{$ifat p/twig q/twig r/twig}`

Expands to: `:if(:fits(^ p) q r)`.

Branches on whether `p` is cellular.

## Irregular forms

### Light logic

Translations:

```
&(a b c)      ?&(a b c)
|(a b c)      ?|(a b c)
!a            ?!(a)
```
