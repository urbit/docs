---
navhome: /docs/
sort: 2
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

## Stems

<list dataPreview="true" className="runes"></list>
