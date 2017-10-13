---
navhome: /docs/
sort: 8
---

# Test, `?` ("wut")
 
Hoon has the usual branches and logical tests.  For pattern
matching, it also has a `$fits` twig that tests whether a value
matches the icon of a mold.  And it has branch inference,
learning from `$fits` tests in the condition of `:if` twigs.

## Overview

All `?` runes expand to `$if` (`?:`) and/or `$fits` (`?=`).

If the condition of an `$if` is a `$fits`, *and* the `$fits` is
testing a leg of the subject, the compile specializes the subject
span for the branches of the `$if`.  Branch inference also works
for twigs which expand to `$if`.

The test does not have to be a single `$fits`; the compiler can
analyze arbitrary boolean logic (`$and`, `$or`, `$not`) with full 
short-circuiting.  Equality tests (`=`) are *not* analyzed.

If the compiler detects that the branch is degenerate (only one
side is taken), it fails with an error.

## Twigs

<list dataPreview="true" className="runes"></list>
