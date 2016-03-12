### `++slav`

Demand: parse span with input odor

Parses a span `txt` to an atom of the odor specificed by `mod`. Crashes
if it failes to parse.

Accepts
-------

Produces
--------

`mod` is a term, an atom of odor [`@tas`]().

`txt` is a span, an atom of odor [`@ta`]().

Source
------

    ++  slav  |=([mod=@tas txt=@ta] (need (slaw mod txt)))

Examples
--------

    ~zod/try=> `@p`(slav %p '~pillyt')
    ~pillyt
    ~zod/try=> `@p`(slav %p '~pillam')
    ! exit
    ~zod/try=> `@ux`(slav %ux '0x12')
    0x12
    ~zod/try=> `@ux`(slav %ux '0b10')
    ! exit
    ~zod/try=> `@if`(slav %if '.127.0.0.1')
    .127.0.0.1
    ~zod/try=> `@if`(slav %if '.fe80.0.0.202')
    ! exit
    ~zod/try=> `@ta`(slav %ta '~.asd_a')
    ~.asd_a
    ~zod/try=> `@ta`(slav %ta '~~asd-a')
    ! exit



***
