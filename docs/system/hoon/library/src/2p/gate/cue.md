### `++cue`

Unpack atom to noun

Produces a noun unpacked from atom `a`. The inverse of jam.

Accepts
-------

`a` is an [atom]().

Produces
--------

A [`++noun`]().

Source
------

    ++  cue                                                 ::  unpack atom to noun
      ~/  %cue
      |=  a=@
      ^-  *
      =+  b=0
      =+  m=`(map ,@ ,*)`~
      =<  q
      |-  ^-  [p=@ q=* r=_m]
      ?:  =(0 (cut 0 [b 1] a))
        =+  c=(rub +(b) a)
        [+(p.c) q.c (~(put by m) b q.c)]
      =+  c=(add 2 b)
      ?:  =(0 (cut 0 [+(b) 1] a))
        =+  u=$(b c)
        =+  v=$(b (add p.u c), m r.u)
        =+  w=[q.u q.v]
        [(add 2 (add p.u p.v)) w (~(put by r.v) b w)]
      =+  d=(rub c a)
      [(add 2 p.d) (need (~(get by m) q.d)) m]
    ::


Examples
--------

    ~zod/try=> (cue 12)
    1
    ~zod/try=> (cue 817)
    [1 1]
    ~zod/try=> (cue 4.657)
    [1 2]
    ~zod/try=> (cue 39.689)
    [0 19]


***
