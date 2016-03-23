### `++mum`

XX document

Accepts
-------

Produces
--------

Source
------

    ++  mum                                                 ::  mug with murmur3
      ~/  %mum
      |=  a/*
      |^  (trim ?@(a a (mix $(a -.a) (mix 0x7fff.ffff $(a +.a)))))
      ++  spec                                              ::  standard murmur3
        |=  {syd/@ key/@}
        ?>  (lte (met 5 syd) 1)
        =+  ^=  row
            |=  {a/@ b/@}
            (con (end 5 1 (lsh 0 a b)) (rsh 0 (sub 32 a) b))
        =+  mow=|=({a/@ b/@} (end 5 1 (mul a b)))
        =+  len=(met 5 key)
        =-  =.  goc  (mix goc len)
            =.  goc  (mix goc (rsh 4 1 goc))
            =.  goc  (mow goc 0x85eb.ca6b)
            =.  goc  (mix goc (rsh 0 13 goc))
            =.  goc  (mow goc 0xc2b2.ae35)
            (mix goc (rsh 4 1 goc))
        ^=  goc
        =+  [inx=0 goc=syd]
        |-  ^-  @
        ?:  =(inx len)  goc
        =+  kop=(cut 5 [inx 1] key)
        =.  kop  (mow kop 0xcc9e.2d51)
        =.  kop  (row 15 kop)
        =.  kop  (mow kop 0x1b87.3593)
        =.  goc  (mix kop goc)
        =.  goc  (row 13 goc)
        =.  goc  (end 5 1 (add 0xe654.6b64 (mul 5 goc)))
        $(inx +(inx))


Examples
--------

    ~zod/try=> (mum 10.000)
    1.232.632.901
    ~zod/try=> (mum 10.001)
    658.093.079
    ~zod/try=> (mum 1)
    818.387.364
    ~zod/try=> (mum (some 10))
    1.177.215.703
    ~zod/try=> (mum ~[1 2 3 4 5])
    1.517.902.092



***
