### `++cap`

Tree head

Tests whether an `a` is in the head or tail of a noun. Produces the
cube `%2` if it is within the head, or the cube `%3` if it is
within the tail.

Accepts
-------

`a` is an atom.

Produces
--------

A cube.

Source
------

        ++  cap                                                 ::  tree head
          ~/  %cap
          |=  a=@
          ^-  ?(%2 %3)
          ?-  a
            %2        %2
            %3        %3
            ?(%0 %1)  !!
            *         $(a (div a 2))
          ==
        ::

Examples
--------

    ~zod/try=> (cap 4)
    %2
    ~zod/try=> (cap 6)
    %3
    ~zod/try=> (cap (add 10 9))
    %2



***
