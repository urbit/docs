### `++zing`

Cons

Turns a [`++list`]() of lists into a single list by promoting the elements of
each sublist into the higher.

Accepts
-------

A list of lists.

Produces
--------

A list.

Source
------

    ++  zing                                                ::  promote
      =|  *
      |%
      +-  $
        ?~  +<
          +<
        (welp +<- $(+< +<+))
      --

Examples
--------

    ~zod/try=> (zing (limo [(limo ['a' 'b' 'c' ~]) (limo ['e' 'f' 'g' ~]) (limo ['h' 'i' 'j' ~]) ~]))
    ~['a' 'b' 'c' 'e' 'f' 'g' 'h' 'i' 'j']
    ~zod/try=> (zing (limo [(limo [1 'a' 2 'b' ~]) (limo [3 'c' 4 'd' ~]) ~]))
    ~[1 97 2 98 3 99 4 100]

