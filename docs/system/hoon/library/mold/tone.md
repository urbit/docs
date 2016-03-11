### `++tone`

Intermediate Nock computation result

Similar to [`++toon`](), but stack trace is not yet rendered.

Source
------

        ++  tone  $%  [%0 p=*]                                  ::  success

Examples
--------

    ~zod/try=> (mink [[20 21] 0 3] ,~)
    [%0 p=21]

    ~zod/try=> (mink [[0] !=(.^(cy//=main/1))] ,~)
    [%1 p=~[[31.075 1.685.027.454 1.852.399.981 49 0]]]
    ~zod/try=> (path [31.075 1.685.027.454 1.852.399.981 49 0])
    /cy/~zod/main/1

    ~zod/try=> (mink [[1 2] !=(~|(%hi +(.)))] ,~)
    [%2 p=~[[~.yelp 26.984]]]
    ~zod/try=> (mink [[1 2] !=(!:(+(.)))] ,~)
    [ %2
        p
      ~[
        [ ~.spot
          [ [ 1.685.027.454
              7.959.156
              \/159.445.990.350.374.058.574.398.238.344.143.957.205.628.479.572.65\/
                8.112.403.878.526
              \/                                                                  \/
              0
            ]
            [1 20]
            1
            24
          ]
        ]
      ]
    ]


