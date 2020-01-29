+++
title = "Clay"
weight = 4
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

## Architecture

Clay is the primary filesystem for the arvo operating system,
which is the [core](/docs/glossary/core/) of an urbit. The architecture of clay is
intrinsically connected with arvo, but we assume no knowledge of
either arvo or urbit. We will point out only those features of
arvo that are necessary for an understanding of clay, and we will
do so only when they arise.

The first relevant feature of arvo is that it is a deterministic
system where input and output are defined as a series of events
and effects. The state of arvo is simply a function of its event
log. None of the effects from an event are emitted until the
event is entered in the log and persisted, either to disk or
another trusted source of persistence, such as a Kafka cluster.
Consequently, arvo is a single-level store: everything in its
state is persistent.

In a more traditional OS, everything in RAM can be erased at any
time by power failure, and is always erased on reboot. Thus, a
primary purpose of a filesystem is to ensure files persist across
power failures and reboots.  In arvo, both power failures and
reboots are special cases of suspending computation, which is
done safely since our event log is already persistent. Therefore,
clay is not needed in arvo for persistence. Why, then, do we have a
filesystem? There are two answers to this question.

First, clay provides a filesystem tree, which is a convenient
user interface for some applications. Unix has the useful concept
of virtual filesystems, which are used for everything from direct
access to devices, to random number generators, to the /proc
tree. It is easy and intuitive to read from and write to a
filesystem tree.

Second, clay has a distributed revision-control system baked into
it.  Traditional filesystems are not revision controlled, so
userspace software -- such as git -- is written on top of them to
do so. clay natively provides the same functionality as modern
DVCSes, and more.

clay has two other unique properties that we'll cover later on:
it supports typed data and is referentially transparent.

### Revision Control

Every urbit has one or more "desks", which are independently
revision-controlled branches. Each desk contains its own mark
definitions, apps, doc, and so forth.

Traditionally, an urbit has at least a base and a home desk. The
base desk has all the system software from the distribution. the
home desk is a fork of base with all the stuff specific to the
user of the urbit.

A desk is a series of numbered commits, the most recent of which
represents the current state of the desk. A commit is composed of
(1) an absolute time when it was created, (2) a list of zero or
more parents, and (3) a map from paths to data.

Most commits have exactly one parent, but the initial commit on a
desk may have zero parents, and merge commits have more than one
parent.

The non-meta data is stored in the map of paths to data. It's
worth noting that no constraints are put on this map, so, for
example, both /a/b and /a/b/c could have data. This is impossible
in a traditional Unix filesystem since it means that /a/b is both
a file and a directory. Conventionally, the final element in the
path is its mark -- much like a filename extension in Unix. Thus,
/doc/readme.md in Unix is stored as /doc/readme/md in urbit.

The data is not stored directly in the map; rather, a hash of the
data is stored, and we maintain a master blob store. Thus, if the
same data is referred to in multiple commits (as, for example,
when a file doesn't change between commits), only the hash is
duplicated.

In the master blob store, we either store the data directly, or
else we store a diff against another blob. The hash is dependent
only on the data within and not on whether or not it's stored
directly, so we may on occasion rearrange the contents of the
blob store for performance reasons.

Recall that a desk is a series of numbered commits. Not every
commit in a desk must be numbered. For example, if the base desk
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
second). Thirdly, every desk has a map of labels to revision
numbers. These labels may be used to refer to specific commits.

Additionally, clay is a global filesystem, so data on other urbit
is easily accessible the same way as data on our local urbit.  In
general, the path to a particular revision of a desk is
/~urbit-name/desk-name/revision.  Thus, to get /try/readme/md
from revision 5 of the home desk on ~sampel-sipnym, we refer to
/~sampel-sipnym/home/5/try/readme/md.  Clay's namespace is thus
global and referentially transparent.

XXX reactivity here?

### A Typed Filesystem

Since clay is a general filesystem for storing data of arbitrary
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

As far as the author is aware, clay is the first generalized,
type-aware revision control system.  We'll go into the workings
of this system in some detail.

### Marks

Central to a typed filesystem is the idea of types. In clay, we
call these "marks". A mark is a file that defines a type,
conversion routines to and from the mark, and diff, patch, and
merge routines.

For example, a `%txt` mark may be a list of lines of text, and it
may include conversions to `%mime` to allow it to be serialized
and sent to a browswer or to the unix filesystem. It will also
include Hunt-McIlroy diff, patch, and merge algorithms.

A `%json` mark would be defined as a json object in the code, and
it would have a parser to convert from `%txt` and a printer to
convert back to `%txt`. The diff, patch, and merge algorithms are
fairly straightforward for json, though they're very different
from the text ones.

More formally, a mark is a core with three [arms](/docs/glossary/arm/), `++grab`,
`++grow`, and `++grad`. In `++grab` is a series of functions to
convert from other marks to the given mark.  In `++grow` is a
series of functions to convert from the given mark to other
marks. In `++grad` is `++diff`, `++pact`, `++join`, and `++mash`.

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
      ++  diff: (<mark-type>, <mark-type>) -> <diff-type>
      ++  pact: (<mark-type>, <diff-type>) -> <mark-type>
      ++  join: (<diff-type>, <diff-type>) -> <diff-type> or NULL
      ++  mash: (<diff-type>, <diff-type>) -> <diff-type>
```

These types are basically what you would expect. Not every mark
has each of these functions defined -- all of them are optional
in the general case.

In general, for a particular mark, the `++grab` and `++grow` entries
(if they exist) should be inverses of each other.

In `++grad`, `++diff` takes two instances of a mark and produces
a diff of them. `++pact` takes an instance of a mark and patches
it with the given diff. `++join` takes two diffs and attempts to
merge them into a single diff. If there are conflicts, it
produces null. `++mash` takes two diffs and forces a merge,
annotating any conflicts.

In general, if `++diff` called with A and B produces diff D, then
`++pact` called with A and D should produce B. Also, if `++join`
of two diffs does not produce null, then `++mash` of the same
diffs should produce the same result.

Alternately, instead of `++diff`, `++pact`, `++join`, and
`++mash`, a mark can provide the same functionality by defining
`++sted` to be the name of another mark to which we wish to
delegate the revision control responsibilities. Then, before
running any of those functions, clay will convert to the other
mark, and convert back afterward. For example, the `%hoon` mark
is revision-controlled in the same way as `%txt`, so its `++grad`
is simply `++sted %txt`. Of course, `++txt` must be defined in
`++grow` and `++grab` as well.

Every file in clay has a mark, and that mark must have a
fully-functioning `++grad`. Marks are used for more than just
clay, and other marks don't need a `++grad`, but if a piece of
data is to be saved to clay, we must know how to revision-control
it.

Additionally, if a file is to be synced out to unix, then it must
have conversion routines to and from the `%mime` mark.

## Using clay

### Reading and Subscribing

When reading from Clay, there are three types of requests.  A
`%sing` request asks for data at single revsion.  A `%next`
request asks to be notified the next time there's a change to
given file.  A `%many` request asks to be notified on every
change in a desk for a range of changes.

For `%sing` and `%next`, there are generally three things to be
queried.  A `%u` request simply checks for the existence of a
file at a path.  A `%x` request gets the data in the file at a
path.  A `%y` request gets a hash of the data in the file at the
path combined with all its children and their data.  Thus, `%y`
of a node changes if it or any of its children change.

A `%sing` request is fulfilled immediately if possible.  If the
requested revision is in the future, or is on another ship for
which we don't have the result cached, we don't respond
immediately.  If the requested revision is in the future, we wait
until the revision happens before we respond to the request.  If
the request is for data on another ship, we pass on the request
to the other ship.  In general, Clay subscriptions, like most
things in Urbit, aren't guaranteed to return immediately.
They'll return when they can, and they'll do so in a
referentially transparent manner.

A `%next` request checks query at the given revision, and it
produces the result of the query the next time it changes, along
with the revsion number when it changes.  Thus, a `%next` of a
`%u` is triggered when a file is added or deleted, a `%next` of a
`%x` is triggered when a file is added, deleted, or changed, and
a `%next` of a `%y` is triggered when a file or any of its
children is added, deleted, or changed.

A `%many` request is triggered every time the given desk has a
new revision.  Unlike a `%next`, a `%many` has both a start and
an end revsion, after which it stops returning.  For `%next`, a
single change is reported, and if the caller wishes to hear of
the next change, it must resubscribe.  For `%many`, every revsion
from the start to the end triggers a response.  Since a `%many`
request doesn't ask for any particular data, there aren't `%u`,
`%x`, and `%y` versions for it.

### Unix sync

One of the primary functions of clay is as a convenient user
interface. While tools exist to use clay from within urbit, it's
often useful to be able to treat clay like any other filesystem
from the Unix perspective -- to "mount" it, as it were.

From urbit, you can run `|mount /path/to/directory %mount-point`,
and this will mount the given clay directory to the mount-point
directory in Unix. Every file is converted to `%mime` before it's
written to Unix, and converted back when read from Unix. The
entire directory is watched (a la Dropbox), and every change is
committed once you run `|commit %mount-point`.

### Merging

Merging is a fundamental operation for a distributed revision
control system. At their root, clay's merges are similar to
git's, but with some additions to accomodate typed data. There
are seven different merge strategies.

Throughout our discussion, we'll say that the merge is from
Alice's desk to Bob's. Recall that a commit is a date (for all
new commits this will be the current date), a list of parents,
and the data itself.

A `%init` merge should be used iff it's the first commit to a
desk.  The head of Alice's desk is used as the number 1 commit to
Bob's desk. Obviously, the ancestry remains intact through
traversing the parentage of the commit even though previous
commits are not numbered for Bob's desk.

A `%this` merge means to keep what's in Bob's desk, but join the
ancestry. Thus, the new commit has the head of each desk as
parents, but the data is exactly what's in Bob's desk. For those
following along in git, this is the 'ours' merge strategy, not
the '--ours' option to the 'recursive' merge strategy. In other
words, even if Alice makes a change that does not conflict with
Bob, we throw it away. It's Bob's way or the highway.

A `%that` merge means to take what's in Alice's desk, but join
the ancestry. This is the reverse of `%this`.

A `%fine` merge is a "fast-forward" merge. This succeeds iff one
head is in the ancestry of the other. In this case, we use the
descendant as our new head.

For `%meet`, `%mate`, and `%meld` merges, we first find the most
recent common ancestor to use as our merge base. If we have no
common ancestors, then we fail. If we have more than one most
recent common ancestor, then we have a criss-cross situation,
which should be handled delicately. At present, we delicately
throw up our hands and give up, but something akin to git's
'recursive' strategy should be implemented in the future.

There's a functional inclusion ordering on `%fine`, `%meet`,
`%mate`, and `%meld` such that if an earlier strategy would have
succeeded, then every later strategy will produce the same
result. Put another way, every earlier strategy is the same as
every later strategy except with a restricted domain.

A `%meet` merge only succeeds if the changes from the merge base
to Alice's head (hereafter, "Alice's changes") are in different
files than Bob's changes. In this case, the parents are both
Alice's and Bob's heads, and the data is the merge base plus
Alice's changed files plus Bob's changed files.

A `%mate` merge attempts to merge changes to the same file when
both Alice and bob change it. If the merge is clean, we use it;
otherwise, we fail. A merge between different types of changes --
for example, deleting a file vs changing it -- is always a
conflict. If we succeed, the parents are both Alice's and Bob's
heads, and the data is the merge base plus Alice's changed files
plus Bob's changed files plus the merged files.

A `%meld` merge will succeed even if there are conflicts. If
there are conflicts in a file, then we use the merge base's
version of that file, and we produce a set of files with
conflicts. The parents are both Alice's and Bob's heads, and the
data is the merge base plus Alice's changed files plus Bob's
changed files plus the successfully merged files plus the merge
base's version of the conflicting files.

That's the extent of the merge options in clay proper. In
userspace there's a final option `%auto`, which is the most
common.  `%auto` checks to see if Bob's desk exists, and if it
doesn't we use a `%init` merge. Otherwise, we progressively try
`%fine`, `%meet`, and `%mate` until one succeeds.

If none succeed, we merge Bob's desk into a scratch desk.  Then,
we merge Alice's desk into the scratch desk with the `%meld`
option to force the merge. For each file in the produced set of
conflicting files, we call the `++mash` function for the
appropriate mark, which annotates the conflicts if we know how.

Finally, we display a message to the user informing them of the
scratch desk's existence, which files have annotated conflicts,
and which files have unannotated conflicts. When the user has
resolved the conflicts, they can merge the scratch desk back into
Bob's desk. This will be a `%fine` merge since Bob's head is in
the ancestry of the scratch desk.

### Autosync

Tracking and staying in sync with another desk is another
fundamental operation. We call this "autosync". This doesn't mean
simply mirroring a desk, since that wouldn't allow local changes.
We simply want to apply changes as they are made upstream, as
long as there are no conflicts with local changes.

This is implemented by watching the other desk, and, when it has
changes, merging these changes into our desk with the usual merge
strategies.

Note that it's quite reasonable for two desks to be autosynced to
each other. This results in any change on one desk being mirrored
to the other and vice versa.

Additionally, it's fine to set up an autosync even if one desk,
the other desk, or both desks do not exist. The sync will be
activated when the upstream desk comes into existence and will
create the downstream desk if needed.

## Commentary

The first part of this section will be reference documentation for the data
types used by our filesystem. In fact, as a general guide, we recommend
reading and attempting to understand the data structures used in any
Hoon code before you try to read the code itself. Although complete
understanding of the data structures is impossible without seeing them
used in the code, an 80% understanding greatly clarifies the code. As
another general guide, when reading Hoon, it rarely pays off to
understand every line of code when it appears. Try to get the gist of
it, and then move on. The next time you come back to it, it'll likely
make a lot more sense.

After a description of the data models, we'll give an overview of the
interface that vanes and applications can use to interact with the
filesystem.

Finally, we'll dive into the code and the algorithms themselves. You
know, the fun part.

### Data Models

As you're reading through this section, remember you can always come
back to this when you run into these types later on. You're not going to
remember everything the first time through, but it is worth reading, or
at least skimming, this so that you get a rough idea of how our state is
organized.

The types that are certainly worth reading are `++raft`, `++room`,
`++dome:clay`, `++ankh:clay`, `++rung:clay`, `++rang:clay`, `++blob:clay`, `++yaki:clay`, and `++nori:clay`
(possibly in that order). All in all, though, this section isn't too
long, so many readers may wish to quickly read through all of it. If you
get bored, though, just skip to the next section. You can always come
back when you need to.

### `++raft`, formal state

```hoon
    ++  raft                                                ::  filesystem
              $:  fat=(map ship room)                       ::  domestic
                  hoy=(map ship rung)                       ::  foreign
                  ran=rang                                  ::  hashes
              ==                                            ::
