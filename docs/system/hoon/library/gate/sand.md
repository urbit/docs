### `++sand`

Soft-cast by odor

Soft-cast validity by [odor]().

Accepts
-------

`a` is a [`++span`]() (`@ta`).

`b` is an atom.

Produces
--------

A `(unit ,@)`.

Source
------

    ++  sand                                                ::  atom sanity
      |=  a=@ta
      |=  b=@  ^-  (unit ,@)
      ?.(((sane a) b) ~ [~ b])
    ::

Examples
--------

    /~zod/try=> `(unit ,@ta)`((sand %ta) 'sym-som')
    [~ ~.sym-som]
    /~zod/try=> `(unit ,@ta)`((sand %ta) 'err!')
    ~


