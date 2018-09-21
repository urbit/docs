---
navhome: /docs/
---


### `++taco`

Converts an atom to an octet stream [`++octs`](), which contains a length, to
encode trailing zeroes.

Produces
--------

An `++octs`.

Source
------

    ++  taco                                                ::  atom to octstream
      |=  tam=@  ^-  octs
      [(met 3 tam) tam]
    ::

Examples
--------

    ~zod/try=> (taco 'abc')
    [p=3 q=6.513.249]
    ~zod/try=> `@t`6.513.249
    'abc'


