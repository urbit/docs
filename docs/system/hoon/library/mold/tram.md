### `++tram`

List of changes

List of changes by location in context. When using [`%=`](), for example,
the list of changes is a `++tram`.

Source
------

        ++  tram  (list ,[p=wing q=twig])                       ::

Examples
--------

    ~zod/try=> (ream '$(a 1, b 2)')
    [ %cnts
      p=~[%$]
      q=~[[p=~[%a] q=[%dtzy p=%ud q=1]] [p=~[%b] q=[%dtzy p=%ud q=2]]]
    ]
    ~zod/try=> (tram +:(ream '$(a 1, b 2)'))
    ~[[p=~ q=[% p=0]] [p=~[%a] q=[%dtzy p=%ud q=1]] [p=~[%b] q=[%dtzy p=%ud q=2]]]


