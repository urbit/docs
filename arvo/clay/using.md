+++
title = "Using Clay"
weight = 3
template = "doc.html"
+++

This document is up-to-date as of March 2021.

### Reading and Subscribing

When reading from Clay, there are three types of requests.  A
`%sing` request asks for data at single revsion.  A `%next`
request asks to be notified the next time there's a change to
given file.  A `%many` request asks to be notified on every
change in a `desk` for a range of changes.

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

A `%next` request checks the query at the given revision, and it
produces the result of the query the next time it changes, along
with the revision number when it changes.  Thus, a `%next` of a
`%u` is triggered when a file is added or deleted, a `%next` of a
`%x` is triggered when a file is added, deleted, or changed, and
a `%next` of a `%y` is triggered when a file or any of its
children is added, deleted, or changed.

A `%many` request is triggered every time the given `desk` has a
new revision.  Unlike a `%next`, a `%many` has both a start and
an end revision, after which it stops returning.  For `%next`, a
single change is reported, and if the caller wishes to hear of
the next change, it must resubscribe.  For `%many`, every revision
from the start to the end triggers a response.  Since a `%many`
request doesn't ask for any particular data, there aren't `%u`,
`%x`, and `%y` versions for it.

For further information, see [Local Reads](@/docs/arvo/Clay/local-reads.md),
[Local Subscriptions](@/docs/arvo/Clay/local-sub.md), and [Foreign
Requests](@/docs/arvo/Clay/foreign.md)

### Unix sync

Usage:
```
|mount %/path/to/directory %mount-point
|commit %mount-point
|autocommit %mount-point
```

One of the primary functions of Clay is as a convenient user
interface. While tools exist to use Clay from within Urbit, it's
often useful to be able to treat Clay like any other filesystem
from the Unix perspective -- to "mount" it, as it were.

From the dojo, you can run `|mount %/path/to/directory %mount-point`, and this
will mount the given Clay directory to the mount-point directory in Unix, with
your pier as the root directory. For example `|mount %/gen %generators` will
create a `/generators` directory in your pier, and mount the `/gen` folder at
that point. If you'd like to use the directory name as the mount point, you can
elide the last argument, e.g. `|mount %/gen` mounts `/gen` to `/gen`.

Every file is converted to `%mime` before it's written to Unix, and converted
back when read from Unix. The entire directory is watched (a la Dropbox), and
every change is committed once you run `|commit %mount-point`. Every change can
be automatically committed with `|autocommit %mount-point`.

### Merging

Usage:
```
|merge %target-desk ~source-ship %source-desk
|merge %target-desk ~source-ship %source-desk, =gem %strategy
|merge %target-desk ~source-ship %source-desk, =cas ud+5
```

Clay supports various merge strategies.  A "commit" is a snapshot of
the files with a list of parents plus a date.   Most commits have
one parent; a "merge" commit is a commit with two parents.  The
%home `desk` starts with an initial commit with no parents; commits
with several parents ("octopus merges") are possible but we don't
generate them right now.
                                                                      
Unless otherwise specified, all of the following create a new commit
with the source and destination commits as parents.
                                                                      
Several strategies need a "merge-base".  They find it by identifying
the most recent common ancestor of the two `desk`s.  If none, fail
with `%merge-no-merge-base`; if there are two or more, pick one.

#### Strategies
                                                                      
**`%init`**: the only way to create a `desk`.  Not a true merge, since it
simply assigns the source commit to the destination.
                                                                      
**`%fine`**: if source or destination are in the ancestry of each other,
use the newer one; else abort.  If the destination is ahead of the
source, succeed but do nothing.  If the source is ahead of the
destination, assign the next revision number to the source commit.
Some call this "fast-forward".
                                                                      
**`%meet`**: combine changes, failing if both sides changed the same file.
Specifically, take diff(merge-base,source) and
diff(merge-base,destination) and combine them as long as those diffs
touch different files.
                                                                      
