# `:poll`, `~$` "sigbuc", `{$poll p/term q/twig}`

Label for profiling.

Labels computation `q` as `p` for profiling.

Irregular form: *2-fixed*

Examples:

    ~zod:dojo> (make '~$(foo |-($))')
    [%10 p=[p=1.702.259.052 q=[%1 p=7.303.014]] q=[%8 p=[%1 p=[9 2 0 1]] q=[%9 p=2 q=[%0 p=1]]]]
    ~zod:dojo> `@tas`1.702.259.052
    %live
    ~zod:dojo> `@tas`7.303.014
    %foo