```

This is the state of our vane. Anything that must be remembered between
calls to clay is stored in this state.

`fat` is the set of domestic servers. This stores all the information
that is specfic to a particular ship on this pier. The keys to this map
are the ships on the current pier. all the information that is specific
to a particular foreign ship. The keys to this map are all the ships
whose filesystems we have attempted to access through clay.

`ran` is the store of all commits and deltas, keyed by hash. The is
where all the "real" data we know is stored; the rest is "just
bookkeeping".

#### `++room`, filesystem per domestic ship

```hoon
    ++  room                                                ::  fs per ship
              $:  hun=duct                                  ::  terminal duct
                  hez=(unit duct)                           ::  sync duch
                  dos=(map desk dojo)                       ::  native desk
              ==                                            ::
```

This is the representation of the filesystem of a ship on our pier.

`hun` is the duct we use to send messages to dill to display
notifications of filesystem changes. Only `%note` gifts should be
produced along this duct. This is set by the `%init` kiss.

`hez`, if present, is the duct we use to send sync messages to unix so
that they end up in the pier unix directory. Only `%ergo` gifts should
be producd along this duct. This is set by `%into` and `%invo` kisses.

`dos` is a well-known operating system released in 1981. It is also the
set of desks on this ship, mapped to their data.

#### `++desk`, filesystem branch

```hoon
    ++  desk  ,@tas                                         ::  ship desk case spur
```

This is the name of a branch of the filesystem. The default desks are
"arvo", "main", and "try". More may be created by simply referencing
them. Desks have independent histories and states, and they may be
merged into each other.

### `++dojo`, domestic desk state

```hoon
    ++  dojo  ,[p=cult q=dome]                              ::  domestic desk state
```

This is the all the data that is specific to a particular desk on a
domestic ship. `p` is the set of subscribers to this desk and `q` is the
data in the desk.

#### `++cult`, subscriptions

```hoon
    ++  cult  (map duct rave)                               ::  subscriptions
```

This is the set of subscriptions to a particular desk. The keys are the
ducts from where the subscriptions requests came. The results will be
produced along these ducts. The values are a description of the
requested information.

#### `++rave:clay`, general subscription request

```hoon
    ++  rave                                                ::  general request
              $%  [& p=mood]                                ::  single request
                  [| p=moat]                                ::  change range
              ==                                            ::
```

This represents a subscription request for a desk. The request can be
for either a single item in the desk or else for a range of changes on
the desk.

### `++rove`, stored general subscription request

```hoon
    ++  rove  (each mood moot)                              ::  stored request
```

When we store a request, we store subscriptions with a little extra
information so that we can determine whether new versions actually
affect the path we're subscribed to.

#### `++mood:clay`, single subscription request

```hoon
    ++  mood  ,[p=care q=case r=path]                       ::  request in desk
```

This represents a request for the state of the desk at a particular
commit, specfied by `q`. `p` specifies what kind of information is
desired, and `r` specifies the path we are requesting.

#### `++moat:clay`, range subscription request

```hoon
    ++  moat  ,[p=case q=case r=path]                       ::  change range
```

This represents a request for all changes between `p` and `q` on path
`r`. You will be notified when a change is made to the node referenced
by the path or to any of its children.

### `++moot`, stored range subscription request

```hoon
    ++  moot  ,[p=case q=case r=path s=(map path lobe)]     ::
```

This is just a `++moat:clay` plus a map of paths to lobes. This map
represents the data at the node referenced by the path at case `p`, if
we've gotten to that case (else null). We only send a notification along
the subscription if the data at a new revision is different than it was.

### `++care:clay`, clay submode

```hoon
    ++  care  ?(%u %v %w %x %y %z)                          ::  clay submode
```

This specifies what type of information is requested in a subscription
or a scry.

`%u` requests the `++rang:clay` at the current moment. Because this
information is not stored for any moment other than the present, we
crash if the `++case:clay` is not a `%da` for now.

`%v` requests the `++dome:clay` at the specified commit.

`%w` requests the revsion number of the desk.

`%x` requests the file at a specified path at the specified commit. If
there is no node at that path or if the node has no contents (that is,
if `q:ankh` is null), then this produces null.

`%y` requests a `++arch` of the specfied commit at the specified path.

`%z` requests the `++ankh` of the specified commit at the specfied path.

### `++arch`, shallow filesystem node

```hoon
    ++  arch  ,[p=@uvI q=(unit ,@uvI) r=(map ,@ta ,~)]      ::  fundamental node
```

This is analogous to `++ankh:clay` except that the we have neither our
contents nor the ankhs of our children. The other fields are exactly the
same, so `p` is a hash of the associated ankh, `u.q`, if it exists, is a
hash of the contents of this node, and the keys of `r` are the names of
our children. `r` is a map to null rather than a set so that the
ordering of the map will be equivalent to that of `r:ankh`, allowing
efficient conversion.

#### `++case:clay`, specifying a commit

```hoon
    ++  case                                                ::  ship desk case spur
              $%  [%da p=@da]                               ::  date
                  [%tas p=@tas]                             ::  label
                  [%ud p=@ud]                               ::  number
              ==                                            ::
```

A commit can be referred to in three ways: `%da` refers to the commit
that was at the head on date `p`, `%tas` refers to the commit labeled
`p`, and `%ud` refers to the commit numbered `p`. Note that since these
all can be reduced down to a `%ud`, only numbered commits may be
referenced with a `++case:clay`.

#### `++dome:clay`, desk data

```hoon
    ++  dome                                                ::  project state
              $:  ang=agon                                  ::  pedigree
                  ank=ankh                                  ::  state
                  let=@ud                                   ::  top id
                  hit=(map ,@ud tako)                       ::  changes by id
                  lab=(map ,@tas ,@ud)                      ::  labels
              ==                                            ::
```

This is the data that is actually stored in a desk.

`ang` is unused and should be removed.

`ank` is the current state of the desk. Thus, it is the state of the
filesystem at revison `let`. The head of a desk is always a numbered
commit.

`let` is the number of the most recently numbered commit. This is also
the total number of numbered commits.

`hit` is a map of numerical ids to hashes of commits. These hashes are
mapped into their associated commits in `hut:rang:clay`. In general, the keys
of this map are exactly the numbers from 1 to `let`, with no gaps. Of
course, when there are no numbered commits, `let` is 0, so `hit` is
null. Additionally, each of the commits is an ancestor of every commit
numbered greater than this one. Thus, each is a descendant of every
commit numbered less than this one. Since it is true that the date in
each commit (`t:yaki`) is no earlier than that of each of its parents,
the numbered commits are totally ordered in the same way by both
pedigree and date. Of course, not every commit is numbered. If that
sounds too complicated to you, don't worry about it. It basically
behaves exactly as you would expect.

`lab` is a map of textual labels to numbered commits. Note that labels
can only be applied to numbered commits. Labels must be unique across a
desk.

#### `++ankh`, filesystem node

```hoon
    ++  ankh                                                ::  fs node (new)
              $:  p=cash                                    ::  recursive hash
                  q=(unit ,[p=cash q=*])                    ::  file
                  r=(map ,@ta ankh)                         ::  folders
              ==                                            ::
```

This is a single node in the filesystem. This may be file or a directory
or both. In earth filesystems, a node is a file xor a directory. On
mars, we're inclusive, so a node is a file ior a directory.

`p` is a recursive hash that depends on the contents of the this file or
directory and on any children.

`q` is the contents of this file, if any. `p.q` is a hash of the
contents while `q.q` is the data itself.

`r` is the set of children of this node. In the case of a pure file,
this is empty. The keys are the names of the children and the values
are, recursively, the nodes themselves.

#### `++cash`, ankh hash

```hoon
    ++  cash  ,@uvH                                         ::  ankh hash
