---
navhome: /docs/
---


### `++sifo`

64-bit encode

Encodes an atom to MIME base64, producing a [`++tape`]().

Accepts
-------

`tig` is an atom.

Produces
--------

A `++tape`.

Source
------

    ++  sifo                                                ::  64-bit encode
          |=  tig=@
          ^-  tape
          =+  poc=(~(dif fo 3) 0 (met 3 tig))
          =+  pad=(lsh 3 poc (swap 3 tig))
          =+  ^=  cha
          'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
          =+  ^=  sif
              |-  ^-  tape
              ?~  pad
                ~
              =+  d=(end 0 6 pad)
              [(cut 3 [d 1] cha) $(pad (rsh 0 6 pad))]
          (weld (flop (slag poc sif)) (trip (fil 3 poc '=')))
        ::

Examples
--------

    ~zod/main=> (sifo 'foobar')
    "Zm9vYmFy"
    ~zod/main=> (sifo 1)
    "Q=="
    ~zod/main=> (sifo (shax %hi))
    "j0NDRmSPa5bfid2pAcUXaxCm2Dlh3TwayItZstwyeqQ="


