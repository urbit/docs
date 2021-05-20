+++
title = "Read and Subscribe"
weight = 6
template = "doc.html"
+++

Here we'll look at reading files and subscribing to changes. We'll do this by sending Clay a `card` containing a `%warp` `task`.

## Contents

- [Introduction](#introduction)
- [%sing](#sing) - Read a single file or directory.
- [%next](#next) - Subscribe for the next change to a file or directory.
- [%mult](#mult) - Subscribe for the next change to a set of files and/or directories.
- [%many](#many) - Track changes to a `desk` for the specified range of revisions.
- [Cancel Subsciption](#cancel-subscription)

## Introduction

A `%warp` `task` looks like:

```hoon
[%warp wer=ship rif=riff]  ::  internal file req
```

The `riff` part is the following structure:

```hoon
+$  riff  [p=desk q=(unit rave)]  ::  request+desist
```

 The `(unit rave)` is null to cancel a subscription, otherwise the `rave` is:

```hoon
+$  rave                     ::  general request
  $%  [%sing =mood]          ::  single request
      [%next =mood]          ::  await next version
      [%mult =mool]          ::  next version of any
      [%many track=? =moat]  ::  track range
  ==                         ::
```

- `%sing` - Read a single file or directory.
- `%next` - Subscribe for the next change to a file or directory.
- `%mult` - Subscribe for the next change to a set of files and/or directories.
- `%many` - Track changes to a desk for the specified range of revisions.

We'll look at each of these in more detail later.

Clay responds to a `%mult` request with a `sign` containing a `%wris` `gift`, and the rest with a `%writ` `gift`.

A `%wris` `gift` looks like:

```hoon
[%wris p=[%da p=@da] q=(set (pair care path))]  ::  many changes
```

A `%writ` `gift` looks like:

```hoon
[%writ p=riot]  ::  response
```

The `riot` is just:

```hoon
+$  riot  (unit rant)  ::  response+complete
```

And the `rant` has the following structure:

```hoon
+$  rant                        ::  response to request
  $:  p=[p=care q=case r=desk]  ::  clade release book
      q=path                    ::  spur
      r=cage                    ::  data
  ==                            ::
```

The `cage` will contain the data you requested and its contents will vary depending on the kind of request and `care`.

Now we'll look at each of the `rave` request types in turn.

## %sing

```hoon
[%sing =mood] 
```

This is for reading a single file or directory immediately. The `mood` structure is:

```hoon
+$  mood  [=care =case =path]  ::  request in desk
```

The `care` is `%x`, `%y` or whatever else. This will determine what you can read and what type of data will be returned. See the type documentation and scry documentation for details on the various `care`s.

The `case` specifies the `desk` revision and looks like:

```hoon
+$  case             ::  ship desk case spur
  $%  [%da p=@da]    ::  date
      [%tas p=@tas]  ::  label
      [%ud p=@ud]    ::  number
  ==                 ::
```

You can use whichever you prefer. The `path` will usually be a path to a file or directory like `/gen/hood/hi/hoon` but may be something else depending on the `care`.

Example:

`read-file.hoon`

```hoon
/-  spider 
/+  strandio
=,  strand=strand:spider 
^-  thread:spider 
|=  arg=vase 
=/  m  (strand ,vase) 
^-  form:m
=/  uarg  !<  (unit path)  arg
?~  uarg
  (strand-fail:strand %no-arg ~)
=/  =path  u.uarg
;<  =bowl:strand  bind:m  get-bowl:strandio
=/  =task:clay  [%warp our.bowl %home ~ %sing %x da+now.bowl path]
=/  =card:agent:gall  [%pass /sing %arvo %c task]
;<  ~             bind:m  (send-raw-card:strandio card)
;<  =riot:clay    bind:m  (take-writ:strandio /sing)
(pure:m !>(riot))
```

Save this thread to `/ted/read-file.hoon`, `|commit %home` and run it like:

```hoon
> -read-file /gen/hood/hi/hoon
```

You should see something like this as the output:

```hoon
[ ~
  [ p=[p=%x q=[%da p=~2021.4.17..10.55.30..ed01] r=%home]
    q=/gen/hood/hi/hoon
      r
    [ p=%hoon
        q
      [ #t/@
          q
3.548.750.706.400.251.607.252.023.288.575.526.190.856.734.474.077.821.289.791.377.301.707.878.697.553.411.219.689.905.949.957.893.633.811.025.757.107.990.477.902.858.170.125.439.223.250.551.937.540.468.638.902.955.378.837.954.792.031.592.462.617.422.136.386.332.469.076.584.061.249.923.938.374.214.925.312.954.606.277.212.923.859.309.330.556.730.410.200.952.056.760.727.611.447.500.996.168.035.027.753.417.869.213.425.113.257.514.474.700.810.203.348.784.547.006.707.150.406.298.809.062.567.217.447.347.357.039.994.339.342.906
      ]
    ]
  ]
]
```

The `cage` in the `riot` contains the file's data due to our use of an `%x` `care`. It needn't be an `%x` though. If we change it to `%u`, for example, we'll get a `?` `cage` instead:

```hoon
> -read-file /gen/hood/hi/hoon
[ ~
  [ p=[p=%u q=[%da p=~2021.4.26..06.51.32..56a7] r=%home]
    q=/gen/hood/hi/hoon
    r=[p=%flag q=[#t/?(%.y %.n) q=0]]
  ]
]
```

Here's a breakdown of the `task` we sent:

![read file diagram](https://pub.m.tinnus-napbus.xyz/read-file.png "read file diagram")

## %next

```hoon
[%next =mood]  ::  await next version
```

This subscribes to the next version of the specified file. The `mood` structure is the same as described in the `%sing` example.

If you subscribe to the current `case` of the `desk`, Clay will not respond until the file changes. If you subscribe to a previous `case` of the `desk` and the file has changed in between then and now, it will immediately return the first change it comes across in that range. For example, if you're currently at `case` `100`, subscribe to case `50` and the file in question has been modified at both `60` and `80`, clay will immediately return the version of the file at `case` `60`.

`sub-next.hoon`

```hoon
/-  spider 
/+  strandio
=,  strand=strand:spider 
^-  thread:spider 
|=  arg=vase 
=/  m  (strand ,vase) 
^-  form:m
=/  uarg  !<  (unit path)  arg
?~  uarg
  (strand-fail:strand %no-arg ~)
=/  =path  u.uarg
;<  =bowl:strand  bind:m  get-bowl:strandio
=/  =task:clay  [%warp our.bowl %home ~ %next %x da+now.bowl path]
=/  =card:agent:gall  [%pass /next %arvo %c task]
;<  ~             bind:m  (send-raw-card:strandio card)
;<  =riot:clay    bind:m  (take-writ:strandio /next)
~&  riot
?~  riot
  %-  (slog leaf+"{(spud path)} deleted!" ~)
  (pure:m !>(~))
%-  (slog leaf+"{(spud q.u.riot)} changed!" ~)
(pure:m !>(~))
```

This thread will subscribe to the next version of the file given as an argument. It will print the `riot` it gets back from Clay and will also print a message saying whether the file's been deleted or changed.

Save this in `ted/sub-next.hoon`, `|commit %home` and run like:

```hoon
> -sub-next /foo/txt
```

Now, in unix, create a file called `foo.txt` in the `ted` directory of your ship. In the dojo, hit backspace to disconnect the thread from the dojo prompt and run `|commit %home`. You should see something like:

```hoon
> |commit %home
>=
[ ~
  [ p=[p=%x q=[%ud p=106] r=%home]
    q=/foo/txt
    r=[p=%txt q=[#t/*'' q=[7.303.014 0]]]
  ]
]
/foo/txt changed!
+ /~zod/home/106/foo/txt
```

As you can see, the `riot` includes a `cage` with the data of `/foo/txt` due to our use of an `%x` care.

Now run the thread again, and this time delete the file in unix and again `|commit %home` in the dojo. You should see:

```hoon
> |commit %home
>=
~
/foo/txt deleted!
- /~zod/home/107/foo/txt
```

You can see the `riot` is just `~` due to the file being deleted. 

Here's a breakdown of the task we sent:

![subscribe next diagram](https://pub.m.tinnus-napbus.xyz/sub-next.png "subscribe next diagram")

## %mult

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

Example:

This thread will subscribe to `/foo/txt` with an `%x` `care` and `/bar/txt` with a `%u` `care`. It will print out the `%wris` it gets back from Clay.

`sub-mult.hoon`

```hoon
/-  spider 
/+  strandio
=,  strand=strand:spider 
^-  thread:spider 
|=  arg=vase 
=/  m  (strand ,vase) 
^-  form:m
=/  files=(set (pair care:clay path))
  %-  sy  :~
            [%x /foo/txt]
            [%u /bar/txt]
          ==
;<  =bowl:strand  bind:m  get-bowl:strandio
=/  =task:clay  [%warp our.bowl %home ~ %mult da+now.bowl files]
=/  =card:agent:gall  [%pass /mult %arvo %c task]
;<  ~  bind:m  (send-raw-card:strandio card)
;<  response=(pair wire sign-arvo)  bind:m  take-sign-arvo:strandio
~&  +.q.response
(pure:m !>(~))
```

Save the above to `ted/sub-mult.hoon`, `|commit %home` and run with `-sub-mult`. Now, create `foo.txt` and `bar.txt` in your home directory, hit backspace in the dojo to disconnect the thread and run `|commit %home`. You should see something like:

```hoon
> |commit %home
>=
[%wris p=[%da p=~2021.4.27..06.07.08..5ec4] q={[p=%u q=/bar/txt] [p=%x q=/foo/txt]}]
+ /~zod/home/151/foo/txt
+ /~zod/home/151/bar/txt
```

You'll notice that, unlike a `%writ`, the `%wris` doesn't give you the data. It merely tells you the `care`s and `path`s of the files that changed. If you need to actually get the data, you can just scry or send a request for the files in question.

Now, run the thread again, open `bar.txt` in an editor, modify its contents, save it and `|commit %home`. You'll notice you didn't receive a `%wris`. This is because we subscribed to `/bar/txt` with `%u` care and its existence didn't change.

Lastly, delete `foo.txt` and `|commit %home`. You should see something like:

```hoon
> |commit %home
>=
[%wris p=[%da p=~2021.4.27..06.15.03..0da4] q={[p=%x q=/foo/txt]}]
- /~zod/home/153/foo/txt
```

As you can see, a relevant change to any of the subscribed files will trigger a response, not just when all of them change.

Here's a breakdown of the `task` we sent:

![subscribe mult diagram](https://pub.m.tinnus-napbus.xyz/sub-mult.png "subscribe mult diagram")

## %many

```hoon
[%many track=? =moat]  ::  track range
```

This subscribes to all changes to a `desk` for the specified range of `case`s. Note that you're unlikely to use this directly, it's mostly used implicitly if you make a `%sing` or `%next` request with a `%v` `care` to a foreign `desk`. Regardless, we'll have a look at it for completeness.

If the `track` is `%.y` it will just return a `%writ` like:

```hoon
[%writ p=[~ [p=[p=%w q=[%ud p=256] r=%home] q=/ r=[p=%null q=[#t/@n q=0]]]]]
```

...that merely informs you of a change. If you want the actual data you'll have to request it separately.

If the `track` is `%.n`, the `cage` of the `%writ` will contain a `nako`, which looks like:

```hoon
::  New desk data.
::
::  Sent to other ships to update them about a particular desk.  Includes a map
::  of all new aeons to hashes of their commits, the most recent aeon, and sets
::  of all new commits and data.
::
+$  nako                   ::  subscription state
  $:  gar=(map aeon tako)  ::  new ids
      let=aeon             ::  next id
      lar=(set yaki)       ::  new commits
      bar=(set plop)       ::  new content
  ==                       ::
```

As the comment explains, it contains all relevant data for a changes to a desk between what you have and the `case` requested. It is very large and fairly complicated. The `nako` structure is defined in the `clay.hoon` source file itself rather than in `lull.hoon` or elsewhere since you're unlikely to work with it yourself.

The `moat` in the `%many` is the following structure:

```hoon
  +$  moat  [from=case to=case =path]  ::  change range
```

The `from` and `to` fields specify the range of `case`s for which to subscribe. The range is *inclusive*. It can be specified by date or by revision number, whichever you prefer.

The `path` is a path to a file or directory. If it's `~` it refers to the root of the `desk` in question. This lets you say "only inform me of changes to the `desk` if the specified file or directory exists". If it doesn't exist, Clay will not send you anything.

When you reach the end of the subscribed range of `case`s, Clay will send you a `%writ` with a null `riot` to inform you the subscription has ended like:

```hoon
[%writ p=~]
```

Example:

This thread will subscribe to changes to your `%home` `desk` for the next three minutes. The `track` is `%.y` so it will only inform you of changes, not send the full `nako`. It will only get updates if the specified file exists. It contains a `main-loop` that will take an arbitrary number of `sign`s and print them out in the dojo. Since it never ends, you'll need to stop it with the `:spider|kill` command in the dojo.

`sub-many.hoon`

```hoon
/-  spider 
/+  strandio
=,  strand=strand:spider
|%
++  take-sign-loop
  =/  m  (strand ,~)
  ^-  form:m
  %-  (main-loop:strandio ,~)
  :~  |=  ~
      ^-  form:m
      ;<  res=(pair wire sign-arvo)
        bind:m
      ((handle:strandio ,(pair wire sign-arvo)) take-sign-arvo:strandio)
      ~&  res
      (pure:m ~)
  ==
-- 
^-  thread:spider 
|=  arg=vase 
=/  m  (strand ,vase) 
^-  form:m
=/  uarg  !<  (unit path)  arg
?~  uarg
  (strand-fail:strand %no-arg ~)
=/  =path  u.uarg
;<  =bowl:strand  bind:m  get-bowl:strandio
=/  =task:clay  [%warp our.bowl %home ~ %many %.y da+now.bowl da+(add ~m3 now.bowl) path]
=/  =card:agent:gall  [%pass /many %arvo %c task]
;<  ~  bind:m  (send-raw-card:strandio card)
;<  ~  bind:m  take-sign-loop
(pure:m !>(~))
```

Make sure `foo.txt` doesn't exist in the root of your `%home` `desk`. Save this to `ted/sub-many.hoon`, `|commit %home`, run it like `-sub-many /foo/txt`, and hit backspace in the dojo to free up the dojo prompt. Now, add a file called `bar.txt` to your `desk` and `|commit %home`. You should see something like:

```hoon
> |commit %home
>=
+ /~zod/home/260/bar/txt
```

Notice you've received no `%writ` from Clay. This is because `/foo/txt` doesn't exist. Now, create `foo.txt` and `|commit %home` again. You should see:

```hoon
> |commit %home
>=
[ p=/many
  q=[%clay [%writ p=[~ [p=[p=%w q=[%ud p=261] r=%home] q=/ r=[p=%null q=[#t/@n q=0]]]]]]
]
+ /~zod/home/261/foo/txt
```

Now that `/foo/txt` exists it will inform you of updates. Note that if you delete `/foo/txt` again it will again stop sending updates.

Now try adding `baz.txt`:

```hoon
> |commit %home
>=
[ p=/many
  q=[%clay [%writ p=[~ [p=[p=%w q=[%ud p=262] r=%home] q=/ r=[p=%null q=[#t/@n q=0]]]]]]
]
+ /~zod/home/262/baz/txt
```

Now wait until the three minutes is up and try making a change, for example deleting `baz.txt`:

```hoon
> |commit %home
>=
[ p=/many
  q=[%clay [%writ p=[~ [p=[p=%w q=[%ud p=264] r=%home] q=/ r=[p=%null q=[#t/@n q=0]]]]]]
]
[p=/many q=[%clay [%writ p=~]]]
- /~zod/home/263/baz/txt
```

You can see that along with the normal `%writ` it's also sent a second `%writ` with a null `riot` to indicate the subscription has ended. This is because it has now passed the end of the range of `case`s to which you subscribed. 

Run `:spider|kill` to stop the thread.

Here's a breakdown of the task we sent:

![subscribe many diagram](https://pub.m.tinnus-napbus.xyz/sub-many.png "subscribe many diagram")

## Cancel Subscription

Here we'll look at cancelling a subscription. It's very simple, you just send a `%warp` with a null `(unit rave)` in the `riff`. Clay will cancel the subscription based on the `wire`. The request is exactly the same regardless of which type of `rave` you subscribed with originally.

Example:

This thread will subscribe to the `%next` version of `/foo/txt`, then immediately cancel the subscription and wait for a response to print (which it will never receive).

`stop-sub.hoon`

```hoon
/-  spider 
/+  strandio
=,  strand=strand:spider 
^-  thread:spider 
|=  arg=vase 
=/  m  (strand ,vase) 
^-  form:m
;<  =bowl:strand  bind:m  get-bowl:strandio
=/  =task:clay  [%warp our.bowl %home ~ %next %x da+now.bowl /foo/txt]
=/  =card:agent:gall  [%pass /next %arvo %c task]
;<  ~             bind:m  (send-raw-card:strandio card)
=.  task  [%warp our.bowl %home ~]
=.  card  [%pass /next %arvo %c task]
;<  ~             bind:m  (send-raw-card:strandio card) 
;<  =riot:clay    bind:m  (take-writ:strandio /next)
~&  riot
(pure:m !>(~))
```

Save the above to `ted/stop-sub.hoon`, `|commit %home`, run it with `-stop-sub` and hit backspace to detach it from the dojo prompt. Now, add `foo.txt` to the root of your `%home` `desk` and `|commit %home`. You should see:

```hoon
> |commit %home
>=
+ /~zod/home/266/foo/txt
```

As you can see we've received no `%writ`. We can thus conclude the subscription has successfully been cancelled.

Run `:spider|kill` to stop the thread.

Here's a breakdown of the `task` we sent:

![cancel subscription diagram](https://pub.m.tinnus-napbus.xyz/stop-sub.png "cancel subscription diagram")
