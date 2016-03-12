### `++wonk`

XX Not a model?

Pull result out of a `++edge`, or crash if there's no result.

Source
------

        ++  wonk  |*(veq=edge ?~(q.veq !! p.u.q.veq))           ::

Examples
--------

See also: [`++edge`]()

    ~zod/try=> (wide:vast [1 1] "(add 2 2)")
    [ p=[p=1 q=10]
        q
      [ ~
        [ p=[%cnhp p=[%cnzz p=~[%add]] q=~[[%dtzy p=%ud q=2] [%dtzy p=%ud q=2]]]
          q=[p=[p=1 q=10] q=""]
        ]
      ]
    ]
    ~zod/try=> (wonk (wide:vast [1 1] "(add 2 2)"))
    [%cnhp p=[%cnzz p=~[%add]] q=~[[%dtzy p=%ud q=2] [%dtzy p=%ud q=2]]]


