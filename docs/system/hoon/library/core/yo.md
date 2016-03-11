### `++yo`

    ++  yo                                                  ::  time constants core
      
Useful constants for interacting with earth time.

### `++cet`

Days in a century. Derived by multiplying the number of days in a year
(365) by the number of years in a century (100), then adding the number
days from leap years in a century (24).

Produces
--------

An [atom]().

Source
------

      |%  ++  cet  36.524                 ::  (add 24 (mul 100 365))

Examples
--------

    ~zod/try=> cet:yo
    36.524
    ~zod/try=> (add 365 cet:yo)
    36.889
    ~zod/try=> (sub (add 24 (mul 100 365)) cet:yo)
    0

------------------------------------------------------------------------

### `++day`

Number of seconds in a day.

Produces
--------

An [atom]().

Source
------

          ++  day  86.400                 ::  (mul 24 hor)

Examples
--------

    ~zod/try=> day:yo
    86.400
    ~zod/try=> (add 60 day:yo)
    86.460

------------------------------------------------------------------------

### `++era`

XX Revisit

Produces
--------

An [atom]().

Source
------

          ++  era  146.097                ::  (add 1 (mul 4 cet))

Examples
--------


------------------------------------------------------------------------

### `++hor`

Seconds in hour

The number of seconds in an hour. Derived by multiplying the number of
seconds in a minute by the minutes in an hour.

Produces
--------

An [atom]().

Source
------

          ++  hor  3.600                  ::  (mul 60 mit)

Examples
--------

    ~zod/try=> hor:yo
    3.600
    ~zod/try=> (div hor:yo 60)
    60

------------------------------------------------------------------------

### `++jes`

XX Revisit

Produces
--------

An atom.

Source
------

          ++  jes  106.751.991.084.417    ::  (mul 730.692.561 era)

Examples
--------

    ~zod/try=> jes:yo
    106.751.991.084.417

------------------------------------------------------------------------

### `++mit`

Seconds in minute

The number of seconds in a minute.

Produces
--------

An [atom]().

Source
------

          ++  mit  60

Examples
--------

    ~zod/try=> mit:yo
    60

------------------------------------------------------------------------

### `++moh`

Days in month

The days in each month of the Gregorian common year. A list of unsigned
decimal atoms (Either 28, 30, or 31) denoting the number of days in the
month at the year at that index.

Produces
--------

A [`++list`]() of [`@ud`]()

Source
------

          ++  moh  `(list ,@ud)`[31 28 31 30 31 30 31 31 30 31 30 31 ~]

Examples
--------

    ~zod/try=> moh:yo
    ~[31 28 31 30 31 30 31 31 30 31 30 31]
    ~zod/try=> (snag 4 moh:yo)
    31

------------------------------------------------------------------------

### `++moy`

Moh with leapyear

The days in each month of the Gregorian leap-year. A list of unsigned
decimal atoms (Either 29,30, or 31) denoting the number of days in the
month at the leap-year at that index.

Examples
--------

A [`++list`]() of [`@ud`]()

Source
------

          ++  moy  `(list ,@ud)`[31 29 31 30 31 30 31 31 30 31 30 31 ~]

Examples
--------

    ~zod/try=> moy:yo
    ~[31 29 31 30 31 30 31 31 30 31 30 31]
    ~zod/try=> (snag 1 moy:yo)
    29

------------------------------------------------------------------------

### `++qad`

Seconds in 4 years

The number of seconds in four years. Derived by adding one second to the
number of seconds in four years.

Produces
--------

An [atom]().

Source
------

          ++  qad  126.144.001            ::  (add 1 (mul 4 yer))

Examples
--------

    ~zod/try=> qad:yo
    126.144.001

------------------------------------------------------------------------

### `++yer`

Seconds in year

The number of seconds in a year. Derived by multiplying the number of
seconds in a day by 365.

Produces
--------

An [atom]().

Source
------

          ++  yer  31.536.000             ::  (mul 365 day)

Examples
--------

    ~zod/try=> yer:yo
    31.536.000