```

This is a 128-bit hash of an ankh. These are mostly stored within ankhs
themselves, and they are used to check for changes in possibly-deep
hierarchies.

#### `++rung`, filesystem per neighbor ship

```hoon
    ++  rung  $:  rus=(map desk rede)                       ::  neighbor desks
              ==                                            ::
```

This is the filesystem of a neighbor ship. The keys to this map are all
the desks we know about on their ship.

#### `++rede`, desk state

```hoon
    ++  rede                                                ::  universal project
              $:  lim=@da                                   ::  complete to
                  qyx=cult                                  ::  subscribers
                  ref=(unit rind)                           ::  outgoing requests
                  dom=dome                                  ::  revision state
              ==                                            ::
```

This is our knowledge of the state of a desk, either foreign or
domestic.

`lim` is the date of the last full update. We only respond to requests
for stuff before this time.

`qyx` is the list of subscribers to this desk. For domestic desks, this
is simply `p:dojo`, all subscribers to the desk, while in foreign desks
this is all the subscribers from our ship to the foreign desk.

`ref` is the request manager for the desk. For domestic desks, this is
null since we handle requests ourselves.

`dom` is the actual data in the desk.

#### `++rind`, request manager

```hoon
    ++  rind                                                ::  request manager
              $:  nix=@ud                                   ::  request index
                  bom=(map ,@ud ,[p=duct q=rave])           ::  outstanding
                  fod=(map duct ,@ud)                       ::  current requests
                  haw=(map mood (unit))                     ::  simple cache
              ==                                            ::
```

This is the request manager for a foreign desk.

`nix` is one more than the index of the most recent request. Thus, it is
the next available request number.

`bom` is the set of outstanding requests. The keys of this map are some
subset of the numbers between 0 and one less than `nix`. The members of
the map are exactly those requests that have not yet been fully
satisfied.

`fod` is the same set as `bom`, but from a different perspective. In
particular, the values of `fod` are the same as the values of `bom`, and
the `p` out of the values of `bom` are the same as the keys of `fod`.
Thus, we can map ducts to their associated request number and `++rave:clay`,
and we can map numbers to their associated duct and `++rave:clay`.

`haw` is a map from simple requests to their values. This acts as a
cache for requests that have already been made. Thus, the second request
for a particular `++mood:clay` is nearly instantaneous.

#### `++rang:clay`, data store

```hoon
    ++  rang  $:  hut=(map tako yaki)                       ::
                  lat=(map lobe blob)                       ::
              ==                                            ::
```

This is a set of data keyed by hash. Thus, this is where the "real" data
is stored, but it is only meaningful if we know the hash of what we're
looking for.

`hut` is a map from hashes to commits. We often get the hashes from
`hit:dome:clay`, which keys them by logical id. Not every commit has an id.

`lat` is a map from hashes to the actual data. We often get the hashes
from a `++yaki`, a commit, which references this map to get the data.
There is no `++blob:clay` in any `++yaki:clay`. They are only accessible through
this map.

#### `++tako:clay`, commit reference

```hoon
    ++  tako  ,@                                            ::  yaki ref
```

This is a hash of a `++yaki:clay`, a commit. These are most notably used as
the keys in `hut:rang:clay`, where they are associated with the actual
`++yaki:clay`, and as the values in `hit:dome:clay`, where sequential ids are
associated with these.

#### `++yaki:clay`, commit

```hoon
    ++  yaki  ,[p=(list tako) q=(map path lobe) r=tako t=@da] ::  commit
```

This is a single commit.

`p` is a list of the hashes of the parents of this commit. In most
cases, this will be a single commit, but in a merge there may be more
parents. In theory, there may be an arbitrary number of parents, but in
practice merges have exactly two parents. This may change in the future.
For commit 1, there is no parent.

`q` is a map of the paths on a desk to the data at that location. If you
understand what a `++lobe:clay` and a `++blob:clay` is, then the type signature
here tells the whole story.

`r` is the hash associated with this commit.

`t` is the date at which this commit was made.

#### `++lobe:clay`, data reference

```hoon
    ++  lobe  ,@                                            ::  blob ref
```

This is a hash of a `++blob:clay`. These are most notably used in `lat:rang:clay`,
where they are associated with the actual `++blob:clay`, and as the values in
`q:yaki:clay`, where paths are associated with their data in a commit.

#### `++blob:clay`, data

```hoon
    ++  blob  $%  [%delta p=lobe q=lobe r=udon]             ::  delta on q
                  [%direct p=lobe q=* r=umph]               ::
                  [%indirect p=lobe q=* r=udon s=lobe]      ::
              ==                                            ::
```

This is a node of data. In every case, `p` is the hash of the blob.

`%delta` is the case where we define the data by a delta on other data.
In practice, the other data is always the previous commit, but nothing
depends on this. `q` is the hash of the parent blob, and `r` is the
delta.

`%direct` is the case where we simply have the data directly. `q` is the
data itself, and `r` is any preprocessing instructions. These almost
always come from the creation of a file.

`%indirect` is both of the preceding cases at once. `q` is the direct
data, `r` is the delta, and `s` is the parent blob. It should always be
the case that applying `r` to `s` gives the same data as `q` directly
(with the prepreprocessor instructions in `p.r`). This exists purely for
performance reasons. This is unused, at the moment, but in general these
should be created when there are a long line of changes so that we do
not have to traverse the delta chain back to the creation of the file.

#### `++udon`, abstract delta

```hoon
    ++  udon                                                ::  abstract delta
              $:  p=umph                                    ::  preprocessor
                  $=  q                                     ::  patch
                  $%  [%a p=* q=*]                          ::  trivial replace
                      [%b p=udal]                           ::  atomic indel
                      [%c p=(urge)]                         ::  list indel
                      [%d p=upas q=upas]                    ::  tree edit
                  ==                                        ::
              ==                                            ::
```

This is an abstract change to a file. This is a superset of what would
normally be called diffs. Diffs usually refer to changes in lines of
text while we have the ability to do more interesting deltas on
arbitrary data structures.

`p` is any preprocessor instructions.

`%a` refers to the trival delta of a complete replace of old data with
new data.

`%b` refers to changes in an opaque atom on the block level. This has
very limited usefulness, and is not used at the moment.

`%c` refers to changes in a list of data. This is often lines of text,
which is your classic diff. We, however, will work on any list of data.

`%d` refers to changes in a tree of data. This is general enough to
describe changes to any hoon [noun](/docs/glossary/noun/), but often more special-purpose delta
should be created for different content types. This is not used at the
moment, and may in fact be unimplemented.

#### `++urge`, list change

```hoon
    ++  urge  |*(a=_,* (list (unce a)))                     ::  list change
```

This is a parametrized type for list changes. For example, `(urge ,@t)`
is a list change for lines of text.

#### `++unce`, change part of a list.

```hoon
    ++  unce  |*  a=_,*                                     ::  change part
              $%  [%& p=@ud]                                ::  skip[copy]
                  [%| p=(list a) q=(list a)]                ::  p -> q[chunk]
              ==                                            ::
```

This is a single change in a list of elements of type `a`. For example,
`(unce ,@t)` is a single change in a lines of text.

`%&` means the next `p` lines are unchanged.

`%|` means the lines `p` have changed to `q`.

#### `++umph`, preprocessing information

```hoon
    ++  umph                                                ::  change filter
              $|  $?  %a                                    ::  no filter
                      %b                                    ::  jamfile
                      %c                                    ::  LF text
                  ==                                        ::
              $%  [%d p=@ud]                                ::  blocklist
              ==                                            ::
```

This space intentionally left undocumented. This stuff will change once
we get a well-typed clay.

#### `++upas`, tree change

```hoon
    ++  upas                                                ::  tree change (%d)
              $&  [p=upas q=upas]                           ::  cell
              $%  [%0 p=axis]                               ::  copy old
                  [%1 p=*]                                  ::  insert new
                  [%2 p=axis q=udon]                        ::  mutate!
              ==                                            ::
```

This space intentionally left undocumented. This stuff is not known to
work, and will likely change when we get a well-typed clay. Also, this
is not a complicated type; it is not difficult to work out the meaning.

#### `++nori:clay`, repository action

```hoon
    ++  nori                                                ::  repository action
              $%  [& q=soba]                                ::  delta
                  [| p=@tas]                                ::  label
              ==                                            ::
```

This describes a change that we are asking clay to make to the desk.
There are two kinds of changes that may be made: we can modify files or
we can apply a label to a commit.

In the `|` case, we will simply label the current commit with the given
label. In the `&` case, we will apply the given changes.

#### `++soba:clay`, delta

```hoon
    ++  soba  ,[p=cart q=(list ,[p=path q=miso])]           ::  delta
```

This describes a set of changes to make to a desk. The `cart` is simply
a pair of the old hash and the new hash of the desk. The list is a list
of changes keyed by the file they're changing. Thus, the paths are paths
to files to be changed while `miso` is a description of the change
itself.

#### `++miso:clay`, ankh delta

```hoon
    ++  miso                                                ::  ankh delta
              $%  [%del p=*]                                ::  delete
                  [%ins p=*]                                ::  insert
                  [%mut p=udon]                             ::  mutate
              ==                                            ::
```

There are three kinds of changes that may be made to a node in a desk.
We can insert a file, in which case `p` is the contents of the new file.
We can delete a file, in which case `p` is the contents of the old file.
Finally, we can mutate that file, in which case the `udon` describes the
changes we are applying to the file.

#### `++mizu:clay`, merged state

```hoon
    ++  mizu  ,[p=@u q=(map ,@ud tako) r=rang]              ::  new state
```

This is the input to the `%merg` kiss, which allows us to perform a
merge. The `p` is the number of the new head commit. The `q` is a map
from numbers to commit hashes. This is all the new numbered commits that
are to be inserted. The keys to this should always be the numbers from
`let.dom` plus one to `p`, inclusive. The `r` is the maps of all the new
commits and data. Since these are merged into the current state, no old
commits or data need be here.

#### `++riff:clay`, request/desist

```hoon
    ++  riff  ,[p=desk q=(unit rave)]                       ::  request/desist
```

This represents a request for data about a particular desk. If `q`
contains a `rave`, then this opens a subscription to the desk for that
data. If `q` is null, then this tells clay to cancel the subscription
along this duct.

#### `++riot:clay`, response

```hoon
    ++  riot  (unit rant)                                   ::  response/complete
```

A riot is a response to a subscription. If null, the subscription has
been completed, and no more responses will be sent. Otherwise, the
`rant` is the produced data.

#### `++rant:clay`, response data

```hoon
    ++  rant                                                ::  namespace binding
              $:  p=[p=care q=case r=@tas]                  ::  clade release book
                  q=path                                    ::  spur
                  r=*                                       ::  data
              ==                                            ::
```

This is the data at a particular node in the filesystem. `p.p` specifies
the type of data that was requested (and is produced). `q.p` gives the
specific version reported (since a range of versions may be requested in
a subscription). `r.p` is the desk. `q` is the path to the filesystem
node. `r` is the data itself (in the format specified by `p.p`).

### `++nako`, subscription response data

```hoon
    ++  nako  $:  gar=(map ,@ud tako)                       ::  new ids
                  let=@ud                                   ::  next id
                  lar=(set yaki)                            ::  new commits
                  bar=(set blob)                            ::  new content
              ==                                            ::
