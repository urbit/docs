### `++rub`

Length-decode

The inverse of `++mat`. Accepts a cell of index `a` and a bitstring `b`
and produces the cell whose tail `q` is the decoded atom at index `a`
and whose head is the length of the encoded atom `q`, by which the
offset `a` is advanced. Only used internally as a helper cue.

Accepts
-------

`a` is an atom.

`b` is a bitstring as an atom.

Produces
--------

A cell of two atoms, `p` and `q`.

Source
------

    ++  rub                                                 ::  length-decode
      ~/  %rub
      |=  [a=@ b=@]
      ^-  [p=@ q=@]
      =+  ^=  c
          =+  [c=0 m=(met 0 b)]
          |-  ?<  (gth c m)
          ?.  =(0 (cut 0 [(add a c) 1] b))
            c
          $(c +(c))
      ?:  =(0 c)
        [1 0]
      =+  d=(add a +(c))
      =+  e=(add (bex (dec c)) (cut 0 [d (dec c)] b))
      [(add (add c c) e) (cut 0 [(add d (dec c)) e] b)]


Examples
--------

    ~zod/try=> `@ub`(jam 0xaaa)
    0b1.0101.0101.0101.0010.0000
    ~zod/try=> (rub 1 0b1.0101.0101.0101.0010.0000)
    [p=20 q=2.730]
    ~zod/try=> `@ux`q:(rub 1 0b1.0101.0101.0101.0010.0000)
    0xaaa

***
