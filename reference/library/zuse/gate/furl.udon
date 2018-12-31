---
navhome: /docs/
---


### `++furl`

Unify changes

Merge two [`++toro`]()s `one` and `two` that are in the same [`desk`]()
and pointed at the same [`++path`]().

Accepts
-------

`one` is a `++toro`.

`two` is a `++toro`.

Produces
--------

A `++toro`.

Source
------

    ++  furl                                                ::  unify changes
          |=  [one=toro two=toro]
          ^-  toro
          ~|  %furl
          ?>  ?&  =(p.one p.two)                                ::  same path
                  &(?=(& -.q.one) ?=(& -.q.two))                ::  both deltas
              ==
          [p.one [%& [*cart (weld q.q.q.one q.q.q.two)]]]
        ::

Examples
--------

    ~zod/try=> %/zak
    ~zod/try=/zak> :ls %
    mop
    ~zod/try=/zak> (furl (fray %/mop) (foal %/mok 'hi'))
    [ p=~.try
        q
      [ %.y
          q
        [ p=[p=0v0 q=0v0]
          q=~[[p=/zak/mop q=[%del p=20]] [p=/zak/mok q=[%ins p=26.984]]]
        ]
      ]
    ]


