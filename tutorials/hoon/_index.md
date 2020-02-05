+++
title = "Hoon"
weight = 1
sort_by = "weight"
template = "sections/docs/hoon.html"
aliases = ["/docs/byte/0/", "/docs/byte", "/docs/learn/hoon/hoon-tutorial/"]
+++

This series is designed to teach you Hoon without assuming you have an extensive programming background.  In fact, you should be able to follow much of it even if you have no programming experience at all, though of course experience helps.  We strongly encourage you to try out all the examples of each lesson.  These lessons are meant for the beginner but they aren't meant to be skimmed. Each lesson falls into one of two categories: **readings**, which are prose-heavy explanations of Hoon fundamentals, and **walkthroughs**, which are line-by-line explanations of example programs. Walkthroughs are found between readings, offering a practical implementation of the concepts taught in the reading before.

Before you start, we recommend reading [Why Hoon?](https://urbit.org/blog/why-hoon/), a blog post by a Tlon engineer that justifies the existence and use of this peculiar language. This explainer gives useful context to all types of learners, but those new to programming will need to use Google frequently for the jargon.

Chapter 1 introduces and explains the fundamental concepts you need in order to understand Hoon's semantics.

Hoon is a 'subject-oriented' programming language -- every expression of Hoon is evaluated relative to a **subject**.  The subject is a piece of data that represents the environment, or the context, of an expression.  After reading Chapter 1 you should understand what the subject is and how to refer to its various parts.  In this chapter you'll also learn about **[cores](/docs/glossary/core/)**, which are an important data structure in Hoon.  Once you get the hang of [cores](/docs/glossary/core/) you'll be able to write your own functions in Hoon.

Chapter 2 covers the type system, and writing apps, and the workings of the Arvo kernel.
