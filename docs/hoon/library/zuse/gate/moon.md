---
navhome: /docs/
---


### `++moon`

Mime type to `++cord`

Renders a [mime](http://en.wikipedia.org/wiki/MIME) type path with infix
`/` to a [`++cord`]().
Accepts
-------

`myn` is a ++[`mite`](), a [`++list`]() of [`@ta`]().

Produces
--------

A `++cord`.

Source
------

    ++  moon                                                ::  mime type to text
      |=  myn=mite
      %+  rap
        3
      |-  ^-  tape
      ?~  myn  ~
      ?:  =(~ t.myn)  (trip i.myn)
      (weld (trip i.myn) `tape`['/' $(myn t.myn)])
    ::

Examples
--------

    ~zod/try=> `@t`(moon /image/png)
    'image/png'
    ~zod/try=> `@t`(moon /text/x-hoon)
    'text/x-hoon'
    ~zod/try=> `@t`(moon /application/x-pnacl)
    'application/x-pnacl'


