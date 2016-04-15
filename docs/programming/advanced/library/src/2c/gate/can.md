
### `++can`

Assemble

Produces an atom from a list `b` of length-value pairs `p` and `q`,
where `p` is the length in bloqs of size `a`, and `q` is an atomic
value.

Accepts
-------

`a` is a block size (see `++bloq`).

`b` is a `++list` of length value pairs, `p` and `q`.

Produces
--------

An atom.

Source
------

    ++  can                                                 ::  assemble
      ~/  %can
      |=  [a/bloq b/(list [p=@ q=@])]
      ^-  @
      ?~  b  0
      (mix (end a p.i.b q.i.b) (lsh a p.i.b $(b t.b)))

Examples
--------

    ~zod/try=> `@ub`(can 3 ~[[1 1]])
    0b1 
    ~zod/try=> `@ub`(can 0 ~[[1 255]])
    0b1
    ~zod/try=> `@ux`(can 3 [3 0xc1] [1 0xa] ~)
    0xa00.00c1
    ~zod/try=> `@ux`(can 3 [3 0xc1] [1 0xa] [1 0x23] ~)
    0x23.0a00.00c1
    ~zod/try=> `@ux`(can 4 [3 0xc1] [1 0xa] [1 0x23] ~)
    0x23.000a.0000.0000.00c1
    ~zod/try=> `@ux`(can 3 ~[[1 'a'] [2 'bc']])
    0x63.6261


***
