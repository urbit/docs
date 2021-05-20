+++
title = "Scry Reference"
weight = 5
template = "doc.html"
+++

The various Clay scries are specified by a `care`, which is a single character corresponding with a Clay submodule. Apart from `%s` they just take a `path` to a `desk`, file or directory. All examples are dojo commands, the ='s in the path are automatically populated by the dojo like:

```hoon
> /===
[~.~zod ~.home ~.~2021.4.26..02.29.03..d31b ~]
```

## Contents

- [a](#a) - Build a hoon file.
- [b](#b) - Dynamic mark.
- [c](#c) - Dynamic mark conversion.
- [d](#d) - List desks.
- [e](#e) - Static mark.
- [f](#f) - Static mark conversion.
- [p](#p) - File permissions.
- [r](#r) - Vase-wrapped file data. 
- [s](#s) - Miscellaneous scries:
    - [yaki](#yaki) - `yaki:clay` of the specified commit.
    - [blob](#blob) - `blob:clay` of file.
    - [hash](#hash) - Content hash of the specified commit.
    - [cage](#cage) - `cage` of the data of a file.
    - [open](#open) - Compile prelude of file.
    - [late](#late) - Most recent case of desk.
    - [base](#base) - Mergebase of two desks.
- [t](#t) - List files in directory.
- [u](#u) - Check for existence of file.
- [v](#v) - Desk state.
- [w](#w) - Revision number of the given desk case.
- [x](#x) - Raw data of file.
- [y](#y) - `arch` of a file or directory.
- [z](#z) - Content hash of a file or directory.

## a

A scry with a `care` of `%a` will build a `hoon` file and return it as a `vase`.

Example:

```hoon
.^(vase %ca /===/lib/strandio/hoon)
```

## b

A scry with a `care` of `%b` will produce a `dais:clay` processed `mark` core for the specified `mark`. The `path` in the scry is a `mark`.

Example:

```hoon
.^(dais:clay %cb /===/txt)
```

## c

A scry with a `care` of `%c` will produce a `tube:clay` dynamically typed `mark` conversion gate. The `path` specifies two `mark`s - *from* and *to*, like `/txt/noun`.

Example:

```hoon
> =a .^(tube:clay %cc /===/txt/mime)
> !<  mime  (a !>(~['foo']))
[p=/text/plain q=[p=3 q=7.303.014]]
```

## d

A scry with a `care` of `%d` will return a `(set desk)` of the `desk`s that exist on your ship.

Example:

```hoon
> .^((set desk) %cd /===)
{%home %kids}
```

## e

A scry with a `care` of `%e` will return a statically typed `nave:clay` `mark` core in a `vase`. The `path` in the scry specifies the `mark`.

Example:

```hoon
.^(vase %ce /===/noun)
```

## f

A scry with a `care` of `%f` will return a static `mark` conversion gate. The `path` specifies two `mark`s - *from* and *to*, like `/txt/mime`.

```hoon
> =a .^($-(text mime) %cf /===/txt/mime)
> (a ~['foo'])
[p=/text/plain q=[p=3 q=7.303.014]]
```

## p

A scry with a `care` of `%p` will return the permissions of the file or directory in question. The type returned is a `[dict:clay dict:clay]` where the head is read permissions and the tail is write permissions.

A `dict` is:

```hoon
+$  dict  [src=path rul=real]
```

...and a `real` is:

```hoon
+$  real
  $:  mod=?(%black %white)
      who=(pair (set ship) (map @ta crew))
  ==
```

...where:

- `mod` specifies either a **black**list or a **white**list.
- `who` specifies:
   - the set of allowed/disallowed ships.
   - allowed/disallowed named `crew`s (a `crew` is just a `set` of ships) - basically groups.

If the specified file or directory has no permissions set, it will default to the permissions of its parent. If nothing above it has permissions set, it will default to empty whitelists. If the specified file or directory doesn't exist, it will also return the default empty whitelist.

Example:

```hoon
> .^([dict:clay dict:clay] %cp /===/gen)
[[src=/ rul=[mod=%white who=[p={} q={}]]] src=/ rul=[mod=%white who=[p={} q={}]]]
```

## r

A scry with a `care` of `%r` will return the data of the given file wrapped in a `vase` or crash if it's a directory. It's basically just a vase-wrapped `%x` scry.

Examples:

```hoon
> .^(vase %cr /===/gen/hood/hi/hoon)
[ #t/@
    q
  3.548.750.706.400.251.607.252.023.288.575.526.190.856.734.474.077.821.289.791.377.301.707.878.697.553.411.219.689.905.949.957.893.633.811.025.757.107.990.477.902.858.170.125.439.223.250.551.937.540.468.638.902.955.378.837.954.792.031.592.462.617.422.136.386.332.469.076.584.061.249.923.938.374.214.925.312.954.606.277.212.923.859.309.330.556.730.410.200.952.056.760.727.611.447.500.996.168.035.027.753.417.869.213.425.113.257.514.474.700.810.203.348.784.547.006.707.150.406.298.809.062.567.217.447.347.357.039.994.339.342.906
]
```

```hoon
> !<  @t  .^(vase %cr /===/gen/hood/hi/hoon)
'::  Helm: send message to an urbit\0a::\0a::::  /hoon/hi/hood/gen\0a  ::\0a/?    310\0a:-  %say\0a|=([^ [who=ship mez=$@(~ [a=tape ~])] ~] helm-send-hi+[who ?~(mez ~ `a.mez)])\0a'
```

```hoon
> .^(vase %cr /===/gen)
Crash!
```

## s

A scry with a `care` of `%s` is for miscellaneous internal and debug functions and is liable to change in the future.

Rather than just a `path` to a file, the head of the `path` is tagged with one of `%yaki %blob %hash %cage %open %late %base` and the tail depends on which tag you use. We'll look at each in turn. 

### yaki

This will return the `yaki:clay` of the specified commit. It takes a `tako:clay`.

Example:

Here we scry the `dome:clay` for `/===`, get the latest `tako:clay` and the do a `%s` scry for the `yaki:clay` in question.

```hoon
> =/  =dome:clay  .^(dome:clay %cv /===)
  =/  =tako:clay  (~(got by hit.dome) let.dome)
  .^(yaki:clay %cs /===/yaki/(scot %uv tako))
[ p=~[80.174.473.756.485.530.520.259.753.935.584.637.641.665.425.899.348.092.348.244.635.557.986.495.151.006]
    q
  { [p=/mar/hark/graph-hook-update/hoon q=0v5.ea0bj.21s5c.mjrop.ishic.fpkvl.e5bbs.91kc9.tdo41.ifi06.60v41]
    [p=/gen/hood/autocommit/hoon q=0v19.rh7jv.sa67o.t3jrb.4sdvs.7c45f.pv2u0.ragik.psp20.agqd8.8srkj]
    ...
    [p=/tests/lib/primitive-rsa/hoon q=0v1g.3qmq3.6i15q.arh6h.lfsqu.gvc9m.ql6m5.e2rdr.vnnt9.tptc6.mv9u7]
    [p=/tests/sys/vane/gall/hoon q=0va.alspc.qptqn.7tuj0.bgecg.1093t.gtsjs.up03k.d1fmk.4jrh8.2tdfa]
  }
  r=88.666.797.531.755.181.802.690.473.856.185.443.710.929.766.582.249.039.904.824.278.074.149.777.897.099
  t=~2021.4.16..10.41.57..3565
]
```

### blob

This will return the `blob:clay` of some file. It takes a `lobe:clay`.

Example:

Here we grab the `lobe:clay` of `/gen/hood/hi/hoon` with a `%y` scry, then use it to do a `%s` scry for the `blob:clay` of the file.

```hoon
> =/  =arch  .^(arch %cy /===/gen/hood/hi/hoon)
  ?~  fil.arch
    ~
  .^(blob:clay %cs /===/blob/(scot %uv u.fil.arch))
[ %direct
  p=0vp.k7nsm.qkdr3.t17rp.33bae.8gajg.v27gi.40itr.2u9qa.nppbt.7k255
    q
  [ p=%hoon
      q
3.548.750.706.400.251.607.252.023.288.575.526.190.856.734.474.077.821.289.791.377.301.707.878.697.553.411.219.689.905.949.957.893.633.811.025.757.107.990.477.902.858.170.125.439.223.250.551.937.540.468.638.902.955.378.837.954.792.031.592.462.617.422.136.386.332.469.076.584.061.249.923.938.374.214.925.312.954.606.277.212.923.859.309.330.556.730.410.200.952.056.760.727.611.447.500.996.168.035.027.753.417.869.213.425.113.257.514.474.700.810.203.348.784.547.006.707.150.406.298.809.062.567.217.447.347.357.039.994.339.342.906
  ]
]
```

### hash

This will return the `@uvI` content hash of the specified commit. It takes a `tako:clay`.

Example:

Here we grab the `dome:clay` for `/===` with a `%v` scry, get the latest `tako:clay` and then do a `%s` `%hash` scry for it.

```hoon
> =/  =dome:clay  .^(dome:clay %cv /===)
  =/  =tako:clay  (~(got by hit.dome) let.dome)
  .^(tako:clay %cs /===/hash/(scot %uv tako))
0v16.er7uq.oke4u.cru7u.nglu9.q3su7.6ub1o.bh4qk.r5uav.ut12d.5rdl5
```

### cage

This will return a `cage` of the data of some file. It takes a `lobe:clay`.

Example:

Here we grab the `lobe:clay` of `/gen/hood/hi/hoon` with a `%y` scry, then use it to do a `%s` scry for the `cage` of the data.

```hoon
> =/  =arch  .^(arch %cy /===/gen/hood/hi/hoon)
  ?~  fil.arch
    ~
  .^(cage %cs /===/cage/(scot %uv u.fil.arch))
[ p=%hoon
    q
  [ #t/@t
      q
3.548.750.706.400.251.607.252.023.288.575.526.190.856.734.474.077.821.289.791.377.301.707.878.697.553.411.219.689.905.949.957.893.633.811.025.757.107.990.477.902.858.170.125.439.223.250.551.937.540.468.638.902.955.378.837.954.792.031.592.462.617.422.136.386.332.469.076.584.061.249.923.938.374.214.925.312.954.606.277.212.923.859.309.330.556.730.410.200.952.056.760.727.611.447.500.996.168.035.027.753.417.869.213.425.113.257.514.474.700.810.203.348.784.547.006.707.150.406.298.809.062.567.217.447.347.357.039.994.339.342.906
  ]
]
```

### open

This is like a `%a` scry but it only compiles the prelude to the file, e.g. the Ford rune imports. Proper documentation for this will be done as part of Ford documentaton at a later date.

### late

This will return the most recent revision number of a `desk` that has been fully downloaded. The type it returns is a `cass:clay`. The `case` in the `beak` must be a revision number rather than a date. You can just provide a case of `1` since it returns the latest regardless. If we have nothing for the specified `desk`, this will just return the bunt of a `cass:clay` like `cass=[ud=0 da=~2000.1.1]`.

Example:

```hoon
> .^(=cass:clay %cs /(scot %p (sein:title our now our))/kids/1/late)
cass=[ud=50 da=~2021.4.22..10.38.50..57a8]
```

```hoon
> .^(=cass:clay %cs /~sampel/kids/1/late)
cass=[ud=0 da=~2000.1.1]
```

### base

This will return the mergebase (i.e. most recent common ancestor) between two `desk`s. The type it returns is a `(list tako:clay)`. The first `desk` will just be the one in the `beak` `path` prefix and the second will be specified like `/ship/desk` at the end of the scry `path`. If there is no common ancestor between the two `desk`s, this will just produce an empty `list`.

Examples:

```hoon
> .^((list tako:clay) %cs /===/base/(scot %p (sein:title our now our))/kids)
~[102.787.244.596.033.419.950.995.540.301.493.841.569.518.772.322.508.085.465.561.801.703.148.627.263.473]
```

```hoon
> .^((list tako:clay) %cs /===/base/~sampel/kids)
~
```

## t

A scry with a `care` of `%t` will return a `(list path)` of all files in the given directory, or just a `(list path)` of the single file if it's a file. This is done recursively so will provide files in subdirectories as well. The paths will be fully qualified except for the `ship`, `desk` and `case`. If the directory or file specified does not exist, it will return an empty `list`.

Examples:

```hoon
> .^((list path) %ct /===/app/landscape)
~[
  /app/landscape/css/index/css
  /app/landscape/img/favicon/png
  /app/landscape/img/imageupload/png
  /app/landscape/img/touch_icon/png
  /app/landscape/index/html
  /app/landscape/js/channel/js
]
```

```hoon
> .^((list path) %ct /===/gen/group-store/add/hoon)
~[/gen/group-store/add/hoon]
```

```hoon
> .^((list path) %ct /===/foobar)
~
```

## u

A scry with a `care` of `%u` will return a `?` depending on whether the file exists. It will produce `%.n` if it's a directory or doesn't exist and will produce `%.y` if it's a file and exists.

Examples:

```hoon
> .^(? %cu /===/app)
%.n
```

```hoon
> .^(? %cu /===/gen/code/hoon)
%.y
```

```hoon
> .^(? %cu /===/foobar)
%.n
```

## v

A scry with a care of `%v` will return the entire state of a `desk` as a `dome:clay`.

Example:

```hoon
> =a .^(dome:clay %cv /===)
> let.a
1
```

Note: If you try printing this it will take forever and probably OOM your ship.

## w

A scry with a `care` of `%w` will return the revision number and date of a given `case`. The type returned is a `cass:clay` like `[ud=@ud da=@da]` where `ud` is the revision number and `da` is the date.

Example:

```hoon
> .^(cass:clay %cw /===)
[ud=2 da=~2021.4.13..19.12.49..3389]
```

## x

A scry with a `care` of `%x` will return the raw data of a file as an `@` or crash if it's a directory.


Examples:

```hoon
> .^(@ %cx /===/gen/hood/hi/hoon)
3.548.750.706.400.251.607.252.023.288.575.526.190.856.734.474.077.821.289.791.377.301.707.878.697.553.411.219.689.905.949.957.893.633.811.025.757.107.990.477.902.858.170.125.439.223.250.551.937.540.468.638.902.955.378.837.954.792.031.592.462.617.422.136.386.332.469.076.584.061.249.923.938.374.214.925.312.954.606.277.212.923.859.309.330.556.730.410.200.952.056.760.727.611.447.500.996.168.035.027.753.417.869.213.425.113.257.514.474.700.810.203.348.784.547.006.707.150.406.298.809.062.567.217.447.347.357.039.994.339.342.906
```

```hoon
> .^(@t %cx /===/gen/hood/hi/hoon)
'::  Helm: send message to an urbit\0a::\0a::::  /hoon/hi/hood/gen\0a  ::\0a/?    310\0a:-  %say\0a|=([^ [who=ship mez=$@(~ [a=tape ~])] ~] helm-send-hi+[who ?~(mez ~ `a.mez)])\0a'
```

```hoon
> .^(@ %cx /===/gen/hood)
Crash!
```

## y

A scry with a `care` of `%y` will return the `arch` of a file or directory.

An `arch` is a `[fil=(unit lobe:clay) dir=(map @ta ~)]`. The `fil` will contain the `lobe:clay` hash if it's a file, otherwise it will be null. The `dir` will contain a map of the files and directories it contains, otherwise it will be null.

It will return the bunt of an `arch` if the file or directory is not found.

Examples:

```hoon
> .^(arch %cy /===/gen/group-store)
[ fil=~
    dir
  { [p=~.allow-ships q=~]
    [p=~.add q=~]
    [p=~.ban-ranks q=~]
    [p=~.remove q=~]
    [p=~.create q=~]
    [p=~.join q=~]
    [p=~.allow-ranks q=~]
    [p=~.ban-ships q=~]
  }
]
```

```hoon
> .^(arch %cy /===/gen/group-store/allow-ships)
[fil=~ dir={[p=~.hoon q=~]}]
```

```hoon
> .^(arch %cy /===/gen/group-store/allow-ships/hoon)
[fil=[~ 0vb.g8sqs.7gjm9.bl3vu.nk677.h5be1.g9eg3.4v1jo.00ivf.g8ndu.48a53] dir={}]
```

```hoon
> .^(arch %cy /===/foobar)
[fil=~ dir={}]
```

## z

A scry with a `care` of `%z` will return the hash of a file or the recursive hash of a directory. If the file or directory doesn't exist it will return a null value.

The type returned is a `@uxI`.

Examples:

```hoon
> .^(@uvI %cz /===/gen)
0v5.itmhj.lt7ak.lgr1k.dr7vu.u7u9s.ko5rf.idfcr.ukrd2.t088n.3ml1k
```

```hoon
> .^(@uvI %cz /===/gen/code/hoon)
0v1t.vi1pf.3ba4n.87g6h.dcc1p.4t4l8.rm6a9.b4de4.v77qc.p9dc0.p8289
```

```hoon
> .^(@uvI %cz /===/foobar)
0v0
```
