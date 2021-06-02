+++
title = "API Reference"
weight = 6
template = "doc.html"
+++

# Contents

- [Introduction](#introduction)
- [%warp](#warp) - Read and Subscribe.
   - [%sing](#sing) - Read a file or directory.
   - [%next](#next) - Subscribe for the next change to a file or directory.
   - [%mult](#mult) - Subscribe for the next change to a set of files and/or directories.
   - [%many](#many) - Track changes to a `desk` for the specified range of revisions.
   - [Cancel Subscription](#cancel-subscription)
- [Write and Modify](#write-and-modify)
   - [%info](#info)
- [Manage Mounts](#manage-mounts)
   - [%boat](#boat) - List mounts.
   - [%mont](#mont) - Mount something.
   - [%ogre](#ogre) - Unmount something.
   - [%dirk](#dirk) - Commit changes.
- [Merge Desks](#merge-desks)
   - [%merg](#merg)
- [Permissions](#permissions)
   - [%perm](#perm) - Set file permissions.
   - [%cred](#cred) - Add permission group.
   - [%crew](#crew) - Get permission groups.
   - [%crow](#crow) - Get group usage.
- [Foreign Ships](#foreign-ships)
   - [%warp](#warp-remote) - Read a file on a foreign ship.
   - [%merg](#merg-remote) - Merge from a foreign `desk`.

# Introduction

This document details all the `task`s you're likely to use to interact with Clay, as well as the `gift`s you'll receive in response. Each section has a corresponding practical example in the [Examples](@/docs/arvo/clay/examples.md) document. Many of the types referenced are detailed in the [Data Types](@/docs/arvo/clay/data-types.md) document. It may also be useful to look at the `++  clay` section of `/sys/lull.hoon` in Arvo where these `task`s, `gift`s and data structures are defined.

The focus of this document is on interacting with Clay from userspace applications and threads, so it doesn't delve into the internal mechanics of Clay from a kernel development perspective.

# `%warp`

A `%warp` `task` is for reading a subscribing to files and directories.

### Accepts

```hoon
[wer=ship rif=riff]
```

The `wer` field is the target ship. The `(unit rave)` of the [riff](@/docs/arvo/clay/data-types.md#riff-clay-request-desist) is null to cancel an existing subscription, otherwise the [rave](@/docs/arvo/clay/data-types.md#rave-clay-general-subscription-request) is tagged with one of:

- `%sing` - Read a single file or directory.
- `%next` - Subscribe for the next change to a file or directory.
- `%mult` - Subscribe for the next change to a set of files and/or directories.
- `%many` - Track changes to a desk for the specified range of revisions.

We'll look at each of these in more detail below.

### Returns

Clay responds to a `%mult` request with a `%wris` `gift`, and the rest with a `%writ` `gift`.

A `%wris` `gift` looks like:

```hoon
[%wris p=[%da p=@da] q=(set (pair care path))]  ::  many changes
```

...and a `%writ` `gift` looks like:

```hoon
[%writ p=riot]  ::  response
```

The `unit` of the [riot](@/docs/arvo/clay/data-types.md#riot-clay-response) will be null if the target file cannot be found or if a subscription has ended (depending on context). Otherwise it will have a [rant](@/docs/arvo/clay/data-types.md#rant-clay-response-data) with a `cage` containing the data you requested. Its contents will vary depending on the kind of request and `care`.

Now we'll look at each of the `rave` request types in turn.

## `%sing`

```hoon
[%sing =mood] 
```

This `rave` is for reading a single file or directory immediately.

The `care` of the [mood](@/docs/arvo/clay/data-types.md#mood-clay-single-subscription-request) will determine what you can read and what type of data will be returned. See the [care](@/docs/arvo/clay/data-types.md#care-clay-clay-submode) documentation and [scry](@/docs/arvo/clay/scry.md) documentation for details on the various `care`s.

The [case](@/docs/arvo/clay/data-types.md#case-specifying-a-commit) specifies the `desk` revision and you can use whichever kind you prefer. The `path` will usually be a path to a file or directory like `/gen/hood/hi/hoon` but may be something else depending on the `care`.

### Example

[See here for an example of using %sing.](@/docs/arvo/clay/examples.md#sing)

## `%next`

```hoon
[%next =mood]  ::  await next version
```

This subscribes to the next version of the specified file. See [here](@/docs/arvo/clay/data-types.md#mood-clay-single-subscription-request) for details of the `mood` structure.

If you subscribe to the current `case` of the `desk`, Clay will not respond until the file changes. If you subscribe to a previous `case` of the `desk` and the file has changed in between then and now, it will immediately return the first change it comes across in that range. For example, if you're currently at `case` `100`, subscribe to case `50` and the file in question has been modified at both `60` and `80`, clay will immediately return the version of the file at `case` `60`.

### Example

[See here for an example of using %next.](@/docs/arvo/clay/examples.md#next)

## `%mult`

```hoon
[%mult =mool]  ::  next version of any
```

This subscribes to the next version of a `set` of files or directories. Clay will only send a single response, and it will send it when *any* of the specified files change. For example, if you subscribe to both `/foo/txt` and `/bar/txt`, and only `/foo/txt` changes, Clay will send a response indicating a change to `/foo/txt`. If `/bar/txt` changes subsequently, it will not tell you. If more than one file changes at once, it will tell you about each of the changes in the one response.

The behaviour with respect to requesting old `case`s is the same as explained in the [`%next`](#next) section above.

The `mool` specified in the request is this structure:

```hoon
+$  mool  [=case paths=(set (pair care path))]  ::  requests in desk
```

You can use a different `care` for each of the files specified by the `path` if you like. Significantly, the `care` will determine whether Clay sends a response for a given change. For example, if you subscribe to an existing `/foo/txt` with a `%u` `care` and `/foo/txt` is modified but isn't deleted, Clay will *not* tell you. However, if you subscribe with an `%x` `care`, it *will* tell you.

### Example

[See here for an example of using %mult.](@/docs/arvo/clay/examples.md#mult)

## `%many`

```hoon
[%many track=? =moat]  ::  track range
```

This subscribes to all changes to a `desk` for the specified range of `case`s. Note that you're unlikely to use this directly, it's mostly used implicitly if you make a `%sing` or `%next` request with a `%v` `care` to a foreign `desk`. Regardless, we'll have a look at it for completeness.

If the `track` is `%.y` it will just return a `%writ` like:

```hoon
[%writ p=[~ [p=[p=%w q=[%ud p=256] r=%home] q=/ r=[p=%null q=[#t/@n q=0]]]]]
```

...that merely informs you of a change. If you want the actual data you'll have to request it separately.

If the `track` is `%.n`, the `cage` of the `%writ` will contain a [nako](@/docs/arvo/clay/data-types.md#nako-subscription-response-data) with the relevant data for all changes to a desk between what you have and the `case` requested. It is very large and fairly complicated. The `nako` structure is defined in the `clay.hoon` source file itself rather than in `lull.hoon` or elsewhere since you're unlikely to work with it yourself.

The `from` and `to` fields of the [moat](@/docs/arvo/clay/data-types.md#moat-clay-range-subscription-request) specify the range of `case`s for which to subscribe. The range is *inclusive*. It can be specified by date or by revision number, whichever you prefer.

The `path` in the `moat` is a path to a file or directory. If it's `~` it refers to the root of the `desk` in question. This lets you say "only inform me of changes to the `desk` if the specified file or directory exists". If it doesn't exist, Clay will not send you anything.

When you reach the end of the subscribed range of `case`s, Clay will send you a `%writ` with a null `riot` to inform you the subscription has ended like:

```hoon
[%writ p=~]
```

### Example

[See here for an example of using %many.](@/docs/arvo/clay/examples.md#many)

## Cancel Subscription

To cancel a subscription, you just send a `%warp` with a null `(unit rave)` in the `riff`. Clay will cancel the subscription based on the `wire`. The request is exactly the same regardless of which type of `rave` you subscribed with originally.

### Example

[See here for an example of cancelling a subscription.](@/docs/arvo/clay/examples.md#cancel-subscription)

# Write and Modify

## `%info`

To write or modify a file, we send Clay a `%info` `task`.

### Accepts

```hoon
[des=desk dit=nori]
```

The `%|` tag in the [nori](@/docs/arvo/clay/data-types.md#nori-clay-repository-action) is not currently supported and will crash with a `%labelling-not-implemented` if used, so you can focus on the `%&` part. The [soba](@/docs/arvo/clay/data-types.md#soba-clay-delta) in the `nori` is just a list of changes so you can make more than one change in one request. Its `path` is just the path to a file like `/gen/hood/hi/hoon` and the [miso](@/docs/arvo/clay/data-types.md#miso-clay-ankh-delta) is one of these types of requests:

- `%del` - Delete a file.
- `%ins` - Insert file. This will also replace an existing file.
- `%dif` - This has not yet been implemented so will crash with a `%dif-not-implemented` error.
- `%mut` - Change a file. At the time of writing this behaves identically to `%ins` so its use merely informs the reader.

### Returns

Clay does not give any response to an `%info` `task` so don't expect a `sign` back.

### Example

Here are examples of using each of these as well as making multiple changes in one request:

- [%del](@/docs/arvo/clay/examples.md#del)
- [%ins](@/docs/arvo/clay/examples.md#ins)
- [%mut](@/docs/arvo/clay/examples.md#mut)
- [Multiple Changes](@/docs/arvo/clay/examples.md#multiple-changes)


# Manage Mounts

Here we'll look at managing Clay unix mounts programmatically.

There are four Clay `task`s relevant to mounts:

- [%boat](#boat) - List mounts.
- [%mont](#mont) - Mount something.
- [%ogre](#ogre) - Unmount something.
- [%dirk](#dirk) - Commit changes.

## `%boat`

A `%boat` `task` requests the list of existing mounts.

### Accepts

```hoon
~
```

A `%boat` `task` does not take any arguments.

### Returns

The type it returns is a `%hill` `gift`, which looks like:

```hoon
[%hill p=(list @tas)]
```

...where the `@tas` is the name of the mount point.

### Example

[See here for an example of using %boat.](@/docs/arvo/clay/examples.md#boat)

## `%mont`


A `%mont` `task` mounts the specified `beam` to the specified `term` mount point.

### Accepts

```hoon
[pot=term bem=beam]
```

A `beam:clay` is the following structure:

```hoon
+$  beam  [[p=ship q=desk r=case] s=path]  ::  global name
```

You can mount the whole desk with a `path` of `/`, and you can also mount subdirectories or even individual files. If you want to mount an individual file, you must exclude its `mark` from the path. For example, if you want to mount `/gen/hood/hi/hoon`, you'd specify `/gen/hood/hi`. It will automatically be given the correct file extension when mounted. If you include the `hoon` mark it will crash (and currently crash your ship).

### Returns

Clay does not return a `gift` in response to a `%mont` `%task`.

### Example

[See here for an example of using %mont.](@/docs/arvo/clay/examples.md#mont)

## `%ogre`

A `%ogre` `task` unmounts the specified mount. 

### Accepts

```hoon
[pot=$@(desk beam)]
```

It's defined in `lull.hoon` as taking `$@(desk beam)` but in fact it will only unmount the target when specified as a `term` mount name. Passing it a `desk` will incidentally work if the mount is named the same as the `desk` but otherwise it won't work. Passing it a `beam:clay` will simply not work.

### Returns

Clay does not return a `gift` in response to a `%ogre` `task`.

### Example

[See here for an example of using %ogre.](@/docs/arvo/clay/examples.md#ogre)

## `%dirk`

A `%dirk` `task` commits changes in the target mount.

### Accepts

```hoon
des=desk
```

It's defined in `lull.hoon` as taking a `desk` but like [%ogre](#ogre), it actually takes the name of a mount point rather than a `desk` as is specified.

### Returns

Clay does not return a `gift` in response to a `%dirk` `task`.

### Example

[See here for an example of using %dirk.](@/docs/arvo/clay/examples.md#dirk)

# Merge Desks

## `%merg`

A `%merg` `task` will merge the specified source `desk` into the target local `desk`.

### Accepts

```hoon
$:  des=desk                    ::  target
    her=@p  dem=desk  cas=case  ::  source
    how=germ                    ::  method
==
```
The `germ` specifies the merge strategy. You can refer to the [Strategies](@/docs/arvo/clay/using.md#strategies) section of the [Using Clay](@/docs/arvo/clay/using.md) document for details of each `germ`.

If you're merging into a new `desk` you must use `%init`, all other strategies will fail. If the desk already exists, you cannot use `%init`. Otherwise, you're free to use whichever you'd like.

### Returns

Clay will respond to the request with a `%mere` `gift` which looks like:

```hoon
[%mere p=(each (set path) (pair term tang))]  ::  merge result
```

If the merge succeeded, `p` will look like `[%mere p=[%.y p={}]]` where `p.p` is the set of files which had a merge conflict. For example, `[%mere p=[%.y p={/foo/txt}]]` means there was a conflict with `/foo/txt`. An empty set means there were no conflicts.

If the merge failed, `p` will have a head of `%.n` and then a `[term tang]` where the `term` is an error message and the `tang` contains additional details, for example:

```hoon
[ %mere
    p
  [ %.n
    p=[p=%mate-conflict q=~[[%rose p=[p="/" q="/" r=""] q=~[[%leaf p="foo"] [%leaf p="txt"]]]]]
  ]
]
```

### Example

[See here for an example of using %merg.](@/docs/arvo/clay/examples.md#merg)

# Permissions

For each file or directory, there is both a read permission and a write permission. Each may be set separately and is either a whitelist or a blacklist (but not both). The whitelist/blacklist contains a `set` of ships and/or groups which are allowed or banned respectively. If it's an empty whitelist it means all foreign ships are denied. If it's an empty blacklist it means all foreign ships are allowed.

If permissions are not set for a particular file, they will be inherited from the directory in which it resides. If *that* directory has no permissions set, they will be inherited from another level up, and so on to the `desk`'s root directory. If the root directory has no permissions set, it will have the default permissions of an empty whitelist, meaning "deny all".

A group is called a `crew` and is just a `set` of ships with a `@ta` name.

The permissions for each file or directory are a pair of `dict:clay` where the head is read permissions and the tail is write permissions.

A `dict:clay` is this structure:

```hoon
+$  dict  [src=path rul=real]  ::  effective permission
```

The `src` path is where the permissions were inherited from and the `real` is this structure:

```hoon
  +$  real                                    ::  resolved permissions
    $:  mod=?(%black %white)                  ::
        who=(pair (set ship) (map @ta crew))  ::
    ==                                        ::
```

So if we scry for permissions with a `%p` `care`, it'll look like:

```hoon
> .^([r=dict:clay w=dict:clay] %cp /===/lib/strandio/hoon)
[r=[src=/ rul=[mod=%white who=[p={} q={}]]] w=[src=/ rul=[mod=%white who=[p={} q={}]]]]
```

There are four permission-related `task`s which you can pass to Clay.

A `%perm` `task` is for setting permissions, and the other three are for managing groups:

- `%cred` - Add permission group.
- `%crew` - Get permission groups.
- `%crow` - Get group usage.

We'll look at each of these in turn.

## `%perm`

A `%perm` `task` sets permissions for the target file or directory.

Note this will replace existing permissions rather than add to them, so if you want to add a ship to an existing whitelist or whatever you'll have to first read the existing permissions, add the ship, then send the whole lot back.

### Accepts

```hoon
[des=desk pax=path rit=rite]
```

The `pax` path is the file or directory whose permissions you want to change, and the `rite` is this structure:

```hoon
+$  rite                                     ::  new permissions
  $%  [%r red=(unit rule)]                   ::  for read
      [%w wit=(unit rule)]                   ::  for write
      [%rw red=(unit rule) wit=(unit rule)]  ::  for read and write
```

Where a `rule` is this structure:

```hoon
+$  rule  [mod=?(%black %white) who=(set whom)]  ::  node permission
```

...and finally `whom` is this:

```hoon
+$  whom  (each ship @ta)  ::  ship or named crew
```

As the comment suggests, the `@ta` is the name of a `crew` (group).

### Returns

Clay does not return a `gift` in response to a `%perm` `task`.

### Example

[See here for an example of using %perm.](@/docs/arvo/clay/examples.md#perm)

## `%cred`

This simply creates a permission group.

### Accepts

```hoon
[nom=@ta cew=crew]
```

The `nom` is a name for the group and the `crew` is just a `(set ship)`:

```hoon
+$  crew  (set ship)  ::  permissions group
```

### Returns

Clay does not return a `gift` in response to a `%cred` `task`.

### Example

[See here for an example of using %cred.](@/docs/arvo/clay/examples.md#cred)

## `%crew`

This retrieves all permission groups.

### Accepts

```hoon
~
```

A `%crew` `task` takes no arguments.

### Returns

Clay wil return a `%cruz` `gift`. It looks like:

```hoon
[%cruz cez=(map @ta crew)]  ::  permission groups
```

The `cez` is just a map from group name to `crew` which is just a `(set ship)`.

### Example

[See here for an example of using %crew.](@/docs/arvo/clay/examples.md#crew)

## `%crow`

A `%crow` `task` retrieves all files and directories in all `desk`s which have permissions set for the group in question. It will not return inherited permissions, only those explicitly set.

### Accepts

```hoon
nom=@ta
```

The `nom` is the name of a `crew`.

### Returns

The `gift` you get back is a `%croz` which looks like:

```hoon
[%croz rus=(map desk [r=regs w=regs])]  ::  rules for group
```

...where `regs` is this structure:

```hoon
+$  regs  (map path rule)  ::  rules for paths
```

### Example

[See here for an example of using %crow.](@/docs/arvo/clay/examples.md#crow)

# Foreign Ships

Here we'll looking at making Clay requests to a foreign ship.

As it currently stands, it's not possible to write to a foreign `desk`. Additionally, remote scries are not implemented. That leaves requests to read files (`%warp`) and merge desks (`%merg`), which we'll look at next.

## `%warp` - Remote

To read files on a foreign `desk`, you just send Clay a `%warp` `task` (as you would for a local read) and specify the target ship in the `wer` field. For details on making such requests, see the [Read and Subscribe](#warp) section.

Clay only allows a subset of `care`s to be used remotely. They are:

- `%u` - Check for existence of file.
- `%v` - Get entire `dome:clay` state of a desk.
- `%w` - Get revision number.
- `%x` - Get data of file.
- `%y` - Get `arch` of file or directory.
- `%z` - Get content hash of file or directory.

Any other `care` will crash with a `%clay-bad-foreign-request-care` error.

The foreign ship will respond only if correct permissions have been set. See the [Permissions](#permissions) section for details.

Note that if you're reading a whole `desk` or directory, all subfolders and files must also permit reading. If even a single file does not permit you reading it, the foreign ship will not respond to the request.

### Example

[See here for examples of requests to foreign ships.](@/docs/arvo/clay/examples.md#foreign-ships)

## `%merg` - Remote

To merge a foreign `desk` into a local one, you just send Clay a `%merg` `task` (as you would for a local merge) and specify the foreign ship in the `her` field. For details on making such requests, see the [Merge Desks](#merge-desks) section.

The foreign ship will respond only if correct permissions have been set. See the [Permissions](#permissions) section for details. By default, a ship's `%kids` desk is set to be publicly readable, so unless permissions have been manually modified, you should be able to merge from any `%kids` `desk`.

Note that all subfolders and individual files within the `desk` must permit your reading in order for the merge to succeed. If even one file does not permit you reading it, the remote ship will not respond to the request at all.

### Example

[See here for examples of requests to foreign ships.](@/docs/arvo/clay/examples.md#foreign-ships)
