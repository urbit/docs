# `:name`, `^=`, "kettis", `{$name p/toga q/twig}`

Wraps a variable name around a value.

`^=`, `kettis`, `[%ktts p=toga q=twig]` is a natural rune that wraps `q`
in the `++toga` `p`. `^=` is most commonly used for assignment,
adding one or more names to values.

Regular form: *2-fixed*

Examples:

    ~zod:dojo> a=1
    a=1
    ~zod:dojo> ^=  a
               1
    a=1

In this straightforward example we see the irregular and tall forms of
`^=`, both of which assign `a` to be `1`.

    ~zod:dojo> [b ~ c]=[1 2 3 4]
    [b=1 2 c=[3 4]]

Here we see multiple names being applied at once, using the irregular
form of `^=`.
