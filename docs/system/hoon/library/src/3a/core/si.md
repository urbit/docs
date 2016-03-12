### `++si`

    ++  si  !:                                              ::  signed integer
      |%

Container core for the signed integer functions.

------------------------------------------------------------------------

### `++abs`

Absolute value

Produces the absolute value of a signed integer.

Accepts
-------

`a` is a signed integer, [`@s`]().

Produces
--------

An [atom]().

Source
------

    ++  abs  |=(a=@s (add (end 0 1 a) (rsh 0 1 a)))       ::  absolute value

Examples
--------

    ~zod/try=> (abs:si -2)
    2
    ~zod/try=> (abs:si -10.000)
    10.000
    ~zod/try=> (abs:si --2)
    2

------------------------------------------------------------------------

### `++dif`

Difference

Produces the difference between two signed integers `b` and `c`.

Accepts
-------

`a` is a signed integer, [`@s`]().

`b` is a signed integer, `@s`.

Produces
--------

A [`@s`]().


Source
------

      ++  dif  |=  [a=@s b=@s]                              ::  subtraction
               (sum a (new !(syn b) (abs b)))

Examples
--------

    ~zod/try=> (dif:si --10 -7)
    --17
    ~zod/try=> (dif:si --10 --7)
    --3
    ~zod/try=> (dif:si `@s`0 --7)
    -7
    ~zod/try=> (dif:si `@s`0 `@s`7)
    --4

------------------------------------------------------------------------

### `++dul`

Modulus

Produces the modulus of two signed integers.

Accepts
-------

`a` is a signed integer, `@s`.

`b` is an [atom]().

Produces
--------

An atom. 

Source
------

      ++  dul  |=  [a=@s b=@]                               ::  modulus
               =+(c=(old a) ?:(-.c (mod +.c b) (sub b +.c)))

Examples
--------

    ~zod/try=> (dul:si --9 3)
    0
    ~zod/try=> (dul:si --9 4)
    1
    ~zod/try=> (dul:si --9 5)
    4
    ~zod/try=> (dul:si --9 6)
    3
    ~zod/try=> (dul:si --90 --10)
    10

------------------------------------------------------------------------

### `++fra`

Divide

Produces the quotient of two signed integers.

Accepts
-------

`a` is a signed integer, [`@s`].

`b` is a signed integer, `@s`.

Produces
--------

An [atom]().

Source
------

      ++  fra  |=  [a=@s b=@s]                              ::  divide
               (new =(0 (mix (syn a) (syn b))) (div (abs a) (abs b)))

Examples
--------

    ~zod/try=> (fra:si --10 -2)
    -5
    ~zod/try=> (fra:si -20 -5)
    --4

------------------------------------------------------------------------

### `++new`

Signed integer

Produces a signed integer from a loobean sign value `a` and an [atom]() `b`.

Accepts
-------

`a` is a loobean.

`b` is an atom.

Produces
--------

A [`@s`]()

Source
------

      ++  new  |=  [a=? b=@]                                ::  [sign value] to @s
               `@s`?:(a (mul 2 b) ?:(=(0 b) 0 +((mul 2 (dec b)))))

Examples
--------

    ~zod/try=> (new:si [& 10])
    --10
    ~zod/try=> (new:si [| 10])
    -10
    ~zod/try=> (new:si [%.y 7])
    --7

------------------------------------------------------------------------

### `++old`

[sign value]

Produces the cell `[sign value]` representations of a signed integer.

Accepts
-------

`a` is a [`@s`]().

Produces
--------

A cell of a boolean and an [atom]().

Source
------

      ++  old  |=(a=@s [(syn a) (abs a)])                   ::  [sign value]

Examples
--------

    ~zod/try=> (old:si 7)
    ! type-fail
    ! exit
    ~zod/try=> (old:si -7)
    [%.n 7]
    ~zod/try=> (old:si --7)
    [%.y 7]
    ~zod/try=> (old:si `@s`7)
    [%.n 4]
    ~zod/try=> (old:si -0)
    [%.y 0]

------------------------------------------------------------------------

### `++pro`

Multiply

Produces the product of two signed integers.

Accepts
-------

`a` is a [`@s`]().

`b` is a  `@s`.

Produces
--------

A `@s`.

