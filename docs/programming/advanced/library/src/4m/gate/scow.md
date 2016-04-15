### `++scow`

Render dime as tape

Renders `mol` as a tape.

Accepts
-------

Produces
--------

`mol` is a `++dime`.

Source
------

    ++  scow  |=(mol/dime ~(rend co %$ mol))

Examples
--------

    ~zod/try=> (scow %p ~pillyt)
    "~pillyt"
    ~zod/try=> (scow %ux 0x12)
    "0x12"
    ~zod/try=> (scow %if .127.0.0.1)
    ".127.0.0.1"
    ~zod/try=> (scow %ta ~.asd_a)
    "~.asd_a"



***
