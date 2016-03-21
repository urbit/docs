### `++bass`

Parser modifier: LSB
ordered `++list` as atom of a `++base`.

Accepts
-------

`wuc` is an atom.

`tyd` is a `++rule`.

Produces
--------

A `++rule`.

Source
------

    ++  bass
      |*  {wuc/@ tyd/rule}
      %+  cook
        |=  waq/(list @)
        %+  roll
          waq
        =|({p/@ q/@} |.((add p (mul wuc q))))
      tyd
    ::


Examples
--------
    
    ~zod/try=> (scan "123" (bass 10 (star dit)))
    q=123
    ~zod/try=> (scan "123" (bass 8 (star dit)))
    q=83
    ~zod/try=> `@ub`(scan "123" (bass 8 (star dit)))
    0b101.0011



***
