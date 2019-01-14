---
navhome: /docs/
---


### `++mung`

Virtualize slamming gate

Produces a [`++tone`]() computation result from slamming `gat` with
`sam`, using `sky` to compute or block on nock 11 when applicable.

Accepts
-------

`gat` is a [noun]() that is generally a [`gate`]().

`sam` is a [`sample`]() noun.

`sky` is an [%iron]() gate invoked with [nock operator 11]().

Produces
--------

A `++tone`.

Source
------

    ++  mung
      |=  [[gat=* sam=*] sky=$+(* (unit))]
      ^-  tone
      ?.  &(?=(^ gat) ?=(^ +.gat))
        [%2 ~]
      (mink [[-.gat [sam +>.gat]] -.gat] sky)
    ::

Examples
--------

    ~zod/try=> (mung [|=(@ 20) ~] ,~)
    [%0 p=20]
    ~zod/try=> (mung [|=(@ !!) ~] ,~)
    [%2 p=~]
    ~zod/try=> (mung [|=(a=@ (add 20 a)) ~] ,~)
    [%0 p=20]
    ~zod/try=> (mung [|=(a=[@ @] (add 20 -.a)) ~] ,~)
    [%2 p=~]
    ~zod/try=> (mung [|=(a=[@ @] (add 20 -.a)) [4 6]] ,~)
    [%0 p=24]
    ~zod/try=> (mung [|=(a=@ .^(a)) ~] ,~)
    [%1 p=~[0]]
    ~zod/try=> (mung [|=(a=@ .^(a)) ~] ,[~ %42])
    [%0 p=42]
    ~zod/try=> (mung [|=(a=@ .^(a)) ~] |=(a=* [~ a 6]))
    [%0 p=[0 6]]
    ~zod/try=> (mung [|=(a=@ .^(a)) 8] |=(a=* [~ a 6]))
    [%0 p=[8 6]]


