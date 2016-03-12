### `++toon`

Nock computation result

Either success (`%0`), a block with list of requests blocked on (`%1`), or
failure with stack trace (`%2`).

Source
------

        ++  toon  $%  [%0 p=*]                                  ::  success

Examples
--------
    ~zod/try=> (mock [[20 21] 0 3] ,~)
    [%0 p=21]

    ~zod/try=> (mock [[0] !=(.^(cy//=main/1))] ,~)
    [%1 p=~[[31.075 1.685.027.454 1.852.399.981 49 0]]]
    ~zod/try=> (path [31.075 1.685.027.454 1.852.399.981 49 0])
    /cy/~zod/main/1

    ~zod/try=> (mock [[1 2] !=(!:(+(.)))] ,~)
    [%2 p=~[[%leaf p="/~zod/try/~2014.9.23..18.34.32..d3c5/:<[1 20].[1 24]>"]]]



***
