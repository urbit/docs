### `++mule`

Typed virtual

Kicks a `++trap`, producing its results or any errors that occur along
the way. Used to lazily compute stack traces.

Accepts
-------

`taq` is a `++trap`, generally producing a list of `++tank`s.

Produces
--------

XX

Source
------

    ++  mule                                                ::  typed virtual
      ~/  %mule
      |*  taq/_|.(**)
      =+  mud=(mute taq)
      ?-  -.mud
        $&  [%& p=$:taq]                                    ::  XX transition
        $|  [%| p=p.mud]
      ==
    ::


Examples
--------

    ~zod/try=> (mule |.(leaf/"hello"))
    [%.y p=[%leaf "hello"]]
    ~zod/try=> (mule |.(!!))
    [%.n p=~]
    ~zod/try=> (mule |.(.^(a//=pals/1)))
    [ %.n
        p
      ~[
        [ %rose
          p=[p="/" q="/" r="/"]
            q
          [ i=[%leaf p="a"] 
            t=[i=[%leaf p="~zod"] t=[i=[%leaf p="pals"] t=[i=[%leaf p="1"] t=~]]]
          ]
        ]
      ]
    ]



***
