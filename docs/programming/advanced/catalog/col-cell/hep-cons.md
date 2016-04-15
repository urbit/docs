# `:cons`, `:-`, "colhep", `{$cons p/twig q/twig}`

*Construct a cell (2-tuple*).

Syntax: *2-fixed*.

The product: the cell of `p` and `q`, each compiled against
the subject.

Irregular forms:

```
[a b]  :-(a b)
1^2^3  [1 2 3]
a+1    [%a 1]
`1     [~ 1]
[1 2]~ [[1 2] ~] 
```

Examples:

    ~zod:dojo> :-(1 2)
    [1 2]
    ~zod:dojo> :-  'a'
               %b
    ['a' %b]

This is the most straightforward case of `:-`, producing a cell of
static data in either tall or wide form.

    /~zod:dojo> 
        :-  (add 2 2)
        |-  (div 4 2)
    [4 2]

Most commonly `:-` helps to organize code, allowing you to produce a
cell from nested computation.

Some obscure `:-` irregular forms
==================================

### Infix `^`

    ~zod:dojo> 1^2^3
    [1 2 3]

`a^b` is equivalent to `:-  a  b`

### Infix `/`

    ~zod:dojo> a/1
    [%a 1]
    ~zod:dojo> a/'twig'
    [%a 'twig']

Like `^`, but first item must be a `++term`, and is cubed. Used to construct `path`s and frond.

### Prefix `` ` ``, postfix `~`

    ~zod:dojo> ````20
    [~ ~ ~ ~ 20]
    ~zod:dojo> [42 30]~
    [[42 30] ~]

Complimenting each other, these construct pairs with `~` in the head and
`tail` respectively. Multiple postfix `~` do not work for unknown reasons.
