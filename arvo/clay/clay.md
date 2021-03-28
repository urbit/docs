+++
title = "Overview"
weight = 1
template = "doc.html"
aliases = ["/docs/learn/arvo/clay/"]
+++


Our filesystem.

`%clay` is version-controlled, referentially-transparent, and global.
While this filesystem is stored in `%clay`, it is mirrored to Unix for
convenience. Unix tells `%clay`s whenever a file changes in the Unix
copy of the filesystem so that the change may be applied. `%clay` tells
unix whenever an app or vane changes the filesystem so that the change
can be effected in Unix. Apps and vanes may use `%clay` to write to the
filesystem, query it, and subscribe to changes in it. Ford and gall use
`%clay` to serve up apps and web pages.

`%clay` includes three components. First is the filesystem/version
control algorithms, which are mostly defined in `++ze` and `++zu` in
zuse. Second is the write, query, and subscription logic. Finally, there
is the logic for communicating requests to, and receiving requests from,
foreign ships.

Clay documentation is extensive, but the reader much tread carefully as portions
of it are out of date as of March 2021. We are actively working on updating
them. If you'd like to help, please reach out to us in the Docs channel on Urbit
Community or submit a PR at
[https://github.com/urbit/docs](https://github.com/urbit/docs).

### User documentation

[Filesystem](@/using/os/filesystem.md)

How to interact with the Clay filesystem via Dojo. This includes basics such as
mounting to Unix, changing directory, merging, and listing files.

### Developer Documentation

[Architecture](@/docs/arvo/clay/architecture.md)

A conceptual overview of how Clay was designed. (Up to date as of March 2021)

[Using Clay](@/docs/arvo/clay/using.md)

A quick overview of how the most common tasks involving Clay are performed:
reading and subscribing, syncing to Unix, and merging.

[Data Types](@/docs/arvo/clay/data-types.md)

Explanations of the many data types found throughout Clay.

[Local Reads and Writes](@/docs/arvo/clay/local-reads.md)

How local reads and writes work.

[Local Subscriptions](@/docs/arvo/clay/local-sub.md)

How local subscriptions work.

[Foreign Requests](@/docs/arvo/clay/foreign.md)

How foreign reads and subscriptions work.
