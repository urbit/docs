
### `++gah`

Newline or ' '

Whitespace component, either newline or space.

Source
------

    ++  gah  (mask [`@`10 ' ' ~])                           ::  newline or ace

Examples
--------

    /~zod/try=> ^-  *  ::  show spaces
                """
                   -
                 -
                  -
                """
    [32 32 32 45 10 32 45 10 32 32 45 0]
    /~zod/try=> ^-  *
                """

                """
    [32 32 32 10 32 10 32 32 0]
    /~zod/try=> ^-  (list ,@)
                %-  scan  :_  (star gah)
                """

                """
    ~[32 32 32 10 32 10 32 32]



***
