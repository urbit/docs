---
navhome: /docs/
---


### `++unt`

UGT to UTC time

Transforms Urbit Galactic Time to UTC time, producing an atom.

Accepts
-------

An atom of [odor]() [`@da`](), representing an absolute date.

Produces
--------

An atom.

Source
------

    ++  unt                                                 ::  UGT to UTC time
      |=  a=@da
      (div (sub a ~1970.1.1) (bex 64))
    ::

Examples
--------

    ~zod/try=/hom> (unt -<-)
    1.413.927.704
    ~zod/try=> (unt ~20014.1.1)
    569.413.670.400
    ~zod/try=> (unt ~2014.1.1)
    1.388.534.400