**`%mate`**: combine changes, failing if both sides changed the same part
of a file.  Identical to `%meet`, except that some marks, like `%hoon`,
allow intelligent merge of changes to different parts of a file.
                                                                      
**`%meld`**: combine changes; if both sides changed the same part of a
file, use the version of the file in the merge-base.
                                                                      
**`%only-this`**: create a merge commit with exactly the contents of the
destination `desk`.
                                                                      
**`%only-that`**: create a merge commit with exactly the contents of the
source commit.
                                                                      
**`%take-this`**: create a merge commit with exactly the contents of the
destination `desk` except take any files from the source commit which
are not in the destination `desk`.
                                                                      
**`%take-that`**: create a merge commit with exactly the contents of the
source commit except preserve any files from the destination `desk`
which are not in the source commit.
                                                                      
**`%meet-this`**: merge as in `%meet`, except if both sides changed the same
file, use the version in the destination `desk`.
                                                                      
**`%meet-that`**: merge as in `%meet`, except if both sides changed the same
file, use the version in the source commit.
                                                                      
#### Examples and notes:
                                                                      
The most common merge strategy is `%mate`, which is a normal 3-way
merge which aborts on conflict.
                                                                      
`%take-that` is useful to "force" an OTA.  After running `%take-that`,
you're guaranteed to have exactly the files in the source commit plus
any files you separately added.
                                                                      
We speak of merging into a destination *`desk`* from a source *commit*
because while you can only merge on top of a `desk`, you can merge from
historical commits.  For example,
```                                                                    
|merge %old our %home, =cas ud+5, =gem %init
```
will create a new `desk` called `%old` with the 5th commit in `%home`.
You can revert the contents of a `desk` to what they were yesterday
with
```
|merge %home our %home, =cas da+(sub now ~d1), =gem %only-that
```
                                                                      
Note this is a normal `%only-that merge`, which means you're creating a
*new* commit with the old *contents*.
                                                                      
`%meld` is rarely used on its own, however if you specify `%auto` or
omit the merge strategy, `%kiln` will run a `%meld` merge into a scratch
`desk` and then annotate the conflicts there.
                                                                      
If you resolve merge conflicts manually, for example by mounting the
`desk`s, copying the files in Unix and then running `|commit`, you
should usually run an `%only-this merge`.  This will not change the
newly-fixed contents of your `desk`, but it will record that the merge
happened so that those conflicts don't reappear in later merges.
                                                                      
If you get a `%merge-no-merge-base` error, this means you're trying to
merge two `desk`s which have no common ancestors.  You need to give
them a common ancestor by choosing a merge strategy which doesn't
need a merge-base, like `%only-this`, `%only-that`, `%take-this`, or
`%take-that`.
                                                                      
`%take-this` could be useful to install 3rd party software, but you
couldn't get subsequent updates this way, since the files would
already exist in the destination `desk`.  Something like "take only
the files which aren't in my OTA source or any other 3rd party app"
would be basically correct.  This would require a parameter listing
the `desk`s to not conflict with.
                                                                      
`%meet-this` and `%meet-that` imply the existence of `%mate-this` and
`%mate-that`, but those don't exist yet.

### Autosync

Usage:
```
|sync %target-desk ~source-ship %source-desk
```

Tracking and staying in sync with another `desk` is another
fundamental operation. We call this "autosync". This doesn't mean
simply mirroring a `desk`, since that wouldn't allow local changes.
We simply want to apply changes as they are made upstream, as
long as there are no conflicts with local changes.

This is implemented by subscribing to changes to the other `desk`, with a
`%many` request and, when it has changes, merging these changes into our `desk`
with the usual merge strategies.

Note that it's quite reasonable for two `desk`s to be autosynced to
each other. This results in any change on one `desk` being mirrored
to the other and vice versa.

Additionally, it's fine to set up an autosync even if one `desk`,
the other `desk`, or both `desk`s do not exist. The sync will be
activated when the upstream `desk` comes into existence and will
create the downstream `desk` if needed.
