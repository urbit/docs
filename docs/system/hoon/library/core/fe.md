### `++fe`                                                 ::  modulo bloq

Modulo bloq

Core containing XX

Accepts
-------

`a` is a [`++bloq`]().

Source
------

  |_  a=bloq

### `++dif`

Produces the difference between two [atom]()s in the modular basis
representation.

Accepts
-------

`a` is a [`++bloq`]().

`b` is an atom.

`c` is an atom.

Produces
--------

A [`@s`]()

Source
------

      ++  dif  |=([b=@ c=@] (sit (sub (add out (sit b)) (sit c))))

Examples
--------

    ~zod/try=> (~(dif fe 3) 63 64)
    255
    ~zod/try=> (~(dif fe 3) 5 10)
    251
    ~zod/try=> (~(dif fe 3) 0 1)
    255
    ~zod/try=> (~(dif fe 0) 9 10)
    1
    ~zod/try=> (~(dif fe 0) 9 11)
    0
    ~zod/try=> (~(dif fe 0) 9 12)
    1
    ~zod/try=> (~(dif fe 2) 9 12)
    13
    ~zod/try=> (~(dif fe 2) 63 64)
    15

------------------------------------------------------------------------

### `++inv`

Invert mod field

Inverts the order of the modular field.

Accepts
-------

`b` is a [`++bloq`]().

Produces
--------

An atom.


Source
------

      ++  inv  |=(b=@ (sub (dec out) (sit b)))

Examples
--------

    ~zod/try=> (~(inv fe 3) 255)
    0
    ~zod/try=> (~(inv fe 3) 256)
    255
    ~zod/try=> (~(inv fe 3) 0)
    255
    ~zod/try=> (~(inv fe 3) 1)
    254
    ~zod/try=> (~(inv fe 3) 2)
    253
    ~zod/try=> (~(inv fe 3) 55)
    200

------------------------------------------------------------------------

### `++net`

Reverse bytes

Revereses bytes within block.

Accepts
-------

`b` is a [`++bloq`]().

Produces
--------

An atom.=

Source
------

      ++  net  |=  b=@  ^-  @
               =>  .(b (sit b))
               ?:  (lte a 3)
                 b
               =+  c=(dec a)
               %+  con
                 (lsh c 1 $(a c, b (cut c [0 1] b)))
               $(a c, b (cut c [1 1] b))

Examples
--------

    ~zod/try=> (~(net fe 3) 64)
    64
    ~zod/try=> (~(net fe 3) 128)
    128
    ~zod/try=> (~(net fe 3) 255)
    255
    ~zod/try=> (~(net fe 3) 256)
    0
    ~zod/try=> (~(net fe 3) 257)
    1
    ~zod/try=> (~(net fe 3) 500)
    244
    ~zod/try=> (~(net fe 3) 511)
    255
    ~zod/try=> (~(net fe 3) 512)
    0
    ~zod/try=> (~(net fe 3) 513)
    1
    ~zod/try=> (~(net fe 3) 0)
    0
    ~zod/try=> (~(net fe 3) 1)
    1
    ~zod/try=> (~(net fe 0) 1)
    1
    ~zod/try=> (~(net fe 0) 2)
    0
    ~zod/try=> (~(net fe 0) 3)
    1
    ~zod/try=> (~(net fe 6) 1)
    72.057.594.037.927.936
    ~zod/try=> (~(net fe 6) 2)
    144.115.188.075.855.872
    ~zod/try=> (~(net fe 6) 3)
    216.172.782.113.783.808
    ~zod/try=> (~(net fe 6) 4)
    288.230.376.151.711.744
    ~zod/try=> (~(net fe 6) 5)
    360.287.970.189.639.680
    ~zod/try=> (~(net fe 6) 6)
    432.345.564.227.567.616
    ~zod/try=> (~(net fe 6) 7)
    504.403.158.265.495.552
    ~zod/try=> (~(net fe 6) 512)
    562.949.953.421.312
    ~zod/try=> (~(net fe 6) 513)
    72.620.543.991.349.248

------------------------------------------------------------------------

### `++out`

Max integer value

The maximum integer value that the current block can store.

Accepts
-------

A [`++bloq`](). 

Produces
--------

An [atom]().

Source
------

      ++  out  (bex (bex a))

Examples
--------

    ~zod/try=> ~(out fe 0)
    2
    ~zod/try=> ~(out fe 1)
    4
    ~zod/try=> ~(out fe 2)
    16
    ~zod/try=> ~(out fe 3)
    256
    ~zod/try=> ~(out fe 4)
    65.536
    ~zod/try=> ~(out fe 10)
    \/179.769.313.486.231.590.772.930.519.078.902.473.361.797.697.894.230.657.\/
      273.430.081.157.732.675.805.500.963.132.708.477.322.407.536.021.120.113.
      879.871.393.357.658.789.768.814.416.622.492.847.430.639.474.124.377.767.
      893.424.865.485.276.302.219.601.246.094.119.453.082.952.085.005.768.838.
      150.682.342.462.881.473.913.110.540.827.237.163.350.510.684.586.298.239.
      947.245.938.479.716.304.835.356.329.624.224.137.216
    \/                                                                        \/

