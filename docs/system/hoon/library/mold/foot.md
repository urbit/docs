### `++foot`

Cases of arms by variance model.

`%ash` arms are [`dry`]() and [geometric]().

Source
------

    ++  foot  $%  [%ash p=twig]                             ::  dry arm, geometric
                  [%elm p=twig]                             ::  wet arm, generic
                  [%oak ~]                                  ::  XX not used
                  [%yew p=(map term foot)]                  ::  XX not used
              ==                                            ::

Examples
--------

See also: [`++ap`](), [`++ut`]()

     ~zod/try=> *foot
    [%yew p={}]

    ~zod/try=> (ream '|%  ++  $  foo  --')
    [%brcn p={[p=%$ q=[%ash p=[%cnzz p=~[%foo]]]]}]
    ~zod/try=> +<+:(ream '|%  ++  $  foo  --')
    t=~[%ash %cnzz %foo]
    ~zod/try=> (foot +<+:(ream '|%  ++  $  foo  --'))
    [%ash p=[%cnzz p=~[%foo]]]
    ~zod/try=> (foot +<+:(ream '|%  +-  $  foo  --'))
    [%elm p=[%cnzz p=~[%foo]]]
