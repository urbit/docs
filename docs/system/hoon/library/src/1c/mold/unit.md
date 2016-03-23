### `++unit`

Maybe

mold generator. A `++unit` is either `~` or `[~ u=a]` where `a` is the
type that was passed in.


Source
------

    ++  unit  |*  a/$-(* *)                                 ::  maybe
              $@($~ {$~ u/a})                               ::


Examples
--------

See also: `++bind`

    ~zod/try=> ? *(unit time)
    ?({$~ u/@da} $~)
    ~

     ~zod/try=> > =a |=  a/@
      ^-  (unit @)
      ?~  a  ~
      [~ a]
    > (a 2)
    [~ u=2]


***
