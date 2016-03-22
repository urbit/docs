### `++vit`

Base64 digit

Parse a standard base64 digit.

Source
------

    ++  vit                                                 ::  base64 digit
      ;~  pose
        (cook |=(a/@ (sub a 65)) (shim 'A' 'Z'))
        (cook |=(a/@ (sub a 71)) (shim 'a' 'z'))
        (cook |=(a/@ (add a 4)) (shim '0' '9'))
        (cold 62 (just '-'))
        (cold 63 (just '+'))
      ==

Examples
--------

    ~zod/arvo=/hoon/hoon> (scan "C" vit)
    2
    ~zod/arvo=/hoon/hoon> (scan "c" vit)
    28
    ~zod/arvo=/hoon/hoon> (scan "2" vit)
    54
    ~zod/arvo=/hoon/hoon> (scan "-" vit)
    62


***
