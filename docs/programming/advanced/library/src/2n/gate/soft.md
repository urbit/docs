### `++soft`

Politely requests a specific type to be produced, producing null if it
is not.

Source
------

    ++  soft                                                ::  maybe coerce to span
      |*  han/$-(* *)
      |=  fud/*  ^-  (unit han)
      =+  gol=(han fud)
      ?.(=(gol fud) ~ [~ gol])
    ::

Examples
--------

    ~zod/try=> ((soft %4) (add 2 2))
    [~ %4]
    ~zod/try=> ((soft @) (add 2 2))
    [~ 4]
    ~zod/try=> ((soft %5) (add 2 2))
    ~
    ~zod/try=> ((soft @t) (crip "Tape to cord, Woohoo!"))
    [~ 'Tape to cord, Woohoo!']
    ~zod/try=> ((soft @t) (trip 'Cmon man... Tape to cord? Please?!'))
    ~



***
