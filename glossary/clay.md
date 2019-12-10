+++
title = "Clay"

template = "doc.html"
[extra]
category = "arvo"
+++

**Clay** is the filesystem and typed revision-control [vane](../filesystem). It can be thought of as a continuously synced git. Clay handles file-change events and maps them from [Arvo](../arvo) to Unix and vice versa.

A common way to use Clay is to create a pier, a directory that exists in and is visible in Unix. Changes are automatically recorded from Urbit to the Unix directory and vice versa. Just set it and forget it!

Clay is located at `/home/sys/vane/clay.hoon` within Arvo.

### Further Reading

- [Using Your Ship](@/using/operations/using-your-ship.md#filesystem): A user guide that includes instructions on using Clay.  
- [The Clay tutorial](@/docs/tutorials/arvo/clay.md): An technical guide to the Clay vane.
