### `++tank`

Pretty-printing structure.

A `++tank` is one of three cases: a `%leaf`
is simply a string; a `%palm` is XX need more information; and a `%rose` is a
list of `++tank` delimted by the strings in `p`.


Source
------

    ++  tank  $%  {$leaf p/tape}                            ::  printing formats
                  $:  $palm                                 ::  backstep list
                      p/{p/tape q/tape r/tape s/tape}       ::
                      q/(list tank)                         ::
                  ==                                        ::
                  $:  $rose                                 ::  flat list
                      p/{p/tape q/tape r/tape}              ::  mid open close
                      q/(list tank)                         ::
                  ==                                        ::
              ==                                            ::

Examples
--------

    ~zod/try=> >(bex 20) (bex 19)<
    [%rose p=[p=" " q="[" r="]"] q=~[[%leaf p="1.048.576"] [%leaf p="524.288"]]]
    ~zod/try=> (wash [0 80] >(bex 20) (bex 19)<)  :: at 80 cols
    <<"[1.048.576 524.288]">>
    ~zod/try=> (wash [0 15] >(bex 20) (bex 19)<)  :: at 15 cols (two lines)
    <<"[ 1.048.576" "  524.288" "]">>

    ~zod/try=> [(bex 150) (bex 151)]  :: at 80 cols
    [ 1.427.247.692.705.959.881.058.285.969.449.495.136.382.746.624
      2.854.495.385.411.919.762.116.571.938.898.990.272.765.493.248
    ]



***
