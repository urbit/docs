### `++ifix`

Infix

Parser modifier: surround with pair of `++rule`s, the output of which is
discarded.

Accepts
-------

`fel` is a pair of `++rule`s.

`hof` is a `++rule`.

Produces
--------

A `++rule`.

Source
------

    ++  ifix
      |*  {fel/{rule rule} hof/rule}
      ~!  +<
      ~!  +<:-.fel
      ~!  +<:+.fel
      ;~(pfix -.fel ;~(sfix hof +.fel))
    ::

Examples
--------
    
    ~zod/try=> (scan "-40-" (ifix [hep hep] dem))
    q=40
    ~zod/try=> (scan "4my4" (ifix [dit dit] (star alf)))
    "my"



***
