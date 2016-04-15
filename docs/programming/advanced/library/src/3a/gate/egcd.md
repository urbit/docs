### `++egcd`

GCD

    ++  egcd  !:                                            ::  schneier's egcd
      |=  {a/@ b/@}
      =+  si
      =+  [c=(sun a) d=(sun b)]
      =+  [u=[c=(sun 1) d=--0] v=[c=--0 d=(sun 1)]]
      |-  ^-  {d/@ u/@s v/@s}
      ?:  =(--0 c)
        [(abs d) d.u d.v]
      ::  ?>  ?&  =(c (sum (pro (sun a) c.u) (pro (sun b) c.v)))
      ::          =(d (sum (pro (sun a) d.u) (pro (sun b) d.v)))
      ::      ==
      =+  q=(fra d c)
      %=  $
        c  (dif d (pro q c))
        d  c
        u  [(dif d.u (pro q c.u)) c.u]
        v  [(dif d.v (pro q c.v)) c.v]
      ==
    ::


Greatest common denominator

    ~zod/try=> (egcd 20 15)
    [d=5 u=2 v=1]
    ~zod/try=> (egcd 24 16)
    [d=8 u=2 v=1]
    ~zod/try=> (egcd 7 5)
    [d=1 u=3 v=6]
    ~zod/try=> (egcd (shaf ~ %ham) (shaf ~ %sam))
    [ d=1
      u=59.983.396.314.566.203.239.184.568.129.921.874.787  
      v=38.716.650.351.034.402.960.165.718.823.532.275.722
    ]



***
