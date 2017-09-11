---
navhome: '/docs/'
sort: 2
---

# `:dip  ;~  "semsig"`

`{$dip p/seed q/(list seed)}`: glue a pipeline together with a product-sample
adapter.

## Produces

The gates in `q` connected together using the gate `p`, which transforms a `q`
product and a `q` gate into a `q` sample.

## Discussion

Apparently `:dip` is a "Kleisli arrow." Whatevs. It's also a close cousin of the
infamous "monad." Don't let that bother you either. Hoon doesn't know anything
about category theory, so you don't need to either.

`:dip` is often used in parsers, but is not only for parsers.

## Syntax

Regular: *1-fixed*, then *running*.

## Examples

A simple "parser." `trip` converts a `cord` (atomic string) to a `tape` (linked
string).

    ~zod:dojo> =cmp |=({a/tape b/$-(char tape)] `tape`?~(a ~ (weld (b i.a) t.a)))
    ~zod:dojo> ;~(cmp trip)
    <1.xef [a=@ <374.hzt 100.kzl 1.ypj %164>]>
    ~zod:dojo> (;~(cmp trip) 'a')
    "a"

With just one gate in the pipeline `q`, the glue `p` is unused:

    ~zod:dojo> (;~(cmp trip |=(a/@ ~[a a])) 'a')
    "aa"
    ~zod:dojo> (;~(cmp trip |=(a/@ ~[a a])) '')
    ""

But for multiple gates, we need it to connect the pipeline:

    ~zod:dojo> (;~(cmp trip ;~(cmp |=(a/@ ~[a a]) |=(a/@ <(dec a)>))) 'b')
    "97b"
    ~zod:dojo> (;~(cmp trip |=(a/@ ~[a a]) |=(a/@ <(dec a)>)) 'b')
    "97b"
    ~zod:dojo> (;~(cmp trip |=(a/@ ~[a a]) |=(a/@ <(dec a)>)) '')
    ""
    ~zod:dojo> (;~(cmp trip |=(a/@ ~[a a]) |=(a/@ <(dec a)>)) 'a')
    "96a"
    ~zod:dojo> (;~(cmp trip |=(a/@ ~[a a]) |=(a/@ <(dec a)>)) 'acd')
    "96acd"
