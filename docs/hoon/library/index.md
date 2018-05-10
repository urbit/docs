---
navhome: /docs/
sort: 1
title: Index
---

# A

[add](../1a/#add) :: *Add.* Produces the sum of `a` and `b`.

# B

[bloq](../1c/#bloq) :: *Blocksize.* Atom representing a blocksize, by convention
expressed as a power of 2.

# C

[cap](../1b/#cap) :: *Tree head.* Tests whether an `a` is in the head or tail of
a noun. Produces the cube `%2` if it is within the head, or the cube `%3` if it
is within the tail.

# D

[dec](../1a/#dec) :: *Decrement.* Decrements `a` by `1`.

[div](../1a/#div) :: *Divide.* Computes `a` divided by `b`.

# E

[each](../1c/#each) :: *Mold of fork between two.* mold generator: produces a
discriminated fork between two types.

# G

[gate](../1c/#gate) :: *Function.* A core with one arm, `$`--the empty
name--which transforms a sample noun into a product noun. If used dryly as a
type, the subject must have a sample type of `*`.

[gte](../1a/#gte) :: *Greater-than/equal.* Tests whether `a` is greater than a
number `b`.

[gth](../1a/#gth) :: *Greater-than.* Tests whether `a` is greater than `b`.

# L

[list](../1c/#list) :: *List.* mold generator. `++list` generates a mold of a
null-termanated list of a homogenous type.

[lone](../1c/#lone) :: *Put face on.* `++lone` puts face of `p` on something.

[lte](../1a/#lte) :: *Less-than/equal.* Tests whether `a` is less than or equal
to `b`.

[lth](../1a/#lth) :: *Less-than.* Tests whether `a` is less than `b`.

# M

[mas](../1b/#mas) :: *Axis within head/tail?* Computes the axis of `a` within
either the head or tail of a noun (depends whether `a` lies within the the head
  or tail).

[max](../1a/#max) :: *Maximum.* Computes the greater of `a` and `b`.

[min](../1a/#min) :: *Minimum.* Computes the lesser of `a` and `b`.

[mod](../1a/#mod) :: *Modulus.* Computes the remainder of dividing `a` by `b`.

[mul](../1a/#mul) :: *Multiply.* Multiplies `a` by `b`.

# P

[pair](../1c/#pair) :: *Mold of pair of types.* mold generator. Produces a tuple
of two of the types passed in.

[peg](../1b/#peg) :: *Axis within axis.* Computes the axis of `b` within axis `a`.

[pole](../1c/#pole) :: *Faceless list.* A `++list` without the faces `i` and `t`.

# Q

[qual](../1c/#qual) :: *Mold of 4 type tuple.* A `++qual` is a tuple of four of
the types passed in.

[quid](../1c/#quid) :: *For use with `=^` `:sip`.* Mold generator. Produces a
tuple of `a` and the mold of `b`.

[quip](../1c/#quip) :: *For use with `=^` `:sip`.* Mold generator. Produces a
tuple of a list of `a` and the mold of `b`.

# S

[sub](../1a/#sub) :: *Subtract.* Subtracts `b` from `a`.
