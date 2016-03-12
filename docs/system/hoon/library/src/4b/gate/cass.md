
### `++cass`

To lowercase

Produce the case insensitive (all lowercase) [`++cord`]() of a [`++tape`]().

Accepts
-------

`vib` is a `++tape`.

Produces
--------

A `++cord`.

Source
------

    ++  cass                                                ::  lowercase
      |=  vib=tape
      %+  rap  3
      (turn vib |=(a=@ ?.(&((gte a 'A') (lte a 'Z')) a (add 32 a))))
    ::

Examples
--------

    ~zod/try=> (cass "john doe")
    7.309.170.810.699.673.450
    ~zod/try=> `cord`(cass "john doe")
    'john doe'
    ~zod/try=> (cass "abc, 123, !@#")
    2.792.832.775.110.938.439.066.079.945.313
    ~zod/try=> `cord`(cass "abc, 123, !@#")
    'abc, 123, !@#' 


***
