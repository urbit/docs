### `++coin`

Noun literal syntax cases

Noun literal syntax cases: atoms, jammed nouns, and nestable tuples.
Parsed and printed using `++so` and `++co` cores.

Source
------

    ++  coin  $%  {$$ p/dime}                               ::
                  {$blob p/*}                               ::
                  {$many p/(list coin)}                     ::
              ==                                            ::

Examples
--------

    ~zod/try=> `coin`(need (slay '~s1'))
    [%$ p=[p=~.dr q=18.446.744.073.709.551.616]]
    ~zod/try=> `coin`(need (slay '0x2b59'))
    [%$ p=[p=~.ux q=11.097]]

    ~zod/try=> ~(rend co [%many ~[[%$ %ud 1] [%$ %tas 'a'] [%$ %s -2]]])
    "._1_a_-2__"
    ~zod/try=> ._1_a_-2__
    [1 %a -2]

    ~zod/try=> `@uv`(jam [3 4])
    0v2cd1
    ~zod/try=> (slay '~02cd1')
    [~ [%blob p=[3 4]]]
    ~zod/try=> ~02cd1
    [3 4]



***
