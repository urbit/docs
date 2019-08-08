+++
title = "Nock . ('dot')"
weight = 3
template = "doc.html"
+++
Anything Nock can do, Hoon can do also.  These runes are used for carrying out Nock operations in Hoon.

## Runes

### .^ "dotket"

`[%dtkt p=spec q=hoon]`: load from the Arvo namespace with a fake Nock instruction: 'Nock `12`''.

##### Produces

The noun `q`, cast to the type `p`.

##### Discussion

Nock has no `12` instruction!  But the virtual Nock
used to run userspace code does.  Nock `12` loads from a
typed immutable namespace defined by its virtual context.

Ordinarily a Hoon expression has access to no information but whatever can be found in the subject.  The one exception is with the `.^` rune.  It essentially allows you to request information from one of the Arvo vanes (modules).

`.^` checks that the type of the value retrieved from Arvo nests under `p`.  `p` is a `path` which includes information about which vane is being queried, and what sort of information is requested.

In principle `.^` takes two subexpressions, but in practice `q` is often given in two parts: the first part includes the vane to be queried (e.g., `%a` for Ames, `%b` for Behn, `%c` for Clay, etc.) and the kind of request.  The second part is a path that corresponds to the kind of request.

##### Examples

In the dojo we can ask Clay -- the Arvo filesystem -- for a listing of the files at our current path, `%`:

```
> .^(arch %cy %)
[ fil=~
    dir
  { [p=~.web q=~]
    [p=~.LICENSE q=~]
    [p=~.app q=~]
    [p=~.lib q=~]
    [p=~.sec q=~]
    [p=~.sys q=~]
    [p=~.ren q=~]
    [p=~.sur q=~]
    [p=~.tests q=~]
    [p=~.mar q=~]
    [p=~.gen q=~]
  }
]
```

The `%c` is for Clay, and the `y` is for the request type.  `arch` is the type of the listing.  See `gen/cat.hoon` to see how this information is printed more prettily.

The `%` is for the current path in the dojo:

```
> `path`%
/~zod/home/~2018.9.20..23.05.35..0231
```

You can modify the time of the file listing quite simply and ask for a listing from 5 hours ago.  (Remember that Clay is a revision-controlled file system.)

```
> .^(arch %cy /(scot %p our)/home/(scot %da (sub now ~h5)))
[ fil=~
    dir
  { [p=~.web q=~]
    [p=~.LICENSE q=~]
    [p=~.app q=~]
    [p=~.lib q=~]
    [p=~.sec q=~]
    [p=~.sys q=~]
    [p=~.ren q=~]
    [p=~.sur q=~]
    [p=~.tests q=~]
    [p=~.mar q=~]
    [p=~.gen q=~]
  }
]
```

`our` is the value for your ship's name.

### .+ "dotlus"

`[%dtls p=hoon]`: increment an atom with Nock `4`.

##### Produces

`p` plus `1` if `p` is an atom; otherwise, crashes.  The product atom has no aura.

##### Syntax

Regular: **1-fixed**.

Irregular: `+(6)` is `.+(6)`.

##### Examples

```
> .+(6)
7

> +(6)
7

> +(%foo)
7.303.015

> +([1 2])
nest-fail
```

### .* "dottar"

`[%dttr p=hoon q=hoon]`: evaluate with Nock `2`.

##### Produces

Nock of formula `q` and subject `p`, with type `%noun`.

##### Syntax

Regular: **2-fixed**.

##### Discussion

`.*(p q)` is used to run Nock formula `p` on the subject `q` from within Hoon.

Keep in mind that `p` and `q` can be arbitrary Hoon expressions, as long as they evaluate to the appropriate nouns for Nock evaluation.

Note also that `.*` ("dottar") can be used to bypass the type system.  It's
therefore possible to use Hoon as a typeless language.

##### Examples

```
> .*([20 30] [0 2])
20

> .*(33 [4 0 1])
34

> .*(|.(50) [9 2 0 1])
50

> .*(12 [7 [`1 [4 `1]] [`2 `3 `2]])
[12 13 12]

> .*(~ [5 1^4 [4 1^3]])
0

> .*(~ [5 1^5 [4 1^3]])
1
```

### .= "dottis" {#dottis}

`[%dtts p=hoon q=hoon]`: test for equality with Nock `5`.

##### Produces

`%.y` if `p` equals `q`; otherwise `%.n`.

##### Syntax

Regular: **2-fixed**.

Irregular: `=(a b)` is `.=(a b)`.

##### Discussion

The test for equality includes a type check.  Either the type of `p` must nest under the type of `q`, or _vice versa_.  Otherwise the result is a crash.

Like Nock equality, `.=` ("dottis") tests whether two nouns are the same,
ignoring invisible pointer structure.  Because in a conventional
noun implementation each noun has a lazy short hash, comparisons
are fast unless the hash needs to be computed, or we are comparing
separate copies of identical nouns.  (Comparing large duplicates
is a common cause of performance bugs.)

##### Examples

```
> .=(0 0)
%.y

> =(0 0)
%.y

> .=(1 2)
%.n

> =(1 2)
%.n

> =(12 [12 14])
nest-fail
```

### .? "dotwut"

`[%dtwt p=hoon]`: test for cell or atom with Nock `3`.

##### Produces

`%.y` if `p` is a cell; otherwise `%.n`.

##### Syntax

Regular: **1-fixed**.

##### Examples

```
> .?(42)
%.n

> .?([42 43])
%.y
```
