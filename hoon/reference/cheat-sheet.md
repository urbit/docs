+++
title = "Cheat Sheet"
weight = 10
template = "doc.html"
aliases = ["docs/reference/cheat-sheet/"]
+++

Download the cheat sheet PDF [here](https://storage.googleapis.com/media.urbit.org/docs/hoon-cheat-sheet-2020-07-24.pdf).

We've found it's useful to have a quick reference of Hoon's syntax always at
hand. So above is a download link to a Hoon cheatsheet .pdf. It's missing a
few of the literal syntaxes, but it covers the most common ones.

This doesn't list any of the Ford runes, although there is now at least
some documentation for those [here](@/docs/arvo/ford/ford.md).

The following runes also exist, but are currently undocumented and not listed in
the cheat sheet:

```
!:  ::  turn on debugging printfs
!.  ::  turn off debugging printfs
!;  ::  using the "type of type", emit the type for an expression
!,  ::  emit AST of expression
$*  ::  bunt (irregular form is *)
^.  ::  use gate to transform type
^&  ::  zinc (covariant) -- see the docs on advanced types
```
