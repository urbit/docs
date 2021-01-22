+++
title = "Pill"

template = "doc.html"
[extra]
category = "arvo"
+++

A **Pill** is a bootstrap sequence to launch an Urbit ship for the first time. The [event log](../eventlog) begins with the bootstrap sequence of a Pill.

A Pill consists of three ordered lists:
 * A list of events which are interpreted by Nock to create an [Arvo](../arvo) kernel.
 * A list of Arvo events to run once the Arvo kernel is created.
 * A list of userspace events to run once the Arvo events have been run. Currently, this consists of setting up the [Clay](../clay) file system.
