### `++snag`

Index

Accepts an atom `a` and a `++list` `b`, producing the element at the index
of `a`and failing if the list is null. Lists are 0-indexed.

Accepts
-------

`b` is a list.

Produces
--------

Produces an element of `b`, or crashes if no element exists at that index.

Source
------

    ++  snag                                                ::  index
      ~/  %snag
      |*  {a/@ b/(list)}
      |-
      ?~  b
        ~|('snag-fail' !!)
      ?:  =(0 a)  i.b
      $(b t.b, a (dec a))


Examples
--------

    ~zod/try=> (snag 2 "asdf")
    ~~d
    ~zod/try=> (snag 0 `(list ,@ud)`~[1 2 3 4])
    1



***
