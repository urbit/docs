### `++weld`

Concatenate

Concatenate two [`++list`]()s `a` and `b`.

Accepts
-------

`a` and `b` are [list]()s.

Source
------

    ++  weld                                                ::  concatenate
      ~/  %weld
      |*  [a=(list) b=(list)]
      =>  .(a ^.(homo a), b ^.(homo b))
      |-  ^+  b
      ?~  a  b
      [i.a $(a t.a)]

Examples
--------

    ~zod/try=> (weld "urb" "it")
    ~[~~u ~~r ~~b ~~i ~~t]
    ~zod/try=> (weld (limo [1 2 ~]) (limo [3 4 ~]))
    ~[1 2 3 4]


