+++
title = "Parsing tutorial"
weight = 12
template = "doc.html"
+++

# Parsing Tutorial

This document serves as an introduction to parsing text with Hoon. No prior
knowledge of parsing is required, and we will explain the basic structure of how
parsing works in a purely functional language such as Hoon before moving on to
how it is implemented in Hoon.

## What is parsing?

A program which takes a raw sequence of characters as an input and produces a data
structure as an output is known as a _parser_. The data structure produced
depends on the use case, but often it may be represented as a tree, and the
output is thought of as a structural representation of the input. Parsers are ubiquitous in
computing, commonly used in applications such as reading files, compiling
source code, or understanding commands input in a command line interface.

Parsing a string is rarely done all at once. Instead, it is usually done
character-by-character, and the return contains the data structure representing
what has been parsed thus far as well as the remainder of the string to be
parsed. They also need to be able to fail in case the input is improperly formed.

## Functional parsers

How parsers are built varies greatly depending on what sort of programming
language it is written in. As Hoon is a functional programming language, we will
be focused on understanding _functional parsers_, also known as _combinator
parsers_.

Functional parsers are built piece by piece from simple irreducible components
that are plugged into one another in various ways to form more complex
parsers.

The basic building blocks, or primitives, are parsers that read only a
single character. There are frequently a few types of possible input characters,
such as letters, numbers, and symbols. For example, `parse(integer, "1")` calls
the parsing routine on the string `"1"` and looks for an integer, and so it
returns the integer `1`. However, taking into account what was said above about
parsers returning the unparsed portion of the string as well, we should
represent this return as a tuple. So we should expect something like this:
```
> parse(integer, "1")
(1, "")
> parse(integer, "123")
(1, "23")
```
What if we wish to parse the rest of the string? We would need to apply the
`parse(integer, -)` function again:
```
> parse(integer, parse(integer, "123"))
(12, "3")
> parse(integer, parse(integer, parse(integer, "123")))
(123, "")
```
So we see that we can parse strings larger than one character by stringing
together parsing functions for single characters. Thus in addition to parsing
functions for single input characters, we want _parser combinators_ that
allow you to combine two or more simple parsers to form more complex ones.
Combinators come in a few shapes and sizes, and typical operations they may
perform would be to repeat the same parsing operation until the string is
consumed, try a few different parsing operations until one of them works,
or perform a sequence of parsing operations. We will see how all of this is done
with Hoon in the [Parsing in Hoon](#parsing-in-hoon) section.

# Parsing in Hoon

In this section we will cover the basic types and functions that are utilized for parsing in
Hoon, and then build some simple parsers.

## Basic types

hair, edge, etc

## Parsing arithmetic expressions
