### `++mack`

Nock subject to unit

Accepts a nock subject-formula cell and wraps it into a [`++unit`]().
`fol` is pure nock, meaning that nock `11` operations result in a block,
producing a `~`.

Accepts
-------

`sub` is a subject [noun]().

`fol` is a formula noun, which is generally a `++nock`.

Produces
--------

The `++unit` of a noun.

Source
------

    ++  mack
      |=  [sub=* fol=*]
      ^-  (unit)
      =+  ton=(mink [sub fol] |=(* ~))
      ?.(?=([0 *] ton) ~ [~ p.ton])
    ::

Examples
--------

    ~zod/try=> (mack [[1 2 3] [0 1]])
    [~ [1 2 3]]
    ~zod/try=> (mack [41 4 0 1])
    [~ 42]
    ~zod/try=> (mack [4 0 4])
    ~
    ~zod/try=> (mack [[[0 2] [1 3]] 4 4 4 4 0 5])
    [~ 6]
    ~zod/try=> ;;((unit ,@tas) (mack [[1 %yes %no] 6 [0 2] [0 6] 0 7]))
    [~ %no]


