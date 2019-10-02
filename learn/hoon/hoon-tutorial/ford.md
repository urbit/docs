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

In this section we cover the main features that distinguish Ford from other build systems. We do not yet speak of how they are implemented, which will be covered to some extent later in the lesson.

The main features of Ford that distinguish it from most build systems that we wish to emphasize in this section are the following:

 - Ford is strongly and dynamically typed
 - Ford is monadic
 - Ford is purely functional
 - Ford can do live builds
 - Ford keeps a cache of previous builds

 To some extent these features overlap depending on how you split hairs. If you are already familiar with build systems, know that the capabilities of Ford are similar to those of [Shake](https://shakebuild.com/) and [Nix](https://nixos.org/nix/), but still differs from them in some key aspects.

 We will also give an overview of Ford's testing suite, as that is the main thrust of the Ford walkthrough following this lesson.


### Strongly and Dynamically Typed

### Monadic

### Purely functional

Like every aspect of Urbit, Ford is purely functional. What this means for a build system is that builds produce no side effects, and so the same build ran on the same source files will produce the same output every time. If you've never dealt with build systems before, the idea that things could work any other way may sound absurd! But the reason depends on a subtletly of what one considers to be the "input" (I think?)

For a typical build system, such as `make`, the build instructions contain a list of dependencies. These dependencies may or may not be written with a restriction on a particular version, and even for a fixed version number there may still be multiple builds for any number of reasons (like poor version control practices). For example, you may run a build with a package with `make` that has `gizmo` named as a dependency, with no version restriction. On one system, you may have `gizmo` v1.0 installed, while on another you may have `gizmo` 1.1 installed. The build system makes no distinction between these versions - all it sees is that it needs `gizmo`, and pays no attention to the version. Thus, building the same source files with the same build instructions on two different system may result in two slightly different outputs.



### Live Builds

## Using Ford

### Ford runes

### Building

### Testing
