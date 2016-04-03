### `++lent`

List length

Produces the length of any `++list` `a` as an atom.

Accepts
-------

`a` is a list.

Produces
--------

an atom.

Source
------

    ++  lent                                                ::  length
      ~/  %lent
      |=  a/(list)
      ^-  @
      =+  b=0
      |-
      ?~  a  b
      $(a t.a, b +(b))


Examples
--------

    ~zod/try=> (lent (limo [1 2 3 4 ~]))
    4
    ~zod/try=> (lent (limo [1 'a' 2 'b' (some 10) ~]))
    5



***
