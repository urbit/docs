# `:show`, `~|` "sigbar", `{$show p/twig q/twig}`

`p` in stack trace if `q` crashes.

Produces: `p` in the stack trace if `q` crashes. `p` is only
evaluated if `q` crashes.

Regular form: *2-fixed*

Examples:

    > ~|('sample error message' !!)
    'sample error message'
    ford: build failed ~[/g/~sivtyv-barnel/use/dojo/~sivtyv-barnel/inn/hand /g/~sivtyv-barnel/use/hood/~sivtyv-barnel/out/dojo/drum/phat/~sivtyv-barnel/dojo /d //term/1]
