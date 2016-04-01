# `:sip`, `=^`, "tisket" `{$sip p/taco q/wing r/twig s/twig}`
====

State monad: push a new variable on the subject, change value of another.

Similar to `=+` in that it pushes a value `q` on the stack with
face (variable name) `p`. It then modifies the new value of `q` within the subject.
`r` is the cell of [new-product-p updated-value-1].

Regular form: *2-fixed*

Examples:

    > =+  rng=~(. og 0wrando.mseed.12345)
      =^  r1  rng  (rads:rng 100)
      =^  r2  rng  (rads:rng 100)
      [r1 r2 rng]
    [99 46 <4.tty [@uw <399.uhj 106.umz 1.lgo %163>]>]
    ~fodrem-michex:dojo/try>

This is an example of using the `++og` pseudorandom number generator
with the `=^` rune. `++og` is evaluated with the initial random seed and
stored in `rng`. `=^` takes a face (to put on the result), a wing of the
subject (to modify), and a twig that must evaluate to a cell. The head
of the cell is the result, which is pushed on the subject with the
specified face. The tail of the cell is the updated state, which
replaces the specified wing of the subject. The final child twig is then
evaluated with the new subject.

In the case above, `++rads` in `++og` returns a cell of the result and a
new `++og` core with the next state of the PRNG. `=^` is useful for any
computation that also updates some kind of state.
