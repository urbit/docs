+++
title = "Hoon Tutorial"
weight = 1
sort_by = "weight"
template = "sections/docs/chapters.html"
+++
This series is designed to teach you Hoon without assuming you have an extensive programming background.  In fact, you should be able to follow much of it even if you have no programming experience at all, though of course experience helps.  We strongly encourage you to try out all the examples of each lesson.  These lessons are meant for the beginner but they aren't meant to be skimmed.

Chapter 1 introduces and explains the fundamental concepts you need in order to understand Hoon's semantics.

Hoon is a 'subject-oriented' programming language -- every expression of Hoon is evaluated relative to a **subject**.  The subject is a piece of data that represents the environment, or the context, of an expression.  After reading Chapter 1 you should understand what the subject is and how to refer to its various parts.  In this chapter you'll also learn about **cores**, which are an important data structure in Hoon.  Once you get the hang of cores you'll be able to write your own functions in Hoon.

Chapter 2 covers the basics of writing full programs in Hoon.

The first three lessons take you through a simple Hoon program, explain Hoon's syntax, and explains basic flow control.  The next three lessons introduce Hoon's type system.  Lessons 7 and 8 show you how to use cores effectively in your Hoon programs, including how to use them as state machines.  Lessons 9 and 10 cover some of the basic data structures commonly used in Hoon, such as lists, trees, and sets.  Those lessons also introduce many of the standard library functions for use with those data structures.  Lesson 11 includes a walk-through of two Hoon programs that are intended to reinforce everything taught earlier in the chapter: a prime sieve and a tic-tac-toe program.

## Lessons

### Chapter 1

- [1.1 Setup](./docs/learn/hoon/hoon-tutorial/setup.md)
- [1.2 Nouns](./docs/learn/hoon/hoon-tutorial/nouns.md)
- [1.3 The Subject and Its Legs](./docs/learn/hoon/hoon-tutorial/the-subject-and-its-legs.md)
- [1.4 Arms and Cores](./docs/learn/hoon/hoon-tutorial/arms-and-cores.md)
- [1.5 Gates (Hoon Functions)](./docs/learn/hoon/hoon-tutorial/gates.md)
- [1.6 Multi-gate Cores and Doors](./docs/learn/hoon/hoon-tutorial/multi-gate-cores-and-doors.md)

### Chapter 2

- [2.1 Hoon Programs](./docs/learn/hoon/hoon-tutorial/hoon-programs.md)
- [2.2 Hoon Syntax](./docs/learn/hoon/hoon-tutorial/hoon-syntax.md)
- [2.3 Simple One-Gate Programs](./docs/learn/hoon/hoon-tutorial/simple-one-gate-programs.md)
- [2.4 Atoms, Auras, and Simple Cell Types](./docs/learn/hoon/hoon-tutorial/atoms-auras-and-simple-cell-types.md)
- [2.5 Type Checking and Type Inference](./docs/learn/hoon/hoon-tutorial/type-checking-and-type-inference.md)
- [2.6 Structures and Complex Types](./docs/learn/hoon/hoon-tutorial/structures-and-complex-types.md)
- [2.7 Cores](./docs/learn/hoon/hoon-tutorial/cores.md)
- [2.8 Cores Again](./docs/learn/hoon/hoon-tutorial/cores-again.md)
- [2.9 Standard Library: Lists](./docs/learn/hoon/hoon-tutorial/lists.md)
- [2.10 Standard Library: Trees, Sets, and Maps](./docs/learn/hoon/hoon-tutorial/trees-sets-and-maps.md)
- [2.11 Examples](./docs/learn/hoon/hoon-tutorial/examples.md)

### Chapter 3

- [3.1 Type Polymorphism](./docs/learn/hoon/hoon-tutorial/type-polymorphism.md)

## Other Resources

Consult the [Reference section](./docs/reference/_index.md) to look up any unknown rune or standard library function you don't understand.

As you work your way through these lessons you may want to work on example problems from the [Hoon Workbook](./docs/learn/hoon/workbook/_index.md) for practice.  Once you finish the lessons here you may want to write more versatile Hoon programs which can make use of more of your urbit's environment, in which case you'll want to check out the [Generators](./docs/using/generators.md) documentation.  Or maybe you'd like to learn how to write a [Gall app](content/docs/learn/arvo/gall.md).  Learn about [Udon](./docs/using/sail-and-udon.md), Urbit's stripped-down version of Markdown.  Or learn [Sail](./docs/using/sail-and-udon.md), a subset of Hoon used for generating XML nodes.


> Last major revision of this section: February 2019
