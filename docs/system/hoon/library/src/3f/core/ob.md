### `++ob`

Reversible scrambling core, v2

    ++  ob
      |%

A core for performing reversible scrambling operations for the `@p` phonetic base.

------------------------------------------------------------------------

### `++feen`

Conceal structure, v2

Randomly permutes atoms that fit into 17 to 32 bits into one another. If the
atom fits into 33 to 64 bits, does the same permutation on the low 32 bits
only. Otherwise, passes the atom through unchanged.

Accepts
-------

An atom.

Produces
--------

An atom.

Source
------

    ++  feen                                              ::  conceal structure v2
      |=  pyn=@  ^-  @
      ?:  &((gte pyn 0x1.0000) (lte pyn 0xffff.ffff))
        (add 0x1.0000 (fice (sub pyn 0x1.0000)))
      ?:  &((gte pyn 0x1.0000.0000) (lte pyn 0xffff.ffff.ffff.ffff))
        =+  lo=(dis pyn 0xffff.ffff)
        =+  hi=(dis pyn 0xffff.ffff.0000.0000)
        %+  con  hi
        (add 0x1.0000 (fice (sub lo 0x1.0000)))
      pyn

Examples
--------


------------------------------------------------------------------------

### `++fend`

XX

Randomly permutes atoms that fit into 17 to 32 bits into one another, and
randomly permutes the low 32 bits of atoms that fit into 33 to 64 bits;
otherwise, passes the atom through unchanged. The permutation is the inverse of
the one applied by [`++feen`]().

Accepts
-------

An atom.

Produces
--------

An atom.

Source
------

    ++  fend                                              ::  restore structure v2
      |=  cry=@  ^-  @
      ?:  &((gte cry 0x1.0000) (lte cry 0xffff.ffff))
        (add 0x1.0000 (teil (sub cry 0x1.0000)))
      ?:  &((gte cry 0x1.0000.0000) (lte cry 0xffff.ffff.ffff.ffff))
        =+  lo=(dis cry 0xffff.ffff)
        =+  hi=(dis cry 0xffff.ffff.0000.0000)
        %+  con  hi
        (add 0x1.0000 (teil (sub lo 0x1.0000)))
      cry

Examples
--------

------------------------------------------------------------------------

### `++fice`

XX

Applies a 3-round Feistel-like cipher to randomly permute atoms in the range `0` to `2^32 - 2^16`. The construction given in Black and Rogaway is ideal for a domain with a size of that form, and as with a conventionel Feistel cipher, three rounds suffice to make the permutation pseudorandom.

Accepts
-------

An atom.

Produces
--------

An atom.

Source
------

    ++  fice                                              ::  adapted from
      |=  nor=@                                           ::  black and rogaway
      ^-  @                                               ::  "ciphers with
      =+  ^=  sel                                         ::   arbitrary finite
      %+  rynd  2                                         ::   domains", 2002
      %+  rynd  1
      %+  rynd  0
      [(mod nor 65.535) (div nor 65.535)]
      (add (mul 65.535 -.sel) +.sel)

Examples
--------

------------------------------------------------------------------------

### `++teil`

XX

Applies the reverse of the Feistel-like cipher applied by [`++fice`](). Unlike
a conventional Feistel cipher that is its own inverse if keys are used in
reverse order, this Feistel-like cipher uses two moduli that must be swapped
when applying the reverse transformation.

Accepts
-------

An atom.

Produces
--------

An atom.

Source
------

    ++  teil                                              ::  reverse ++fice
      |=  vip=@
      ^-  @
      =+  ^=  sel
      %+  rund  0
      %+  rund  1
      %+  rund  2
      [(mod vip 65.535) (div vip 65.535)]
      (add (mul 65.535 -.sel) +.sel)

Examples
--------

------------------------------------------------------------------------

### `++rynd`

XX

A single round of the Feistel-like cipher [`++fice`](). AES ([`++aesc`]()) is
used as the round function.

Accepts
-------

A cell of three atoms, `n`, `l`, and `r`.

Produces
--------

A cell of two atoms.

Source
------

    ++  rynd                                              ::  feistel round
      |=  [n=@ l=@ r=@]
      ^-  [@ @]
      :-  r
      ?~  (mod n 2)
        (~(sum fo 65.535) l (en:aesc (snag n raku) r))
      (~(sum fo 65.536) l (en:aesc (snag n raku) r))

Examples
--------

------------------------------------------------------------------------

### `++rund`

XX

A single round of the Feistel-like reverse cipher [`++teil`]().

Accepts
-------

A cell of three atoms, `n`, `l`, and `r`.

Produces
--------

A cell of two atoms.

Source
------

    ++  rund                                              ::  reverse round
      |=  [n=@ l=@ r=@]
      ^-  [@ @]
      :-  r
      ?~  (mod n 2)
        (~(dif fo 65.535) l (en:aesc (snag n raku) r))
      (~(dif fo 65.536) l (en:aesc (snag n raku) r))

Examples
--------

------------------------------------------------------------------------

### `++raku`

XX


Accepts
-------

A list of atoms of [odor]() [`@ux`]() (hexadecimal).

Produces
--------

Arbitrary keys for use with [`++aesc`]().

Source
------

    ++  raku
      ^-  (list ,@ux)
      :~  0x15f6.25e3.083a.eb3e.7a55.d4db.fb99.32a3.
            43af.2750.219e.8a24.e5f8.fac3.6c36.f968
          0xf2ff.24fe.54d0.1abd.4b2a.d8aa.4402.8e88.
            e82f.19ec.948d.b1bb.ed2e.f791.83a3.8133
          0xa3d8.6a7b.400e.9e91.187d.91a7.6942.f34a.
            6f5f.ab8e.88b9.c089.b2dc.95a6.aed5.e3a4
      ==

Examples
--------



***
