### `++cuss`

To uppercase

Turn all occurances of lowercase letters in any [`++tape`]() into uppercase
letters, as a [`++cord`]().

Accepts
-------

`vib` is a `++tape`.

Produces
--------

A `++cord`.

Source
------

    ++  cuss                                                ::  uppercase
      |=  vib=tape
      ^-  @t
      %+  rap  3
      (turn vib |=(a=@ ?.(&((gte a 'a') (lte a 'z')) a (sub a 32))))
    ::

Examples
--------

    ~zod/try=> (cuss "john doe")
    'JOHN DOE'
    ~zod/try=> (cuss "abc ABC 123 !@#")
    'ABC ABC 123 !@#'
    ~zod/try=> `@ud`(cuss "abc")
    4.407.873
    ~zod/try=> (cuss "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsQqRrVvWwXxYyZz")
    'AABBCCDDEEFFGGHHIIJJKKLLMMNNOOPPQQRRSSQQRRVVWWXXYYZZ'