```

This is the data that is produced by a request for a range of revisions
of a desk. This allows us to easily keep track of a remote repository --
all the new information we need is contained in the `nako`.

`gar` is a map of the revisions in the range to the hash of the commit
at that revision. These hashes can be used with `hut:rang:clay` to find the
commit itself.

`let` is either the last revision number in the range or the most recent
revision number, whichever is smaller.

`lar` is the set of new commits, and `bar` is the set of new content.

## Public Interface

As with all vanes, there are exactly two ways to interact with clay.
`%clay` exports a namespace accessible through `.^`, which is described
above under `++care:clay`. The primary way of interacting with clay, though,
is by sending kisses and receiving gifts.

```hoon
    ++  gift                                                ::  out result <-$
              $%  [%ergo p=@p q=@tas r=@ud]                 ::  version update
                  [%note p=@tD q=tank]                      ::  debug message
                  [%writ p=riot]                            ::  response
              ==                                            ::
    ++  kiss                                                ::  in request ->$
              $%  [%info p=@p q=@tas r=nori]                ::  internal edit
                  [%ingo p=@p q=@tas r=nori]                ::  internal noun edit
                  [%init p=@p]                              ::  report install
                  [%into p=@p q=@tas r=nori]                ::  external edit
                  [%invo p=@p q=@tas r=nori]                ::  external noun edit
                  [%merg p=@p q=@tas r=mizu]                ::  internal change
                  [%wart p=sock q=@tas r=path s=*]          ::  network request
                  [%warp p=sock q=riff]                     ::  file request
              ==                                            ::
```

There are only a small number of possible kisses, so it behooves us to
describe each in detail.

```hoon
              $%  [%info p=@p q=@tas r=nori]                ::  internal edit

                  [%into p=@p q=@tas r=nori]                ::  external edit
```

These two kisses are nearly identical. At a high level, they apply
changes to the filesystem. Whenever we add, remove, or edit a file, one
of these cards is sent. The `p` is the ship whose filesystem we're
trying to change, the `q` is the desk we're changing, and the `r` is the
request change. For the format of the requested change, see the
documentation for `++nori:clay` above.

When a file is changed in the unix filesystem, vere will send a `%into`
kiss. This tells clay that the duct over which the kiss was sent is the
duct that unix is listening on for changes. From within Arvo, though, we
should never send a `%into` kiss. The `%info` kiss is exactly identical
except it does not reset the duct.

```hoon
                  [%ingo p=@p q=@tas r=nori]                ::  internal noun edit

                  [%invo p=@p q=@tas r=nori]                ::  external noun edit
```

These kisses are currently identical to `%info` and `%into`, though this
will not always be the case. The intent is for these kisses to allow
typed changes to clay so that we may store typed data. This is currently
unimplemented.

```hoon
                  [%init p=@p]                              ::  report install
```

Init is called when a ship is started on our pier. This simply creates a
default `room` to go into our `raft`. Essentially, this initializes the
filesystem for a ship.

```hoon
                  [%merg p=@p q=@tas r=mizu]                ::  internal change
```

This is called to perform a merge. This is most visibly called by
:update to update the filesystem of the current ship to that of its
sein. The `p` and `q` are as in `%info`, and the `r` is the description
of the merge. See `++mizu:clay` above.

XX
`XX                [%wake ~]                                 ::  timer activate XX`
XX\
XX This card is sent by unix at the time specified by `++doze`. This
time is XX usually the closest time specified in a subscription request.
When `%wake` is XX called, we update our subscribers if there have been
any changes.

```hoon
                  [%wart p=sock q=@tas r=path s=*]          ::  network request
```

This is a request that has come across the network for a particular
file. When another ship asks for a file from us, that request comes to
us in the form of a `%wart` kiss. This is handled by trivially turning
it into a `%warp`.

```hoon
                  [%warp p=sock q=riff]                     ::  file request
```

This is a request for information about a particular desk. This is, in
its most general form, a subscription, though in many cases it is the
trivial case of a subscription -- a read. See `++riff:clay` for the format of
the request.

## Lifecycle of a Local Read

There are two real types of interaction with a filesystem: you can read,
and you can write. We'll describe each process, detailing both the flow
of control followed by the kernel and the algorithms involved. The
simpler case is that of the read, so we'll begin with that.

When a vane or an application wishes to read a file from the filesystem,
it sends a `%warp` kiss, as described above. Of course, you may request
a file on another ship and, being a global filesystem, clay will happily
produce it for you. That code pathway will be described in another
section; here, we will restrict ourselves to examining the case of a
read from a ship on our own pier.

The kiss can request either a single version of a file node or a range
of versions of a desk. Here, we'll deal only with a request for a single
version.

As in all vanes, a kiss enters clay via a call to `++call`. Scanning
through the arm, we quickly see where `%warp` is handled.

```hoon
            ?:  =(p.p.q.hic q.p.q.hic)
              =+  une=(un p.p.q.hic now ruf)
              =+  wex=(di:une p.q.q.hic)
              =+  ^=  wao
                ?~  q.q.q.hic
                  (ease:wex hen)
                (eave:wex hen u.q.q.q.hic)
              =+  ^=  woo
                abet:wao
              [-.woo abet:(pish:une p.q.q.hic +.woo ran.wao)]
```

We're following the familar patern of producing a list of moves and an
updated state. In this case, the state is `++raft`.

We first check to see if the sending and receiving ships are the same.
If they're not, then this is a request for data on another ship. We
describe that process later. Here, we discuss only the case of a local
read.

At a high level, the call to `++un` sets up the core for the domestic
ship that contains the files we're looking for. The call to `++di` sets
up the core for the particular desk we're referring to.

After this, we perform the actual request. If there is no rave in the
riff, then that means we are cancelling a request, so we call
`++ease:de`. Otherwise, we start a subscription with `++eave:de`. We
call `++abet:de` to resolve our various types of output into actual
moves. We produce the moves we found above and the `++un` core resolved
with `++pish:un` (putting the modified desk in the room) and `++abet:un`
(putting the modified room in the raft).

Much of this is fairly straightforward, so we'll only describe `++ease`,
`++eave`, and `++abet:de`. Feel free to look up the code to the other
steps -- it should be easy to follow.

Although it's called last, it's usually worth examining `++abet` first,
since it defines in what ways we can cause side effects. Let's do that,
and also a few of the lines at the beginning of `++de`.

```hoon
        =|  yel=(list ,[p=duct q=gift])
        =|  byn=(list ,[p=duct q=riot])
        =|  vag=(list ,[p=duct q=gift])
        =|  say=(list ,[p=duct q=path r=ship s=[p=@ud q=riff]])
        =|  tag=(list ,[p=duct q=path c=note])
        |%
        ++  abet
          ^-  [(list move) rede]
          :_  red
          ;:  weld
            %+  turn  (flop yel)
            |=([a=duct b=gift] [hun %give b])
          ::
            %+  turn  (flop byn)
            |=([a=duct b=riot] [a %give [%writ b]])
          ::
            %+  turn  (flop vag)
            |=([a=duct b=gift] [a %give b])
          ::
            %+  turn  (flop say)
            |=  [a=duct b=path c=ship d=[p=@ud q=riff]]
            :-  a
            [%pass b %a %want [who c] [%q %re p.q.d (scot %ud p.d) ~] q.d]
          ::
            %+  turn  (flop tag)
            |=([a=duct b=path c=note] [a %pass b c])
          ==
```

This is very simple code. We see there are exactly five different kinds
of side effects we can generate.

In `yel` we put gifts that we wish to be sent along the `hun:room` duct
to dill. See the documentation for `++room` above. This is how we
display messages to the terminal.

In `byn` we put riots that we wish returned to subscribers. Recall that
a riot is a response to a subscription. These are returned to our
subscribers in the form of a `%writ` gift.

In `vag` we put gifts along with the ducts on which to send them. This
allows us to produce arbitrary gifts, but in practice this is only used
to produce `%ergo` gifts.

In `say` we put messages we wish to pass to ames. These messages are
used to request information from clay on other piers. We must provide
not only the duct and the request (the riff), but also the return path,
the other ship to talk to, and the sequence number of the request.

In `tag` we put arbitrary notes we wish to pass to other vanes. For now,
the only notes we pass here are `%wait` and `%rest` to the timer vane.

Now that we know what kinds of side effects we may have, we can jump
into the handling of requests.

```hoon
        ++  ease                                          ::  release request
          |=  hen=duct
          ^+  +>
          ?~  ref  +>
            =+  rov=(~(got by qyx) hen)
            =.  qyx  (~(del by qyx) hen)
            (mabe rov (cury best hen))
          =.  qyx  (~(del by qyx) hen)
          |-  ^+  +>+.$
          =+  nux=(~(get by fod.u.ref) hen)
          ?~  nux  +>+.$
          %=  +>+.$
            say        [[hen [(scot %ud u.nux) ~] for [u.nux syd ~]] say]
            fod.u.ref  (~(del by fod.u.ref) hen)
            bom.u.ref  (~(del by bom.u.ref) u.nux)
          ==
```

This is called when we're cancelling a subscription. For domestic desks,
`ref` is null, so we're going to cancel any timer we might have created.
We first delete the duct from our map of requests, and then we call
`++mabe` with `++best` to send a `%rest` kiss to the timer vane if we
have started a timer. We'll describe `++best` and `++mabe` momentarily.

Although we said we're not going to talk about foreign requests yet,
it's easy to see that for foreign desks, we cancel any outstanding
requests for this duct and send a message over ames to the other ship
telling them to cancel the subscription.

```hoon
        ++  best
          |=  [hen=duct tym=@da]
          %_(+> tag :_(tag [hen /tyme %t %rest tym]))
```

This simply pushes a `%rest` note onto `tag`, from where it will be
passed back to arvo to be handled. This cancels the timer at the given
duct (with the given time).

```hoon
        ++  mabe                                            ::  maybe fire function
          |*  [rov=rove fun=$+(@da _+>.^$)]
          ^+  +>.$
          %-  fall  :_  +>.$
          %-  bind  :_  fun
          ^-  (unit ,@da)
          ?-    -.rov
              %&
            ?.  ?=(%da -.q.p.rov)  ~
            `p.q.p.rov
              %|
            =*  mot  p.rov
            %+  hunt
              ?.  ?=(%da -.p.mot)  ~
              ?.((lth now p.p.mot) ~ [~ p.p.mot])
            ?.  ?=(%da -.q.mot)  ~
            ?.((lth now p.q.mot) [~ now] [~ p.q.mot])
          ==
```

This decides whether the given request can only be satsified in the
future. In that case, we call the given function with the time in the
future when we expect to have an update to give to this request. This is
called with `++best` to cancel timers and with `++bait` to start them.

For single requests, we have a time if the request is for a particular
time (which is assumed to be in the future). For ranges of requests, we
check both the start and end cases to see if they are time cases. If so,
we choose the earlier time.

If any of those give us a time, then we call the given funciton with the
smallest time.

The more interesting case is, of course, when we're not cancelling a
subscription but starting one.

```hoon
        ++  eave                                          ::  subscribe
          |=  [hen=duct rav=rave]
          ^+  +>
          ?-    -.rav
              &
            ?:  &(=(p.p.rav %u) !=(p.q.p.rav now))
              ~&  [%clay-fail p.q.p.rav %now now]
              !!
            =+  ver=(aver p.rav)
            ?~  ver
              (duce hen rav)
            ?~  u.ver
              (blub hen)
            (blab hen p.rav u.u.ver)
```

