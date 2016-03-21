
### `++plus`

List of at least one match.

Parser modifier: parse `++list` of at least one match.

Accepts
-------

`fel` is a `++rule`.

Produces
--------

A `++rule`.

Source
------

    ++  plus  |*(fel/rule ;~(plug fel (star fel)))


Examples
--------
    
    ~zod/try=> (scan ">>>>" (cook lent (plus gar)))
    4
    ~zod/try=> (scan "-  - " (plus ;~(pose ace hep)))
    [~~- "  - "]
    ~zod/try=> `tape`(scan "-  - " (plus ;~(pose ace hep)))
    "-  - "
    ~zod/try=> `(pole ,@t)`(scan "-  - " (plus ;~(pose ace hep)))
    ['-' [' ' [' ' ['-' [' ' ~]]]]]



***
