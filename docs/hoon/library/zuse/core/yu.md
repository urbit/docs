---
navhome: /docs/
---


### `++yu`

UTC format constants

Source
------

    ++  yu                                                  ::  UTC format constants
      |%

    ~zod/try=/hom> yu
    <4.pgn 250.tmw 41.cmo 414.rvm 101.jzo 1.ypj %164>

------------------------------------------------------------------------

### `++mon`

Months

Produces a list of [`++tapes`]() containing the 12 months of the year.

Produces
--------

A `++list` of `++tape`s.

Source
------

      ++  mon  ^-  (list tape)
        :~  "January"  "February"  "March"  "April"  "May"  "June"  "July"
            "August"  "September"  "October"  "November"  "December"
        ==
      ::

Examples
--------

    ~zod/try=/hom> mon:yu
    <<
      "January"
      "February"
      "March"
      "April"
      "May"
      "June"
      "July"
      "August"
      "September"
      "October"
      "November"
      "December"
    >>
    ~zod/try=/hom> (snag 1 mon:yu)
    "February"

------------------------------------------------------------------------

### `++wik`

Weeks

Produces a list of [tapes]() containing the 7 days of the week,
beginning with Sunday.

Source
------

      ++  wik  ^-  (list tape)
        :~  "Sunday"  "Monday"  "Tuesday"  "Wednesday"  "Thursday"
            "Friday"  "Saturday"
        ==
      ::

Examples
--------

    ~zod/try=/hom> wik:yu
    <<"Sunday" "Monday" "Tuesday" "Wednesday" "Thursday" "Friday" "Saturday">>
    ~zod/try=/hom> (snag 2 wik:yu)
    "Tuesday"
    ~zod/try=/hom> (snag (daws (yore -<-)) wik:yu)
    "Tuesday"

------------------------------------------------------------------------

### `++les`

Leap second dates

Produces a [`++list`]() of the (absolute) dates ([`@da`]) of the 25 leap seconds.

Produces
--------

A `++list` of atoms of odor `@da`.

Source
------

      ++  les  ^-  (list ,@da)
        :~  ~2015.7.1 ~2012.7.1  ~2009.1.1  ~2006.1.1  ~1999.1.1  ~1997.7.1
            ~1996.1.1  ~1994.7.1  ~1993.7.1  ~1992.7.1  ~1991.1.1  ~1990.1.1
            ~1988.1.1  ~1985.7.1  ~1983.7.1  ~1982.7.1  ~1981.7.1  ~1980.1.1
            ~1979.1.1  ~1978.1.1  ~1977.1.1  ~1976.1.1  ~1975.1.1  ~1974.1.1
            ~1973.1.1 ~1972.7.1
        ==

Examples
--------

    ~zod/try=/hom> les:yu
    ~[
      ~2015.7.1
      ~2012.7.1
      ~2009.1.1
      ~2006.1.1
      ~1999.1.1
      ~1997.7.1
      ~1996.1.1
      ~1994.7.1
      ~1993.7.1
      ~1992.7.1
      ~1991.1.1
      ~1990.1.1
      ~1988.1.1
      ~1985.7.1
      ~1983.7.1
      ~1982.7.1
      ~1981.7.1
      ~1980.1.1
      ~1979.1.1
      ~1978.1.1
      ~1977.1.1
      ~1976.1.1
      ~1975.1.1
      ~1974.1.1
      ~1973.1.1
      ~1972.7.1
    ]
    ~zod/try=/hom> (snag 2 les:yu)
    ~2006.1.1

------------------------------------------------------------------------

### `++lef`

Back-shifted leap second dates

Produces a [`++list`]() of absolute dates ([`@da`]()s) that represent the Urbit
Galactc Time equivalents of the UTC leap second dates in [`++les`](/docs/hoon/library/3bc#++les).

Produces
--------

A `++list` of atoms of odor `@da`.

Source
------

      ++  lef  ^-  (list ,@da)
        :~  ~2015.6.30..23.59.59   ~2012.6.30..23.59.59
            ~2008.12.31..23.59.58  ~2005.12.31..23.59.57
            ~1998.12.31..23.59.56  ~1997.6.30..23.59.55
            ~1995.12.31..23.59.54  ~1994.6.30..23.59.53
            ~1993.6.30..23.59.52   ~1992.6.30..23.59.51
            ~1990.12.31..23.59.50  ~1989.12.31..23.59.49
            ~1987.12.31..23.59.48  ~1985.6.30..23.59.47
            ~1983.6.30..23.59.46   ~1982.6.30..23.59.45
            ~1981.6.30..23.59.44   ~1979.12.31..23.59.43
            ~1978.12.31..23.59.42  ~1977.12.31..23.59.41
            ~1976.12.31..23.59.40  ~1975.12.31..23.59.39
            ~1974.12.31..23.59.38  ~1973.12.31..23.59.37
            ~1972.12.31..23.59.36  ~1972.6.30..23.59.35
        ==
    ::

Examples
--------

    ~zod/try=/hom> lef:yu
    ~[
      ~2015.6.30..23.59.59
      ~2012.6.30..23.59.59
      ~2008.12.31..23.59.58
      ~2005.12.31..23.59.57
      ~1998.12.31..23.59.56
      ~1997.6.30..23.59.55
      ~1995.12.31..23.59.54
      ~1994.6.30..23.59.53
      ~1993.6.30..23.59.52
      ~1992.6.30..23.59.51
      ~1990.12.31..23.59.50
      ~1989.12.31..23.59.49
      ~1987.12.31..23.59.48
      ~1985.6.30..23.59.47
      ~1983.6.30..23.59.46
      ~1982.6.30..23.59.45
      ~1981.6.30..23.59.44
      ~1979.12.31..23.59.43
      ~1978.12.31..23.59.42
      ~1977.12.31..23.59.41
      ~1976.12.31..23.59.40
      ~1975.12.31..23.59.39
      ~1974.12.31..23.59.38
      ~1973.12.31..23.59.37
      ~1972.12.31..23.59.36
      ~1972.6.30..23.59.35
    ]
    ~zod/try=/hom> (snag 2 lef:yu)
    ~2005.12.31..23.59.57

