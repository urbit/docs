### `++homo`

Homogenize

Produces a `++list` whose type is a fork of all the contained types in the
list `a`. Used when you want to make all the types of the elements of a list the same.

Accepts
-------

`a` is a list.

Produces
--------

a list. 

Source
------

    ++  homo                                                ::  homogenize
      |*  a/(list)
      ^+  =<  $
        |%  +-  $  ?:(*? ~ [i=(snag 0 a) t=$])
        --
      a


Examples
--------

    ~zod/try=> lyst
    [i=1 t=[i=97 t=[i=2 t=[i=98 t=[i=[~ u=10] t=~]]]]]
    ~zod/try=> (homo lyst)
    ~[1 97 2 98 [~ u=10]]
    ~zod/try=> =a (limo [1 2 3 ~])
    ~zod/try=> a
    [i=1 t=[i=2 t=[i=3 t=~]]]
    ~zod/try=> (homo a)
    ~[1 2 3]



***
