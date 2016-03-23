### `++mock`

Compute formula on subject with hint

Produces a `++toon`, which is either a sucessful, blocked, or
crashed result. If nock 11 is invoked, `sky` computes on the subject and
produces a `++unit` result. An empty result becomes a `%1` `++tune`,
indicating a block.

Accepts
-------

`sub` is the subject as a noun.

`fol` is the formula as a noun.

`sky` is an %iron gate invoked with nock operator 11.

Produces
--------

The `++unit` of a noun.

Source
------

    ++  mock
      |=  {{sub/* fol/*} gul/$-({* *} (unit (unit)))}
      (mook (mink [sub fol] gul))
    ::


Examples
--------

    ~zod/try=> (mock [5 4 0 1] ,~)
    [%0 p=6]
    ~zod/try=> (mock [~ 11 1 0] |=(* `999))
    [%0 p=999]
    ~zod/try=> (mock [~ 0 1.337] ,~)
    [%2 p=~]
    ~zod/try=> (mock [~ 11 1 1.337] ,~)
    [%1 p=~[1.337]]
    ~zod/try=> (mock [[[4 4 4 4 0 3] 10] 11 9 2 0 1] |=(* `[+<]))
    [%0 p=14]
    ~zod/try=> (mock [[[4 4 4 4 0 3] 10] 11 9 2 0 1] |=(* `[<+<>]))
    [%0 p=[49 52 0]]
    ~zod/try=> ;;(tape +:(mock [[[4 4 4 4 0 3] 10] 11 9 2 0 1] |=(* `[<+<>])))
    "14"



***
