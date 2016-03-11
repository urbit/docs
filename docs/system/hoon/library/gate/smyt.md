### `++smyt`

Render path as tank

Renders the path `bon` as a [`tank`](), which is used for
pretty-printing.

Accepts
-------

Produces
--------

`bon` is a [`++path`]().

Source
------

    ++  smyt
      |=  bon=path  ^-  tank
      :+  %rose  [['/' ~] ['/' ~] ['/' ~]]
      |-  ^-  (list tank)
      (turn bon |=(a=@ [%leaf (rip 3 a)]))

Examples
--------

    ~zod/try=> (smyt %)
    [ %rose
      p=[p="/" q="/" r="/"]
        q
      ~[ [%leaf p="~zod"]
         [%leaf p="try"] 
         [%leaf p="~2014.10.28..18.36.58..a280"]
       ]
    ]
    ~zod/try=> (smyt /as/les/top)
    [ %rose
      p=[p="/" q="/" r="/"]
      q=~[[%leaf p="as"] [%leaf p="les"] [%leaf p="top"]]
    ]


