---
navhome: /docs/
---


### `++fain`

Restructure path

Splits a concrete

[`++spur`]() out of a full [`++path`](), producing a location [`++beam`]() and
a remainder [`++path`]().

Accepts
-------

`hom` is a `++path`

Produces
--------

    ([pair]() beam path)

Source
------

    ++  fain                                                ::  path restructure
          |=  [hom=path raw=path]
          =+  bem=(need (tome raw))
          =+  [mer=(flop s.bem) moh=(flop hom)]
          |-  ^-  (pair beam path)
          ?~  moh
            [bem(s hom) (flop mer)]
          ?>  &(?=(^ mer) =(i.mer i.moh))
          $(mer t.mer, moh t.moh)
        ::

Examples
--------

    ~zod/try=> (fain / %)
    [p=[[p=~zod q=%try r=[%da p=~2014.11.1..00.07.17..c835]] s=/] q=/]
    ~zod/try=> (fain /lok %)
    ! exit
    ~zod/try=> (fain / %/mer/lok/tem)
    [ p=[[p=~zod q=%try r=[%da p=~2014.11.1..00.08.03..bfdf]] s=/] 
      q=/tem/lok/mer
    ]
    ~zod/try=> (fain /mer %/mer/lok/tem)
    [p=[[p=~zod q=%try r=[%da p=~2014.11.1..00.08.15..4da0]] s=/mer] q=/tem/lok]
    ~zod/try=> (fain /lok/mer %/mer/lok/tem)
    [p=[[p=~zod q=%try r=[%da p=~2014.11.1..00.08.24..4d9e]] s=/lok/mer] q=/tem]
    ~zod/try=> (fain /lok/mer %/mer)
    ! exit
    ~zod/try=> (fain /hook/hymn/tor %/tor/hymn/hook/'._req_1234__')
    [ p=[[p=~zod q=%try r=[%da p=~2014.11.1..00.09.25..c321]] s=/hook/hymn/tor]
      q=/._req_1234__
    ]