------------------------------------------------------------------------

### `++rol`

Roll left

Roll `d` to the left by `c` `b`-sized blocks.

Accepts
-------

`a` is a [`++bloq`]().

`b` is a `++bloq`.

`c` is an atom.

`d` is an atom.

Produces
--------

An atom.

Source
------

      ++  rol  |=  [b=bloq c=@ d=@]  ^-  @                  ::  roll left
               =+  e=(sit d)
               =+  f=(bex (sub a b))
               =+  g=(mod c f)
               (sit (con (lsh b g e) (rsh b (sub f g) e)))

Examples
--------

    ~zod/try=> `@ux`(~(rol fe 6) 4 3 0xabac.dedf.1213)
    0x1213.0000.abac.dedf
    ~zod/try=> `@ux`(~(rol fe 6) 4 2 0xabac.dedf.1213)
    0xdedf.1213.0000.abac
    ~zod/try=> `@t`(~(rol fe 5) 3 1 'dfgh')
    'hdfg'
    ~zod/try=> `@t`(~(rol fe 5) 3 2 'dfgh')
    'ghdf'
    ~zod/try=> `@t`(~(rol fe 5) 3 0 'dfgh')
    'dfgh'

------------------------------------------------------------------------

### `++ror`

Roll right

Roll `d` to the right by `c` `b`-sized blocks.

Accepts
-------

`a` is a [`++bloq`]().

`b` is a `++bloq`.

`c` is an [atom]().

`d` is an atom.

Produces
--------

An atom.

Source
------

      ++  ror  |=  [b=bloq c=@ d=@]  ^-  @                  ::  roll right
               =+  e=(sit d)
               =+  f=(bex (sub a b))
               =+  g=(mod c f)
               (sit (con (rsh b g e) (lsh b (sub f g) e)))

Examples
--------

    ~zod/try=> `@ux`(~(ror fe 6) 4 1 0xabac.dedf.1213)
    0x1213.0000.abac.dedf
    ~zod/try=> `@ux`(~(ror fe 6) 3 5 0xabac.dedf.1213)
    0xacde.df12.1300.00ab
    ~zod/try=> `@ux`(~(ror fe 6) 3 3 0xabac.dedf.1213)
    0xdf12.1300.00ab.acde
    ~zod/try=> `@t`(~(rol fe 5) 3 0 'hijk')
    'hijk'
    ~zod/try=> `@t`(~(rol fe 5) 3 1 'hijk')
    'khij'
    ~zod/try=> `@t`(~(rol fe 5) 3 2 'hijk')
    'jkhi'

------------------------------------------------------------------------

### `++sum`

Sum

Sum two numbers in this modular field.

Accepts
-------

`a` is a [`++bloq`]().

`b` is an [atom]().

`c` is an atom.

Produces
--------

An atom.

Source
------

      ++  sum  |=([b=@ c=@] (sit (add b c)))                ::  wrapping add

Examples
--------

    ~zod/try=> (~(sum fe 3) 10 250)
    4
    ~zod/try=> (~(sum fe 0) 0 1)
    1
    ~zod/try=> (~(sum fe 0) 0 2)
    0
    ~zod/try=> (~(sum fe 2) 14 2)
    0
    ~zod/try=> (~(sum fe 2) 14 3)
    1
    ~zod/try=> (~(sum fe 4) 10.000 256)
    10.256
    ~zod/try=> (~(sum fe 4) 10.000 100.000)
    44.464

### `++sit`

Atom in mod block representation

Produce an [atom]() in the current modular block representation.

Accepts
-------

`a` is a [`++bloq`]().

`b` is an atom.

Produces
--------

An atom.

Source
------

      ++  sit  |=(b=@ (end a 1 b))                          ::  enforce modulo

Examples
--------

    ~zod/try=> (~(sit fe 3) 255)
    255
    ~zod/try=> (~(sit fe 3) 256)
    0
    ~zod/try=> (~(sit fe 3) 257)
    1
    ~zod/try=> (~(sit fe 2) 257)
    1
    ~zod/try=> (~(sit fe 2) 10.000)
    0
    ~zod/try=> (~(sit fe 2) 100)
    4
    ~zod/try=> (~(sit fe 2) 19)
    3
    ~zod/try=> (~(sit fe 2) 17)
    1
    ~zod/try=> (~(sit fe 0) 17)
    1
    ~zod/try=> (~(sit fe 0) 0)
    0
    ~zod/try=> (~(sit fe 0) 1)
    1


