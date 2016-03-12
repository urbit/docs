### `++rule`

Parsing rule

`++rule` is an empty parsing rule, but it is used to check
that parsing rules match this with `_`.


Source
------

        ++  rule  |=(tub=nail `edge`[p.tub ~ ~ tub])            ::  parsing rule

Examples
--------

    ~zod/try=> *rule
    [p=[p=0 q=0] q=[~ [p=0 q=[p=[p=0 q=0] q=""]]]]

    ~zod/try=> ^+(rule [|=(a=nail [p.a ~])]:|6)
    <1.dww [tub=[p=[p=@ud q=@ud] q=""] <101.jzo 1.ypj %164>]>
    ~zod/try=> (^+(rule [|=(a=nail [p.a ~ u=['a' a]])]:|6) [1 1] "hi")
    [p=[p=1 q=1] q=[~ [p=97 q=[p=[p=1 q=1] q="hi"]]]]
    ~zod/try=> ([|=(a=nail [p.a ~ u=['a' a]])]:|6 [1 1] "hi")
    [[p=1 q=1] ~ u=['a' p=[p=1 q=1] q="hi"]]



***
