+++
title = "Foreign Ships"
weight = 11
template = "doc.html"
+++

Here we'll looking at making Clay requests to a foreign ship.

As it currently stands, it's not possible to write to a foreign `desk`. Additionally, remote scries are not implemented. That leaves requests to read files (`%warp`) and merge desks (`%merg`).

## Contents

- [%warp](#warp) - Read files and directories.
- [%merg](#merg) - Merge a foreign desk into a local one.

## %warp

To read files on a foreign `desk`, you just send Clay a `%warp` `task` (as you would for a local read) and specify the target ship in the `wer` field. For details on making such requests, see the [Read and Subscribe](@/docs/arvo/clay/read.md) document.

Clay only allows a subset of `care`s to be used remotely. They are:

- `%u` - Check for existence of file.
- `%v` - Get entire `dome:clay` state of a desk.
- `%w` - Get revision number.
- `%x` - Get data of file.
- `%y` - Get `arch` of file or directory.
- `%z` - Get content hash of file or directory.

Any other `care` will crash with a `%clay-bad-foreign-request-care` error.

The foreign ship will respond only if correct permissions have been set. See the [Permissions](@/docs/arvo/clay/permissions.md) document for details.

Note that if you're reading a whole `desk` or directory, all subfolders and files must also permit reading. If even a single file does not permit you reading it, the foreign ship will not respond to the request.

Example:

We'll use a fake ~nes as the the foreign ship and a fake ~zod as the local ship.

First we'll set permissions on the foreign ship. Here's a simple thread that just sends a `task` to Clay:

`send-clay-task.hoon`

```hoon
/-  spider 
/+  strandio
=,  strand=strand:spider 
^-  thread:spider 
|=  arg=vase 
=/  m  (strand ,vase) 
^-  form:m
=/  uarg  !<  (unit task:clay)  arg
?~  uarg
  (strand-fail:strand %no-arg ~)
=/  =task:clay  u.uarg
=/  =card:agent:gall  [%pass /foo %arvo %c task]
;<  ~  bind:m  (send-raw-card:strandio card)
(pure:m !>(~))
```

Create a file called `foo.txt` in the `%home` of ~nes. Save the above thread to `ted/send-clay/task.hoon`, `|commit %home`, and then send a `%perm` request to allow ~zod to read and write the file:

```hoon
> -send-clay-task [%perm %home /foo/txt %rw `[%white (sy [%.y ~zod]~)] `[%white (sy [%.y ~zod]~)]]
```

If we scry the file for its permissions with a `%p` `care`, we'll see ~zod is now whitelisted:

```hoon
> .^([r=dict:clay w=dict:clay] %cp /===/foo/txt)
[r=[src=/foo/txt rul=[mod=%white who=[p={~zod} q={}]]] w=[src=/foo/txt rul=[mod=%white who=[p={~zod} q={}]]]]
```

Next, save the following thread to `ted/send-task-take-gift.hoon` on ~zod:

`send-task-take-gift.hoon`

```hoon
/-  spider
/+  strandio
=,  strand=strand:spider
^-  thread:spider
|=  arg=vase
=/  m  (strand ,vase)
^-  form:m
=/  uarg  !<  (unit task:clay)  arg
?~  uarg
  (strand-fail:strand %no-arg ~)
=/  =task:clay  u.uarg
=/  =card:agent:gall  [%pass /foo %arvo %c task]
;<  ~  bind:m  (send-raw-card:strandio card)
;<  res=[wire sign-arvo]  bind:m  take-sign-arvo:strandio
~&  +>:res
(pure:m !>(~))
```

`|commit %home`, and send a `%x` read request for `/foo/txt` on ~nes like:

```hoon
> -send-task-take-gift [%warp ~nes %home ~ %sing %x da+now /foo/txt]
[ %writ
    p
  [ ~
    [ p=[p=%x q=[%da p=~2021.5.3..08.24.22..9ce7] r=%home]
      q=/foo/txt
      r=[p=%txt q=[#t/txt=*'' q=[7.303.014 0]]]
    ]
  ]
]
```

As you can see, we've received a `%writ` containing the requested data just as we would with a local request. Let's try a `%u`:

```hoon
> -send-task-take-gift [%warp ~nes %home ~ %sing %u da+now /foo/txt]
[ %writ
    p
  [ ~
    [ p=[p=%u q=[%da p=~2021.5.3..08.26.32..88cf] r=%home]
      q=/foo/txt
      r=[p=%flag q=[#t/?(%.y %.n) q=0]]
    ]
  ]
]
```

If we send a `%d` request however, it will crash:

```hoon
> -send-receive-task [%warp ~nes %home ~ %sing %d da+now /foo/txt]
call: failed
/sys/vane/clay/hoon:<[4.085 3].[4.314 5]>
...
/sys/vane/clay/hoon:<[1.365 7].[1.365 51]>
[ %clay-bad-foreign-request-care
  [%sing mood=[care=%d case=[%da p=~2021.5.3..20.04.57..1092] path=/foo/txt]]
]
/sys/vane/clay/hoon:<[1.365 48].[1.365 50]>
```

## %merg

To merge a foreign `desk` into a local one, you just send Clay a `%merg` `task` (as you would for a local merge) and specify the foreign ship in the `her` field. For details on making such requests, see the [Merge Desks](@/docs/arvo/clay/merge.md) document.

The foreign ship will respond only if correct permissions have been set. See the [Permissions](@/docs/arvo/clay/permissions.md) document for details. By default, a ship's `%kids` desk is set to be publicly readable, so unless permissions have been manually modified, you should be able to merge from any `%kids` `desk`.

Note that all subfolders and individual files within the `desk` must permit your reading in order for the merge to succeed. If even one file does not permit you reading it, the remote ship will not respond to the request at all.
