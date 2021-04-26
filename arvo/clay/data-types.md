+++
title = "Data Types"
weight = 4
template = "doc.html"
+++

This section will be reference documentation for the data types used by our
filesystem. It is up to date as of March 2021.

As a general guide, we recommend reading and attempting to understand the data
structures used in any Hoon code before you try to read the code itself.
Although complete understanding of the data structures is impossible without
seeing them used in the code, an 80% understanding greatly clarifies the code.
As another general guide, when reading Hoon, it rarely pays off to understand
every line of code when it appears. Try to get the gist of it, and then move on.
The next time you come back to it, it'll likely make a lot more sense.

### Data Models

As you're reading through this section, remember you can always come
back to this when you run into these types later on. You're not going to
remember everything the first time through, but it is worth reading, or
at least skimming, this so that you get a rough idea of how our state is
organized.

The types that are certainly worth reading are `++raft`, `++room`,
`++dome:clay`, `++ankh:clay`, `++rung:clay`, `++rang:clay`, `++blob:clay`,
`++yaki:clay`, and `++nori:clay` (possibly in that order). All in all, though,
this section isn't too long, so many readers may wish to quickly read through
all of it. If you get bored, though, just skip to the next section. You can
always come back when you need to.

### `$raft`, formal state

```hoon
+$  raft                                                ::  filesystem
  $:  rom=room                                          ::  domestic
      hoy=(map ship rung)                               ::  foreign
      ran=rang                                          ::  hashes
      mon=(map term beam)                               ::  mount points
      hez=(unit duct)                                   ::  sync duct
      cez=(map @ta crew)                                ::  permission groups
      pud=(unit [=desk =yoki])                          ::  pending update
  ==                                                    ::
```

This is the state of the vane. Anything that must be remembered between
calls to Clay is stored in this state.

`ran` is the store of all commits and deltas, keyed by hash. The is
where all the "real" data we know is stored; the rest is "just
bookkeeping".

`rom` is the state for all local desks. It consists of a `duct` to
[Dill](@/docs/arvo/dill/dill.md) and a collection of `desk`s.

`hoy` is the state for all foreign desks.

`ran` is the global, hash-addressed object store. It has maps of commit hashes
to commits and content hashes to content.

`mon` is a collection of Unix mount points. `term` is the mount point (relative
to th pier) and `beam` is a domestic Clay directory.

`hez` is the duct used to sync with Unix.

`cez` is a collection of named permission groups.

`pud` is an update that's waiting on a kernel upgrade.


#### `$room`, filesystem per domestic ship

```hoon
+$  room                                                ::  fs per ship
          $:  hun=duct                                  ::  terminal duct
              dos=(map desk dojo)                       ::  native desk
          ==                                            ::
```

This is the representation of the filesystem of a ship on our pier.

`hun` is the duct we use to send messages to [Dill](@/docs/arvo/dill/dill.md) to
display notifications of filesystem changes. Only `%note` `%gift`s should be
produced along this `duct`. This is set by the `%init` `move`.

`dos` is a well-known operating system released in 1981. It is also the
set of `desk`s on this ship, mapped to their `desk` state.

#### `$desk`, filesystem branch

```hoon
+$  desk  @tas
```

