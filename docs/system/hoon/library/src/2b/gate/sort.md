### `++sort`

Quicksort

Quicksort: accepts a [`++list`]() `a` and a [gate]() `b` which accepts two nouns and
produces a loobean. `++sort` then produces a list of the elements of `a`,
sorted according to `b`.

Accepts
-------

`b` is a gate that ccepts two nouns and produces a boolean.

Produces
--------

A list

Source
------

    ++  sort                                                ::  quicksort
      ~/  %sort
      |*  [a=(list) b=$+([* *] ?)]
      =>  .(a ^.(homo a))
      |-  ^+  a
      ?~  a  ~
      %+  weld
        $(a (skim t.a |=(c=_i.a (b c i.a))))
      ^+  t.a
      [i.a $(a (skim t.a |=(c=_i.a !(b c i.a))))]

Examples
--------

        ~zod/try=> =a =|([p=@ q=@] |.((gth p q)))
        ~zod/try=> (sort (limo [0 1 2 3 ~]) a)
        ~[3 2 1 0]



***
