### `++span`

ASCII atom

A restricted text atom for canonical atom syntaxes. The prefix is `~.`.
There are no escape sequences except `~~`, which means `~`, and `~-`,
which means `_`. `-` and `.` encode themselves. No other characters
besides numbers and lowercase letters are permitted.

Source
------

        ++  span  ,@ta                                          ::  text-atom (ASCII)
Examples
--------
    ~zod/try=> *span
    ~.

    ~zod/try=> `@t`~.foo
    'foo'
    ~zod/try=> `@t`~.foo.bar
    'foo.bar'
    ~zod/try=> `@t`~.foo~~bar
    'foo~bar'
    ~zod/try=> `@t`~.foo~-bar
    'foo_bar'
    ~zod/try=> `@t`~.foo-bar
    'foo-bar'


