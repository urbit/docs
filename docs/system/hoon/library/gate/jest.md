### `++jest`

Match a cord

Match and consume a cord.

Accepts
-------

`daf` is a [`@t`]().

Produces
--------

An [`++edge`]().

Source
------

    ++  jest                                                ::  match a cord
      |=  daf=@t
      |=  tub=nail
      =+  fad=daf
      |-  ^-  (like ,@t)
      ?:  =(0 daf)
        [p=p.tub q=[~ u=[p=fad q=tub]]]
      ?:  |(?=(~ q.tub) !=((end 3 1 daf) i.q.tub))
        (fail tub)
      $(p.tub (lust i.q.tub p.tub), q.tub t.q.tub, daf (rsh 3 1 daf))
    ::

Examples
--------

    ~zod/try=> ((jest 'abc') [[1 1] "abc"])
    [p=[p=1 q=4] q=[~ [p='abc' q=[p=[p=1 q=4] q=""]]]]
    ~zod/try=> (scan "abc" (jest 'abc'))
    'abc'
    ~zod/try=> (scan "abc" (jest 'acb'))
    ! {1 2}
    ! 'syntax-error'
    ! exit
    ~zod/try=> ((jest 'john doe') [[1 1] "john smith"])
    [p=[p=1 q=6] q=~]
    ~zod/try=> ((jest 'john doe') [[1 1] "john doe"])
    [p=[p=1 q=9] q=[~ [p='john doe' q=[p=[p=1 q=9] q=""]]]]


