### `++star`

List of matches

Parser modifier: parse [`++list`]() of matches.

Accepts
-------

`fel` is a [`++rule`]().

Produces
--------

    ++  star                                                ::  0 or more times
      |*  fel=_rule
      (stir `(list ,_(wonk *fel))`~ |*([a=* b=*] [a b]) fel)

Examples
--------
        
        ~zod/try=> (scan "aaaaa" (just 'a'))
        ! {1 2}
        ! 'syntax-error'
        ! exit
        ~zod/try=> (scan "aaaaa" (star (just 'a')))
        "aaaaa"
        ~zod/try=> (scan "abcdef" (star (just 'a')))
        ! {1 2}
        ! 'syntax-error'
        ! exit
        ~zod/try=> (scan "abcabc" (star (jest 'abc')))
        <|abc abc|>
        ~zod/try=> (scan "john smith" (star (shim 0 200)))
        "john smith"


