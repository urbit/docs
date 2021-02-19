+++
title = "Atom"
template = "doc.html"
[extra]
category = "hoon-nock"
+++

An **atom** is any non-negative integer of any size. The atom is the most basic data type in [Nock](../nock) and [Hoon](../hoon).

A Hoon atom type consists of a Nock atom with two additional pieces of metadata:
an _aura_, which is a soft type that declares if an atom is a date, a ship name, a
number, etc, and an optional constant. A Hoon atom type is _warm_ or _cold_ based on whether or not the constant exists:
* A Hoon atom type is **warm** if the constant is `~` (null), any atom is in the type.
* A Hoon atom type is **cold** if the constant is `[~ atom]`, its only legal value is atom.

### Further Reading

- [The Hoon Tutorial](@/docs/hoon/hoon-school/_index.md): Our guide to learning the Hoon programming language.
  - [Lesson 1.2: Nouns](@/docs//hoon/hoon-school/nouns.md): A Hoon Tutoral lesson that explains how atoms work.
- [The Nock explanation](@/docs/nock/explanation.md): Includes an explanation of atoms.
