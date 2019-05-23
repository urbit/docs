+++
title = "Hoon Tutorial"
weight = 1
sort_by = "weight"
template = "sections/docs/chapters.html"
+++

This series is designed to teach you Hoon without assuming you have an extensive programming background.  In fact, you should be able to follow much of it even if you have no programming experience at all, though of course experience helps.  We strongly encourage you to try out all the examples of each lesson.  These lessons are meant for the beginner but they aren't meant to be skimmed. Each lesson falls into one of two categories: **readings**, which are prose-heavy explanations of Hoon fundamentals, and **walkthroughs**, which are line-by-line explanations of example programs. Walkthroughs are found between readings, offering a practical implementation of the concepts taught in the reading before.

Chapter 1 introduces and explains the fundamental concepts you need in order to understand Hoon's semantics.

Hoon is a 'subject-oriented' programming language -- every expression of Hoon is evaluated relative to a **subject**.  The subject is a piece of data that represents the environment, or the context, of an expression.  After reading Chapter 1 you should understand what the subject is and how to refer to its various parts.  In this chapter you'll also learn about **cores**, which are an important data structure in Hoon.  Once you get the hang of cores you'll be able to write your own functions in Hoon.

Chapter 2 covers the basics of writing full programs in Hoon.

The first three lessons take you through a simple Hoon program, explain Hoon's syntax, and explains basic flow control.  The next three lessons introduce Hoon's type system.  Lessons 7 and 8 show you how to use cores effectively in your Hoon programs, including how to use them as state machines.  Lessons 9 and 10 cover some of the basic data structures commonly used in Hoon, such as lists, trees, and sets.  Those lessons also introduce many of the standard library functions for use with those data structures.  Lesson 11 includes a walk-through of two Hoon programs that are intended to reinforce everything taught earlier in the chapter: a prime sieve and a tic-tac-toe program.

## Lessons

### Chapter 1

- [1.1 Setup](setup)
- [1.1.1 Walkthrough: List of Numbers](list-of-numbers)
- [1.2 Nouns](nouns)
- [1.2.1 Walkthrough: Boolean Branching](boolean-branching)
- [1.3 Hoon Syntax](hoon-syntax)
- [1.4 Lists](list)
- [1.4.1 Walkthrough: Fibonacci Sequence](fibonacci)
- [1.5 Gates (Hoon Functions)](gates)
- [1.5.1 Walkthrough: Recursion](recursion)
- [1.6 The Subject and Its Legs](the-subject-and-its-legs)
- [1.6.1 Walkthrough: Ackerman Function](ackermann)
- [1.7 Arms and Cores](arms-and-cores)
- [1.7.1 Walkthrough: Caesar Cipher](caesar)
- [1.8 Doors](doors)
- [1.8.1 Walkthough: Bank Account](bank-account)
- [1.9 Generators](generators)

### Chapter 2

- [2.1 Hoon Programs](hoon-programs)
- [2.2 Hoon Syntax](hoon-syntax)
- [2.3 Simple One-Gate Programs](simple-one-gate-programs)
- [2.4 Atoms, Auras, and Simple Cell Types](atoms-auras-and-simple-cell-types)
- [2.5 Type Checking and Type Inference](type-checking-and-type-inference)
- [2.6 Structures and Complex Types](structures-and-complex-types)
- [2.7 Cores](cores)
- [2.8 Cores Again](cores-again)
- [2.9 Standard Library: Lists](lists)
- [2.10 Standard Library: Trees, Sets, and Maps](trees-sets-and-maps)
- [2.11 Examples](examples)

### Chapter 3

- [3.1 Type Polymorphism](type-polymorphism)

## Other Resources

Consult the [Reference section](/docs/reference/) to look up any unknown rune or standard library function you don't understand.

As you work your way through these lessons you may want to work on example problems from the [Hoon Workbook](../workbook) for practice.  Once you finish the lessons here you may want to write more versatile Hoon programs which can make use of more of your urbit's environment, in which case you'll want to check out the [Generators](/docs/using/generators) documentation.  Or maybe you'd like to learn how to write a [Gall app](/docs/learn/arvo/gall).  Learn about [Udon](/docs/using/udon), Urbit's stripped-down version of Markdown.  Or learn [Sail](/docs/using/sail), a subset of Hoon used for generating XML nodes.


> Last major revision of this section: February 2019
