### `++bend`

Conditional composer

Parsing composer: connects the [`++edge`]() `vex` with the subsequent [`++rule`]() `sab`
as an optional suffix, using [gate]() `raq` to compose or reject its
result. If there is no suffix, or if the suffix fails to be composed
with the current result, the current result is produced. Used to map a
group of rules to a specified output.

Accepts
-------

`raq` is a [gate]().

`sab` is a [rule]().

`vex` is an [edge]().

Produces
--------

A [`++rule`]().

Source
------

    ++  bend                                                ::  conditional comp
      ~/  %bend
      |*  raq=_|*([a=* b=*] [~ u=[a b]])
      ~/  %fun
      |*  [vex=edge sab=_rule]
      ?~  q.vex
        vex
      =+  yit=(sab q.u.q.vex)
      =+  yur=(last p.vex p.yit)
      ?~  q.yit
        [p=yur q=q.vex]
      =+  vux=(raq p.u.q.vex p.u.q.yit)
      ?~  vux
        [p=yur q=q.vex]
      [p=yur q=[~ u=[p=u.vux q=q.u.q.yit]]]
    ::

Examples
--------

    ~zod/try=> (;~((bend |=([a=char b=char] ?.(=(a b) ~ (some +(a))))) prn prn) [1 1] "qs")
    [p=[p=1 q=3] q=[~ u=[p=~~q q=[p=[p=1 q=2] q="s"]]]]
    ~zod/try=> (;~((bend |=([a=char b=char] ?.(=(a b) ~ (some +(a))))) prn prn) [1 1] "qqq")
    [p=[p=1 q=3] q=[~ u=[p=~~r q=[p=[p=1 q=3] q="q"]]]]
    ~zod/try=> (scan "aa" ;~((bend |=([a=char b=char] ?.(=(a b) ~ (some +(a))))) prn prn))
    ~~b
    ~zod/try=> (scan "ba" ;~((bend |=([a=char b=char] ?.(=(a b) ~ (some +(a))))) prn prn))
    ! {1 3}
    ! exit
    ~zod/try=> `(unit ,@tas)`(scan "" ;~((bend) (easy ~) sym))
    ~
    ~zod/try=> `(unit ,@tas)`(scan "sep" ;~((bend) (easy ~) sym))
    [~ %sep]



***
