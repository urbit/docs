---
navhome: /docs/
---


### `++dawn`

Weekday of Jan 1

Computes which day of the week January 1st falls on for a year `yer`,
producing an atom. Weeks are zero-indexed beginning on Sunday.

Accepts
-------

`yer` is an unsigned decimal, [`@ud`]().

Produces
--------

An atom.

Source
------

    ++  dawn                                                ::  weekday of jan 1
      |=  yer=@ud
      =+  yet=(sub yer 1)
      %-  mod  :_  7
      :(add 1 (mul 5 (mod yet 4)) (mul 4 (mod yet 100)) (mul 6 (mod yet 400)))
    ::

Examples
--------

    ~zod/try=> (dawn 2.015)
    4
    ~zod/try=> (dawn 1)
    1
    ~zod/try=> (dawn 0)
    ! subtract-underflow
    ! exit


