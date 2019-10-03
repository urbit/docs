+++
title = "Limbs and wings"
weight = 3
sort_by = "weight"
template = "sections/docs/chapters.html"
+++
One feature Hoon lacks: a context that isn't a first-class value. Hoon has no
concept of scope, environment, etc.  An expression has exactly one data source,
the **subject**, a noun like any other.

## [Limbs](@/docs/hoon/hoon-expressions/limb/limb.md)

A limb is used to resolve to a piece of data in the subject.  A wing is thus a resolution path into the subject.

## [Wings](@/docs/hoon/hoon-expressions/limb/wing.md)

In Hoon we use 'wings' to extract information from the subject.  A wing is a list of limbs (including a trivial list of one limb).
