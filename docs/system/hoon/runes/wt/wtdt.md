# `:lest`, `?.`, "wutdot" `{$lest p/twig q/twig r/twig}`

Inverted if-then-else.

Unless `p` is true, evaluate `r`. Used to keep the heavier of `q` and `r` as the bottom expression, which makes for more readable code (see the section on backstep in the syntax section).

Regular form: *3-fixed*

Examples:

    ~zod/try=> ?.((gth 1 2) 1 2)
    1
    ~zod/try=> ?.(?=(%a 'a') %not-a %yup)
    %yup
    > ?.  %.y
        'this false case is less heavy than the true case'
      ?:  =(2 3)
      'two not equal to 3'
      'but see how \'r is much heavier than \'q?'
    'but see how \'r is much heavier than \'q?'

Here we see two common cases of `?.` in the wide form, one uses an
expression `gth` that produces a boolean and the other `?=` to
produce one of its cases.
