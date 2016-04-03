### `++slat`

Curried slaw

Produces a `gate` that parses a `term` `txt` to an atom of the
odor specified by `mod`.

Accepts
-------

Produces
--------

`mod` is a term, an atom of odor `@tas`.

`txt` is a span, an atom of odor `@ta`.

Source
------

    ++  slat  |=(mod/@tas |=(txt/@ta (slaw mod txt)))

Examples
--------

    ~zod/try=> `(unit @p)`((slat %p) '~pillyt')
    [~ ~pillyt]
    ~zod/try=> `(unit @ux)`((slat %ux) '0x12')
    [~ 0x12]
    ~zod/try=> `(unit @if)`((slat %if) '.127.0.0.1')
    [~ .127.0.0.1]
    ~zod/try=> `(unit @ta)`((slat %ta) '~.asd_a')
    [~ ~.asd_a



***
