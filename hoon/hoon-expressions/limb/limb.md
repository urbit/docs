+++
title = "Limbs"
weight = 1
template = "doc.html"
+++
A limb is an attribute of subject.

### Produces

There are two kinds of limbs: arms and legs.  An **arm** is a computation of some core.  A **leg** is a piece of data in the subject.

If a limb expression resolves to a leg, the leg is produced.  If a limb expression resolves to an arm -- in particular, by way of an arm name -- then the arm is computed with its parent core as the subject.  The result of that computation is produced.

### Syntax

Irregular: `+15` is slot `15`.  The value at address `15` of the subject is produced.

Irregular: `.` is slot `1`, the whole subject.

Irregular: `&4` is slot `30`, the 4th element of a tuple with at least 5 elements.

Irregular: `|4` is slot `31`, the elements that follow `&4`.

Irregular: `abc` is a name that can resolve either to an arm or a leg of the subject.

Irregular: `^^^abc` is the name `abc`, but which will skip the first three name matches in the subject.

Irregular: `+<-` is "take the tail, then take the head of that, then the head of that." `+` and `>` mean "tail" while `-` and `<` mean "head." This limb syntax starts on `+` or `-` and alternates with `>` or `<` for readability.

### Traverse

Name resolution happens by way of a search through the subject. The search traverse takes a name `q` and a **skip count** `p`.

The search product may be an **arm** or a **leg**.  A **leg** is a subtree of the subject.  An arm is a Nock formula paired with a core to compute the result.  You can think of the limb as an attribute -- computation or subtree, "synthesized" or "natural"
-- of the subject.

We search the subject type headfirst, depth-first, and pre-order.
If we descend to a `%face` type whose label matches the limb
symbol, the descent address is a leg.   The type is the type
beneath the label.  But if the `%face` label differs, the search
skips this whole subtree.

If we descend into a `%core` type in which the limb symbol is an
arm, we produce that arm.  If the limb symbol is not found, we
descend into the payload (data) of the core.

If the skip count `p` is nonzero, we pretend our first `p`
matches are actually mismatches.  This lets the programmer "look
through" an overriding label.

### Examples

The Dojo prompt gives you a subject with a decent namespace.
Try:

```
> now
~2016.4.25..01.39.59..a0f0
```

You can also add variables to the subject, then use them.  (Note
that `=variable value` is not Hoon (language) syntax; it's Dojo
(shell) syntax.)

```
> =a 12

> a
12
```
