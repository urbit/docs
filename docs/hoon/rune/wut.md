---
navhome: /docs/
next: true
sort: 14
title: Test ? ("wut")
---

# Test `?` ("wut")
 
Hoon has the usual branches and logical tests.  For pattern
matching, it also has a [`?=` ("wuttis")](./tis/) rune that tests whether a value
matches the icon of a mold.  And it has branch inference,
learning from `?=` tests in the condition of [`?:` ("wutcol")](./col/) hoons.

## Overview

All `?` runes expand to `?:` and/or `?=`.

If the condition of an `?:` is a `?=`, *and* the `?=` is
testing a leg of the subject, the compiler specializes the subject
type for the branches of the `?:`.  Branch inference also works
for expressions which expand to `?:`.

The test does not have to be a single `?=`; the compiler can
analyze arbitrary boolean logic ([`?&` ("wutpam")](./pam/), 
[`?|` ("wutbar")](./bar/), [`?!` ("wutzap")](./zap/)) with full 
short-circuiting.  Equality tests ([`.=` ("dottis")](../dot/tis/)) are *not* 
analyzed.

If the compiler detects that the branch is degenerate (only one
side is taken), it fails with an error.

## Twigs

<list dataPreview="true" className="runes"></list>
