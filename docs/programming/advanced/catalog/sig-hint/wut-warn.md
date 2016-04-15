# `:warn`, `~?`, "sigwut", `{$warn p/@ud q/twig r/twig s/twig}`

PrintF if `q` true.

Same as `~&` except for that `r` is printed to the console if and only
if `q` evaluates to true. `p` is the priority level between 1-3 (defaults to 0) and is both optional and rarely used.

Regularm form *4-fixed*

Examples:

    ~zod:dojo> ~?((gth 1 2) 'oops' ~)
    ~
    ~zod:dojo> ~?((gth 1 0) 'oops' ~)
    'oops'
    ~

A simple case of the conditional printf. When our condition evaluates to
true we print our `r`. Most useful in computation dealing with dynamic
data.
