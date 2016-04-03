### `++spot`

Stack trace line

A `++spot` is what we print after crashing.

Source
------

            ++  spot  {p/path q/pint}                               ::  range in file


Examples
--------

    ~zod/try=> :into /=main=/bin/fail/hoon '!:  !!'
    + /~zod/main/359/bin/fail/hoon
    ~zod/try=> :fail
    ! /~zod/main/~2014.9.22..18.40.56..ef04/bin/fail/:<[1 5].[1 7]>
    ! exit



***
