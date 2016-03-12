### `++welp`

Perfect weld

Concatenate two [`++list`]()s `a` and `b` without losing their type information
to homogenization.

Accepts
-------

`a` is a list.

`b` is a list.

Produces
--------

A list.

Source
------

    ++  welp                                                ::  perfect weld
      =|  [* *]
      |%
      +-  $
        ?~  +<-
          +<-(. +<+)
        +<-(+ $(+<- +<->))
      --

Examples
--------

    ~zod/try=> (welp "foo" "bar")
    "foobar"
    ~zod/arvo=/hoon/hoon> (welp ~[60 61 62] ~[%a %b %c])
    [60 61 62 %a %b %c ~]
    ~zod/arvo=/hoon/hoon> :type; (welp ~[60 61 62] ~[%a %b %c])
    [60 61 62 %a %b %c ~]
    [@ud @ud @ud %a %b %c %~]
    ~zod/arvo=/hoon/hoon> (welp [sa/1 so/2 ~] si/3)
    [[%sa 1] [%so 2] %si 3]



***
