### `++mu`

Core used to scramble 16-bit atoms

A door that contains arms that are used to scramble two atoms, `top`
and `bot`. Used especially in the phonetic base to disguise the
relationship between a destroyer and its cruiser.

Accepts
-------

Produces
--------

`bot` is an atom.

`top` is an atom.

Source
------

    ++  mu
      |_  [top/@ bot/@]

Examples
--------

    ~zod/try=> ~(. mu 0x20e5 0x5901)
    <3.sjm [[@ux @ux] <414.hhh 100.xkc 1.ypj %164>]>

------------------------------------------------------------------------

### `++zag`

Add bottom into top

Produces the cell of `top` and `bot` with `top` scrambled to the result
of adding `bot` to `top` modulo 16. Used to scramble the name of a
destroyer.

Accepts
-------

Produces
--------

`bot` is an atom.

`top` is an atom.

Source
------

      ++  zag  [p=(end 4 1 (add top bot)) q=bot]


Examples
--------

    ~zod/try=> `[@ux @ux]`~(zag mu 0x20e0 0x201)
    [0x22e1 0x201]

------------------------------------------------------------------------

### `++zig`

Subtract bottom from top

The inverse of `++zag`. Produces the cell of `top` and `bot` with
`top` unscrambled. The unscrambled `top` is the sum of the sample `top`
and the 16-bit complement of `bot`. Used to unscramble the name of the
destroyer.

Accepts
-------

Produces
--------

`bot` is an atom.

`top` is an atom.

Source
------

      ++  zig  [p=(end 4 1 (add top (sub 0x1.0000 bot))) q=bot]

Examples
--------

    ~zod/try=> `[@ux @ux]`~(zig mu 0x2f46 0x1042)
    [0x1f04 0x1042]

------------------------------------------------------------------------

### `++zug`

Concatenate into atom

Produces the concatenation of `top` and `bot`. Used to assemble a
destroyer name.

Accepts
-------

Produces
--------

`bot` is an atom.

`top` is an atom.

Source
------

      ++  zug  (mix (lsh 4 1 top) bot)

Examples
--------

    ~zod/try=> `@ux`~(zug mu 0x10e1 0xfa)
    0x10e1.00fa



***
