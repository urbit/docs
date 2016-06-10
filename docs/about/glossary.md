---
navhome: /docs
next: true
sort: 3
title: Glossary of Urbit Terms
---

# Glossary of Urbit Terms

Here is a simple overview of the most common Urbit terms. Once you understand this, you know almost everything you need to start using Urbit.

## The Universe in a Table

    Size   Name    Parent  Object      Example
    -----  ------  ------  ------      -------
    2^8    galaxy  ~       datacenter  ~zod
    2^16   star    galaxy  sysadmin    ~doznec
    2^32   planet  star    user        ~tasfyn-partyv
    2^64   moon    planet  device      ~sigsam-nimbot-tasfyn-partyv
    2^128  comet   ~       bot         ~racmus-mollen-fallyt-linpex--watres-sibbur-modlux-rinmex
    any    urbit   *       *           ~somnym-anynym

> The below summary is also available [here](http://urbit.org/posts/address-space/).

An Urbit identity is a string like `~firbyr-napbes`.  It
means nothing, but it's easy to remember and say out loud.
`~firbyr-napbes` is actually just a 32-bit number, like an IP address,
that we turn into a human-memorable string.

Technically, an urbit is a secure digital identity that you own and
control with a cryptographic key, like a Bitcoin wallet.  As in
Bitcoin, the supply of urbits is mathematically limited.  This keeps
the network friendly, by making spam and abuse expensive.

An urbit name is just a number; smaller numbers make shorter names.
Shorter names are easier to remember, so they're more valuable.  So
urbits are classified by the number of bits in their name.  (A ship
name is just a scrambled base-256 representation of the number.)

A 32-bit urbit (like `~firbyr-napbes`) is called a "planet." A 16-bit
urbit (like `~pollev)` is a "star." An 8-bit ship (like `~mun`) is a
"galaxy." A planet is an identity for an independent, adult human.
Stars and galaxies are network infrastructure.

Each planet or star is launched by its "parent," the star or galaxy
whose number is its bottom half.  So the planet `~firbyr-napbes`,
`0xdead.beef` or `3.735.928.559`, is the child of `~pollev`, `0xbeef`
or `48.879`, whose parent is `~mun`, `0xef`, `239`.  The parent of
`~mun` and all galaxies is `~zod`, `0`.

### Nock

> Nock is a Turing-complete, non-lambda combinator function.

- `noun`: an `atom` or a `cell`
- `atom`: any natural number
- `cell`: any ordered pair of `noun`s
- `subject`: a `noun` - the argument against which a `formula` is evaluated
- `formula`: a `noun` - any of the Hoon formula numbers (0-10), followed by *(TODO: ?)*
- `product`: a `noun` - the result of evaluating a `formula` against a `subject`

*See [Nock definition](../../nock/definition/)*

### Hoon

> Hoon is a strict, higher-order typed functional language which compiles itself to Nock.

###### `span`: an inferred type

A `span` defines a set (finite or infinite) of `noun`s and ascribes some semantics to it. There is no Hoon syntax for a `span`; it is always produced as the inferred range of an expression (`twig`).

*See [basic types](../../hoon/basic/#-type-span-and-mold)*

###### `mold`: a type constructor / validator

A mold is an idempotent `gate` (function), accepting any `noun` and normalizing it to a range.

- `icon`: the `span` of a `mold`
- `bunt`: *(TODO: ??)*

*See [`mold` `twig`s](../../hoon/twig/buc-mold/)*

###### `gate`: a function, lambda or closure

*TODO: simplify description*

A `gate` is a specialized `core` with only one `arm` (whose name is the empty string (the symbol `$`). To call a `gate` on an argument, replace the `sample` (at tree address `6` in the `core`) with the argument, and then compute the `arm`.

The `payload` of a `gate` has a shape of `{sample context}`.

- `sample`: the argument *(TODO: or plural?)* of a `gate`
- `context`: the subject in *(TODO: against?)* which a `gate` was defined

+*See [basic types](../../hoon/basic/#-core-p-span-q-map-term-span), [`%-` or `:call`](../../hoon/twig/cen-call/hep-call/) (the `twig` for calling a `gate`)*

###### `core`: a code-data `cell`

The code (`battery`) is the head, the data (`payload`) is the tail. All code-data structures in normal languages (functions, objects, modules, etc) become `core`s in Hoon.

- `battery`: the code of a `core`, a tree of `arm`s
- `payload`: the data in a `core`

`core`s are *polymorphic* structures; every function call (`gate`) in Hoon replaces the `payload` of a `core` with a different `noun`, and then invokes an `arm` from the `battery`.

- `wet`: polymorphic by means of *genericity*

*TODO: simplify*

> When we call a `wet` `arm`, we're essentially using the `twig` as a macro. We are not generating new code for every call site; we are creating a new type analysis path, which works as if we expanded the callee with the caller's context.

- `dry`: polymorphic by means of *variance*

For a `dry` `arm`, we ask, is the new `payload` compatible with the old `payload` (against which the `core` was compiled)?

Every `dry` `core` has a `metal` *(TODO: check)* which defines its *variance* model (ie, the properties of the `span` of a compatible `core`).

*TODO: is the core dry, the arm dry, or both?*

- `gold`: *invariant*
- `lead`: *bivariant*
- `zync`: *covariant*
- `iron`: *contravariant*

*See [advanced types](../../hoon/advanced)*

###### `arm`: a named, functionally-computed attribute of a `core`

The `twig` of each `arm` is compiled to a Nock formula, with the enclosing `core` itself as the subject.

*See [basic types](../../hoon/basic)*

###### `foot`: a `wet` or `dry` `twig`

*TODO: any `twig`, or always an `arm` within a `battery`?*

###### `atom`

A Hoon `atom` is a Nock `atom`, with two additional pieces of metadata (TODO: ?): an `aura`, and a `unit`.

- `unit`: a nullable pointer (TODO: ?), or a Maybe

`atom`s are said to be `warm` or `cold` based on their `unit`

- `warm`: if the `unit` is `~` (null), any `atom` is in the `span`
- `cold`: if the `unit` is `[~ x]`, where `x` is any `atom`, its only legal value is the constant `x`. *(TODO: what does this actually mean? What is the consequence of illegality?)*

*See [basic types](../../hoon/basic/#-atom-p-term-q-unit-atom)*

###### `aura`: a soft `atom` type

*alternately `odor`*

*TODO: write a short summary*

*TODO: are `aura`s always `mold`s? just the built-in `aura`s?*

> Auras are a lightweight, advisory representation of the units, semantics, and/or syntax of an `atom`. An `aura` is an atomic string; two auras are compatible if one is a prefix of the other.
>
> For instance, @t means UTF-8 text (LSB low), @ta means ASCII text, and @tas means an ASCII symbol. @u means an unsigned integer, @ud an unsigned decimal, @ux an unsigned hexadecimal. You can use a @ud atom as a @u or vice versa, but not as a @tas.
>
> Auras are truly soft; you can turn any `aura` into any other, statically, by casting through the empty `aura` `@`. Hoon is not dependently typed and can't statically enforce data constraints (for example, it can't enforce that a `@tas` is really a symbol).
>

- `term` (`@tas`): a symbol - an atomic ASCII string which obeys symbol rules: lowercase and digit only, infix hyphen ("worm-case"), first character must be lowercase *(TODO: alphabetic?)*.

- `cord` (`@t`): UTF-8 text, least-significant-byte first

- `char` (`@tD`): a character, a single unicode byte (for multi-byte characters and codepoints, see `@c`)

- `tape` (`(list char)`): a `tape` is not an `aura`, but a `mold` for a collection where every item has an `aura` of `char` *(TODO: is this for easy indexing vs `@t`?)*

*See [basic types](../../hoon/basic/#-atom-p-term-q-unit-atom)*

###### `loobean`: a Hoon boolean

`0` (`%.y`) is *true*, `1` (`%.n`) is *false*.

>Why? It's fresh, it's different, it's new. And it's annoying. And it keeps you on your toes. And it's also just intuitively right.

###### `twig`: a Hoon expression

A `twig` is the name for any Hoon expression, and for the AST node representing the expression as compiled to a Nock formula *(TODO: seems to be used interchangeably in the docs)*. It is a `book` with the form `{stem bulb}`.

- `book`: a tagged-union
- `page`: an item in a `book`
- `stem`: an atomic symbol (`@tas`) - uniquely identifies a `twig` *(TODO: ?)*
- `bulb`: The `bulb` for each `stem` has its own type, usually a tuple, sometimes a list or a map.

A `twig` is either a `moss` ("mossy") or a `seed` ("woody"):

- `moss`: a `twig` whose `product` is used as a `mold`
- `seed`: a `twig` whose `product` could be anything

The vast majority of `twig`s have a *regular form*, beginning with either a keyword `sigil` or a digraph `rune`. Some `twig`s also have a syntactic *irregular form*, a handful have *only* an *irregular form*.

- `sigil`: a keyword used to begin a `twig`

Hoon does not have reserved words, but `sigil`s (prefixed with `:`), which are effectively aliases for `rune`s. For example, [`:if` is `?:`](../../hoon/twig/wut-test/col-if/).

- `rune`: a pair of ASCII symbols used to begin a `twig` - the first symbol represents a family of related `twig`s. For example, the [`?` family](../../hoon/twig/wut-test/) are all conditionals.

*regular forms* can alternate between *tall* and *wide* (or *flat*) syntax, *irregular formas* can use only the *wide*/*flat* syntax.

*See [`twig` concept](../../hoon/concepts/#-twig-expression), [expressions](../../hoon/twig/), and [syntax](../../hoon/syntax/)*

###### `limb`: attribute or variable reference

To resolve a `limb` named "foo", the `subject` is searched depth-first, head-first for either a `face` named "foo" or a `core` with an `arm` of "foo". If a `face` is found, the result is a `leg`, if a `core` is found, the result is the `product` of the `arm`.

- `leg`: a subexpression, or subtree of the `subject`. usually another `twig`, sometimes a symbol (`@tas`) or `wing`
- `wing`: a list of `limb`s

*See [Limbs and wings](../../hoon/twig/limb)*

###### `face`: a named variable

Hoon has no scope or symbol-table; there is only the `subject`. To "declare" a "variable" is to construct a new `subject`: `[variable old-subject]`.

A `face` is a `span` *(TODO: ?)* with a label (`@tas`) wrapped around it.

- `taco`: a `symbol` (for a *type-inferred* `face`), or a `symbol` *with* a `mold` (for a *type-checked* `face`)

*TODO: check these*

- `tune`: advanced `face`s:
    - `alias`: a `face` that is a lazy reference to another `face`
    - `bridge`: a `face` that references a `twig`, against which the `face` label is resolved

*See [advanced types](../../hoon/advanced/#-face-aliases-and-bridges)*

###### `nest`: a type-casting operation

*TODO:*

### Arvo

> Arvo is a nonpreemptive OS kernel, a single-threaded event interpreter.

- `mark`
- `generator`

*... TODO*
