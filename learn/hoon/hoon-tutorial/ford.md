+++
title = "Ford"
weight = 0
template = "doc.html"
+++

# Ford

This lesson introduces the basics of the Ford vane, Arvo's build system and computation engine.

In terms of sheer size, Ford is Arvo's largest vane, weighing in at over 6000 lines of code at the time of writing. As a result, we will only be scratching the surface of Ford in this lesson. In particular, we will solely be focused on the build system aspect of Ford, and leave its other capabilities alone.

## Build systems

You may consider skipping the following section if you are quite familiar with build systems, but be warned that Ford has several key features that distinguish it from most other build systems.

### What are build systems?
At a high level, build systems are software that builds other software from source files. How this is accomplished varies from build system to build system, but there are some general properties shared by almost everything in this category.

The primary output of a build system, the final binary known as a _build_, comes from two inputs: (1) source files, and (2) build instructions. Analogous to building a house, you could think of these as corresponding to raw materials and architectural blueprints. The build system calls the compiler (typically a separate piece of software) on each source file, which you may think of as shaping the raw materials something suitable for the final product. The compiled source files are then put together according to the build instructions.

Besides the primary task of building software outlined above, build systems also typically handle some or all of the following responsibilities:
 - Resolving dependencies
 - Downloading dependencies
 - Managing dependencies (updating, garbage collection, etc.)
 - Running tests on compiled code
 - Performing version control

 Build systems typically require a set of instructions giving the skeleton of how the pieces of the program fit together and what outside libraries it depends on. The build system fleshes out the skeleton and then executes it.