### `++aor`

Alphabetic order

Computes whether `a` and `b` are in alphabetical order, producing a
boolean.

Accepts
-------

`a` is a [noun]().

`b` is a noun.

Produces
--------

A boolean atom.


Source
------

    ++  aor                                                 ::  alphabetic-order
      ~/  %aor
      |=  [a=* b=*]
      ^-  ?
      ?:  =(a b)  &
      ?.  ?=(@ a)
        ?:  ?=(@ b)  |
        ?:  =(-.a -.b)
          $(a +.a, b +.b)
        $(a -.a, b -.b)
      ?.  ?=(@ b)  &
      |-
      =+  [c=(end 3 1 a) d=(end 3 1 b)]
      ?:  =(c d)
        $(a (rsh 3 1 a), b (rsh 3 1 b))
      (lth c d)

Examples
--------

    ~zod/try=> (aor 'a' 'b')
    %.y
    ~zod/try=> (aor 'b' 'a')
    %.n
    ~zod/try=> (aor "foo" "bar")
    %.n
    ~zod/try=> (aor "bar" "foo")
    %.y
    ~zod/try=> (aor "abcdefz" "abcdefa")
    %.n
    ~zod/try=> (aor "abcdefa" "abcdefz")
    %.y
    ~zod/try=> (aor 10.000 17.000)
    %.y
    ~zod/try=> (aor 10 9)
    %.n


