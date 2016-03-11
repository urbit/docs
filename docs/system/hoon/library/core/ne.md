### `++ne`

Digit rendering engine

A [door]() containing arms that render digits at bases 10, 16, 32, and
64.

Accepts
-------

Produces
--------

`tig` is an [`atom`]().

Source
------

    ++  ne
      |_  tig=@

Examples
--------

    ~zod/try=> ~(. ne 20)
    <4.gut [@ud <414.hhh 100.xkc 1.ypj %164>]>

------------------------------------------------------------------------

### `++d`

Render decimal

Renders a decimal digit as an atom of an ACII byte value.

Accepts
-------

Produces
--------

`tig` is an [`atom`]().

Source
------

      ++  d  (add tig '0')

Examples
--------

    ~zod/try=> `@t`~(d ne 7)
    '7'

------------------------------------------------------------------------

### `++x`

Render hex

Renders a hexadecimal digit as an atom of an ASCII byte value.

Accepts
-------

Produces
--------

`tig` is an [`atom`]().

Source
------

      ++  x  ?:((gte tig 10) (add tig 87) d)

Examples
--------

    ~zod/try=> `@t`~(x ne 7)
    '7'
    ~zod/try=> `@t`~(x ne 14)
    'e'

------------------------------------------------------------------------

### `++v`

Render base-32

Renders a base-32 digit as an atom of an ASCII byte value.

Accepts
-------

Produces
--------

Source
------

      ++  v  ?:((gte tig 10) (add tig 87) d)

Examples
--------

    ~zod/try=> `@t`~(v ne 7)
    '7'
    ~zod/try=> `@t`~(v ne 14)
    'e'
    ~zod/try=> `@t`~(v ne 25)
    'p'

------------------------------------------------------------------------

### `++w`

Render base-64

Renders a base-64 digit as an atom of an ASCII byte value.

Accepts
-------

Produces
--------

`tig` is an [`atom`]().

Source
------

      ++  w  ?:(=(tig 63) '~' ?:(=(tig 62) '-' ?:((gte tig 36) (add tig 29) x)))
      --
    ::

Examples
--------

    ~zod/try=> `@t`~(w ne 7)
    '7'
    ~zod/try=> `@t`~(w ne 14)
    'e'
    ~zod/try=> `@t`~(w ne 25)
    'p'
    ~zod/try=> `@t`~(w ne 52)
    'Q'
    ~zod/try=> `@t`~(w ne 61)
    'Z'
    ~zod/try=> `@t`~(w ne 63)
    '~'
    ~zod/try=> `@t`~(w ne 62)
    '-'