This is the name of a branch of the filesystem. The default `desk`s are `%home`
and `%kids`. More may be created by simply referencing them. `desk`s have
independent histories and states, and they may be
[merged](@/docs/arvo/clay/using.md#merging) into each other.

### `$dojo`, domestic desk state

```hoon
+$  dojo
  $:  qyx=cult                                          ::  subscribers
      dom=dome                                          ::  desk state
      per=regs                                          ::  read perms per path
      pew=regs                                          ::  write perms per path
  ==
```

This is the all the data that is specific to a particular `desk` on a domestic
ship. `qyx` is the set of subscribers to this `desk`, and `dom` is the data in
the `desk`. `regs` are `(map path rule)`, and so `per` is a `map` of read
permissions by `path` and `pew` is a `map` of write permissions by `path`.

#### `$cult`, subscriptions

```hoon
+$  cult  (jug wove duct)
```

`cult`s keep track of subscribers. `wove`s are associated to requests, and each
`wove` is mapped to a set of `duct`s associated to subscribers who should be
notified when the request is filled/updated.

#### `$rave:clay`, general subscription request

```hoon
  +$  rave                                              ::  general request
    $%  [%sing =mood]                                   ::  single request
        [%next =mood]                                   ::  await next version
        [%mult =mool]                                   ::  next version of any
        [%many track=? =moat]                           ::  track range
    ==                                                  ::
```

This represents a subscription request for a `desk`.

A `%sing` request asks for data at single revision.

A `%next` request asks to be notified the next time there’s a change to the
specified file.

A `%mult` request asks to be notified the next time there's a change to a
specified set of files.

A `%many` request asks to be notified on every change in a `desk` for a range of changes (including into the future).

### `$rove`, stored general subscription request

```hoon
    +$  rove                                                ::  stored request
          $%  [%sing =mood]                             ::  single request
              [%next =mood aeon=(unit aeon) =cach]      ::  next version of one
              $:  %mult                                 ::  next version of any
                  =mool                                 ::  original request
                  aeon=(unit aeon)                      ::  checking for change
                  old-cach=(map [=care =path] cach)     ::  old version
                  new-cach=(map [=care =path] cach)     ::  new version
              ==                                        ::
              [%many track=? =moat lobes=(map path lobe)] ::  change range
          ==                                            ::
```

Like a `rave` but with provisions to store current versions for `%next` and `%many`.
Generally used when we store a request in our state somewhere. This is so that
we can determine whether new versions actually affect the path we're subscribed to.


#### `$mood:clay`, single subscription request

```hoon
  +$  mood  [=care =case =path]                         ::  request in desk
```

This represents a request for data related to the state of the `desk` at a
particular commit, specfied by `case`. `care` specifies what kind of information
is desired, and `path` specifies the path we are requesting.

#### `$moat:clay`, range subscription request

```hoon
  +$  moat  [from=case to=case =path]                   ::  change range
```

This represents a request for all changes between `from` and `to` on `path`. You
will be notified when a change is made to the node referenced by the `path` or to
any of its children.

### `$care:clay`, Clay submode

```hoon
  +$  care  ?(%a %b %c %d %e %f %p %r %s %t %u %v %w %x %y %z)  ::  clay submode
```


This specifies what type of information is requested in a subscription
or a scry.

`%a` build a Hoon file at a `path`.

`%b` build a dynamically typed `mark` by name (a `$dais` mark-interface core).

`%c` build a dynamically typed `mark` conversion gate (a `$tube`) by "from" and
"to" `mark` names.

`%d` returns a `(set desk)` of the `desk`s that exist on your ship.

`%e` builds a statically typed `mark` by name (a `$nave` mark-interface core).

`%f` builds a statically typed mark converstion gate.

`%p` produces the permissions for a directory, returned as a `[dict:clay dict:clay]`.

`%r` requests the file in the same fashion as `%x`, but wraps the result in a `vase`. 

`%s` has miscellaneous debug endpoints.

`%t` produces a `(list path)` of descendent `path`s for a directory within a `yaki`.

`%u` produces a `?` depending on whether or not the specified file exists. It
does not check any of its children.

`%v` requests the entire `dome` for a specified `desk` at a particular `aeon`.
When used on a foreign `desk`, this get us up-to-date to the requested version.

`%w` requests the revision number and date of the specified path, returned as a `cass:clay`.

`%x` requests the file at a specified path at the specified commit, returned as
an `@`. If there is no node at that path or if the node has no contents (that
is, if `fil:ankh` is null), then this crashes.

`%y` requests an `arch` of the specfied commit at the specified path. It will
return the bunt of an `arch` if the file or directory is not found.

`%z` requests a recursive hash of a node and all its children, returned as a `@uxI`.

#### `$ankh`, filesystem node

```hoon
+$  ankh                                                ::  expanded node
  $~  [~ ~]
  $:  fil=(unit [p=lobe q=cage])                        ::  file
      dir=(map @ta ankh)                                ::  folders
  ==                                                    ::
```

This is a recursive filesystem node type that can describe a whole tree of
folders and files, with subtrees organized by path prefix. In Earth filesystems,
a node is a file xor a directory. On Mars, we're inclusive, so a node is a file
ior a directory.

`fil` is the contents of this file, if any. `p.fil` is a hash of the
contents while `q.fil` is the data itself.

`dir` is the set of children of this node. In the case of a pure file,
this is empty. The keys are the names of the children and the values
are, recursively, the nodes themselves.


### `$arch`, shallow filesystem node

```hoon
+$  arch  (axil @uvI)
++  axil
  |$  [item]
  [fil=(unit item) dir=(map @ta ~)]
```

An `arch` is a lightweight version of an `ankh` that only contains the hash
of the associated file and a `map` of child directories, but not the children of
those directories.

The child directories are given by a `map` to null rather than a `set` so that the
ordering of the `map` will be the same as it is for an `axal`, allowing
efficient conversion for when the heavier node is needed.
```hoon
++  axal
  |$  [item]
  [fil=(unit item) dir=(map @ta $)]
```

#### `$case`, specifying a commit

```hoon
+$  case
  $%  ::  %da:  date
      ::  %tas: label
      ::  %ud:  sequence
      ::
      [%da p=@da]
      [%tas p=@tas]
      [%ud p=@ud]
  ==
```

A commit can be referred to in three ways: `%da` refers to the commit
that was at the head on date `p`, `%tas` refers to the commit labeled
`p`, and `%ud` refers to the commit numbered `p`. Note that since these
all can be reduced down to a `%ud`, only numbered commits may be
referenced with a `++case:clay`.

#### `$dome`, desk data

```hoon
+$  dome
  $:  ank=ankh                                          ::  state
      let=aeon                                          ::  top id
      hit=(map aeon tako)                               ::  versions by id
      lab=(map @tas aeon)                               ::  labels
      mim=(map path mime)                               ::  mime cache
      fod=ford-cache                                    ::  ford cache
      fer=(unit reef-cache)                             ::  reef cache
  ==                                                    ::
```

A `dome` is the state of a `desk` and associated data.

`ank` is the current state of the desk. Thus, it is the state of the
filesystem at revison `let`. The head of a `desk` is always a numbered
commit.

`let` is the number of the most recently numbered commit. This is also
the total number of numbered commits.

`hit` is a map of numerical ids to commit hashes. These hashes are mapped into
their associated commits in `hut.rang` in the `raft` of Clay. In general, the
keys of this map are exactly the numbers from 1 to `let`, with no gaps. Of
course, when there are no numbered commits, `let` is 0, so `hit` is null.
Additionally, each of the commits is an ancestor of every commit numbered
greater than this one. Thus, each is a descendant of every commit numbered less
than this one. Since it is true that the date in each commit (`t:yaki`) is no
earlier than that of each of its parents, the numbered commits are totally
ordered in the same way by both pedigree and date. Of course, not every commit
is numbered. If that sounds too complicated to you, don't worry about it. It
basically behaves exactly as you would expect.

`lab` is a map of textual labels to numbered commits. Note that labels
can only be applied to numbered commits. Labels must be unique across a
desk.

`mim` is a cache of the content in the directories that are mounted to Unix.
Often, we convert to/from mime without anything really having changed; this lets
us short-circuit that in some cases. Whenever you `%give` an `%ergo` `gift`
(updating the unix sync), `mim` is updated to reflect this.

`fod` is the Ford cache, which keeps a cache of the results of builds performed
at this `desk`'s current revision, including a full transitive closure of
dependencies for each completed build.

`fer` is the system file cache, which consists of `vase`s for `hoon.hoon`,
`arvo.hoon`, `lull.hoon`, and `zuse.hoon`.

#### `++rung`, filesystem per neighbor ship

```hoon
+$  rung
          $:  rus=(map desk rede)                       ::  neighbor desks
          ==
```

This is the filesystem of a neighbor ship. The keys to this `map` are all
the `desk`s we know about on their ship.

#### `++rede`, generic desk state

```hoon
    ++  rede                                                ::  universal project
              $:  lim=@da                                   ::  complete to
                  qyx=cult                                  ::  subscribers
                  ref=(unit rind)                           ::  outgoing requests
                  dom=dome                                  ::  revision state
              ==                                            ::
+$  rede                                                ::  universal project
          $:  lim=@da                                   ::  complete to
              ref=(unit rind)                           ::  outgoing requests
              qyx=cult                                  ::  subscribers
              dom=dome                                  ::  revision state
              per=regs                                  ::  read perms per path
              pew=regs                                  ::  write perms per path
          ==                                            ::
```

This is our knowledge of the state of a desk, either foreign or
domestic.

`lim` is the most recent `@da` for which we're confident we have all the
information for. For local `desk`s, this is always `now`. For foriegn `desk`s,
this is the last time we got a full update from the foreign ship.

`ref` is the request manager for the desk. For domestic `desk`s, this is
null since we handle requests ourselves. For foreign `desk`s, this keeps track
of all pending foriegn requests plus a cache of the responses to previous requests.

`qyx` is the `set` of subscriptions to this desk, with listening `duct`s. These
subscriptions exist only until they've been filled. For domestic `desk`s, this
is simply `qyx:dojo` - all subscribers to the `desk`. For foreign `desk`s this
is all the subscribers from our ship to the foreign `desk`.

`dom` is the data in the `desk`.

`regs` are `(map path rule)`, and so `per` is a `map` of read permissions by
`path` and `pew` is a `map` of write permissions by `path`.


#### `$rind`, foreign request manager

```hoon
+$  rind                                                ::  request manager
  $:  nix=@ud                                           ::  request index
      bom=(map @ud update-state)                        ::  outstanding
      fod=(map duct @ud)                                ::  current requests
      haw=(map mood (unit cage))                        ::  simple cache
  ==                                                    ::
```

This is the request manager for a foreign `desk`. When we send a request to a
foreign ship, we keep track of it in here.

`nix` is one more than the index of the most recent request. Thus, it is the
next available request number.

`bom` is the set of outstanding requests. The keys of this `map` are some subset
of the numbers between 0 and one less than `nix`. The members of the `map` are
exactly those requests that have not yet been fully satisfied.

`fod` is the same set as `bom`, but from a different perspective. In particular,
the values of `fod` are the same as the keys of `bom`, and the `duct` of the
values of `bom` are the same as the keys of `fod`. Thus, we can map `duct`s to
their associated request number and `update-state`, and we can map request
numbers to their associated `duct`.

`haw` is a map from `%sing` requests to their values. This acts as a cache for
requests that have already been filled.

#### `$update-state`, status of outstanding foreign request

```hoon
+$  update-state
  $:  =duct
      =rave
      have=(map lobe blob)
      need=(list lobe)
      nako=(qeu (unit nako))
      busy=_|
  ==
```

An `update-state` is used to represent the status of an outstanding request to a
foreign `desk`.

`duct` and `rave` are the `duct` along which the request was made and the
request itself.

`have` is a map of hashes thus far acquired in the request to the data
associated with those hashes.

`need` is a list of hashes yet to be acquired.

`nako` is a queue of data yet to be validated.

`busy` tracks whether or not the request is currently being fulfilled.

#### `$rang:clay`, data repository

```hoon
  +$  rang                                              ::  repository
    $:  hut=(map tako yaki)                             ::  changes
        lat=(map lobe blob)                             ::  data
    ==                                                  ::
```

This is a data repository keyed by hash. Thus, this is where the "real" data
is stored, but it is only meaningful if we know the hash of what we're
looking for.

`hut` is a `map` from commit hashes (`tako`s) to commits (`yaki`s). We often get
the hashes from `hit:dome`, which keys them by numerical id. Not every commit
has an numerical id.

`lat` is a `map` from content hashes (`lobe`s) to the actual content (`blob`s).
We often get the hashes from a `yaki`, which references this `map` to get the
data. There is no `blob` in `yaki:clay`. They are only accessible through
`lat`.

#### `$tako:clay`, commit reference

```hoon
  +$  tako  @                                           ::  yaki ref
```

This is a hash of a `yaki:clay`, a commit. These are most notably used as the
keys in `hut:rang:clay`, where they are associated with the actual `yaki:clay`,
and as the values in `hit:dome:clay`, where sequential numerical ids are
associated with these.

#### `$yaki:clay`, commit

```hoon
  +$  yaki                                              ::  commit
    $:  p=(list tako)                                   ::  parents
        q=(map path lobe)                               ::  namespace
        r=tako                                          ::  self-reference
        t=@da                                           ::  date
    ==                                                  ::
```

This is a single commit.

`p` is a `list` of the hashes of the parents of this commit. In most
cases, this will be a single commit, but in a merge there may be more
parents. In theory, there may be an arbitrary number of parents, but in
practice merges have exactly two parents. This may change in the future.
For commit 1, there is no parent.

`q` is a `map` of the `path`s on a desk to the content hashes at that location.
If you understand what a `lobe:clay` and a `blob:clay` is, then the type
signature here tells the whole story.

`r` is the hash associated with this commit.

`t` is the date at which this commit was made.

#### `$lobe:clay`, data reference

```hoon
  +$  lobe  @uvI                                        ::  blob ref
```

This is a hash of a `blob:clay`. These are most notably used in `lat:rang:clay`,
where they are associated with the actual `blob:clay`, and as the values in
`q:yaki:clay`, where `path`s are associated with their content hashes in a commit.

#### `$blob:clay`, data

```hoon
  +$  blob                                              ::  fs blob
    $%  [%delta p=lobe q=[p=mark q=lobe] r=page]        ::  delta on q
        [%direct p=lobe q=page]                         ::  immediate
```

This is a node of data. In both cases, `p` is the hash of the blob.

`%delta` is the case where we define the data by a delta on other data. In
practice, the other data is always the previous commit, but nothing depends on
this. `p.q` is the `mark` of the parent blob, `q.q` is the hash of the parent
blob, and `r` is the delta.

`%direct` is the case where we simply have the data directly. `q` is the data.
These almost always come from the creation of a file.


#### `+urge`, list change

```hoon
  ++  urge  |*(a=mold (list (unce a)))                  ::  list change
```

This is a parametrized type for list changes. For example, `(urge @t)`
is a list change for lines of text.

#### `+unce`, change part of a list.

```hoon
  ++  unce                                              ::  change part
    |*  a=mold                                          ::
    $%  [%& p=@ud]                                      ::  skip[copy]
        [%| p=(list a) q=(list a)]                      ::  p -> q[chunk]
    ==                                                  ::
```

This is a single change in a list of elements of type `a`. For example,
`(unce @t)` is a single change in lines of text.

`%&` means the next `p` lines are unchanged.

`%|` means the lines `p` have changed to `q`.

#### `$nori:clay`, repository action

```hoon
  +$  nori                                              ::  repository action
    $%  [%& p=soba]                                     ::  delta
        [%| p=@tas]                                     ::  label
    ==                                                  ::
```

This describes a change that we are asking Clay to make to the `desk`.
There are two kinds of changes that may be made: we can modify files or
we can apply a label to a commit.

In the `|` case, we will simply label the current commit with the given
label. In the `&` case, we will apply the given changes.

#### `$soba:clay`, delta

```hoon
  +$  soba  (list [p=path q=miso])                      ::  delta
```

This describes a `list` of changes to make to a `desk`. The `path`s are `path`s
to files to be changed, and the corresponding `miso` value is a description of
the change itself.

#### `$miso:clay`, ankh delta

```hoon
  +$  miso                                              ::  ankh delta
    $%  [%del ~]                                        ::  delete
        [%ins p=cage]                                   ::  insert
        [%dif p=cage]                                   ::  mutate from diff
        [%mut p=cage]                                   ::  mutate from raw
    ==                                                  ::
```

There are four kinds of changes that may be made to a node in a `desk`.

`%del` deletes the node.

`%ins` inserts a file given by `p`.

`%dif` is currently unimplemented. This may seem strange, so we remark that
diffs for individual files are implemented using `+diff` and `+pact` in `mark`s.
So for an `ankh`, which may include both files and directories, `%dif` being
unimplemented really just means that we do not yet have a formal concept of
changes in directory structure.

`%mut` mutates the file using raw data given by `p`.

#### `$riff:clay`, request/desist

```hoon
  +$  riff  [p=desk q=(unit rave)]                      ::  request+desist
```

This represents a request for data about a particular `desk`. If `q`
contains a `rave`, then this opens a subscription to the `desk` for that
data. If `q` is null, then this tells Clay to cancel the subscription
along this duct.

#### `$riot:clay`, response

```hoon
  +$  riot  (unit rant)                                 ::  response+complete
```

A `riot` is a response to a subscription. If null, the subscription has
been completed, and no more responses will be sent. Otherwise, the
`rant` is the produced data.

#### `$rant:clay`, response data

```hoon
  +$  rant                                              ::  response to request
    $:  p=[p=care q=case r=desk]                        ::  clade release book
        q=path                                          ::  spur
        r=cage                                          ::  data
    ==                                                  ::
```

This is the data associated to the response to a request. `p.p` specifies
the type of data that was requested (and is produced). `q.p` gives the
specific version reported (since a range of versions may be requested in
a subscription). `r.p` is the `desk`. `q` is the path to the filesystem
node. `r` is the data itself (in the format specified by `p.p`).

### `$nako`, subscription response data

```hoon
+$  nako                                                ::  subscription state
  $:  gar=(map aeon tako)                               ::  new ids
      let=aeon                                          ::  next id
      lar=(set yaki)                                    ::  new commits
      bar=(set plop)                                    ::  new content
  ==                                                    ::
```

This is the data that is produced by a request for a range of revisions
of a `desk`. This allows us to easily keep track of a remote repository --
all the new information we need is contained in the `nako`.

`gar` is a map of the revisions in the range to the hash of the commit
at that revision. These hashes can be used with `hut:rang:clay` to find the
commit itself.

`let` is either the last revision number in the range or the most recent
revision number, whichever is smaller.

`lar` is the set of new commits, and `bar` is the set of new content.

