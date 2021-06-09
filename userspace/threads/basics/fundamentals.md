+++
title = "Fundamentals"
weight = 1
template = "doc.html"
+++

## Introduction

A thread is like a transient gall agent. Unlike an agent, it can end and it can fail. The primary uses for threads are:

1. Complex IO, like making a bunch of external API calls where each call depends on the last. Doing this in an agent significantly increases its complexity and the risk of a mishandled intermediary state corrupting permanent state. If you spin the IO out into a thread, your agent only has to make one call to the thread and receive one response.
2. Testing - threads are very useful for writing complex tests for your agents.

Threads are managed by the gall agent called `spider`.

## Thread location

Threads live in the `ted` directory of your desk:

```
%
├──app
├──gen
├──lib
├──mar
├──sur
├──sys
└──ted <-
   ├──foo
   │  └──bar.hoon
   └──baz.hoon
```

From the dojo, `ted/baz.hoon` can be run with `-baz`, and `ted/foo/bar.hoon` with `-foo-bar`.

**NOTE:** When the dojo sees the `-` prefix it automatically handles creating a thread ID, composing the argument, poking the `spider` gall agent and subscribing for the result. Running a thread from another context (eg. a gall agent) requires doing these things explicitly and is outside the scope of this particular tutorial.

## Libraries and Structures

There are three files that matter:

- `/sur/spider/hoon` - this contains a few simple structures used by spider. It's not terribly useful except it imports libstrand, so you'll typically get `strand` from `spider`.

- `/lib/strand/hoon` - this contains all the main functions and structures for strands (a thread is a running strand), and you'll refer to this fairly frequently.

- `/lib/strandio/hoon` - this contains a large collection of ready-made functions for use in threads. You'll likely use many of these when you write threads, so it's very useful.

## Thread definition

`/sur/spider/hoon` defines a thread as:

```hoon
+$  thread  $-(vase _*form:(strand ,vase))
```

That is, a gate which takes a `vase` and returns the `form` of a `strand` that produces a `vase`. This is a little confusing and we'll look at each part in detail later. For now, note that the thread doesn't just produce a result, it actually produces a strand that takes input and produces output from which a result can be extracted. It works something like this:

![thread diagram](https://storage.googleapis.com/media.urbit.org/site/thread-diagram.png "diagram of a thread")

This is because threads typically do a bunch of I/O so it can't just immediately produce a result and end. Instead the strand will get some input, produce output, get some new input, produce new output, and so forth, until they eventually produce a `%done` with the actual final result. 

## Strands

Strands are the building blocks of threads. A thread will typically compose multiple strands.

A strand is a function of `strand-input:strand -> output:strand` and is defined in `/lib/strand/hoon`. You can see the details of `strand-input` [here](https://github.com/urbit/urbit/blob/master/pkg/arvo/lib/strand.hoon#L2-L21) and `output:strand` [here](https://github.com/urbit/urbit/blob/master/pkg/arvo/lib/strand.hoon#L23-L48). At this stage you don't need to know the nitty-gritty but it's helpful to have a quick look through. We'll discuss these things in more detail later.

A strand is a core that has three important arms:
- `form` - the mold of the strand
- `pure` - produces a strand that does nothing except return a value
- `bind` - monadic bind, like `then` in javascript promises 

We'll discuss each of these arms later.

A strand must be specialised to produce a particular type like `(strand ,<type>)`. As previously mentioned, a `thread` produces a `vase` so is specialised like `(strand ,vase)`. Within your thread you'll likely compose multiple strands which produce different types like `(strand ,@ud)`, `(strand ,[path cage])`, etc, but the thread itself will always come back to a `(strand ,vase)`.

Strands are conventionally given the face `m` like:

```hoon
=/  m  (strand ,vase)
...
```

**NOTE:** a comma prefix as in `,vase` is the irregular form of `^:` which is a gate that returns the sample value if it's of the correct type, but crashes otherwise. 

## Form and Pure

### `form`

The `form` arm is the mold of the strand, suitable for casting. The two other arms produce `form`s so you'll cast everything to this like:

```hoon
=/  m  (strand ,@ud)
^-  form:m
...
```

### `pure`

Pure produces a strand that does nothing except return a value. So, `(pure:(strand ,@tas) %foo)` is a strand that produces `%foo` without doing any IO.

We'll cover `bind` later.

## A trivial thread

```hoon
/-  spider 
=,  strand=strand:spider 
^-  thread:spider 
|=  arg=vase 
=/  m  (strand ,vase) 
^-  form:m 
(pure:m arg)
```

The above code is a simple thread that just returns its argument, and it's a good boilerplate to start from.

Save the above code as a file in `ted/mythread.hoon` and `|commit` it. Run it with `-mythread 'foo'`, you should see the following:


```
> -mythread 'foo'
[~ 'foo']
```

**NOTE:** The dojo wraps arguments in a unit so that's why it's `[~ 'foo']` rather than just `foo`.

## Analysis

We'll go through it line-by line.

```hoon
/-  spider 
=,  strand=strand:spider 
```

First we import `/sur/spider/hoon` which includes `/lib/strand/hoon` and give give the latter the face `strand` for convenience.

```hoon
^-  thread:spider
```

We make it a thread by casting it to `thread:spider`

```hoon
|=  arg=vase
```

We create a gate that takes a vase, the first part of the previously mentioned thread definition.

```hoon
=/  m  (strand ,vase)
```

Inside the gate we create our `strand` specialised to produce a `vase` and give it the canonical face `m`.

```hoon
^-  form:m 
```

We cast the output to `form` - the mold of the strand we created.

```hoon
(pure:m arg)
```

Finally we call `pure` with the gate input `arg` as its argument. Since `arg` is a `vase` it will return the `form` of a `strand` which produces a `vase`. Thus we've created a thread in accordance with its type definition.

Next we'll look at the third arm of a strand: `bind`.
