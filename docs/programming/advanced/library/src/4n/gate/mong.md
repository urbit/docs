### `++mong`

Slam gate with sample

Produces a `++toon` computation result from slamming `gat` with
`sam`, using `sky` to compute or block on nock 11 when applicable.

Accepts
-------

`gat` is a noun that is generally a `gate`.

`sam` is a `sample` noun.

`sky` is an %iron gate invoked with nock operator 11.

Produces
--------

A `++toon`.

Source
------

    ++  mong
      |=  {{gat/* sam/*} gul/$-({* *} (unit (unit)))}
      ^-  toon
      ?.  &(?=(^ gat) ?=(^ +.gat))
        [%2 ~]
      (mock [[-.gat [sam +>.gat]] -.gat] gul)
    ::

Examples
--------

    ~zod/try=> (mong [|=(@ 20) ~] ,~)
    [%0 p=20]
    ~zod/try=> (mong [|=(@ !!) ~] ,~)
    [%2 p=~]
    ~zod/try=> (mong [|=(a/@ (add 20 a)) ~] ,~)
    [%0 p=20]
    ~zod/try=> (mong [|=(a/[@ @] (add 20 -.a)) ~] ,~)
    [%2 p=~]
    ~zod/try=> (mong [|=(a/[@ @] (add 20 -.a)) [4 6]] ,~)
    [%0 p=24]
    ~zod/try=> (mong [|=(a/@ .^(a)) ~] ,~)
    [%1 p=~[0]]
    ~zod/try=> (mong [|=(a/@ .^(a)) ~] ,[~ %42])
    [%0 p=42]
    ~zod/try=> (mong [|=(a/@ .^(a)) ~] |=(a/* [~ a 6]))
    [%0 p=[0 6]]
    ~zod/try=> (mong [|=(a/@ .^(a)) 8] |=(a/* [~ a 6]))
    [%0 p=[8 6]]



***
