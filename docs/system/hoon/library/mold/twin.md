### `++twin`

Aliasing

Used in `%bull` within [`++type`]() to typecheck aliased faces.

Source
------

        ++  twin  ,[p=term q=wing r=axis s=type]                ::  alias info

Examples
--------

    ~zod/try=> (~(busk ut %cell %noun [%atom %ud]) %fal [%& 3]~)
    [ %bull
      p=[p=%fal q=~[[%.y p=3]] r=3 s=[%atom p=%ud]]
      q=[%cell p=%noun q=[%atom p=%ud]]
    ]
    ~zod/try=> &2:(~(busk ut %cell %noun [%atom %ud]) %fal [%& 3]~)
    p=[p=%fal q=~[[%.y p=3]] r=3 s=[%atom p=%ud]]
    ~zod/try=> (twin &2:(~(busk ut %cell %noun [%atom %ud]) %fal [%& 3]~))
    [p=%fal q=~[[%.y p=3]] r=3 s=[%atom p=%ud]]


