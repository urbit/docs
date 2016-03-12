### `++mas`

Axis within head/tail?

Computes the axis of `a` within either the head or tail of a noun (depends whether `a` lies within the the head or tail).

Accepts
-------

`a` is an [atom]().

Produces
--------

An atom.

Source
------

    ++  mas                                                 ::  tree body
      ~/  %mas
      |=  a=@
      ^-  @
      ?-  a
        1   !!
        2   1
        3   1
        *   (add (mod a 2) (mul $(a (div a 2)) 2))
      ==
    ::

Examples
--------

    ~zod/try=> (mas 3)
    1
    ~zod/try=> (mas 4)
    2
    ~zod/try=> (mas 5)
    3
    ~zod/try=> (mas 6)
    2
    ~zod/try=> (mas 0)
    ! exit
    ~zod/try=> (mas 1)
    ! exit



***
