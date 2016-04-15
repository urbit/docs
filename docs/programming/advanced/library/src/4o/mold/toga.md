### `++toga`

Tree of faces

A [face](), or tree of faces. A `++toga` is applied to anything assigned
using [`^=`]().

XX move to `++ut` and rune doc (for \^= examples)

Source
------

        ++  toga                                                ::  face control
                  [2 p=toga q=toga]                         ::  cell toga
              ==                                            ::

Examples
--------

    ~zod/try=> a=1
    a=1
    ~zod/try=> (ream 'a=1')
    [%ktts p=p=%a q=[%dtzy p=%ud q=1]]
    ~zod/try=> [a b]=[1 2 3]
    [a=1 b=[2 3]]
    ~zod/try=> (ream '[a b]=[1 2 3]')
    [ %ktts
      p=[%2 p=p=%a q=p=%b]
      q=[%cltr p=~[[%dtzy p=%ud q=1] [%dtzy p=%ud q=2] [%dtzy p=%ud q=3]]]
    ]

    ~zod/try=> [a ~]=[1 2 3]
    [a=1 2 3]
    ~zod/try=> (ream '[a ~]=[1 2 3]')
    [ %ktts
      p=[%2 p=p=%a q=[%0 ~]]
      q=[%cltr p=~[[%dtzy p=%ud q=1] [%dtzy p=%ud q=2] [%dtzy p=%ud q=3]]]
    ]



***