There are two types of subscriptions -- either we're requesting a single
file or we're requesting a range of versions of a desk. We'll dicuss the
simpler case first.

First, we check that we're not requesting the `rang` from any time other
than the present. Since we don't store that information for any other
time, we can't produce it in a referentially transparent manner for any
time other than the present.

Then, we try to read the requested `mood:clay` `p.rav`. If we can't access
the request data right now, we call `++duce` to put the request in our
queue to be satisfied when the information becomes available.

This case occurs when we make a request for a case whose (1) date is
after the current date, (2) number is after the current number, or (3)
label is not yet used.

```hoon
        ++  duce                                            ::  produce request
          |=  [hen=duct rov=rove]
          ^+  +>
          =.  qyx  (~(put by qyx) hen rov)
          ?~  ref
            (mabe rov (cury bait hen))
          |-  ^+  +>+.$                                     ::  XX  why?
          =+  rav=(reve rov)
          =+  ^=  vaw  ^-  rave
            ?.  ?=([%& %v *] rav)  rav
            [%| [%ud let.dom] `case`q.p.rav r.p.rav]
          =+  inx=nix.u.ref
          %=  +>+.$
            say        [[hen [(scot %ud inx) ~] for [inx syd ~ vaw]] say]
            nix.u.ref  +(nix.u.ref)
            bom.u.ref  (~(put by bom.u.ref) inx [hen vaw])
            fod.u.ref  (~(put by fod.u.ref) hen inx)
          ==
```

The code for `++duce` is nearly the exact inverse of `++ease`, which in
the case of a domestic desk is very simple -- we simply put the duct and
rave into `qyx` and possibly start a timer with `++mabe` and `++bait`.
Recall that `ref` is null for domestic desks and that `++mabe` fires the
given function with the time we need to be woken up at, if we need to be
woken up at a particular time.

```hoon
        ++  bait
          |=  [hen=duct tym=@da]
          %_(+> tag :_(tag [hen /tyme %t %wait tym]))
```

This sets an alarm by sending a `%wait` card with the given time to the
timer vane.

Back in `++eave`, if `++aver` returned `[~ ~]`, then we cancel the
subscription. This occurs when we make (1) a `%x` request for a file
that does not exist, (2) a `%w` request with a case that is not a
number, or (3) a `%w` request with a nonempty path. The `++blub` is
exactly what you would expect it to be.

```hoon
        ++  blub                                          ::  ship stop
          |=  hen=duct
          %_(+> byn [[hen ~] byn])
```

We notify the duct that we're cancelling their subscription since it
isn't satisfiable.

Otherwise, we have received the desired information, so we send it on to
the subscriber with `++blab`.

```hoon
        ++  blab                                          ::  ship result
          |=  [hen=duct mun=mood dat=*]
          ^+  +>
          +>(byn [[hen ~ [p.mun q.mun syd] r.mun dat] byn])
```

The most interesting arm called in `++eave` is, of course, `++aver`,
where we actually try to read the data.

```hoon
        ++  aver                                          ::  read
          |=  mun=mood
          ^-  (unit (unit ,*))
          ?:  &(=(p.mun %u) !=(p.q.mun now))              ::  prevent bad things
            ~&  [%clay-fail p.q.mun %now now]
            !!
          =+  ezy=?~(ref ~ (~(get by haw.u.ref) mun))
          ?^  ezy  ezy
          =+  nao=(~(case-to-aeon ze lim dom ran) q.mun)
          ?~(nao ~ [~ (~(read-at-aeon ze lim dom ran) u.nao mun)])
```

We check immediately that we're not requesting the `rang` for any time
other than the present.

If this is a foreign desk, then we check our cache for the specific
request. If either this is a domestic desk or we don't have the request
in our cache, then we have to actually go read the data from our dome.

We need to do two things. First, we try to find the number of the commit
specified by the given case, and then we try to get the data there.

Here, we jump into `arvo/zuse.hoon`, which is where much of the
algorithmic code is stored, as opposed to the clay interface, which is
stored in `arvo/clay.hoon`. We examine `++case-to-aeon:ze`.

```hoon
      ++  case-to-aeon                                      ::    case-to-aeon:ze
        |=  lok=case                                        ::  act count through
        ^-  (unit aeon)
        ?-    -.lok
            %da
          ?:  (gth p.lok lim)  ~
          |-  ^-  (unit aeon)
          ?:  =(0 let)  [~ 0]                               ::  avoid underflow
          ?:  %+  gte  p.lok
              =<  t
              %-  tako-to-yaki
              %-  aeon-to-tako
              let
            [~ let]
          $(let (dec let))
        ::
            %tas  (~(get by lab) p.lok)
            %ud   ?:((gth p.lok let) ~ [~ p.lok])
        ==
```

We handle each type of `case:clay` differently. The latter two types are
easy.

If we're requesting a revision by label, then we simply look up the
requested label in `lab` from the given dome. If it exists, that is our
aeon; else we produce null, indicating the requested revision does not
yet exist.

If we're requesting a revision by number, we check if we've yet reached
that number. If so, we produce the number; else we produce null.

If we're requesting a revision by date, we check first if the date is in
the future, returning null if so. Else we start from the most recent
revision and scan backwards until we find the first revision committed
before that date, and we produce that. If we requested a date before any
revisions were committed, we produce `0`.

The definitions of `++aeon-to-tako` and `++tako-to-yaki` are trivial.

```hoon
      ++  aeon-to-tako  ~(got by hit)

      ++  tako-to-yaki  ~(got by hut)                       ::  grab yaki
```

We simply look up the aeon or tako in their respective maps (`hit` and
`hut`).

Assuming we got a valid version number, `++aver` calls
`++read-at-aeon:ze`, which reads the requested data at the given
revision.

```hoon
      ++  read-at-aeon                                      ::    read-at-aeon:ze
        |=  [oan=aeon mun=mood]                             ::  seek and read
        ^-  (unit)
        ?:  &(?=(%w p.mun) !?=(%ud -.q.mun))                ::  NB only for speed
          ?^(r.mun ~ [~ oan])
        (read:(rewind oan) mun)
```

If we're requesting the revision number with a case other than by
number, then we go ahead and just produce the number we were given.
Otherwise, we call `++rewind` to rewind our state to the given revision,
and then we call `++read` to get the requested information.

```hoon
      ++  rewind                                            ::    rewind:ze
        |=  oan=aeon                                        ::  rewind to aeon
        ^+  +>
        ?:  =(let oan)  +>
        ?:  (gth oan let)  !!                               ::  don't have version
        +>(ank (checkout-ankh q:(tako-to-yaki (aeon-to-tako oan))), let oan)
```

If we're already at the requested version, we do nothing. If we're
requesting a version later than our head, we are unable to comply.

Otherwise, we get the hash of the commit at the number, and from that we
get the commit itself (the yaki), which has the map of path to lobe that
represents a version of the filesystem. We call `++checkout-ankh` to
checkout the commit, and we replace `ank` in our context with the
result.

```hoon
      ++  checkout-ankh                                     ::    checkout-ankh:ze
        |=  hat=(map path lobe)                             ::  checkout commit
        ^-  ankh
        %-  cosh
        %+  roll  (~(tap by hat) ~)
        |=  [[pat=path bar=lobe] ank=ankh]
        ^-  ankh
        %-  cosh
        ?~  pat
          =+  zar=(lobe-to-noun bar)
          ank(q [~ (sham zar) zar])
        =+  nak=(~(get by r.ank) i.pat)
        %=  ank
          r  %+  ~(put by r.ank)  i.pat
             $(pat t.pat, ank (fall nak _ankh))
        ==
```

Twice we call `++cosh`, which hashes a commit, updating `p` in an
`ankh`. Let's jump into that algorithm before we describe
`++checkout-ankh`.

```hoon
    ++  cosh                                                ::  locally rehash
      |=  ank=ankh                                          ::  NB v/unix.c
      ank(p rehash:(zu ank))
```

We simply replace `p` in the hash with the `cash` we get from a call to
`++rehash:zu`.

```hoon
    ++  zu  !:                                              ::  filesystem
      |=  ank=ankh                                          ::  filesystem state
      =|  myz=(list ,[p=path q=miso])                       ::  changes in reverse
      =|  ram=path                                          ::  reverse path into
      |%
      ++  rehash                                            ::  local rehash
        ^-  cash
        %+  mix  ?~(q.ank 0 p.u.q.ank)
        =+  axe=1
        |-  ^-  cash
        ?~  r.ank  _@
        ;:  mix
          (shaf %dash (mix axe (shaf %dush (mix p.n.r.ank p.q.n.r.ank))))
          $(r.ank l.r.ank, axe (peg axe 2))
          $(r.ank r.r.ank, axe (peg axe 3))
        ==
```

`++zu` is a core we set up with a particular filesystem node to traverse
a checkout of the filesystem and access the actual data inside it. One
of the things we can do with it is to create a recursive hash of the
node.

In `++rehash`, if this node is a file, then we xor the remainder of the
hash with the hash of the contents of the file. The remainder of the
hash is `0` if we have no children, else we descend into our children.
Basically, we do a half SHA-256 of the xor of the axis of this child and
the half SHA-256 of the xor of the name of the child and the hash of the
child. This is done for each child and all the results are xored
together.

Now we return to our discussion of `++checkout-ankh`.

We fold over every path in this version of the filesystem and create a
great ankh out of them. First, we call `++lobe-to-noun` to get the raw
data referred to be each lobe.

```hoon
      ++  lobe-to-noun                                      ::  grab blob
        |=  p=lobe                                          ::  ^-  *
        %-  blob-to-noun
        (lobe-to-blob p)
```

This converts a lobe into the raw data it refers to by first getting the
blob with `++lobe-to-blob` and converting that into data with
`++blob-to-noun`.

```hoon
      ++  lobe-to-blob  ~(got by lat)                       ::  grab blob
```

This just grabs the blob that the lobe refers to.

```hoon
      ++  blob-to-noun                                      ::  grab blob
        |=  p=blob
        ?-   -.p
           %delta  (lump r.p (lobe-to-noun q.p))
           %direct  q.p
           %indirect  q.p
        ==
```

If we have either a direct or an indirect blob, then the data is stored
right in the blob. Otherwise, we have to reconstruct it from the diffs.
We do this by calling `++lump` on the diff in the blob with the data
obtained by recursively calling the parent of this blob.

```hoon
    ++  lump                                                ::  apply patch
      |=  [don=udon src=*]
      ^-  *
      ?+    p.don  ~|(%unsupported !!)
          %a
        ?+  -.q.don  ~|(%unsupported !!)
          %a  q.q.don
          %c  (lurk ((hard (list)) src) p.q.don)
          %d  (lure src p.q.don)
        ==
      ::
          %c
        =+  dst=(lore ((hard ,@) src))
        %-  roly
        ?+  -.q.don  ~|(%unsupported !!)
          %a  ((hard (list ,@t)) q.q.don)
          %c  (lurk dst p.q.don)
        ==
      ==
```

This is defined in `arvo/hoon.hoon` for historical reasons which are
likely no longer applicable. Since the `++umph` structure will likely
change we convert clay to be a typed filesystem, we'll only give a
high-level description of this process. If we have a `%a` udon, then
we're performing a trivial replace, so we produce simply `q.q.don`. If
we have a `%c` udon, then we're performing a list merge (as in, for
example, lines of text). The merge is performed by `++lurk`.

