+++
title = "Architecture"
weight = 2
template = "doc.html"
+++

Clay is the primary filesystem for the [Arvo](@/docs/arvo/overview.md) operating system,
which is the [core](/docs/glossary/core/) of an urbit. The architecture of Clay is
intrinsically connected with Arvo, but for this section we assume no knowledge of
either Arvo or Urbit. We will point out only those features of
Arvo that are necessary for an understanding of Clay, and we will
do so only when they arise.

The first relevant feature of Arvo is that it is a deterministic
system where input and output are defined as a series of events
and effects. The state of Arvo is simply a pure function of its event
log. None of the effects from an event are emitted until the
event is entered in the log and persisted, either to disk or
another trusted source of persistence, such as a Kafka cluster.
Consequently, Arvo is a single-level store: everything in its
state is persistent.

In a more traditional OS, everything in RAM can be erased at any
time by power failure, and is always erased on reboot. Thus, a
primary purpose of a filesystem is to ensure files persist across
power failures and reboots.  In Arvo, both power failures and
reboots are special cases of suspending computation, which is
done safely since our event log is already persistent. Therefore,
Clay is not needed in Arvo for persistence. Why, then, do we have a
filesystem? There are two answers to this question.

First, Clay provides a filesystem tree, which is a convenient
user interface for some applications. Unix has the useful concept
of virtual filesystems, which are used for everything from direct
access to devices, to random number generators, to the /proc
tree. It is easy and intuitive to read from and write to a
filesystem tree.

Second, Clay has a distributed revision-control system baked into
it.  Traditional filesystems are not revision controlled, so
userspace software -- such as git -- is written on top of them to
do so. Clay natively provides the same functionality as modern
DVCSes, and more.

Clay has two other unique properties that we'll cover later on:
it supports typed data and is referentially transparent.

### Revision Control

Every urbit has one or more `desk`s, which are independently
revision-controlled branches. Each `desk` contains its own `mark`
definitions, apps, and so forth.

Traditionally, an urbit has at least a `%home` `desk` and `%kids` `desk`. The
`%home` `desk` has all the system software from the distribution, along with your
personal files. The `%home` `desk` is a fork of the `%kids` desk of whichever ship
you download [OTAs](@/docs/glossary/ota-updates.md) from - typically your sponsor,
but theoretically may be any ship. You will also find references to a `%base`
`desk` - which is not a real `desk`, rather it just a hash associated to the
`desk` from which your `%home` `desk` was forked.

A `desk` is a series of numbered commits, the most recent of which
represents the current state of the `desk`. A commit is composed of
(1) an absolute time when it was created, (2) a list of zero or
more parents, and (3) a map from paths to data.

Most commits have exactly one parent, but the initial commit on a
`desk` may have zero parents, and merge commits have more than one
parent.

The non-metadata is stored as a `map` of `path`s to data. It's
worth noting that no constraints are put on this `map`, so, for
example, both `/a/b` and `/a/b/c` could have data. This is impossible
in a traditional Unix filesystem since it means that `/a/b` is both
a file and a directory. Conventionally, the final element in the
path is its `mark` -- much like a filename extension in Unix. Thus,
`/doc/readme.md` in Unix is stored as `/doc/readme/md` in urbit.

