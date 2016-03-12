### `++just`

Match a char

Match and consume a single character.

Accepts
-------

`daf` is a [`++char`]()

Produces
--------

A [`++rule`]().

Source
------

    ++  just                                                ::  XX redundant, jest
      ~/  %just                                             ::  match a char
      |=  daf=char
      ~/  %fun
      |=  tub=nail
      ^-  (like char)
      ?~  q.tub
        (fail tub)
      ?.  =(daf i.q.tub)
        (fail tub)
      (next tub)
    ::


Examples
--------

    ~zod/try=> ((just 'a') [[1 1] "abc"])
    [p=[p=1 q=2] q=[~ [p=~~a q=[p=[p=1 q=2] q="bc"]]]]
    ~zod/try=> (scan "abc" (just 'a'))
    ! {1 2}
    ! 'syntax-error'
    ! exit
    ~zod/try=> (scan "a" (just 'a'))
    ~~a
    ~zod/try=> (scan "%" (just '%'))
    ~~~25.


