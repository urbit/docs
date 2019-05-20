+++
title = "Filesystem"
weight = 4
template = "doc.html"
+++
Urbit has its own revision-controlled filesystem, Clay. Clay is a typed, global,
referentially transparent namespace. An easy way to think about it is like typed
`git` with continuous sync.

The most common way to use Clay is to mount a Clay node in a Unix directory. The
Urbit process will watch this directory and automatically record edits as
changes, Dropbox style. The mounted directory is always at the root of your
pier directory.

## Quickstart

This quick-start guide will walk you through some common commands. Follow along
using your Dojo. When you get a `>=` message after entering a command, the means
that the command was successful.

When developing it's a good idea to use a separate desk. Create a `%sandbox`
desk based on the `%home` desk:

```
|merge %sandbox ~your-urbit %home
```

Running `our` produces your ship-name, meaning that you can run the following
command instead of typing out the entire thing. Useful for comets, due to their
very long names.

```
|merge %sandbox our %home
```

Most of the time we want to use Clay from Unix.  Mount the entire contents of
your `sandbox` desk to Unix:

```
~your-urbit:dojo> |mount /=sandbox=
```

To explore the filesystem from inside Urbit `+ls` and `+cat` are useful. `+ls`
displays files in the current directory, and `+cat` displays the contents of
a file.

We can use `%` to mean "current directory." The result of the command below
is just like using `ls` in a Unix terminal.

```
~your-urbit:dojo> +ls %
```

Notice how `+cat %` does the same thing. That's because everything in Clay,
including directories, is a file.

Let's explore the `/web` directory of the `%sandbox` desk.

```
~your-urbit:dojo> +ls /=sandbox=/web
```

Let's see the contents of `/=sandbox=/web/md`:

```
~your-urbit:dojo> +cat /=sandbox=/web/md
```

Now let's navigate to that folder using `=dir`, which is a like `cd` in Unix.

```
~your-urbit:dojo> =dir /=sandbox=/web/md
```

Youl'll notice that your prompt is now `~your-urbit:dojo/sandbox/web/md>`. To
change back to our home directory, we use `=dir` without any path.

```
~your-urbit:dojo/sandbox/web/md> =dir
```

Sync from your friend `~some-ship`'s `%experiment` desk to your
`%sandbox` desk:

```
|sync %sandbox ~some-ship %experiment
```

If and when your sync is successful, you will receive a message:

```
activated sync from %experiment on ~some-ship to %sandbox
```

The ship that you sync from will get their own message indicating that you're
both connected as peers:

```
; ~your-urbit is your neighbor.
```

---

## Manual

### Paths

A path in Clay is a list of URL-safe text, restricted to the characters
`[a z]`,`[0 9]`, `.`, `-`, `_`, and `~`. Formally this is a `(list knot)`,
meaning that each segment, delineated by `/`, is of the `knot` ASCII-text type.
In other words, paths are expressed as `/foo/bar/baz`. File extensions are
separated from file names with `/`, not `.`. Extensions are syntactically
identical to subdirectories, except that they must terminate the path.

Paths begin with a piece of data called a `beak`. A beak is formally a
`(p=ship q=desk r=case)`; it has three components, and might look like
`/~dozbud-namsep/home/11`.

The first `beak` component is `ship`, which is, as you might guess, the name of
an Urbit ship. The second component is `desk`, which is a workspace meant to
contain other directories; the default desk is `%home`. The third component is
`case`, which represents version information in various ways: date and time;
a version sequence, which is a value incremented by one whenever a file on the
given `desk` is modified; or an arbitrary plaintext label.

You can find what your `beak` is at any given moment by
typing `%` in the Dojo and looking at the first three results.

We use `beak`s because, unlike the current internet, the Urbit network uses a
global namespace. That means that a file named `example.hoon` in the `/gen`
directory on the `%home` desk of your ship `~lodleb-ritrul` would have a
universal address to anyone else on the network:
`~lodleb-ritrul/home/186/gen/example.hoon`. That, of
course, doesn't mean that everyone on the network has privileges to access that
path.

