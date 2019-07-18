+++
title = "Hoon Tutorial"
weight = 1
sort_by = "weight"
template = "sections/docs/chapters.html"
+++

This series is designed to teach you Hoon without assuming you have an extensive programming background.  In fact, you should be able to follow much of it even if you have no programming experience at all, though of course experience helps.  We strongly encourage you to try out all the examples of each lesson.  These lessons are meant for the beginner but they aren't meant to be skimmed. Each lesson falls into one of two categories: **readings**, which are prose-heavy explanations of Hoon fundamentals, and **walkthroughs**, which are line-by-line explanations of example programs. Walkthroughs are found between readings, offering a practical implementation of the concepts taught in the reading before.

Chapter 1 introduces and explains the fundamental concepts you need in order to understand Hoon's semantics.

Hoon is a 'subject-oriented' programming language -- every expression of Hoon is evaluated relative to a **subject**.  The subject is a piece of data that represents the environment, or the context, of an expression.  After reading Chapter 1 you should understand what the subject is and how to refer to its various parts.  In this chapter you'll also learn about **cores**, which are an important data structure in Hoon.  Once you get the hang of cores you'll be able to write your own functions in Hoon.

Chapter 2 covers the type system, and writing apps, and the workings of the Arvo kernel.


## Lessons

### Chapter 1

- [1.1 Setup](setup)
- [1.1.1 Walkthrough: List of Numbers](list-of-numbers)
- [1.2 Nouns](nouns)
- [1.2.1 Walkthrough: Conditionals](conditionals)
- [1.3 Hoon Syntax](hoon-syntax)
- [1.4 Lists](lists)
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

- [2.1 Atoms, Auras, and Simple Cell Types](atoms-auras-and-simple-cell-types)
- [2.2 Type Checking and Type Inference](type-checking-and-type-inference)
- [2.3 Structures and Complex Types](structures-and-complex-types)
- [2.4 Standard Library: Trees, Sets, and Maps](trees-sets-and-maps)
- [2.5 Type Polymorphism](type-polymorphism)

## Other Resources

Consult the [Reference section](@/docs/reference/_index.md) to look up any unknown rune or standard library function you don't understand.

As you work your way through these lessons you may want to work on example problems from the [Hoon Workbook](@/docs/learn/hoon/workbook/_index.md) for practice.  Once you finish the lessons here you may want to write more versatile Hoon programs which can make use of more of your urbit's environment, in which case you'll want to check out the [Generators](@/docs/learn/hoon/hoon-tutorial/generators.md) documentation.  Or maybe you'd like to learn how to write a [Gall app](content/docs/learn/arvo/gall.md).  Learn about [Udon](@/docs/using/sail-and-udon.md), Urbit's stripped-down version of Markdown.  Or learn [Sail](@/docs/using/sail-and-udon.md), a subset of Hoon used for generating XML nodes.


> Last major revision of this section: February 2019
