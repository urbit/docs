### `++knee`

Recursive parsers

Used for recursive parsers, which would otherwise be infinite when
compiled.

Accepts
-------

`gar` is a noun.

`sef` is a [gate]() that accepts a [`++rule`]()

Produces
--------

A [`++rule`]().

Source
------

    ++  knee                                                ::  callbacks
      |*  [gar=* sef=_|.(rule)]
      |=  tub=nail
      ^-  (like ,_gar)
      ((sef) tub)
    ::

Examples
--------

    ~zod/try=> |-(;~(plug prn ;~(pose $ (easy ~))))
    ! rest-loop
    ! exit
    ~zod/try=> |-(;~(plug prn ;~(pose (knee *tape |.(^$)) (easy ~))))
    < 1.obo
      [ c=c=tub=[p=[p=@ud q=@ud] q=""]
          b
        < 1.bes
          [ c=tub=[p=[p=@ud q=@ud] q=""]
            b=<1.tnv [tub=[p=[p=@ud q=@ud] q=""] <1.ktu [daf=@tD <414.fvk 101.jzo 1.ypj %164>]>]>
            a=<1.fvg [tub=[p=[p=@ud q=@ud] q=""] <1.khu [[les=@ mos=@] <414.fvk 101.jzo 1.ypj %164>]>]>
            v=<414.fvk 101.jzo 1.ypj %164>
          ]
        >
          a
        ... 450 lines omitted ...
      ]
    >
    ~zod/try=> (scan "abcd" |-(;~(plug prn ;~(pose (knee *tape |.(^$)) (easy ~)))))
    [~~a "bcd"]


