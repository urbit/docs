+++
title = "Ford"
weight = 0
template = "doc.html"
+++

# Ford

This lesson introduces the basics of the Ford vane, Arvo's build system and computation engine.

In terms of sheer size, Ford is Arvo's largest vane, weighing in at over 6000 lines of code at the time of writing. As a result, we will only be scratching the surface of Ford in this lesson. In particular, we will solely be focused on the build system aspect of Ford, and leave its other capabilities alone.

## What are build systems?

You may safely skip this section if you are familiar with build ystems, as there is no Ford-specific information.

At a high level, build systems are software that builds other software from source files. How this is accomplished varies from build system to build system, but there are some general properties shared by almost everything in this category.

The primary output of a build system, the final binary known as a _build_, comes from two inputs: (1) source files, and (2) build instructions. Analogous to building a house, you could think of these as corresponding to raw materials and architectural blueprints. The build system calls the compiler (typically a separate piece of software) on each source file, which you may think of as shaping the raw materials something suitable for the final product. The compiled source files are then put together according to the build instructions.

The number of languages a build system is designed to work with varies, from specialized build systems that focus on a single language (like Ford) to general purpose ones that could conceivably work for any language and frequently rely on other build systems to function (such as [make](https://en.wikipedia.org/wiki/Make_(software))).

Source files frequently have _dependencies_, which are other source files or compiled code they depend on to run. Much of the work of a build system goes into determining dependencies.

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

In this section we cover the main features of the Ford build system that distinguish itfrom other build systems. We do not yet speak of how they are implemented, which will be covered to some extent later in the lesson. We also remind you that Ford has additional capabilities that are not covered in this lesson.

The main features of Ford that distinguish it from most build systems that we wish to emphasize in this section are the following:

 - Ford is strongly and dynamically typed
 - Ford is monadic
 - Ford is purely functional
 - Ford can do live builds
 - Ford keeps a cache of previous builds

 To some extent these features overlap depending on how you split hairs. If you are already familiar with build systems, know that the capabilities of Ford are similar to those of [Shake](https://shakebuild.com/) and [Nix](https://nixos.org/nix/), but still differs from them in some key aspects.

 We will also give an overview of Ford's testing suite, as that is the main thrust of the Ford walkthrough following this lesson.


### Strongly and Dynamically Typed

Ford is a typed build system. The short version of what this means is that Ford cares about Arvo marks and Hoon types, and will fail to build if the marks and types do not satisfy certain restrictions that guarantee working software.

Recall that a mark is a unit type such as `%foo` that acts as metadata telling Arvo what kind of file it is looking it. In the context of Ford, they may be thought of as being analogous to file types in other operating systems.

### Monadic dependencies

I still don't quite understand what is meant by this and how it is interrelated to being purely functional, having live builds, dynamic dependencies, etc. I think these might all be consequences of being monadic? But do any of these properties imply monadicity?

### Purely functional

Like every aspect of Urbit, Ford is purely functional. What this means for a build system is that builds produce no side effects, and so the same build ran on the same source files will produce the same output every time. If you've never dealt with build systems before, the idea that things could work any other way may sound absurd! But the reason depends on a subtletly of what one considers to be the "input" (I think?)

For a typical build system, such as `make`, the build instructions contain a list of dependencies. These dependencies may or may not be written with a restriction on a particular version, and even for a fixed version number there may still be multiple builds for any number of reasons (like poor version control practices). For example, you may run a build with a package with `make` that has `gizmo` named as a dependency, with no version restriction. On one system, you may have `gizmo` v1.0 installed, while on another you may have `gizmo` 1.1 installed. The build system makes no distinction between these versions - all it sees is that it needs `gizmo`, and pays no attention to the version. Thus, building the same source files with the same build instructions on two different system may result in two slightly different outputs.

The chief advantage of being purely functional is that Ford builds are reproducible and dependency hell is averted. Ford accomplishes this as builds do not have a static list of dependencies, that is, they are not known a priori. Instead the dependencies are dynamically generated as the build proceeds, and sub-builds are generated for these dependencies and saved in the cache.

One might instead call Ford [referentially transparent](https://en.wikipedia.org/wiki/Referential_transparency) instead of (or in addition to) purely functional. The exact meaning of this terminology differs from source to source and how many hairs you want to split, but the general notion that one may replace Hoon expressions by their value without changing the output of the build is true.

### Cache

Ford saves everything it has ever built in a cache. Whenever Ford generates a dependency for a build, it checks the cache to see if it has already built that dependency before. If so, because Ford is purely functional, the result of that build can be put directly into the current build. No rebuilding necessary.

The primary reason for this feature is that it saves time - building large projects can take hours or more.

The cache is somewhat analogous to the Nix store in functionality, but is quite different in terms of implementation. How the cache works is by far the most complex part of Ford, but this internal complexity ultimately results in simplicity for the software engineer, as it solves the problem of dependency hell.

### Live Builds

## Using Ford

### Schematics

### Scaffolds

### Ford runes

Ford runes, which all begin with `/`, are instructions for Ford typically written at the top of a source file. Ford runes instruct Ford to perform actions such as scraping through directories and grabbing files from Clay.

The most common pattern you are likely to see is a sequence of Ford runes at the top of a Hoon source file that imports the results of evaluating other Hoon files. This is like importing a library in any other build system. The way this works in Hoon is that the result of compiling a named Hoon source file is added to the current subject, possibly with a face.

The rune interpreter is most complicated part of `ford.hoon` after the cache. But again, thankfully for us, most of the commonly used runes are straightforward. We cover a few of them here.

#### `/+` import from `lib/`

(this is copied directly from `arvo/ford.md`)

The `/+` rune accepts a filename as an argument. It interprets that filename as a hoon source file within the `lib` directory. This is how we import a shared library in urbit.

To run this example, put this code in your desk at `gen/faslus.hoon` and run `+faslus` in your dojo.

```
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

```
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

Another feature of the `/+` and `/-` runes is the ability to specify the ship and case from which to load the library.

Example:

```
/+  time-to-id, hep-to-cab/4/~zod
```

will load the `hep-to-cab` library from `~zod` at `%clay` revision `4`.

#### `/-` import from `sur/`

The `/-` rune accepts a filename as an argument. It interprets that filename as a hoon source file within the `sur` directory. The `sur` directory contains shared structures that can be used by other parts of urbit. This is somewhat similar to including a header file in C.

Example:

```
/-  talk
::
*serial:talk
```

produces: `0v0`

`/-` can also take multiple files as arguments, and the ship and case of those
arguments can be specified. See the `/+` docs for more details about the syntax
for those features.

### Mark conversion

### Building

### Testing