Source
------

      ++  pro  |=  [a=@s b=@s]                              ::  multiplication
               (new =(0 (mix (syn a) (syn b))) (mul (abs a) (abs b)))

Examples
--------

    ~zod/try=> (pro:si -4 --2)
    -8
    ~zod/try=> (pro:si -4 -2)
    --8
    ~zod/try=> (pro:si --10.000.000 -10)
    -100.000.000
    ~zod/try=> (pro:si -1.337 --0)
    --0

------------------------------------------------------------------------

### `++rem`

Remainder

Produces the remainder from a division of two signed integers.

Accepts
-------

`a` is a [`@s`]().

`b` is a `@s`.

Produces
--------

A `@sd`.

Source
------

      ++  rem  |=([a=@s b=@s] (dif a (pro b (fra a b))))    ::  remainder

Examples
--------

    ~zod/try=> (rem:si -10 -4)
    -2
    ~zod/try=> (rem:si --10 --4)
    --2
    ~zod/try=> (rem:si --10 -4)
    --2
    ~zod/try=> (rem:si --7 --3)
    --1
    ~zod/try=> (rem:si --0 --10.000)
    --0

------------------------------------------------------------------------

### `++sum`

Add

Sum two signed integers.

Accepts
-------

`b` is a [`@s`]().

`c` is a signed integer `@s`.

Produces
--------

A `@s`.

Source
------

      ++  sum  |=  [a=@s b=@s]                              ::  addition
               ~|  %si-sum
               =+  [c=(old a) d=(old b)]
               ?:  -.c
                 ?:  -.d
                   (new & (add +.c +.d))
                 ?:  (gte +.c +.d)
                   (new & (sub +.c +.d))
                 (new | (sub +.d +.c))
               ?:  -.d
                 ?:  (gte +.c +.d)
                   (new | (sub +.c +.d))
                 (new & (sub +.d +.c))
               (new | (add +.c +.d))

Examples
--------

    ~zod/try=> (sum:si --10 --10)
    --20
    ~zod/try=> (sum:si --10 -0)
    --10
    ~zod/try=> (sum:si -10 -7)
    -17
    ~zod/try=> (sum:si -10 --7)
    -3

------------------------------------------------------------------------

### `++sun`

Signed from unsigned

Produces a signed integer from an unsigned integer.

Note that the result must be manually cast to some [`@s`]() odor to be
inferred as an unsigned integer in the type system.

Accepts
-------

`a` is a [`@u`]().

Produces
--------

A [`@s`]().

Source
------

      ++  sun  |=(a=@u (mul 2 a))                           ::  @u to @s

Examples
--------

    ~zod/try=> `@s`10
    --5
    ~zod/try=> (sun:si 10)
    20
    ~zod/try=> `@s`(sun:si 10)
    --10
    ~zod/try=> `@sd`(sun:si 10)
    --10
    ~zod/try=> `@sd`(sun:si 12.345)
    --12.345

------------------------------------------------------------------------

### `++syn`

Sign

Produce the sign of a signed integer, where `&` is posiitve, and `|` is negative.

Accepts
-------

`a` is a [`@s`]().

Produces
--------

A boolean.

Source
------

      ++  syn  |=(a=@s =(0 (end 0 1 a)))                    ::  sign test

Examples
--------

    ~zod/try=> (syn:si -2)
    %.n
    ~zod/try=> (syn:si --2)
    %.y
    ~zod/try=> (syn:si -0)
    %.y

------------------------------------------------------------------------

### `++cmp`

Compare

Compare two signed integers.

Accepts
-------

`b` is a  [`@s`]().

`c` is a  `@s`.

Produces
--------

A `@s`.

Source
------

      ++  cmp  |=  [a=@s b=@s]                              ::  compare
               ^-  @s
               ?:  =(a b)
                 --0
               ?:  (syn a)
                 ?:  (syn b)
                   ?:  (gth a b)
                     --1
                   -1
                 --1
              ?:  (syn b)
                -1
              ?:  (gth a b)
                -1
              --1

Examples
--------

    ~zod/try=> (cmp:si --10 --10)
    --0
    ~zod/try=> (cmp:si --10 -0)
    --1
    ~zod/try=> (cmp:si -10 -7)
    -1
    ~zod/try=> (cmp:si -10 --7)
    -1


***