The structure that combines a `beak` with further path information is called a
`beam`.

##### Relative paths

The `%` command, which we gestured at in the above section, represents the
**relative path**, which is the path where you are currently working. If your
working directory is just your home desk, indicated by the
prompt `~your-planet:dojo>`, then running the command below will print your
working directory's `beam` information: your `beak`, and a `~` that represents
the empty list since no path is present.

```
~your-urbit:dojo> %
```

`%`s can be stacked to indicate one level further up in the hierarchy for each
additional `%`. Try the following command:

```
~your-planet:dojo> %%%
```

You'll probably notice that it only has your ship name and the empty list. The
two additional `%`s abandoned the `case` and the `desk` information by moving
up twice the hierarchy.

There are no local relative paths. `/foo/bar` must be written as
`%/foo/bar`.

##### Substitution

You don't need to write out the explicit path every time you want to reference
somewhere outside of your working directory. You can substitute `=` for the
segments of a path.

Recall that a full address in the the Urbit namespace is a `beam`: the
`/ship/desk/case/path`. If you've switched to another desk before, you're
already familiar with substitution syntax:

```
~your-urbit:dojo> =dir /=sandbox=
```

The above command substitutes uses substitution to use your current `ship` and
`case`; only the `desk` argument, which is located between the other two, is
given something new. Without substitution, you would need to write:

```
~your-urbit:dojo> =dir /~your-urbit/home/85
```

Substitutions work the same way in `beak`s (the `ship/desk/case` part) and
paths. For example, if you are in the `/gen` directory, you can reference a file
in the `/app` directory like below. (`+cat` displays the contents of a file).

```
~your-urbit:dojo/home/gen> +cat /===/app/curl/hoon
```

Note what was substituted out, and note that we don't need to separate `=` with
`/`.

If we changed our working directory to something called `/gen/gmail`, we could
access a file called

```
~fasdul-balsev-lodleb-ritrul:dojo/home/gen/gmail> +cat /===/app/=/split/hoon
```

Because both paths share a directory named `/gmail` at the same position in the
address hierarchy -- which, if you recall, is just a `list` -- the above command
works!

We can do the same thing between desks. If `%sandbox` has been merged with
`%home`, the following command will produce the same results as the above
command.

```
~your-urbit:dojo/home/gen/gmail> +cat /=sandbox=/app/=/split/hoon
```

Most commonly this is used to avoid having to know the current revision
number in the `dojo`: `~lodleb-ritrul/home/~2018.10.2..00.35.44..d7e8/gen/example.hoon`

##### Changing directories

Change the working directory with `=dir`. It's our equivalent of the Unix `cd`.

For example, the syntax to navigate to `/home/gen/ask` is:

```
~your-urbit:dojo> =dir /=gen=/ask
```

This command will turn your prompt into something like this:

```
~your-urbit:dojo/gen/ask>
```

Using `=dir` without anything else uses the null path, which returns you to
your home desk.

```
~your-urbit:dojo> =dir
```

To go up levels in the path hierarchy, recall the relative path expression
`%`. Stacking them represents another level higher in the hierarchy than
the current working directory for each `%` beyond the initial. The command below
brings you one level up:

```
~your-urbit:dojo/gen> =dir %%
```

### Revision-control

##### Mount

Syntax: `|mount /clay/path [Unix-name]`

Mount the `clay-path` at the Unix mount point `Unix-name`.

**Examples:**

```
|mount %/web
```

Mounts `%/web` to `/web` inside your pier directory.

```
|mount %/gen generators
```

Mounts `%/gen` to `/generators` inside your pier directory.

##### Unmount

```
|unmount [clay-path || Unix-name]
```

Unmount the path or name from Unix.

**Examples:**

```
|unmount %/web
```

Unmounts the path `%/web` from whatever name it was mounted as.

```
|unmount %generators
```

Unmounts the Unix path `/generators`.

```
|merge desk beak[, =gem strategy]
```

Merges a `beak` into a `desk` using an optional merge `strategy`.

A `beak` is a ship-desk-case triple, encoded as a
path(`/~dozbud/home/2`)

**Examples:**

