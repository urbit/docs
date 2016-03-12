### `++trip`

Cord to tape

Produce a [`++tape`]() from [`++cord`]().

Accepts
-------

`a` is an atom.

Produces
--------

A `++tape`.

Source
------

    ++  trip                                                ::  cord to tape
      ~/  %trip
      |=  a=@  ^-  tape
      ?:  =(0 (met 3 a))
        ~
      [^-(@ta (end 3 1 a)) $(a (rsh 3 1 a))]
    ::

Examples
--------

    /~zod/try=> (trip 'john doe')
    "john doe"
    /~zod/try=> (trip 'abc 123 !@#')
    "abc 123 !@#"
    /~zod/try=> (trip 'abc')
    "abc"



***
