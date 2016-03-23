---
sort: 3
---

# Limbs and wings

One feature Hoon lacks: a context that isn't a first-class value.
Hoon has no concept of scope, environment, etc.  A twig has one
data source, the *subject*, a noun like any other.

In most languages "variable" and "attribute" are different
things.  They are both symbols, but a variable is in "the
environment" and a attribute is on "an object."  In Hoon, "the
environment" is "an object" -- the subject.

`$limb` and `$wing` are two basic twig stems that extract
information from the subject.  A `limb` is an attribute; a `wing`
is an attribute path, ie, a list of limbs.

## Twigs

Using a mold 
```
++  limb  
  $%  {$& p/@ud}
      {$| p/@ud q/@tas}
  ==
++  twig  
  $%  {$limb p/limb}
      {$wing p/wing}
  ==
++  wing  (list limb)
```

The basic reference twigs are `$limb` and `$wing`.  `$limb`
is a single reference step into the subject.  `$wing` is a path
of reference steps.

## Limbs and wings

A `limb` is either *geometric*, `{$& p/@ud}`, or *symbolic*, 
`{$| p/@ud q/@tas}`. 

The result of compiling a limb is either an *arm* or a *leg*.  A
leg is a subtree of the subject.  An arm is a computed attribute
on a core which is a subtree of the subject.  (See `$core` in 
[span](../span).)

A geometric limb always compiles to a leg.  A symbolic limb may
compile to an arm or a leg, depending on the subject.

### Geometric limb, `{$& p/@ud}`

`p` is a Nock tree address in the subject.  If you don't know
Nock, tree addresses are a way of designating a subtree of a noun
with an atom.  The root is `1`, the left child of any node `n` is
`(mul 2 n)`, the right child is `(add 1 (mul 2 n))`.

### Symbolic limb

A symbolic limb has a name `q` and a *skip count* `p`.

To resolve the limb to arm or leg, we search the subject
headfirst and depth-first.  If we descend to a `$face` span whose
label matches the limb symbol, the descent address is a leg; the
span is the span beneath the label.  But if the `$face` label
differs, the search ignores this leg.

If we descend into a `$core` span in which the limb symbol is an
arm, we produce that arm.  If the limb symbol is not bound, we
descend into the payload (data) of the core.

If the skip count `p` is nonzero, we pretend our first `p`
matches are actually mismatches.  This lets the programmer "look
through" an overriding label.  No label anywhere is inaccessible.

### Wing

A `wing` is a symbolic reference path, `(list limb)`.  Taking a
wing is not quite the same as composing each of these limbs,
though; the product of a wing is still either an arm or a leg.

This is trivial if each step in the wing is a leg.  If an
intermediate step in a wing compiles to an arm, this arm is
rewritten; it becomes a leg to the arm's core.

### Syntax

All limb references are irregular.

A geometric limb `x` is `+x`.  `.` means `+1`.

A symbolic limb `foo` is `foo`; the symbol is naked.  To set a
nonzero skip count, use a unary `^` prefix; thus `^foo` skips one
match, and `^^^foo` skips three.

The empty name `$` is the label whose value is 0.  By convention,
`$` is always an arm, usually on a one-armed core (such as a
function or loop).

A wing is written outside-in with `.` as a separator.  So
`foo.bar.baz` is "foo, in bar, in baz."  Yes, this is the
opposite of what you're used to.