```
|merge %home-work /=home=, =gem %fine
```

Merge `/=home=` into `%home-work` using merge strategy `%fine`.

```
|merge %examples ~wacbex-ribmex %examples
```

Merge the `%examples` desk from `~waxbex-ribmex`

```
|sync desk plot [plot-desk]
```

Subscribe to continuous updates from remote `plot` on local `desk`.
`plot-desk` can specify the remote `desk` name. When omitted it is
defaulted to being the same as `desk`. Non-comet urbits have
`|sync %home ~parent %kids` automatically set up (where `~parent` is the
planet that issued a moon, the star that issued a planet, or the galaxy
that issued a star).

**Examples:**

```
|sync %home-local ~dozbud %home

|sync %home ~doznec
```

```
|unsync desk plot [plot-desk]
```

Unsubscribe from updates from remote `plot` on local `desk` with
optional `plot-desk`. Arguments must match original `|sync` command.

Example:

```
|unsync %home-local ~dozbud %home
```

```
|label desk name`
```

Label the current version of `desk` `name`.

Example:

```
|label %home release
```

### Merge strategies

`%init` - Used if it's the first commit to a desk. Also can be used to
"reinitialize" a desk -- revision numbers keep going up, but the new
revision isn't necessarily a descendent of the previously numbered
version, allowing merges to be rerun.

`%this` - Keep what's in Bob's desk, but join the ancestry.

`%that` - take what's in Alice's desk, but join the ancestry. This is
the reverse of `%this`. This is different from `%init` because the new
commit has both sides in its ancestry.

`%fine` - "fast-forward" merge. This succeeds if and only if one head is in the
ancestry of the other.

`%meet`, `%mate`, and `%meld` - find the most recent common ancestor to
use as our merge base.

A `%meet` merge only succeeds if the changes from the merge base to
Alice's head (hereafter, "Alice's changes") are in different files than
Bob's changes. In this case, the parents are both Alice's and Bob's
heads, and the data is the merge base plus Alice's changed files plus
Bob's changed files.

A `%mate` merge attempts to merge changes to the same file when both
Alice and Bob change it. If the merge is clean, we use it; otherwise, we
fail. A merge between different types of changes -- for example,
deleting a file vs changing it -- is always a conflict. If we succeed,
the parents are both Alice's and Bob's heads, and the data is the merge
base plus Alice's changed files plus Bob's changed files plus the merged
files.

A `%meld` merge will succeed even if there are conflicts. If there are
conflicts in a file, then we use the merge base's version of that file,
and we produce a set of files with conflicts. The parents are both
Alice's and Bob's heads, and the data is the merge base plus Alice's
changed files plus Bob's changed files plus the successfully merged
files plus the merge base's version of the conflicting files.

`%auto` - meta-strategy. Check to see if Bob's desk exists, and if it
doesn't we use an `%init` merge. Otherwise, we progressively try
`%fine`, `%meet`, and `%mate` until one succeeds. If none succeed, we
merge Bob's desk into a scratch desk. Then, we merge Alice's desk into
the scratch desk with the `%meld` option to force the merge. Finally, we
annotate any conflicts, if we know how.

### Manipulation

##### +cat

Syntax: `+cat path [path ...]`

Similar to Unix `cat`. `+cat` takes one or more `path`s, and prints their
contents. If that `path` is a file, the contents of the file is printed. If the
`path` terminates in a directory, the list of names at that path is produced.

##### +ls

Syntax: `+ls path`

Similar to Unix `ls`. `+ls` takes a single `path`.

Produces a list of names at the `path`.

```
~your-urbit:dojo> +cat %/our/home/gen/curl/hoon
```

##### |rm

Syntax: `|rm path`

Remove the data at `path`. `path` must be a path to actual node, not a
'directory'

##### |cp

Syntax: `|cp to from`

Copy the file at `from` into the path `to`.

##### |mv

Syntax: `|mv to from`

Move the file at `from` into the path `to`.

In Clay, `|mv` is just a shorthand for `|cp` then `|rm`. The `|rm`
doesn't happen unless the `|cp` succeeds.
