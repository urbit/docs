Reverse

### `++flop`

Produces the list `a` in reverse order.

Accepts
-------

`a` is a list.

Produces
--------

A list.

Source
------

    ++  flop                                                ::  reverse
      ~/  %flop
      |*  a=(list)
      =>  .(a (homo a))
      ^+  a
      =+  b=`_a`~
      |-
      ?~  a  b
      $(a t.a, b [i.a b])


Examples
--------

    ~zod/try=> =a (limo [1 2 3 ~])
    ~zod/try=> (flop a)
    ~[3 2 1]



***
