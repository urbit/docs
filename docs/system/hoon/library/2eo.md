2eO virtualization
==================

------------------------------------------------------------------------

------------------------------------------------------------------------

------------------------------------------------------------------------

------------------------------------------------------------------------

------------------------------------------------------------------------

------------------------------------------------------------------------

### `++mung`

Virtualize slamming gate

Produces a [`++tone`]() computation result from slamming `gat` with
`sam`, using `sky` to compute or block on nock 11 when applicable.

Accepts
-------

`gat` is a [noun]() that is generally a [`gate`]().

`sam` is a [`sample`]() noun.

`sky` is an [%iron]() gate invoked with [nock operator 11]().

Produces
--------

A `++tone`.

Source
------

    ++  mung
      |=  [[gat=* sam=*] sky=$+(* (unit))]
      ^-  tone
      ?.  &(?=(^ gat) ?=(^ +.gat))
        [%2 ~]
      (mink [[-.gat [sam +>.gat]] -.gat] sky)
    ::

Examples
--------

    ~zod/try=> (mung [|=(@ 20) ~] ,~)
    [%0 p=20]
    ~zod/try=> (mung [|=(@ !!) ~] ,~)
    [%2 p=~]
    ~zod/try=> (mung [|=(a=@ (add 20 a)) ~] ,~)
    [%0 p=20]
    ~zod/try=> (mung [|=(a=[@ @] (add 20 -.a)) ~] ,~)
    [%2 p=~]
    ~zod/try=> (mung [|=(a=[@ @] (add 20 -.a)) [4 6]] ,~)
    [%0 p=24]
    ~zod/try=> (mung [|=(a=@ .^(a)) ~] ,~)
    [%1 p=~[0]]
    ~zod/try=> (mung [|=(a=@ .^(a)) ~] ,[~ %42])
    [%0 p=42]
    ~zod/try=> (mung [|=(a=@ .^(a)) ~] |=(a=* [~ a 6]))
    [%0 p=[0 6]]
    ~zod/try=> (mung [|=(a=@ .^(a)) 8] |=(a=* [~ a 6]))
    [%0 p=[8 6]]

------------------------------------------------------------------------

### `++mule`

Typed virtual

Kicks a [`++trap`](), producing its results or any errors that occur along
the way. Used to lazily compute stack traces.

Accepts
-------

`taq` is a [`++trap`](), generally producing a list of [`++tank`]()s.

Produces
--------

XX

Source
------

    ++  mule                                                ::  typed virtual
      ~/  %mule
      |*  taq=_|.(_*)
      =+  mud=(mute taq)
      ?-  -.mud
        &  [%& p=$:taq]
        |  [%| p=p.mud]
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

------------------------------------------------------------------------

### `++mute`

Untyped virtual

Kicks a `++trap`, producing its result as a noun or the tanks of any
error that occurs. Similar to [`++mule`](), but preserves no type
information.

Accepts
-------

`taq` is a [`++trap`](/doc/hoon/library/1#++trap).

Produces
--------

Either a noun or a [`++list`]() of [`++tank`]().

Source
------

    ++  mute                                                ::  untyped virtual
      |=  taq=_^?(|.(_*))
      ^-  (each ,* (list tank))
      =+  ton=(mock [taq 9 2 0 1] |=(* ~))
      ?-  -.ton
        %0  [%& p.ton]
        %1  [%| (turn p.ton |=(a=* (smyt (path a))))]
        %2  [%| p.ton]
      ==

Examples
--------

    ~zod/try=>  (mute |.(leaf/"hello"))
    [%.y p=[1.717.658.988 104 101 108 108 111 0]]
    ~zod/try=> (mute |.(!!))
    [%.n p=~]
    ~zod/try=> (mute |.(.^(a//=pals/1)))
    [ %.n
        p
      ~[
        [ %rose
          p=[p="/" q="/" r="/"]
          q=[i=[%leaf p="a"] t=[i=[%leaf p="~zod"] t=[i=[%leaf p="pals"] t=[i=[%leaf p="1"] t=~]]]]
        ]
      ]
    ]

------------------------------------------------------------------------
