---
navhome: /docs/
navuptwo: true
sort: 5
title: Glossary
---

# Glossary

Urbit is renowned for its exotic terminology. Here's a simple overview
from the strange words in.

As Dijkstra put it: "The purpose of abstraction is not to be vague, but
to create a new semantic level in which one can be absolutely precise."

## Ships

An Urbit *ship* is a cryptographic title on a *will* signed by private
key, a human-memorable name, and a packet routing address. Ships are
classed by the number of bits in their address:

    Size   Name    Parent  Object      Example
    -----  ------  ------  ------      -------
    2^8    galaxy  ~       supernode   ~zod
    2^16   star    galaxy  supernode   ~dozbud
    2^32   planet  star    user        ~tasfyn-partyv
    2^64   moon    planet  device      ~sigsam-nimbot-tasfyn-partyv
    2^128  comet   ~       bot         ~racmus-mollen-fallyt-linpex--watres-sibbur-modlux-rinmex

Any ship can be called an "urbit."

> You can find a longer-form summary here:
>  [`urbit.org/posts/address-space/`](https://urbit.org/posts/address-space/).

An Urbit identity is a string like `~firbyr-napbes`. It means nothing,
but it's easy to remember and say out loud. `~firbyr-napbes` is actually
just a 32-bit number (`3.237.967.392`, to be exact), like an IP address,
that we turn into a human-memorable string. The full name of this string
can be viewed by typing `our` in the Dojo, Urbit's shell. This is useful
when running a ship with a longer name, such as a *moon* or a *comet*.

Technically, an urbit is a secure digital identity that you own and
control with a cryptographic key, like a Bitcoin wallet. As in Bitcoin,
the supply of urbits is mathematically limited. This keeps the network
friendly, by making spam and abuse expensive.

An urbit name is just a number; smaller numbers make shorter names.
Shorter names are easier to remember, so they're more valuable. So
urbits are classified by the number of bits in their name. (A ship name
is just a scrambled base-256 representation of the number.)

A 32-bit urbit (like `~firbyr-napbes`) is called a *planet.* A 16-bit
urbit (like `~pollev)` is a *star.* An 8-bit ship (like `~mun`) is a
*galaxy.* A planet is an identity for an independent, adult human. Stars
and galaxies are network infrastructure.

Each planet or star is launched by its *parent,* the star or galaxy
whose number is its bottom half. So the planet `~firbyr-napbes`,
`0xdead.beef` or `3.735.928.559`, is the child of `~pollev`, `0xbeef` or
`48.879`, whose parent is `~mun`, `0xef`, `239`. The parent of `~mun`
and all galaxies is `~zod`, `0`.

#### pier

A ship's *pier* is its Unix directory.  For planets the name of the pier is usually the planet name.

### Nock

> Nock is a Turing-complete, non-lambda combinator interpreter.

-   <h6 id="-nock-noun">noun:</h6> an _atom_ or a _cell_
-   <h6 id="-nock-atom">atom:</h6> any natural number
-   <h6 id="-nock-cell">cell:</h6> any ordered pair of nouns
-   <h6 id="-nock-subject">subject:</h6> a noun - the data against which a _formula_ is
    evaluated
-   <h6 id="-nock-formula">formula:</h6> a noun - a function at the Nock level
-   <h6 id="-nock-product">product:</h6> a noun - the result of evaluating a formula against a
    subject

*See [Nock definition](../../nock/definition/).*

## Hoon

> Hoon is a strict, higher-order typed functional language that compiles
> itself to Nock.

#### arm

An _arm_ is a named, functionally-computed attribute of a [core](#-core).

The [hoon](#-a-hoon) of each arm is compiled to a Nock formula, with the
enclosing [core](#-core) itself as the subject.

There are two kinds of arms: *dry* and *wet*. Most arms are dry.

-   <h6 id="-arm-dry">dry:</h6> normal, `++`, polymorphic by means of *variance*

For a dry arm, we ask, is the new payload compatible with the old
payload (against which the core was compiled)?

-   <h6 id="-arm-wet">wet:</h6> unusual, `+-`, polymorphic by means of *genericity*

A wet arm uses the hoon as a macro. We create a new type analysis
path, which works as if we expanded the callee with the caller's
context.

*See [advanced types](../../hoon/advanced/)*.

#### atom

A Hoon _atom_ type describes a Nock atom, with two additional pieces
of metadata: an *aura*, and an optional constant.

An atom type is *warm* or *cold* based on whether the constant exists.

-   <h6 id="-atom-warm">warm:</h6> if the constant is `~` (null), any
    atom is in the type
-   <h6 id="-atom-cold">cold:</h6> if the constant is `[~ atom]`, its
    only legal value is `atom`.

*See [basic types](../../hoon/basic/#-atom-p-term-q-unit-atom)*

#### aura

An *aura* is a soft atom type. It represents the structure of an
atom in a string beginning with `@`. An aura may represent print
format or other semantics. Its constraints on the value of an
atom aren't enforced in any way.

Two auras are compatible if one is a prefix of the other. You can
change any aura into any other aura by casting through the empty
aura, `@`. The standard library has molds which alias many common
auras.

Some common auras and their aliases:

-   <h6 id="-aura-term">term:</h6> (`@tas`): a symbol - an atomic ASCII string which obeys
    symbol rules: lowercase and digit only, infix hyphen ("kebab-case"),
    first character must be lowercase alphabetic.
-   <h6 id="-aura-cord">cord:</h6> (`@t`): UTF-8 text, least-significant-byte first
-   <h6 id="-aura-char">char:</h6> (`@tD`): a character, a single unicode byte (for multi-byte
    characters and codepoints, see `@c`)

You can find the list of all auras [here](../../hoon/atom/sand/).

*See [basic types](../../hoon/basic/#-atom-p-term-q-unit-atom)*.

#### core

A _core_ is a [cell](#-nock-cell) of `[code data]`, where we call the
code head the _battery_ and the data tail the _payload_. All code-data
structures in normal languages (functions, objects, modules, etc.)
become _core_s in Hoon.

-   <h6 id="-core-battery">battery:</h6> the code of a core, a tree of *arms*
-   <h6 id="-core-payload">payload:</h6> the data in a core

*See [basic types](../../hoon/basic)*.

#### face

A Hoon _face_ is a labeled subtree.

Hoon has no scope or symbol-table; there is only the subject. To
"declare" a "variable" is to construct a new subject:
`[name=value old-subject]`.

A face is a type that wraps a named symbol (of [aura](#-aura)
`@tas`) around another type.

*See [advanced types](../../hoon/advanced/#-face-aliases-and-bridges)*.

#### gate

A _gate_ is a [core](#-core) with one [arm](#-arm) -- Hoon's closest
analog to a function/lambda/closure. To call a gate on an argument,
replace the sample (at [tree address](../../hoon/limb/limb/) `+6`
in the core) with the argument, and then compute the arm.

The payload of a gate has a shape of `[sample context]`.

-   <h6 id="-gate-sample">sample:</h6> the argument tuple
-   <h6 id="-gate-context">context:</h6> the subject in which the gate was defined

*See [basic types](../../hoon/basic/#-core-p-type-q-map-term-type),
[`%-` ("cenhep")](../../hoon/rune/cen/hep/) (the
[rune](#-rune) for calling a `gate`).*

#### <h4 id="-a-hoon">hoon</h4>

A [`hoon`](../../hoon/reference/) is the result of parsing a Hoon source
expression into an AST node. These AST nodes are nouns, like all
other Hoon data. Because every Hoon program is, in its entirety, a
single expression of Hoon, the result of parsing the whole thing
into an AST is a single `hoon`.

A hoon is a tagged union of the form `[%tag data]`, where the tag
is a constant such as `%brts` (from the source [rune](#-rune) `|=`,
i.e. "bartis"), and is matched up with the appropriate type of data
(often more `hoon`s, from source subexpressions). For example, the
expression `:-(2 17)`, once parsed into an AST, becomes the following:

```
[%clhp p=[%sand p=%ud q=2] q=[%sand p=%ud q=17]]
```

The `%clhp` is produced from the rune `:-` (i.e. "colhep"). The 2 and
17 have each been parsed as `%sand`-tagged hoons, which represent
atoms (in this case each with an aura of `%ud`, i.e. unsigned
decimal).

To parse Hoon source into a hoon AST, use `ream` on a `cord`
containing Hoon source. Try the following in [Dojo](../../using/shell):

```
(ream ':+(12 7 %a)')
```

The result should be:

```
[%clls p=[%sand p=%ud q=12] q=[%sand p=%ud q=7] r=[%rock p=%tas q=97]]
```

#### limb

A _limb_ is an attribute or variable reference.

To resolve a *limb* named "foo", the subject is searched depth-first,
head-first for either a face named "foo" or a core with an arm of
"foo". If a face is found, the result is a leg, if a core is
found, the result is the product of the arm.

-   <h6 id="-limb-leg">leg:</h6> a subexpression, or subtree of the subject.
-   <h6 id="-limb-wing">wing:</h6> a list of limbs, searched from right to left (`a.b` means
    `b` within `a`).

*See [Limbs and wings](../../hoon/limb/)*

#### loobean

A _loobean_ is a Hoon boolean. `0` (`%.y`) is *yes*, `1` (`%.n`) is *no*.

> Why? It's fresh, it's different, it's new. And it's annoying. And it
> keeps you on your toes. And it's also just intuitively right.

#### mark

A _mark_ is Urbit's version of a MIME type, if a MIME type was an
executable specification. The mark is just a label that's used as a path
to a local source file in the Arvo filesystem.  This source file defines
a core that can mold untrusted data, diff and patch, convert to other
marks, etc.

If this sounds like magic, it isn't quite magic.  There's no way
for different urbits to make sure they mean the same thing by the
same mark.  However, when incompatibility happens, marks ensure
that we at least handle the situation in a predictable way.

#### metal

Every core has a _metal_ which defines its variance model (ie, the
properties of the type of a compatible core). The default is `gold`
(invariant).

-   `gold`: *invariant*
-   `lead`: *bivariant*
-   `zinc`: *covariant*
-   `iron`: *contravariant*

*See [advanced types](../../hoon/advanced)*.

#### mold

A _mold_ is an idempotent [gate](#-gate) (function), accepting any noun,
and producing a range with a type, a set of nouns.

Molds act as type constructor/validators in Hoon. An example: Arvo
[marks](#-marks) use Hoon's type system under the hood via molds to
validate untrusted network data.

Here's some common mold terminology:

-   <h6 id="-mold-bunt">bunt:</h6> the value a mold produces when normalizing its default
    sample
-   <h6 id="-mold-icon">icon:</h6> the type of the mold's range

*See [mold hoons](../../hoon/rune/buc/).*

#### nest

`nest` is an internal Hoon function on two types which performs a type
compatibility test. `nest` produces yes if the
set of nouns in the second type is provably a subset of the first.
If `nest` produces no, the Hoon programmer will receive a `nest-fail`
error. This is one of the most commons errors in Hoon programming.

*See [advanced types](../../hoon/advanced/)*.
*See [troubleshooting](../../hoon/troubleshooting/#-nest-fail)*.

#### rune

A Hoon _rune_ is a pair of ASCII symbols used to begin a
[Hoon expression](#-a-hoon).

For example, the rune [`?:`](../../hoon/rune/wut/col/) is
Hoon's most common conditional, a branch on a boolean test. The first
symbol in a rune represents a family of related runes. For example, the
[`?` family](../../hoon/rune/wut/) are all conditionals.

The result of parsing a Hoon source expression&mdash;the rune, followed
by its respective children&mdash;into an AST node is simply called
a [`hoon`](#-a-hoon).

Runes have two syntactic forms, _tall_ and _flat_:

-   <h6 id="-rune-tall">tall:</h6> multiple lines, no parentheses, two or more spaces between
    tokens

    Example:

    ```
    ~zod:dojo> %+  add  2  2
    4
    ```
-   <h6 id="-rune-flat">flat:</h6> one line, parentheses, one space between tokens

    Example:

    ```
    ~zod:dojo> %+(add 2 2)                              ::  regular flat form
    4

    ~zod:dojo> (add 2 2)                                ::  irregular flat form
    4
    ```

Tall hoons can contain flat hoons, but not vice versa. All irregular
forms are flat.

*See [hoon concept](../../hoon/concepts/#-hoon),
[expressions](../../hoon/rune/), and [syntax](../../hoon/syntax/)*.

#### slot

`slot` is the name for Hoon's tree addressing scheme.

Every cell has a head and a tail, each of which may be either an atom or
a cell. Therefore every noun is a binary tree. `+1` or `.` resolves to
the whole cell (technically this would work against an atom as well).
The head of `+n` is `+2n`, the tail is `+(2n+1)`.

#### type

A Hoon _type_ defines a set (finite or infinite) of nouns and ascribes
some semantics to it.  There is no direct syntax for defining
types; they are always defined by inference (i.e., by
[`mint`](#-mint)), usually using a constructor ([`mold`](#-mold)).

All types are assembled out of base types defined in `++type`.
(Look up `++  type` in hoon.hoon for examples.) When the compiler
does type-inference on a program, it assembles complex types out
of the simpler built-in types.

*See [basic types](../../hoon/basic/).*
