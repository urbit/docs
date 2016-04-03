# `:fix`, `=:`, "tiscol", `{$fix p/(list (pair wing twig)) q/twig}`

List of changes.

Makes a list of changes `p` to the subject and then evaluates `q`.
Useful when you need to make a batch of changes to your subject.

Regular form: *jogging*

Examples:

    ~zod/try=> =+  a=[b=1 c=2]
               =:  c.a  4
                   b.a  3
                 ==
               a
    [b=3 c=4]

Here we add a simple cell with faces to our subject, `a=[b=1 c=2]` and
make a set of changes to it using `=:`.
