+++
title = "2.8 Ford"
weight = 38
template = "doc.html"
+++

This lesson introduces the basics of the Ford vane, Arvo's build system and computation engine.

In terms of sheer size, Ford is Arvo's largest vane, weighing in at over 6000 lines of code at the time of writing. As a result, we will only be scratching the surface of Ford in this lesson. We will mostly focus on describing how Ford works in a broad sense and not dig too deeply into the details.

## What are build systems?

You may safely skip this section if you are familiar with build systems, as there is no Ford-specific information.

At a high level, build systems are software that builds other software from source files. How this is accomplished varies from build system to build system, but there are some general properties shared by almost everything in this category.

The primary output of a build system, the final binary known as a _build_, comes from two inputs: (1) source files, and (2) build instructions. Analogous to building a house, you could think of these as corresponding to raw materials and architectural blueprints. The build system calls the compiler (typically a separate piece of software) on each source file, which you may think of as shaping the raw materials something suitable for the final product. The compiled source files are then put together according to the build instructions.

The number of languages a build system is designed to work with varies, from specialized build systems that focus on a single language (like Ford) to general purpose ones that could conceivably work for any language and frequently rely on other build systems to function (such as [make](https://en.wikipedia.org/wiki/Make_(software))).

Source files frequently have _dependencies_, which are other source files, outside libraries, or tools needed to build a software program. These dependencies can have dependencies themselves, and in general one can draw a dependency graph of all of the different libraries and tools that go into building a project.

It is frequently the case that only specific versions of a given library or tool will work. This can create contradictory version requirements, an issue that falls under the umbrella of "dependency hell". Most build systems suffer from this problem, but functional programming provides workarounds. [Nix](https://nixos.org/nix/) is a popular build system that avoids this issue, and Ford does as well.

Besides the primary task of building software outlined above, build systems also typically handle some or all of the following responsibilities:
 - Resolving dependencies
 - Downloading dependencies
 - Managing dependencies (updating, garbage collection, etc.)
 - Making modular sub-builds
 - Running tests on compiled code
 - Performing version control

While the inner workings of a build system may be quite complex, for most smaller projects they are very simple to use.

## Ford Features

In this section we cover the main features of the Ford build system that distinguish it from other build systems. We do not yet speak of how they are implemented, which will be covered to some extent later in the lesson. We also remind you that Ford has additional capabilities that are not covered in this lesson.

The main features of Ford that distinguish it from most build systems that we wish to emphasize in this section are the following:

 - Ford is strongly and dynamically typed
 - Ford is monadic
 - Ford is referentially transparent
 - Ford can do live builds
 - Ford keeps a cache of previous builds

 To some extent these features overlap depending on how you split hairs. If you are already familiar with build systems, know that the capabilities of Ford are similar to those of [Shake](https://shakebuild.com/) and [Nix](https://nixos.org/nix/), but still differs from them in some key aspects.

 We will also give an overview of how to use Ford for unit testing, as that is what we will be doing in the following lesson.


### Strongly and Dynamically Typed

Ford is a typed build system. The short version of what this means is that Ford cares about Arvo marks and Hoon types, and will fail to build if the marks and types do not satisfy certain restrictions. This guarantees to some level that the built software will work, though of course you can never completely guarantee that software will work as expected due to things such as bugs.

Recall that a mark such as `%foo` acts as metadata which tells Arvo vanes what kind of file it is working with. In the context of Ford, they may be thought of as being analogous to file types in other operating systems. When an Arvo vane sees marked data, it expects that data to take a certain shape, and verifying that that data is in the expected shape is a task performed by Ford.

In fact, it is important to emphasize that the Arvo kernel does not actually know what marks are. Ford is the vane that knows what marks are, and whenever the kernel or another vane needs to know what a mark means, it asks Ford.

Ford is also responsible for converting marked data to another mark. This is a task that is frequently performed during a build, but also is something that other vanes may request Ford to do.

Ford is dynamically typed in the sense that types of builds are not known a priori and are computed dynamically in the course of the build. It is strongly typed in the sense that it is typesafe and the result of a build always has a known type, as do all of the sub-builds that went into it.

### Monadic

That Ford is a monadic build system essentially means that dependencies are generated dynamically as the build proceeds, as a opposed to the list of dependencies being a static value that is input manually, such as with `make`. There are no downsides to this over the alternative, which are known as applicative build systems.

### Referentially transparent

Ford is [referentially transparent](https://en.wikipedia.org/wiki/Referential_transparency). The exact meaning of this depends on who you ask, but for us it means that one may replace a reference to a build (which in Ford's case is something known as a schematic, see below) with the result of that build without changing the output of the overall build. What this ultimately means is that builds are deterministic, and so the same build of the same source files will produce the same output every time. Put another way, the output is a pure function of the input. If you've never dealt with build systems before, the idea that things could work any other way may sound absurd!

For a typical applicative build system, such as `make`, the build instructions contain a static list of dependencies. These dependencies may or may not be written with a restriction on a particular version, and even for a fixed version number there may still be multiple builds for any number of reasons (like poor version control practices). For example, you may run a build with a package with `make` that has `gizmo` named as a dependency, with no version restriction. On one system, you may have `gizmo` v1.0 installed, while on another you may have `gizmo` 1.1 installed. The build system makes no distinction between these versions - all it sees is that it needs `gizmo`, and pays no attention to the version. Thus, building the same source files with the same build instructions on two different system may result in two slightly different outputs.

One might instead call Ford purely functional instead of (or in addition to) referentially transparent. The exact meaning of this terminology differs from source to source and how many hairs you want to split, but the general notion that one may replace Hoon expressions by their product without changing the output of the build is true.

### Cache

Ford saves much of what it builds in a cache. Whenever Ford generates a dependency for a build, it checks the cache to see if it has already built that dependency before. If so, because Ford is referentially transparent, the result of that build can be put directly into the current build. No rebuilding necessary.

The primary reason for this feature is that it saves time - building large projects can take hours or more.

The cache is somewhat analogous to the Nix store in functionality, but is quite different in terms of implementation. How the cache works is by far the most complex part of Ford, but this internal complexity ultimately results in simplicity for the software engineer.

Ford does not save _everything_ it has ever built forever, but instead applies a heuristic to determine what build results to hold onto. An example of such a heuristic is "LRU caching", and Ford does something similar to this.

### Live Builds

Ford is capable of live builds. This means that Ford can subscribe to a Clay desk containing some source code for something Ford has built before, and whenever that source code is updated Ford will automatically rebuild the project.

It is important for us to note that Ford is _not_ used to build vanes. Vanes are compiled from the raw source code by the Arvo kernel.

## Using Ford

Having covered the distinctive features of Ford, we now dive into some of the specifics on how these features are implemented. Let us first cover some of most important types of data we will run into, and then discuss the most frequently used [arm](/docs/glossary/arm/)s.

### Data types

#### Vase

From `hoon.hoon`:
```hoon
+$  vase  [p=type q=*]
```
A `vase` is simply typed data, and it is used wherever typed data is being explicitly worked with.

#### Cage

From `arvo.hoon`, a `cage` is a `[mark vase]` - so its just typed data that is also marked for usage by Arvo.

#### Schematics

A `schematic`, found in `zuse.hoon`, is a set of build instruction for Ford. It is a recursive data structure, in that a schematic may itself consist of additional schematics. Schematics have 25 subtypes corresponding to possible basic build instructions. The product of a `schematic` is a `cage`.

Some examples of subtypes include:
 - `%list` - a list of schematics to build.
 - `%core` - a Clay path to a Hoon source file to build.
 - `%call` - a schematic consisting of two sub-schematics, one of which produces a [gate](/docs/glossary/gate/) and a second that produces a sample. It then runs the [gate](/docs/glossary/gate/) on the sample, producing a vase of the result, tagged with the mark `%noun`.
 - `%scry` - look up a value from the Urbit namespace.

 Schematics are only ever sent to Ford by another vane. Userspace apps do not directly create schematics.

### Ford runes

Ford runes, which all begin with `/`, are instructions for Ford typically written at the top of a source file. Ford runes instruct Ford to perform actions such as scraping through directories and grabbing files from Clay.

The most common pattern you are likely to see is a sequence of Ford runes at the top of a Hoon source file that imports the results of evaluating other Hoon files. This is like importing a library in any other build system. The way this works in Hoon is that the result of compiling a named Hoon source file is added to the current subject, possibly with a face.

The rune interpreter is most complicated part of `ford.hoon` after the cache. But again, thankfully for us, most of the commonly used runes are straightforward. We cover a few of them here.

#### `/+` import from `lib/`

The `/+` rune accepts a filename as an argument. It interprets that filename as a hoon source file within the `lib` directory. This is how we import a shared library in urbit.

To run this example, put this code in your desk at `gen/faslus.hoon` and run `+faslus` in your dojo.

```hoon
/+  time-to-id
::
:-  %say
|=  {{now/@da * *} $~ $~}
:-  %noun
(time-to-id now)
```

produces: `"c.314d"` (or something similar depending on when you run it).

You can import multiple libraries with a single `/+` rune by separating them with commas.

Replace the code in `gen/faslus.hoon` with the following:

```hoon
/+  time-to-id, hep-to-cab
::
:-  %say
|=  {{now/@da * *} $~ $~}
:-  %noun
=/  id  (time-to-id now)
=/  str  "my-id-is-{id}"
(hep-to-cab (crip str))
```

This should print something like `my_id_is_c.3588`.

Another feature of the `/+` rune (and `/-` below) is the ability to specify the ship and case from which to load the library.

Example:

```hoon
/+  time-to-id, hep-to-cab/4/~zod
```
will load the `hep-to-cab` library from `~zod` at `%clay` revision `4`.

#### `/-` import from `sur/`

The `/-` rune accepts a filename as an argument. It interprets that filename as a hoon source file within the `sur` directory. The `sur` directory contains shared structures that can be used by other parts of urbit. This is somewhat similar to including a header file in C.

Example:

```hoon
/-  talk
::
*serial:talk
```

produces: `0v0`

`/-` can also take multiple files as arguments, and the ship and case of those arguments can be specified. See the `/+` docs for more details about the syntax for those features.

### Testing

Ford is the vane utilized for unit testing, which are the the simplest sort of test one may perform on software that is one step removed from manual testing. Ford itself does not have testing capabilities built in, rather Ford has a more general capability known as _rendering_ which is utilized by the `+test` generator to perform the tests. The walkthrough which follows this lesson goes into more detail.

One typically tests software by feeding it inputs and seeing if the outputs matches what is expected (something that is determined manually by the engineer). Unit tests work with only a single "module" at a time. What exactly is meant by this is shown by example in the following walkthrough, but for now it suffices to say that unit tests are in contrast with larger scale tests variously known as end-to-end tests, system tests, and integration tests.
