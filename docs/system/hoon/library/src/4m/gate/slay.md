### `++slay`

Parse span to coin

Parses a span `txt` to the unit of a [`++coin`]().

Accepts
-------

Produces
--------

`txt` is a [`@ta`]().

Source
------

    ++  slay
      |=  txt=@ta  ^-  (unit coin)
      =+  vex=((full nuck:so) [[1 1] (trip txt)])
      ?~  q.vex
        ~
      [~ p.u.q.vex]
    ::

Examples
--------

    ~zod/try=> (slay '~pillyt')
    [~ [% p=[p=~.p q=32.819]]]
    ~zod/try=> (slay '0x12')
    [~ [% p=[p=~.ux q=18]]]
    ~zod/try=> (slay '.127.0.0.1')
    [~ [% p=[p=~.if q=2.130.706.433]]]
    ~zod/try=> `@ud`.127.0.0.1
    2.130.706.433
    ~zod/try=> (slay '._20_0w25_sam__')
    [ ~
      [ %many
        p=~[[% p=[p=~.ud q=20]] [% p=[p=~.uw q=133]] [% p=[p=~.tas q=7.168.371]]]
      ]
    ]
    ~zod/try=> `@`%sam
    7.168.371
    ~zod/try=> (slay '~0ph')
    [~ [%blob p=[1 1]]]
    ~zod/try=> 0ph
    ~ <syntax error at [1 2]>
    ~zod/try=> ~0ph
    [1 1]
    ~zod/try=> `@uv`(jam [1 1])
    0vph


