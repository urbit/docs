### `++mug`

Hashes `a` with the 31-bit nonzero FNV-1a non-cryptographic hash
algorithm, producing an [atom]().

Accepts
-------

A is a [noun]().

Produces
--------

An atom.

Source
------

    ++  mug                                                 ::  31bit nonzero FNV1a
      ~/  %mug
      |=  a=*
      ?^  a
        =+  b=[p=$(a -.a) q=$(a +.a)]
        |-  ^-  @
        =+  c=(fnv (mix p.b (fnv q.b)))
        =+  d=(mix (rsh 0 31 c) (end 0 31 c))
        ?.  =(0 c)  c
        $(q.b +(q.b))
      =+  b=2.166.136.261
      |-  ^-  @
      =+  c=b
      =+  [d=0 e=(met 3 a)]
      |-  ^-  @
      ?:  =(d e)
        =+  f=(mix (rsh 0 31 c) (end 0 31 c))
        ?.  =(0 f)  f
        ^$(b +(b))
      $(c (fnv (mix c (cut 3 [d 1] a))), d +(d))

Examples
--------

    ~zod/try=> (mug 10.000)
    178.152.889
    ~zod/try=> (mug 10.001)
    714.838.017
    ~zod/try=> (mug 1)
    67.918.732
    ~zod/try=> (mug (some 10))
    1.872.403.737
    ~zod/try=> (mug (limo [1 2 3 4 5 ~]))
    1.067.931.605



***
