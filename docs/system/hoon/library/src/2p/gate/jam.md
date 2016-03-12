### `++jam`

Unpack noun to atom

Produces an atom unpacked from noun `a`. The inverse of cue.

Accepts
-------

`a` is a [noun]().

Produces
--------

An atom.

Source
------

    ++  jam                                                 ::  pack
      ~/  %jam
      |=  a=*
      ^-  @
      =+  b=0
      =+  m=`(map ,* ,@)`~
      =<  q
      |-  ^-  [p=@ q=@ r=_m]
      =+  c=(~(get by m) a)
      ?~  c
        =>  .(m (~(put by m) a b))
        ?:  ?=(@ a)
          =+  d=(mat a)
          [(add 1 p.d) (lsh 0 1 q.d) m]
        =>  .(b (add 2 b))
        =+  d=$(a -.a)
        =+  e=$(a +.a, b (add b p.d), m r.d)
        [(add 2 (add p.d p.e)) (mix 1 (lsh 0 2 (cat 0 q.d q.e))) r.e]
      ?:  ?&(?=(@ a) (lte (met 0 a) (met 0 u.c)))
        =+  d=(mat a)
        [(add 1 p.d) (lsh 0 1 q.d) m]
      =+  d=(mat u.c)
      [(add 2 p.d) (mix 3 (lsh 0 2 q.d)) m]
    ::


Examples
--------

    ~zod/try=> (jam 1)
    12
    ~zod/try=> (jam [1 1])
    817
    ~zod/try=> (jam [1 2])
    4.657
    ~zod/try=> (jam [~ u=19])
    39.689



***
