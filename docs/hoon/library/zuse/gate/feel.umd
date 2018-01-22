---
navhome: /docs/
---


### `++feel`

Generate file diff

Generates a diff between a file located at `pax` and an input value
`val`.

Accepts
-------

`pax` is a [`++path`]().

`val` is a value as a [noun]().

Produces
--------

A [`++miso`]().

Source
------

    ++  feel                                                ::  simple file write
          |=  [pax=path val=*]
          ^-  miso
          =+  dir=((hard arch) .^(%cy pax))
          ?~  q.dir  [%ins val]
          :-  %mut
          ^-  udon
          [%a %a .^(%cx pax) val]
        ::

Examples
--------

    ~zod/try=> + %/mel 'test'
    + /~zod/try/2/mel
    ~zod/try=> (feel %/mel 'tesh?')
    [%mut p=[p=%a q=[%a p=44.903.392.628 q=272.335.332.724]]]
    ~zod/try=> `@t`44.903.392.628
    '''
    test
    '''
    ~zod/try=> `@t`272.335.332.724
    'tesh?'


