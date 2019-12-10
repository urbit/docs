+++
title = "Nock"
weight = 4
template = "doc.html"
+++

**Nock** is a purely functional typeless programming language and acts as Urbit's lowest-level language. To be more precise, it is a Turing complete combinator interpreter not based on the lambda calculus. It could be thought of as the assembly-level language of Urbit, and is implemented by the runtime system [Vere](../vere).

[comment]: # ("combinator interpreter" is from the old glossary, but I don't know what is meant by this and there only seems to be a few uses of it online according to google, so maybe there is a better term we can use here, or give more of an explanation of what is meant by this? but maybe that is not appropriate for a glossary)

The only basic data type in Nock is the [atom](../atom), which is a non-negative integer. Computation in Nock occurs through the use of [nouns](../noun) (e.g. binary trees whose leaves are atoms) utilized in three different manners: formulas, subjects, and products. A _formula_ is a noun utilized as a function that takes in a noun, its _subject_, and returns a noun, its _product_.

Code written in [Hoon](../hoon) is compiled to Nock, though it is unnecessary to learn Nock to write code in Hoon.

### Further Reading

- [The Nock Tutorial](@/docs/tutorials/nock.md): An-in depth technical guide.