```hoon
    ++  lurk                                                ::  apply list patch
      |*  [hel=(list) rug=(urge)]
      ^+  hel
      =+  war=`_hel`~
      |-  ^+  hel
      ?~  rug  (flop war)
      ?-    -.i.rug
          &
        %=   $
          rug  t.rug
          hel  (slag p.i.rug hel)
          war  (weld (flop (scag p.i.rug hel)) war)
        ==
      ::
          |
        %=  $
          rug  t.rug
          hel  =+  gur=(flop p.i.rug)
               |-  ^+  hel
               ?~  gur  hel
               ?>(&(?=(^ hel) =(i.gur i.hel)) $(hel t.hel, gur t.gur))
          war  (weld q.i.rug war)
        ==
      ==
```

We accumulate our final result in `war`. If there's nothing more in our
list of merge instructions (unces), we just reverse `war` and produce
it. Otherwise, we process another unce. If the unce is of type `&`, then
we have `p.i.rug` lines of no changes, so we just copy them over from
`hel` to `war`. If the unice is of type `|`, then we verify that the
source lines (in `hel`) are what we expect them to be (`p.i.rug`),
crashing on failure. If they're good, then we append the new lines in
`q.i.rug` onto `war`.

And that's really it. List merges are pretty easy. Anyway, if you
recall, we were discussing `++checkout-ankh`.

```hoon
      ++  checkout-ankh                                     ::    checkout-ankh:ze
        |=  hat=(map path lobe)                             ::  checkout commit
        ^-  ankh
        %-  cosh
        %+  roll  (~(tap by hat) ~)
        |=  [[pat=path bar=lobe] ank=ankh]
        ^-  ankh
        %-  cosh
        ?~  pat
          =+  zar=(lobe-to-noun bar)
          ank(q [~ (sham zar) zar])
        =+  nak=(~(get by r.ank) i.pat)
        %=  ank
          r  %+  ~(put by r.ank)  i.pat
             $(pat t.pat, ank (fall nak _ankh))
        ==
```

If the path is null, then we calculate `zar`, the raw data at the path
`pat` in this version. We produce the given ankh with the correct data.

Otherwise, we try to get the child we're looking at from our parent
ankh. If it's already been created, this succeeds; otherwise, we simply
create a default blank ankh. We place ourselves in our parent after
recursively computing our children.

This algorithm really isn't that complicated, but it may not be
immediately obvious why it works. An example should clear everything up.

Suppose `hat` is a map of the following information.

```
    /greeting                 -->  "customary upon meeting"
    /greeting/english         -->  "hello"
    /greeting/spanish         -->  "hola"
    /greeting/russian/short   -->  "привет"
    /greeting/russian/long    -->  "Здравствуйте"
    /farewell/russian         -->  "до свидания"
```

Furthermore, let's say that we process them in this order:

```
    /greeting/english
    /greeting/russian/short
    /greeting/russian/long
    /greeting
    /greeting/spanish
    /farewell/russian
```

Then, the first path we process is `/greeting/english` . Since our path
is not null, we try to get `nak`, but because our ankh is blank at this
point it doesn't find anything. Thus, update our blank top-level ankh
with a child `%greeting`. and recurse with the blank `nak` to create the
ankh of the new child.

In the recursion, we our path is `/english` and our ankh is again blank.
We try to get the `english` child of our ankh, but this of course fails.
Thus, we update our blank `/greeting` ankh with a child `english`
produced by recursing.

Now our path is null, so we call `++lobe-to-noun` to get the actual
data, and we place it in the brand-new ankh.

Next, we process `/greeting/russian/short`. Since our path is not null,
we try to get the child named `%greeting`, which does exist since we
created it earlier. We put modify this child by recursing on it. Our
path is now `/russian/short`, so we look for a `%russian` child in our
`/greeting` ankh. This doesn't exist, so we add it by recursing. Our
path is now `/short`, so we look for a `%short` child in our
`/greeting/russian` ankh. This doesn't exist, so we add it by recursing.
Now our path is null, so we set the contents of this node to `"привет"`,
and we're done processing this path.

Next, we process `/greeting/russian/long`. This proceeds similarly to
the previous except that now the ankh for `/greeting/russian` already
exists, so we simply reuse it rather than creating a new one. Of course,
we still must create a new `/greeting/russian/long` ankh.

Next, we process `/greeting`. This ankh already exists, so after we've
recursed once, our path is null, and our ankh is not blank -- it already
has two children (and two grandchildren). We don't touch those, though,
since a node may be both a file and a directory. We just add the
contents of the file -- "customary upon meeting" -- to the existing
ankh.

Next, we process `/greeting/spanish`. Of course, the `/greeting` ankh
already exists, but it doesn't have a `%spanish` child, so we create
that, taking care not to disturb the contents of the `/greeting` file.
We put "hola" into the ankh and call it good.

Finally, we process `/farewell/russian`. Here, the `/farewell` ankh
doesn't exist, so we create it. Clearly the newly-created ankh doesn't
have any children, so we have to add a `%russian` child, and in this
child we put our last content -- "до свидания".

We hope it's fairly obvious that the order we process the paths doesn't
affect the final ankh tree. The tree will be constructed in a very
different order depending on what order the paths come in, but the
resulting tree is independent of order.

At any rate, we were talking about something important, weren't we? If
you recall, that concludes our discussion of `++rewind`, which was
called from `++read-at-aeon`. In summary, `++rewind` returns a context
in which our current state is (very nearly) as it was when the specified
version of the desk was the head. This allows `++read-at-aeon` to call
`++read` to read the requested information.

```hoon
      ++  read                                              ::    read:ze
        |=  mun=mood                                        ::  read at point
        ^-  (unit)
        ?:  ?=(%v p.mun)
          [~ `dome`+<+<.read]
        ?:  &(?=(%w p.mun) !?=(%ud -.q.mun))
          ?^(r.mun ~ [~ let])
        ?:  ?=(%w p.mun)
          =+  ^=  yak
              %-  tako-to-yaki
              %-  aeon-to-tako
              let
          ?^(r.mun ~ [~ [t.yak (forge-nori yak)]])
          ::?>  ?=(^ hit)  ?^(r.mun ~ [~ i.hit])     ::  what do?? need [@da nori]
        (query(ank ank:(descend-path:(zu ank) r.mun)) p.mun)
```

If we're requesting the dome, then we just return that immediately.

If we're requesting the revision number of the desk and we're not
requesting it by number, then we just return the current number of this
desk. Note of course that this was really already handled in
`++read-at-aeon`.

If we're requesting a `%w` with a specific revision number, then we do
something or other with the commit there. It's kind of weird, and it
doesn't seem to work, so we'll ignore this case.

Otherwise, we descend into the ankh tree to the given path with
`++descend-path:zu`, and then we handle specific request in `++query`.

```hoon
      ++  descend-path                                      ::  descend recursively
        |=  way=path
        ^+  +>
        ?~(way +> $(way t.way, +> (descend i.way)))
```

This is simple recursion down into the ankh tree. `++descend` descends
one level, so this will eventually get us down to the path we want.

```hoon
      ++  descend                                           ::  descend
        |=  lol=@ta
        ^+  +>
        =+  you=(~(get by r.ank) lol)
        +>.$(ram [lol ram], ank ?~(you [*cash ~ ~] u.you))
```

`ram` is the path that we're at, so to descend one level we push the
name of this level onto that path. We update the ankh with the correct
one at that path if it exists; else we create a blank one.

Once we've decscended to the correct level, we need to actually deal
with the request.

```hoon
      ++  query                                             ::    query:ze
        |=  ren=?(%u %v %x %y %z)                           ::  endpoint query
        ^-  (unit ,*)
        ?-  ren
          %u  [~ `rang`+<+>.query]
          %v  [~ `dome`+<+<.query]
          %x  ?~(q.ank ~ [~ q.u.q.ank])
          %y  [~ as-arch]
          %z  [~ ank]
        ==
```

Now that everything's set up, it's really easy. If they're requesting
the rang, dome, or ankh, we give it to them. If the contents of a file,
we give it to them if it is in fact a file. If the `arch`, then we
calculate it with `++as-arch`.

```hoon
      ++  as-arch                                           ::    as-arch:ze
        ^-  arch                                            ::  arch report
        :+  p.ank
          ?~(q.ank ~ [~ p.u.q.ank])
        |-  ^-  (map ,@ta ,~)
        ?~  r.ank  ~
        [[p.n.r.ank ~] $(r.ank l.r.ank) $(r.ank r.r.ank)]
```

