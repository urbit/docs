+++
title = "Atom"
template = "doc.html"
[extra]
category = "hoon-nock"
+++

An **atom** is any non-negative integer of any size. The atom is the most basic data type in [Nock](../nock) and [Hoon](../hoon).

A Hoon atom type consists of a Nock atom with two additional pieces of metadata: an [aura](../aura) and an optional constant. A Hoon atom type is _warm_ or _cold_ based on whether or not the constant exists:
* An Hoon atom type is **warm** if the constant is `~` (null), any atom is in the type.
* An Hoon atom type is **cold** if the constant is `[~ atom]`, its only legal value is atom.

### Further Reading

- [The Hoon Tutorial](@/docs/tutorials/hoon/_index.md): Our guide to learning the Hoon programming language.
  - [Lesson 1.2: Nouns](@/docs/tutorials/hoon/nouns.md): An Hoon Tutoral lesson that explains how atoms work.
- [The Nock explanation](@/docs/tutorials/nock/explanation.md): Includes an explanation of atoms.