The data is not stored directly in the `map`; rather, a hash of the
data is stored, and we maintain a master blob store. Thus, if the
same data is referred to in multiple commits (as, for example,
when a file doesn't change between commits), only the hash is
duplicated.

In the master blob store, we either store the data directly, or
else we store a diff against another blob. The hash is dependent
only on the data within and not on whether or not it's stored
directly, so we may on occasion rearrange the contents of the
blob store for performance reasons.

Recall that a `desk` is a series of numbered commits. Not every
commit in a `desk` must be numbered. For example, if the base `desk`
has had 50 commits since home was forked from it, then a merge
from base to home will only add a single revision number to home,
although the full commit history will be accessible by traversing
the parentage of the individual commits.

We do guarantee that the first commit is numbered 1, commits are
numbered consecutively after that (i.e. there are no "holes"),
the topmost commit is always numbered, and every numbered commit
is an ancestor of every later numbered commit.

There are three ways to refer to particular commits in the
revision history.  Firstly, one can use the revision number.
Secondly, one can use any absolute time between the one numbered
commit and the next (inclusive of the first, exclusive of the
second). Thirdly, every `desk` has a `map` of labels to revision
numbers. These labels may be used to refer to specific commits.

Additionally, Clay is a global filesystem, so data on other urbits
is easily accessible the same way as data on our local urbit.  In
general, the path to a particular revision of a `desk` is
`/~urbit-name/desk-name/revision`.  Thus, to get `/try/readme/md`
from revision 5 of the home `desk` on `~sampel-sipnym`, we refer to
`/~sampel-sipnym/home/5/try/readme/md`.  Clay's namespace is thus
global and referentially transparent.

### A Typed Filesystem

Since Clay is a general filesystem for storing data of arbitrary
types, in order to revision control correctly it needs to be
aware of types all the way through.  Traditional revision control
does an excellent job of handling source code, so for source code
we act very similar to traditional revision control. The
challenge is to handle other data similarly well.

For example, modern VCSs generally support "binary files", which
are files for which the standard textual diffing, patching, and
merging algorithms are not helpful. A "diff" of two binary files
is just a pair of the files, "patching" this diff is just
replacing the old file with the new one, and "merging"
non-identical diffs is always a conflict, which can't even be
helpfully annotated. Without knowing anything about the structure
of a blob of data, this is the best we can do.

Often, though, "binary" files have some internal structure, and
it is possible to create diff, patch, and merge algorithms that
take advantage of this structure. An image may be the result of a
base image with some set of operations applied. With algorithms
aware of this set of operations, not only can revision control
software save space by not having to save every revision of the
image individually, these transformations can be made on parallel
branches and merged at will.

Suppose Alice is tasked with touching up a picture, improving the
color balance, adjusting the contrast, and so forth, while Bob
has the job of cropping the picture to fit where it's needed and
adding textual overlay.  Without type-aware revision control,
these changes must be made serially, requiring Alice and Bob to
explicitly coordinate their efforts. With type-aware revision
control, these operations may be performed in parallel, and then
the two changesets can be merged programmatically.

Of course, even some kinds of text files may be better served by
diff, patch, and merge algorithms aware of the structure of the
files. Consider a file containing a pretty-printed JSON object.
Small changes in the JSON object may result in rather significant
changes in how the object is pretty-printed (for example, by
addding an indentation level, splitting a single line into
multiple lines).

A text file wrapped at 80 columns also reacts suboptimally with
unadorned Hunt-McIlroy diffs. A single word inserted in a
paragraph may push the final word or two of the line onto the
next line, and the entire rest of the paragraph may be flagged as
a change. Two diffs consisting of a single added word to
different sentences may be flagged as a conflict. In general,
prose should be diffed by sentence, not by line.

As far as we are aware, Clay is the first generalized,
type-aware revision control system.  We'll go into the workings
of this system in some detail.

### Marks

Central to a typed filesystem is the idea of types. In Clay, we
call these `mark`s. A `mark` is a file that defines a type,
conversion routines to and from the `mark`, and diff, patch, and
merge routines.

For example, a `%txt` mark may be a list of lines of text, and it
may include conversions to `%mime` to allow it to be serialized
and sent to a browser or to the Unix filesystem. It will also
include Hunt-McIlroy diff, patch, and merge algorithms.

A `%json` `mark` would be defined as a JSON object in the code, and
it would have a parser to convert from `%txt` and a printer to
convert back to `%txt`. The diff, patch, and merge algorithms are
fairly straightforward for JSON, though they're very different
from the text ones.

More formally, a `mark` is a core with three [arms](/docs/glossary/arm/): `+grab`,
`+grow`, and `+grad`. In `+grab` is a series of functions to
convert from other `mark`s to the given `mark`.  In `+grow` is a
series of functions to convert from the given `mark` to other
`mark`s. In `+grad` is `+diff`, `+pact`, `+join`, and `+mash`, and
`+form`.

The types are as follows, in an informal pseudocode:

```
    ++  grab:
      ++  mime: <mime> -> <mark-type>
      ++  txt: <txt> -> <mark-type>
      ...
    ++  grow:
      ++  mime: <mark-type> -> <mime>
      ++  txt: <mark-type> -> <txt>
      ...
    ++  grad
      ++  form: <mark-type>
      ++  diff: (<mark-type>, <mark-type>) -> <diff-type>
      ++  pact: (<mark-type>, <diff-type>) -> <mark-type>
      ++  join: (<diff-type>, <diff-type>) -> <diff-type> or NULL
      ++  mash: (<diff-type>, <diff-type>) -> <diff-type>
```

These types are basically what you would expect. Not every `mark`
has each of these functions defined -- all of them are optional
in the general case.

In general, for a particular `mark`, the `+grab` and `+grow` entries
(if they exist) should be inverses of each other.

In `+grad`, `+diff` takes two instances of a `mark` and produces a diff of them
whose `mark` is given by `+form`. `+pact` takes an instance of a `mark` and
patches it with the given diff. `+join` takes two diffs and attempts to merge
them into a single diff. If there are conflicts, it produces null. `+mash` takes
two diffs and forces a merge, annotating any conflicts.

In general, if `+diff` called with A and B produces diff D, then
`+pact` called with A and D should produce B. Also, if `+join`
of two diffs does not produce null, then `+mash` of the same
diffs should produce the same result.

Alternately, instead of `+diff`, `+pact`, `+join`, and
`+mash`, a `mark` can provide the same functionality by defining
`+grad` to be the name of another `mark` to which we wish to
delegate the revision control responsibilities. Then, before
running any of those functions, Clay will convert to the other
`mark`, and convert back afterward. For example, the `%hoon` `mark`
is revision-controlled in the same way as `%txt`, so its `+grad`
is simply `++  grad  %txt`. Of course, `+txt` must be defined in
`+grow` and `+grab` as well.

Every file in Clay has a `mark`, and that `mark` must have a
fully-functioning `+grad`. `Mark`s are used for more than just
Clay, and other `mark`s don't need a `+grad`, but if a piece of
data is to be saved to Clay, we must know how to revision-control
it.

Additionally, if a file is to be synced out to Unix, then it must
have conversion routines to and from the `%mime` `mark`.