This very simply strips out all the "real" data and returns just our own
hash, the hash of the file contents (if we're a file), and a map of the
names of our immediate children.

## Lifecycle of a Local Subscription

A subscription to a range of revisions of a desk initially follows the
same path that a single read does. In `++aver`, we checked the head of
the given rave. If the head was `&`, then it was a single request, so we
handled it above. If `|`, then we handle it with the following code.

```hoon
            =+  nab=(~(case-to-aeon ze lim dom ran) p.p.rav)
            ?~  nab
              ?>  =(~ (~(case-to-aeon ze lim dom ran) q.p.rav))
              (duce hen (rive rav))
            =+  huy=(~(case-to-aeon ze lim dom ran) q.p.rav)
            ?:  &(?=(^ huy) |((lth u.huy u.nab) &(=(0 u.huy) =(0 u.nab))))
              (blub hen)
            =+  top=?~(huy let.dom u.huy)
            =+  sar=(~(lobes-at-path ze lim dom ran) u.nab r.p.rav)
            =+  ear=(~(lobes-at-path ze lim dom ran) top r.p.rav)
            =.  +>.$
              ?:  =(sar ear)  +>.$
              =+  fud=(~(make-nako ze lim dom ran) u.nab top)
              (bleb hen u.nab fud)
            ?^  huy
              (blub hen)
            =+  ^=  ptr  ^-  case
                [%ud +(let.dom)]
            (duce hen `rove`[%| ptr q.p.rav r.p.rav ear])
          ==
```

Recall that `++case-to-aeon:ze` produces the revision number that a case
corresponds to, if it corresponds to any. If it doesn't yet correspond
to a revision, then it produces null.

Thus, we first check to see if we've even gotten to the beginning of the
range of revisions requested. If not, then we assert that we haven't yet
gotten to the end of the range either, because that would be really
strange. If not, then we immediately call `++duce`, which, if you
recall, for a local request, simply puts this duct and rove into our
cult `qyx`, so that we know who to respond to when the revision does
appear.

If we've already gotten to the first revision, then we can produce some
content immediately. If we've also gotten to the final revision, and
that revision is earlier than the start revision, then it's a bad
request and we call `++blub`, which tells the subscriber that his
subscription will not be satisfied.

Otherwise, we find the data at the given path at the beginning of the
subscription and at the last available revision in the subscription. If
they're the same, then we don't send a notification. Otherwise, we call
`++gack`, which creates the `++nako` we need to produce. We call
`++bleb` to actually produce the information.

If we already have the last requested revision, then we also tell the
subscriber with `++blub` that the subscription will receive no further
updates.

If there will be more revisions in the subscription, then we call
`++duce`, adding the duct to our subscribers. We modify the rove to
start at the next revision since we've already handled all the revisions
up to the present.

We glossed over the calls to `++lobes-at-path`, `++make-nako`, and
`++bleb`, so we'll get back to those right now. `++bleb` is simple, so
we'll start with that.

```hoon
        ++  bleb                                          ::  ship sequence
          |=  [hen=duct ins=@ud hip=nako]
          ^+  +>
          (blab hen [%w [%ud ins] ~] hip)
```

We're given a duct, the beginning revision number, and the nako that
contains the updates since that revision. We use `++blab` to produce
this result to the subscriber. The case is `%w` with a revision number
of the beginning of the subscription, and the data is the nako itself.

We call `++lobes-at-path:ze` to get the data at the particular path.

```hoon
      ++  lobes-at-path                                     ::    lobes-at-path:ze
        |=  [oan=aeon pax=path]                             ::  data at path
        ^-  (map path lobe)
        ?:  =(0 oan)  ~
        %-  mo
        %+  skim
          %.  ~
          %~  tap  by
          =<  q
          %-  tako-to-yaki
          %-  aeon-to-tako
          oan
        |=  [p=path q=lobe]
        ?|  ?=(~ pax)
            ?&  !?=(~ p)
                =(-.pax -.p)
                $(p +.p, pax +.pax)
        ==  ==
```

At revision zero, the theoretical common revision between all
repositories, there is no data, so we produce null.

We get the list of paths (paired with their lobe) in the revision
referred to by the given number and we keep only those paths which begin
with `pax`. Converting to a map, we now have a map from the subpaths at
the given path to the hash of their data. This is simple and efficient
to calculate and compare to later revisions. This allows us to easily
tell if a node or its children have changed.

Finally, we will describe `++make-nako:ze`.

```hoon
      ++  make-nako                                         ::  gack a through b
        |=  [a=aeon b=aeon]
        ^-  [(map aeon tako) aeon (set yaki) (set blob)]
        :_  :-  b
            =-  [(takos-to-yakis -<) (lobes-to-blobs ->)]
            %+  reachable-between-takos
              (~(get by hit) a)                             ::  if a not found, a=0
            (aeon-to-tako b)
        ^-  (map aeon tako)
        %-  mo  %+  skim  (~(tap by hit) ~)
        |=  [p=aeon *]
        &((gth p a) (lte p b))
```

We need to produce four things -- the numbers of the new commits, the
number of the latest commit, the new commits themselves, and the new
data itself.

The first is fairly easy to produce. We simply go over our map of
numbered commits and produce all those numbered greater than `a` and not
greater than `b`.

The second is even easier to produce -- `b` is clearly our most recent
commit.

The third and fourth are slightly more interesting, though not too
terribly difficult. First, we call `++reachable-between-takos`.

```hoon
      ++  reachable-between-takos
        |=  [a=(unit tako) b=tako]                          ::  pack a through b
        ^-  [(set tako) (set lobe)]
        =+  ^=  sar
            ?~  a  ~
            (reachable-takos r:(tako-to-yaki u.a))
        =+  yak=`yaki`(tako-to-yaki b)
        %+  new-lobes-takos  (new-lobes ~ sar)              ::  get lobes
        |-  ^-  (set tako)                                  ::  walk onto sar
        ?:  (~(has in sar) r.yak)
          ~
        =+  ber=`(set tako)`(~(put in `(set tako)`~) `tako`r.yak)
        %-  ~(uni in ber)
        ^-  (set tako)
        %+  roll  p.yak
        |=  [yek=tako bar=(set tako)]
        ^-  (set tako)
        ?:  (~(has in bar) yek)                             ::  save some time
          bar
        %-  ~(uni in bar)
        ^$(yak (tako-to-yaki yek))
```

We take a possible starting commit and a definite ending commit, and we
produce the set of commits and the set of data between them.

We let `sar` be the set of commits reachable from `a`. If `a` is null,
then obviously no commits are reachable. Otherwise, we call
`++reachable-takos` to calculate this.

```hoon
      ++  reachable-takos                                   ::  reachable
        |=  p=tako                                          ::  XX slow
        ^-  (set tako)
        =+  y=(tako-to-yaki p)
        =+  t=(~(put in _(set tako)) p)
        %+  roll  p.y
        |=  [q=tako s=_t]
        ?:  (~(has in s) q)                                 ::  already done
          s                                                 ::  hence skip
        (~(uni in s) ^$(p q))                               ::  otherwise traverse
```

We very simply produce the set of the given tako plus its parents,
recursively.

Back in `++reachable-between-takos`, we let `yak` be the yaki of `b`,
the ending commit. With this, we create a set that is the union of `sar`
and all takos reachable from `b`.

We pass `sar` into `++new-lobes` to get all the lobes referenced by any
tako referenced by `a`. The result is passed into `++new-lobes-takos` to
do the same, but not recomputing those in already calculated last
sentence. This produces the sets of takos and lobes we need.

```hoon
      ++  new-lobes                                         ::  object hash set
        |=  [b=(set lobe) a=(set tako)]                     ::  that aren't in b
        ^-  (set lobe)
        %+  roll  (~(tap in a) ~)
        |=  [tak=tako bar=(set lobe)]
        ^-  (set lobe)
        =+  yak=(tako-to-yaki tak)
        %+  roll  (~(tap by q.yak) ~)
        |=  [[path lob=lobe] far=_bar]
        ^-  (set lobe)
        ?~  (~(has in b) lob)                               ::  don't need
          far
        =+  gar=(lobe-to-blob lob)
        ?-  -.gar
          %direct  (~(put in far) lob)
          %delta  (~(put in $(lob q.gar)) lob)
          %indirect  (~(put in $(lob s.gar)) lob)
        ==
```

Here, we're creating a set of lobes referenced in a commit in `a`. We
start out with `b` as the initial set of lobes, so we don't need to
recompute any of the lobes referenced in there.

The algorithm is pretty simple, so we won't bore you with the details.
We simply traverse every commit in `a`, looking at every blob referenced
there, and, if it's not already in `b`, we add it to `b`. In the case of
a direct blob, we're done. For a delta or an indirect blob, we
recursively add every blob referenced within the blob.

```hoon
      ++  new-lobes-takos                                   ::  garg & repack
        |=  [b=(set lobe) a=(set tako)]
        ^-  [(set tako) (set lobe)]
        [a (new-lobes b a)]
```

Here, we just update the set of lobes we're given with the commits we're
given and produce both sets.

This concludes our discussion of a local subscription.

## Lifecycle of a Foreign Read or Subscription

Foreign reads and subscriptions are handled in much the same way as
local ones. The interface is the same -- a vane or app sends a `%warp`
kiss with the request. The difference is simply that the `sock` refers
to the foreign ship.

Thus, we start in the same place -- in `++call`, handling `%warp`.
However, since the two side of the `sock` are different, we follow a
different path.

```hoon
            =+  wex=(do now p.q.hic p.q.q.hic ruf)
            =+  ^=  woo
              ?~  q.q.q.hic
                abet:(ease:wex hen)
              abet:(eave:wex hen u.q.q.q.hic)
            [-.woo (posh q.p.q.hic p.q.q.hic +.woo ruf)]
```

If we compare this to how the local case was handled, we see that it's
not all that different. We use `++do` rather than `++un` and `++de` to
set up the core for the foreign ship. This gives us a `++de` core, so we
either cancel or begin the request by calling `++ease` or `++eave`,
exactly as in the local case. In either case, we call `++abet:de` to
resolve our various types of output into actual moves, as described in
the local case. Finally, we call `++posh` to update our raft, putting
the modified rung into the raft.

We'll first trace through `++do`.

```hoon
      ++  do
        |=  [now=@da [who=ship him=ship] syd=@tas ruf=raft]
        =+  ^=  rug  ^-  rung
            =+  rug=(~(get by hoy.ruf) him)
            ?^(rug u.rug *rung)
        =+  ^=  red  ^-  rede
            =+  yit=(~(get by rus.rug) syd)
            ?^(yit u.yit `rede`[~2000.1.1 ~ [~ *rind] *dome])
        ((de now ~ ~) [who him] syd red ran.ruf)
```

If we already have a rung for this foreign ship, then we use that.
Otherwise, we create a new blank one. If we already have a rede in this
rung, then we use that, otherwise we create a blank one. An important
point to note here is that we let `ref` in the rede be `[~ *rind]`.
Recall, for domestic desks `ref` is null. We use this to distinguish
between foreign and domestic desks in `++de`.

With this information, we create a `++de` core as usual.

Although we've already covered `++ease` and `++eave`, we'll go through
them quickly again, highlighting the case of foreign request.

```hoon
        ++  ease                                          ::  release request
          |=  hen=duct
          ^+  +>
          ?~  ref  +>
            =+  rov=(~(got by qyx) hen)
            =.  qyx  (~(del by qyx) hen)
            (mabe rov (cury best hen))
          =.  qyx  (~(del by qyx) hen)
          |-  ^+  +>+.$
          =+  nux=(~(get by fod.u.ref) hen)
          ?~  nux  +>+.$
          %=  +>+.$
            say        [[hen [(scot %ud u.nux) ~] for [u.nux syd ~]] say]
            fod.u.ref  (~(del by fod.u.ref) hen)
            bom.u.ref  (~(del by bom.u.ref) u.nux)
          ==
```

Here, we still remove the duct from our cult (we maintain a cult even
for foreign desks), but we also need to tell the foreign desk to cancel
our subscription. We do this by sending a request (by appending to
`say`, which gets resolved in `++abet:de` to a `%want` kiss to ames) to
the foreign ship to cancel the subscription. Since we don't anymore
expect a response on this duct, we remove it from `fod` and `bom`, which
are the maps between ducts, raves, and request sequence numbers.
Basically, we remove every trace of the subscription from our request
manager.

In the case of `++eave`, where we're creating a new request, everything
is exactly identical to the case of the local request except `++duce`.
We said that `++duce` simply puts the request into our cult. This is
true for a domestic request, but distinctly untrue for foreign requests.

```hoon
        ++  duce                                          ::  produce request
          |=  [hen=duct rov=rove]
          ^+  +>
          =.  qyx  (~(put by qyx) hen rov)
          ?~  ref  +>.$
          |-  ^+  +>+.$                                   ::  XX  why?
          =+  rav=(reve rov)
          =+  ^=  vaw  ^-  rave
            ?.  ?=([%& %v *] rav)  rav
            [%| [%ud let.dom] `case`q.p.rav r.p.rav]
          =+  inx=nix.u.ref
          %=  +>+.$
            say        [[hen [(scot %ud inx) ~] for [inx syd ~ vaw]] say]
            nix.u.ref  +(nix.u.ref)
            bom.u.ref  (~(put by bom.u.ref) inx [hen vaw])
            fod.u.ref  (~(put by fod.u.ref) hen inx)
          ==
```

If we have a request manager (i.e. this is a foreign desk), then we do
the approximate inverse of `++ease`. We create a rave out of the given
request and send it off to the foreign desk by putting it in `say`. Note
that the rave is created to request the information starting at the next
revision number. Since this is a new request, we put it into `fod` and
`bom` to associate the request with its duct and its sequence number.
Since we're using another sequence number, we must increment `nix`,
which represents the next available sequence number.

And that's really it for this side of the request. Requesting foreign
information isn't that hard. Let's see what it looks like on the other
side. When we get a request from another ship for information on our
ship, that comes to us in the form of a `%wart` from ames.

We handle a `%wart` in `++call`, right next to where we handle the
`%warp` case.

```hoon
            %wart
          ?>  ?=(%re q.q.hic)
          =+  ryf=((hard riff) s.q.hic)
          :_  ..^$
          :~  :-  hen
              :^  %pass  [(scot %p p.p.q.hic) (scot %p q.p.q.hic) r.q.hic]
                %c
              [%warp [p.p.q.hic p.p.q.hic] ryf]
          ==
```

Every request we receive should be of type `riff`, so we coerce it into
that type. We just convert this into a new `%warp` kiss that we pass to
ourself. This gets handled like normal, as a local request. When the
request produces a value, it does so like normal as a `%writ`, which is
returned to `++take` along the path we just sent it on.

```hoon
            %writ
          ?>  ?=([@ @ *] tea)
          =+  our=(need (slaw %p i.tea))
          =+  him=(need (slaw %p i.t.tea))
          :_  ..^$
          :~  :-  hen
              [%pass ~ %a [%want [our him] [%r %re %c t.t.tea] p.+.q.hin]]
          ==
```

Since we encoded the ship we need to respond to in the path, we can just
pass our `%want` back to ames, so that we tell the requesting ship about
the new data.

This comes back to the original ship as a `%waft` from ames, which comes
into `++take`, right next to where we handled `%writ`.

```hoon
            %waft
          ?>  ?=([@ @ ~] tea)
          =+  syd=(need (slaw %tas i.tea))
          =+  inx=(need (slaw %ud i.t.tea))
          =+  ^=  zat
            =<  wake
            (knit:(do now p.+.q.hin syd ruf) [inx ((hard riot) q.+.q.hin)])
          =^  mos  ruf
            =+  zot=abet.zat
            [-.zot (posh q.p.+.q.hin syd +.zot ruf)]
          [mos ..^$(ran.ruf ran.zat)]                         ::  merge in new obj
```

This gets the desk and sequence number from the path the request was
sent over. This determines exactly which request is being responded to.
We call `++knit:de` to apply the changes to our local desk, and we call
`++wake` to update our subscribers. Then we call `++abet:de` and
`++posh` as normal (like in `++eave`).

We'll examine `++knit` and `++wake`, in that order.

```hoon
        ++  knit                                          ::  external change
          |=  [inx=@ud rot=riot]
          ^+  +>
          ?>  ?=(^ ref)
          |-  ^+  +>+.$
          =+  ruv=(~(get by bom.u.ref) inx)
          ?~  ruv  +>+.$
          =>  ?.  |(?=(~ rot) ?=(& -.q.u.ruv))  .
              %_  .
                bom.u.ref  (~(del by bom.u.ref) inx)
                fod.u.ref  (~(del by fod.u.ref) p.u.ruv)
              ==
          ?~  rot
            =+  rav=`rave`q.u.ruv
            %=    +>+.$
                lim
              ?.(&(?=(| -.rav) ?=(%da -.q.p.rav)) lim `@da`p.q.p.rav)
            ::
                haw.u.ref
              ?.  ?=(& -.rav)  haw.u.ref
              (~(put by haw.u.ref) p.rav ~)
            ==
          ?<  ?=(%v p.p.u.rot)
          =.  haw.u.ref
            (~(put by haw.u.ref) [p.p.u.rot q.p.u.rot q.u.rot] ~ r.u.rot)
          ?.  ?=(%w p.p.u.rot)  +>+.$
          |-  ^+  +>+.^$
          =+  nez=[%w [%ud let.dom] ~]
          =+  nex=(~(get by haw.u.ref) nez)
          ?~  nex  +>+.^$
          ?~  u.nex  +>+.^$  ::  should never happen
          =.  +>+.^$     =+  roo=(edis ((hard nako) u.u.nex))
                         ?>(?=(^ ref.roo) roo)
          %=  $
            haw.u.ref  (~(del by haw.u.ref) nez)
          ==
```

This is kind of a long [gate](/docs/glossary/gate/), but don't worry, it's not bad at all.

First, we assert that we're not a domestic desk. That wouldn't make any
sense at all.

Since we have the sequence number of the request, we can get the duct
and rave from `bom` in our request manager. If we didn't actually
request this data (or the request was canceled before we got it), then
we do nothing.

Else, we remove the request from `bom` and `fod` unless this was a
subscription request and we didn't receive a null riot (which would
indicate the last message on the subscription).

