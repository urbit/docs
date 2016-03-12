### `++slug`

Use gate to parse delimited list

Parser modifier: By composing with a [gate](), parse a delimited [`++list`]() of
matches.

Accepts
-------

`bus` is a [`++rule`]().

`fel` is a `++rule`.

Produces
--------

A `++rule`.

Source
------

    ++  slug
      |*  raq=_|*([a=* b=*] [a b])
      |*  [bus=_rule fel=_rule]
      ;~((comp raq) fel (stir +<+.raq raq ;~(pfix bus fel)))

Examples
--------
    
    ~zod/try=> (scan "20+5+110" ((slug add) lus dem))
    135
    ~zod/try=> `@t`(scan "a b c" ((slug |=(a=[@ @t] (cat 3 a))) ace alp))
    'abc'



***
