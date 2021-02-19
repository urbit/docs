+++
title = "Arvo"
weight = 1
sort_by = "weight"
template = "sections/docs/chapters.html"
aliases = ["/docs/learn/arvo/"]
+++

## [Arvo](@/docs/arvo/arvo.md)

Arvo is Urbit's functional operating system, written in [Hoon](@/docs/hoon/hoon-school/_index.md). It's composed of modules called _vanes_:

## Vanes

### [Ames](@/docs/arvo/ames/ames.md)

Ames is the name of our network and the vane that communicates over it. It's an encrypted P2P network composed of instances of the Arvo operating system.

### [Behn](@/docs/arvo/behn/behn.md)

Behn is our timer. It allows vanes and applications to set and timer events, which are managed in a simple priority queue.

### [Clay](@/docs/arvo/clay/clay.md)

Clay is our filesystem and revision-control system.

### [Dill](@/docs/arvo/dill/dill.md)

Dill is our terminal driver. Unix sends keyboard events to dill from the terminal, and dill produces terminal output.

### [Eyre](@/docs/arvo/eyre/eyre.md)

Eyre is our HTTP server. Unix sends HTTP messages to `%eyre`, and `%eyre` produces HTTP messages in response.

### [Ford](@/docs/arvo/ford/ford.md)

Ford is our build system. It handles resources and publishing.

### [Gall](@/docs/arvo/gall/gall.md)

Gall is the vane for controlling userspace apps.

### Iris

Iris is our HTTP client.

## [Move trace tutorial](@/docs/arvo/move-trace.md)

A walkthrough of what the Arvo kernel does to respond to a simple command.

