### `++calf`

Cyclical backreferences

Encodes cyclical backreferences in types. Used in pretty printing.

Source
------

       ++  calf  ,[p=(map ,@ud wine) q=wine]                   ::

Examples
--------

    ~zod/try=> `calf`[~ %atom %ta]
    [p={} q=[%atom p=%ta]]

    ~zod/try=> `calf`~(dole ut p:!>(*^))
    [p={} q=[%plot p=~[%noun %noun]]]

    ~zod/try=> `calf`~(dole ut p:!>($:|-(?(~ [* $]))))
    [ p={[p=1 q=[%pick p=~[[%pear p=%n q=0] [%plot p=~[%noun [%stop p=1]]]]]]}
      q=[%stop p=1]
    ]


