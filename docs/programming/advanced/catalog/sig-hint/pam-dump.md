# `:dump`, `~&`, "sigpam", `{$dump p/@ud q/twig r/twig}`

Printf.

Prints `q` on the console before computing `r`. `p` is the log priority, 0-3
defaulting to 0. `p` is optional and is rarely used.

Regular form: *fixed 2 or 3*


Examples:

    ~zod:dojo> ~&('oops' ~)
    'oops'
    ~

The most common use of `~&`: print something to the console before
proceeding.
