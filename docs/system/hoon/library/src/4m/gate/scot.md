### `++scot`

Render dime as cord

Renders a dime `mol` as a cord.

Accepts
-------

Produces
--------

`mol` is a [`++dime`]().

Source
------

    ++  scot  |=(mol=dime ~(rent co %$ mol))

Examples
--------

    ~zod/try=> (scot %p ~pillyt)
    ~.~pillyt
    ~zod/try=> `@t`(scot %p ~pillyt)
    '~pillyt'
    ~zod/try=> (scot %ux 0x12)
    ~.0x12
    ~zod/try=> `@t`(scot %ux 0x12)
    '0x12'
    ~zod/try=> (scot %if .127.0.0.1)
    ~..127.0.0.1
    ~zod/try=> `@t`(scot %if .127.0.0.1)
    '.127.0.0.1'
    ~zod/try=> (scot %ta ~.asd_a)
    ~.~.asd_a
    ~zod/try=> `@t`(scot %ta ~.asd_a)
    '~.asd_a'


