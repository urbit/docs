---
navhome: /docs/
---


### `++tell`

octs from wall

Converts a [`++wall`]() to an octet stream ([`++octs`](), which contains a length
to encode trailing zeroes.

Accepts
-------

`wol` is a [`++wall`]().

Produces
--------

An `++octs`.

Source
------

    ++  tell                                                ::  wall to octstream
      |=  wol=wall  ^-  octs
      =+  buf=(rap 3 (turn wol |=(a=tape (crip (weld a `tape`[`@`10 ~])))))
      [(met 3 buf) buf]
    ::

Examples
--------

    ~zod/try=> (tell ~["abc" "line" "3"])
    [p=11 q=12.330.290.663.108.538.769.039.969]
    ~zod/try=> `@t`12.330.290.663.108.538.769.039.969
    '''
    abc
    line
    3
    '''


