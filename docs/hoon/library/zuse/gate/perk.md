---
navhome: /docs/
---


### `++perk`

Parse cube with fork

Parser generator. Produces a parser that succeeds upon encountering one
of the [`++term`]()s in a faceless list `a`.

A perk is an arm used to parse one of a finite set of options, formally
a choice between [`++term`]()s: if you want to match "true" or "false", and
nothing else, (perk \~[%true %false]) produces the relevant parser,
whose result type is `?(%true %false)`. For more complicated
transformations, a combintation of ++[`++sear`]() and map ++[`++get`]() is recommended,
e.g. `(sear ~(get by (mo ~[[%true &] [%false |]]))) sym)` will have a
similar effect but produce `?(& |)` , a [boolean](). However, constructions
such as `(sear (flit ~(has in (sa %true %false %other ~))) sym)` are
needlessly unwieldy.

Accepts
-------

`a` is a [`++pole`](), which is a [`++list`]() without [`%face`]()s.

Produces
--------

XX

Source
------

    ++  perk                                                ::  parse cube with fork
      |*  a=(pole ,@tas)
      ?~  a  fail
      ;~  pose 
        (cold -.a (jest -.a))
        $(a +.a)
      ==
    ::

Examples
--------

    ~zod/try=> (scan "ham" (perk %sam %ham %lam ~))
    %ham
    ~zod/try=> (scan "ram" (perk %sam %ham %lam ~))
    ! {1 1}
    ! exit