Now, if we received a null riot, then if this was a subscription request
by date, then we update `lim` in our request manager (representing the
latest time at which we have complete information for this desk) to the
date that was requested. If this was a single read request, then we put
the result in our simple cache `haw` to make future requests faster.
Then we're done.

If we received actual data, then we put it into our cache `haw`. Unless
it's a `%w` request, we're done.

If it is a `%w` request, then we try to get the `%w` at our current head
from the cache. In general, that should be the thing we just put in a
moment ago, but that is not guaranteed. The most common case where this
is different is when we receive desk updates out of order. At any rate,
since we now have new information, we need to apply it to our local copy
of the desk. We do so in `++edis`, and then we remove the stuff we just
applied from the cache, since it's not really a true "single read", like
what should really be in the cache.

```hoon
        ++  edis                                          ::  apply subscription
          |=  nak=nako
          ^+  +>
          %=  +>
            hit.dom  (~(uni by hit.dom) gar.nak)
            let.dom  let.nak
            lat.ran  %+  roll  (~(tap in bar.nak) ~)
                     =<  .(yeb lat.ran)
                     |=  [sar=blob yeb=(map lobe blob)]
                     =+  zax=(blob-to-lobe sar)
                     %+  ~(put by yeb)  zax  sar
            hut.ran  %+  roll  (~(tap in lar.nak) ~)
                     =<  .(yeb hut.ran)
                     |=  [sar=yaki yeb=(map tako yaki)]
                     %+  ~(put by yeb)  r.sar  sar
          ==
```

This shows, of course, exactly why nako is defined the way it is. To
become completely up to date with the foreign desk, we need to merge
`hit` with the foreign one so that we have all the revision numbers. We
update `let` so that we know which revision is the head.

We merge the new blobs in `lat`, keying them by their hash, which we get
from a call to `++blob-to-lobe`. Recall that the hash is stored in the
actual blob itself. We do the same thing to the new yakis, putting them
in `hut`, keyed by their hash.

Now, our local dome should be exactly the same as the foreign one.

This concludes our discussion of `++knit`. Now the changes have been
applied to our local copy of the desk, and we just need to update our
subscribers. We do so in `++wake:de`.

```hoon
        ++  wake                                          ::  update subscribers
          ^+  .
          =+  xiq=(~(tap by qyx) ~)
          =|  xaq=(list ,[p=duct q=rove])
          |-  ^+  ..wake
          ?~  xiq
            ..wake(qyx (~(gas by *cult) xaq))
          ?-    -.q.i.xiq
              &
            =+  cas=?~(ref ~ (~(get by haw.u.ref) `mood`p.q.i.xiq))
            ?^  cas
              %=    $
                  xiq  t.xiq
                  ..wake  ?~  u.cas  (blub p.i.xiq)
                          (blab p.i.xiq p.q.i.xiq u.u.cas)
              ==
            =+  nao=(~(case-to-aeon ze lim dom ran) q.p.q.i.xiq)
            ?~  nao  $(xiq t.xiq, xaq [i.xiq xaq])
            $(xiq t.xiq, ..wake (balk p.i.xiq u.nao p.q.i.xiq))
          ::
              |
            =+  mot=`moot`p.q.i.xiq
            =+  nab=(~(case-to-aeon ze lim dom ran) p.mot)
            ?~  nab
              $(xiq t.xiq, xaq [i.xiq xaq])
            =+  huy=(~(case-to-aeon ze lim dom ran) q.mot)
            ?~  huy
              =+  ptr=[%ud +(let.dom)]
              %=  $
                xiq     t.xiq
                xaq     [[p.i.xiq [%| ptr q.mot r.mot s.mot]] xaq]
                ..wake  =+  ^=  ear
                            (~(lobes-at-path ze lim dom ran) let.dom r.p.q.i.xiq)
                        ?:  =(s.p.q.i.xiq ear)  ..wake
                        =+  fud=(~(make-nako ze lim dom ran) u.nab let.dom)
                        (bleb p.i.xiq let.dom fud)
              ==
            %=  $
              xiq     t.xiq
              ..wake  =-  (blub:- p.i.xiq)
                      =+  ^=  ear
                          (~(lobes-at-path ze lim dom ran) u.huy r.p.q.i.xiq)
                      ?:  =(s.p.q.i.xiq ear)  (blub p.i.xiq)
                      =+  fud=(~(make-nako ze lim dom ran) u.nab u.huy)
                      (bleb p.i.xiq +(u.nab) fud)
            ==
          ==
        --
```

This is even longer than `++knit`, but it's pretty similar to `++eave`.
We loop through each of our subscribers `xiq`, processing each in turn.
When we're done, we just put the remaining subscribers back in our
subscriber list.

If the subscriber is a single read, then, if this is a foreign desk
(note that `++wake` is called from other arms, and not only on foreign
desks). Obviously, if we find an identical request there, then we can
produce the result immediately. Referential transparency for the win. We
produce the result with a call to `++blab`. If this is a foreign desk
but the result is not in the cache, then we produce `++blub` (canceled
subscription with no data) for reasons entirely opaque to me. Seriously,
it seems like we should wait until we get an actual response to the
request. If someone figures out why this is, let me know. At any rate,
it seems to work.

If this is a domestic desk, then we check to see if the case exists yet.
If it doesn't, then we simply move on to the next subscriber, consing
this one onto `xaq` so that we can check again the next time around. If
it does exist, then we call `++balk` to fulfill the request and produce
it.

`++balk` is very simple, so we'll describe it here before we get to the
subscription case.

```hoon
        ++  balk                                          ::  read and send
          |=  [hen=duct oan=@ud mun=mood]
          ^+  +>
          =+  vid=(~(read-at-aeon ze lim dom ran) oan mun)
          ?~  vid  (blub hen)  (blab hen mun u.vid)
```

We call `++read-at-aeon` on the given request and aeon. If you recall,
this processes a `mood` at a particular aeon and produces the result, if
there is one. If there is data at the requested location, then we
produce it with `++blab`. Else, we call `++blub` to notify the
subscriber that no data can ever come over this subscriptioin since it
is now impossible for there to ever be data for the given request.
Because referential transparency.

At any rate, back to `++wake`. If the given rave is a subscription
request, then we proceed similarly to how we do in `++eave`. We first
try to get the aeon referred to by the starting case. If it doesn't
exist yet, then we can't do anything interesting with this subscription,
so we move on to the next one.

Otherwise, we try to get the aeon referred to by the ending case. If it
doesn't exist yet, then we produce all the information we can. We call
`++lobes-at-path` at the given aeon and path to see if the requested
path has actually changed. If it hasn't, then we don't produce anything;
else, we produce the correct nako by calling `++bleb` on the result of
`++make-nako`, as in `++eave`. At any rate, we move on to the next
subscription, putting back into our cult the current subscription with a
new start case of the next aeon after the present.

If the aeon referred to by the ending case does exist, then we drop this
subscriber from our cult and satisfy its request immediately. This is
the same as before -- we check to see if the data at the path has
actually changed, producing it if it has; else, we call `++blub` since
no more data can be produced over this subscription.

This concludes our discussion of foreign requests.
