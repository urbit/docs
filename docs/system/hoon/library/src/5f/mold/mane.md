### `++mane`

XML name

An XML name (tag name or attribute name) with an optional namespace.  Parsed by
[`++name`]() within [`++poxa`](), rendered by [`++name`]() within `++poxo`.

Source
------

        ++  mane  $|(@tas [@tas @tas])                          ::  XML name/space

Examples
--------

See also: [`++sail`]()

    ~zod/try=> *mane
    %$

    ~zod/try=> `mane`n.g:`manx`;div:namespace;
    %div
    ~zod/try=> `mane`n.g:`manx`;div_namespace;
    [%div %namespace]


