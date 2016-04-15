### `++stet`

Add faces

Add faces `[p q]` to range-parser pairs in a list.

Accepts
-------

`leh` is a list of range-parsers.

Produces
--------



Source
------

    ++  stet
      |*  leh/(list {?(@ {@ @}) rule})
      |-
      ?~  leh
        ~
      [i=[p=-.i.leh q=+.i.leh] t=$(leh t.leh)]
    ::

Examples
--------

    ~zod/try=> (stet (limo [[5 (just 'a')] [1 (jest 'abc')] [[1 1] (shim 0 200)] 
    [[1 10] (cold %foo (just 'a'))]~]))
    ~[
      [p=5 q=<1.lrk [tub=[p=[p=@ud q=@ud] q=""] <1.nqy [daf=@tD <394.imz 97.kdz 1.xlc %164>]>]>]
      [p=1 q=<1.lrk [tub=[p=[p=@ud q=@ud] q=""] <1.nqy [daf=@tD <394.imz 97.kdz 1.xlc %164>]>]>]
      [p=[1 1] q=<1.lrk [tub=[p=[p=@ud q=@ud] q=""] <1.nqy [daf=@tD <394.imz 97.kdz 1.xlc %164>]>]>]
      [p=[1 10] q=<1.lrk [tub=[p=[p=@ud q=@ud] q=""] <1.nqy [daf=@tD <394.imz 97.kdz 1.xlc %164>]>]>]
    ]
    ~zod/try=> [[[1 1] (just 'a')] [[2 1] (shim 0 200)] ~]
    [ [[1 1] <1.tnv [tub=[p=[p=@ud q=@ud] q=""] <1.ktu [daf=@tD <414.fvk 101.jzo 1.ypj %164>]>]>]
      [[2 1] <1.fvg [tub=[p=[p=@ud q=@ud] q=""] <1.khu [[les=@ mos=@] <414.fvk 101.jzo 1.ypj %164>]>]>]
      ~
    ]
    ~zod/try=> (stet (limo [[[1 1] (just 'a')] [[2 1] (shim 0 200)] ~]))
    ~[
      [p=[1 1] q=<1.lrk [tub=[p=[p=@ud q=@ud] q=""] <1.nqy [daf=@tD <394.imz 97.kdz 1.xlc %164>]>]>] 
      [p=[2 1] q=<1.lrk [tub=[p=[p=@ud q=@ud] q=""] <1.nqy [daf=@tD <394.imz 97.kdz 1.xlc %164>]>]>]
    ]



***
