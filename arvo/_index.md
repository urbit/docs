+++
title = "Arvo"
weight = 300
sort_by = "weight"
template = "sections/docs/chapters.html"
aliases = ["/docs/learn/arvo/"]
+++

Resources about the Urbit OS.

## [Overview](@/docs/arvo/overview.md)

Arvo is Urbit's functional operating system, written in [Hoon](@/docs/hoon/hoon-school/_index.md). It's composed of modules called _vanes_, each of which has its own folder:

## [Ames](@/docs/arvo/ames/ames.md)

Ames is the name of our network and the vane that communicates over it. It's an encrypted P2P network composed of instances of the Arvo operating system.

## [Behn](@/docs/arvo/behn/behn.md)

Behn is our timer. It allows vanes and applications to set and timer events, which are managed in a simple priority queue.

## [Clay](@/docs/arvo/clay/clay.md)

Clay is our filesystem and revision-control system.

## [Dill](@/docs/arvo/dill/dill.md)

Dill is our terminal driver. Unix sends keyboard events to dill from the terminal, and dill produces terminal output.

## [Eyre](@/docs/arvo/eyre/eyre.md)

Eyre is our HTTP server. Unix sends HTTP messages to `%eyre`, and `%eyre` produces HTTP messages in response.

## [Ford](@/docs/arvo/ford/ford.md)

Ford is our build system. It handles resources and publishing.

## [Gall](@/docs/arvo/gall/overview.md)

Gall is the vane for controlling userspace apps.

## [Iris](@/docs/arvo/iris/iris-api.md)

Iris is our HTTP client.

## [Concepts](@/docs/arvo/concepts/_index.md)

Explanations of design decisions that are pervasive throughout Arvo.

## [Tutorials](@/docs/arvo/tutorials/_index.md)

Walkthroughs that teach you more about how Arvo works.


