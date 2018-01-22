---
navhome: /docs/
---


### `++mang`

Unit: Slam gate with sample

Produces a [`++unit`]() computation result from slamming `gat` with
`sam`, using `sky` to compute or block on nock 11 when applicable.
Similar to [`++mong`]().

Accepts
-------

`gat` is a [noun]() that is generally a [`gate`]().

`sam` is a [`sample`]() noun.

`sky` is an [%iron]() gate invoked with [nock operator 11]().

Produces
--------

The `++unit` of a noun.

Source
------

    ++  mang
      |=  [[gat=* sam=*] sky=$+(* (unit))]
      ^-  (unit)
      =+  ton=(mong [[gat sam] sky])
      ?.(?=([0 *] ton) ~ [~ p.ton])
    ::

Examples
--------

    ~zod/try=> (mang [|=(@ 20) ~] ,~)
    [~ 20]
    ~zod/try=> (mang [|=(@ !!) ~] ,~)
    ~
    ~zod/try=> (mang [|=(a=@ (add 20 a)) ~] ,~)
    [~ 20]
    ~zod/try=> (mang [|=(a=[@ @] (add 20 -.a)) ~] ,~)
    ~
    ~zod/try=> (mang [|=(a=[@ @] (add 20 -.a)) [4 6]] ,~)
    [~ 24]
    ~zod/try=> (mang [|=(a=@ .^(a)) ~] ,~)
    ~
    ~zod/try=> (mang [|=(a=@ .^(a)) ~] ,[~ %42])
    [~ 42]
    ~zod/try=> (mang [|=(a=@ .^(a)) ~] |=(a=* [~ a 6]))
    [~ [0 6]]
    ~zod/try=> (mang [|=(a=@ .^(a)) 8] |=(a=* [~ a 6]))
    [~ [8 6]]


