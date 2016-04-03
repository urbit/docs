### `++mute`

Untyped virtual

Kicks a `++trap`, producing its result as a noun or the tanks of any
error that occurs. Similar to `++mule`, but preserves no type
information.

Accepts
-------

`taq` is a `++trap`.
Produces
--------

Either a noun or a `++list` of `++tank`.

Source
------

    ++  mute                                                ::  untyped virtual
      |=  taq/_^?(|.(**))
      ^-  (each * (list tank))
      =+  ton=(mock [taq 9 2 0 1] |=({* *} ~))
      ?-  -.ton
        $0  [%& p.ton]
        $1  [%| (turn p.ton |=(a/* (smyt (path a))))]
        $2  [%| p.ton]
      ==


Examples
--------

    ~zod/try=>  (mute |.(leaf/"hello"))
    [%.y p=[1.717.658.988 104 101 108 108 111 0]]
    ~zod/try=> (mute |.(!!))
    [%.n p=~]


***
