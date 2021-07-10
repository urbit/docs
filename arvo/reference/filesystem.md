+++
title = "Filesystem Hierarchy"
weight = 20
template = "doc.html"
+++

Here we describe what each of the primary folders present in the `%home` `desk`
are used for. This organization is merely a convention, and the exact location
of any file does not affect its operation. That being said, some [Ford
runes](@/docs/arvo/ford/ford.md) are designed with this structure in mind, and
applications such as dojo look in specific folders for code to run. Furthermore,
this organization is not perfectly adhered to - sometimes you may find structure
definitions in `/lib`, for example.

 - `/app` contains userspace applications, i.e. [Gall
   agents](@/docs/userspace/gall/gall.md).
 - `/gen` contains generators. Many applications make use of generators, but
   also each generator in this folder may be run from dojo using `+`. For
   example, `/gen/foo/hoon` is run with `+foo`.
 - `/lib` contains libraries that may be shared by multiple agents, threads,
   generators, etc. However, this is not the location of the standard libraries
   (see `/sys`). Libraries are imported from `/lib` with `/+`.
 - `/mar` contains [mark](@/docs/arvo/clay/architecture.md#marks) definitions.
 - `/sur` contains shared [structure](@/docs/hoon/reference/rune.md) definitions.
   Whenever you expect structures to be used by code across multiple files, it
   is recommended to place their shared structures in `/sur`. Structures are
   imported from `/sur` with `/-`.
 - `/sys` contains the code that defines the kernel and standard libraries.
   `/sys/vane` contains the code for the vanes, aka kernel modules. `/sys` is
   the exception to the rule - structures and functions that are central to
   Hoon, Arvo, and its vanes, are all located within this folder rather than in
   `/lib` and `/sur`. See [below](#sys) for more information on `/sys`.
 - `/ted` contains [threads](@/docs/userspace/threads/overview.md). These may be
   run from dojo using `-`. For example, `/ted/foo/hoon` is run with `-foo`.
 - `/tests` contains unit tests intended to be run using the `test` thread. To
   run a particular test `+test-bar` in `/tests/foo.hoon` in dojo, enter `-test
   %/tests/foo/test-bar ~`. If a file is specified, every test in that file will
   run. If a folder is specified, every test in that folder will run.
   
   
## `/sys` {#sys}

`/sys` contains four files: `hoon.hoon`, `arvo.hoon`, `lull.hoon`, and
`zuse.hoon`. These are the files used to construct kernelspace. The chain of
dependencies is `hoon.hoon` -> `arvo.hoon` -> `lull.hoon` -> `zuse.hoon`. We
give a brief description of each of them.
 - `hoon.hoon` contains the Hoon compiler and the [Hoon standard
   library](@/docs/hoon/reference/stdlib/table-of-contents.md). The Hoon
   compiler is self-hosted. This is the first file loaded by the Nock virtual
   machine, [Vere](@/docs/vere/runtime.md), in order for it to learn how to
   interpret Hoon. The kelvin version number is the subject of `hoon.hoon`,
   currently at 140. One may see this from dojo by inspecting the subject with
   `.` and noting that `%140` is the final entry of the subject.
 - `arvo.hoon` contains the [Arvo kernel](@/docs/arvo/overview.md) and
   additional structures and functions directly relevant to the kernel. This is
   Urbit's "traffic cop", and as such contains the structure definitions for
   call stacks such as `duct`s and `bone`s. Once Vere understands Hoon, it loads
   and interprets `arvo.hoon` to create the kernel. `hoon.hoon` is the subject
   of `arvo.hoon`.
 - `lull.hoon` primarily contains structures shared among the kernel and its
   vanes, as well as a few functions. In particular, this includes the
   definitions of the `card`s utilized by each vane, each of which are
   documented in their respective documentation. `lull.hoon` is loaded by the
   kernel during the [larval stage](@/docs/arvo/overview.md#larval-stage-core)
   in order to prepare to create the vanes. `arvo.hoon` is the subject of `lull.hoon`.
 - `zuse.hoon` is the Arvo standard library. It consists primarily of functions
   shared by the kernel and vanes, such as the ones related to
   [cryptography](@/docs/arvo/reference/cryptography.md). `zuse.hoon` is loaded
   by the larval kernel following `lull.hoon`. `lull.hoon` is the subject of
   `zuse.hoon`. Then `zuse` is the subject of the vanes.
   
