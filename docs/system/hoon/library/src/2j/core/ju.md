### `++ju`

Jug operations

    ++  ju                                                  ::  jug engine
      |/  a=(jug)

Container arm for jug operation arms. A `++jug` is a `++map` of
`++sets`. The contained arms inherit its [sample]() jug, `a`.

`a` is a [jug]().

    ~zod/try=> ~(. ju (mo (limo a/(sa "ho") b/(sa "he") ~)))
    <2.dgz [nlr([p={%a %b} q={nlr(^$1{@tD $1}) nlr(^$3{@tD $3})}]) <414.fvk 101.jzo 1.ypj %164>]>

### `+-del:ju`

Remove

      +-  del                                               ::  delete at key b
        |*  [b=* c=*]
        ^+  a
        =+  d=(get(+< a) b)
        =+  e=(~(del in d) c)
        ?~  e
          (~(del by a) b)
        (~(put by a) b e)

Produces jug `a` with value `c` removed from set located at key `b`.

`a` is a [jug]().

`b` is a key of the same type as the keys in `a`.

`c` is the value of the same type of the keys in `a` that is to be
removed.

    ~zod/try=> s
    {[p='a' q={1 3 2}] [p='b' q={5 4 6}]}
    ~zod/try=> (~(del ju s) 'a' 1)
    {[p='a' q={3 2}] [p='b' q={5 4 6}]}
    ~zod/try=> (~(del ju s) 'c' 7)
    {[p='a' q={1 3 2}] [p='b' q={5 4 6}]}        

------------------------------------------------------------------------

### `+-get:ju`

Retrieve set

      +-  get                                               ::  gets set by key
        |*  b=*
        =+  c=(~(get by a) b)
        ?~(c ~ u.c)

Produces a set retrieved from jar `a` using key `b`.

`a` is a [jar]().

`b` is a key of the same type as the keys in `a`.

    ~zod/try=> s
    {[p='a' q={1 3 2}] [p='b' q={5 4 6}]}
    ~zod/try=> (~(get ju s) 'a')
    {1 3 2}
    ~zod/try=> (~(get ju s) 'b')
    {5 4 6}
    ~zod/try=> (~(get ju s) 'c')
    ~

------------------------------------------------------------------------

### `+-has:ju`

Check contents

      +-  has                                               ::  existence check
        |*  [b=* c=*]
        ^-  ?
        (~(has in (get(+< a) b)) c)

Computes whether a value `c` exists within the set located at key `b`
with jar `a`. Produces a loobean.

`a` is a [set]().

`b` is a key as a [noun]().

`c` is a value as a [noun]().

    ~zod/try=> s
    {[p='a' q={1 3 2}] [p='b' q={5 4 6}]}
    ~zod/try=> (~(has ju s) 'a' 3)
    %.y
    ~zod/try=> (~(has ju s) 'b' 6)
    %.y
    ~zod/try=> (~(has ju s) 'a' 7)
    %.n
    ~zod/try=> (~(has jus s) 'c' 7)
    ! -find-limb.jus
    ! find-none
    ! exit
    ~zod/try=> (~(has ju s) 'c' 7)
    %.n

------------------------------------------------------------------------

### `+-put:ju`

Add key-set pair

      +-  put                                               ::  adds key-element pair
        |*  [b=* c=*]
        ^+  a
        =+  d=(get(+< a) b)
        (~(put by a) b (~(put in d) c))

Produces jar `a` with `c` added to the set value located at key `b`.

`a` is a [set]().

`b` is a key as a [noun]().

`c` is a [value]().

    ~zod/try=> s
    {[p='a' q={1 3 2}] [p='b' q={5 4 6}]}
    ~zod/try=> (~(put ju s) 'a' 7)
    {[p='a' q={7 1 3 2}] [p='b' q={5 4 6}]}
    ~zod/try=> (~(put ju s) 'a' 1)
    {[p='a' q={1 3 2}] [p='b' q={5 4 6}]}
    ~zod/try=> (~(put ju s) 'c' 7)
    {[p='a' q={1 3 2}] [p='c' q={7}] [p='b' q={5 4 6}]}



***
