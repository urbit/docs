+++
title = "Write and Modify"
weight = 7
template = "doc.html"
+++

Here we'll look at creating, changing and deleting files by passing clay an `%info` tagged `task:clay`.

## Contents

- [Introduction](#introduction)
- [Add File](#add-file)
- [Delete File](#delete-file)
- [Mutate File](#mutate-file)
- [Multiple Changes](#multiple-changes)

## Introduction

An `%info` task looks like:

```hoon
[%info des=desk dit=nori]  ::  internal edit
```

While the `desk` part is self-evident, the `nori` part is the following structure:

```hoon
+$  nori           ::  repository action
  $%  [%& p=soba]  ::  delta
      [%| p=@tas]  ::  label
```

The `%|` tag is not currently supported and will crash with a `%labelling-not-implemented` if used, so we can focus on the `%&` part. A `soba` is the following structure:

```hoon
+$  soba  (list [p=path q=miso])  ::  delta
```

This is just a list of changes so you can make more than one change in one request. The `path` is just the path to a file like `/gen/hood/hi/hoon` and the `miso` is the following structure:

```hoon
+$  miso             ::  ankh delta
  $%  [%del ~]       ::  delete
      [%ins p=cage]  ::  insert
      [%dif p=cage]  ::  mutate from diff
      [%mut p=cage]  ::  mutate from raw
```

- `%del` - Delete a file.
- `%ins` - Insert file. This will also replace an existing file.
- `%dif` - this has not yet been implemented so will crash with a `%dif-not-implemented` error.
- `%mut` - Change a file. At the time of writing this behaves identically to `%ins` so its use merely informs the reader.

Clay does not give any response to an `%info` task so don't expect a sign back.

Now we'll look at some example threads:

## Add File

**`add-file.hoon`**

```hoon
/-  spider 
/+  strandio
=,  strand=strand:spider 
^-  thread:spider 
|=  arg=vase 
=/  m  (strand ,vase) 
^-  form:m
=/  uarg  !<  (unit (pair path @t))  arg
?~  uarg
  (strand-fail:strand %no-arg ~)
=/  =path  p.u.uarg
=/  =wain  [q.u.uarg ~]
=/  =task:clay  [%info %home %& [[path %ins %txt !>(wain)] ~]]
=/  =card:agent:gall  [%pass /info %arvo %c task]
;<  ~  bind:m  (send-raw-card:strandio card)
(pure:m !>(~))
```

Save it in `/ted/add-file.hoon`, `|commit %home` and run it like:

```hoon
> -add-file /foo/txt 'foo'
+ /~zod/home/22/foo/txt
```

If you have a look in the home of your pier you'll see there's now a file called `foo.txt` with the text `foo` in it.

We've created the cage of the content like `[%txt !>(wain)]`, if you want to write something besides a text file you'd just give it the appropriate mark and vase.

Here's a breakdown of the `task:clay` we sent:

![write file diagram](https://pub.m.tinnus-napbus.xyz/write-file-diagram.png) 

## Delete File

**`delete-file.hoon`**

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
=/  =task:clay  [%info %home %& [path %del ~] ~]
=/  =card:agent:gall  [%pass /info %arvo %c task]
;<  ~  bind:m  (send-raw-card:strandio card)
(pure:m !>(~))
```

Save the above code in `ted/delete-file.hoon`, `|commit %home` and run it like:

```hoon
> -delete-file /foo/txt
- /~zod/home/24/foo/txt
```

If you have a look in the home of your pier you'll see the `foo.txt` file you created is now gone.

Here's a breakdown of the `task:clay` we sent:

![delete file diagram](https://pub.m.tinnus-napbus.xyz/delete-file-diagram.png) 

## Mutate File

Identical to the [Add File](#add-file) example, just replace `%ins` with `%mut`.

## Multiple Changes

Since `soba:clay` is just a `list` of `miso:clay`, you can add a bunch of `miso:clay` and they'll all be applied. This thread adds three files and then deletes them. Here there's only one type of `miso` in each request but you could mix different types together too.

**`multi-change.hoon`**

```hoon
/-  spider 
/+  strandio
=,  strand=strand:spider 
^-  thread:spider 
|=  arg=vase 
=/  m  (strand ,vase) 
^-  form:m
=/  soba-a  :~  [/foo/txt %ins %txt !>(['foo' ~])]
                [/bar/txt %ins %txt !>(['bar' ~])]
                [/baz/txt %ins %txt !>(['baz' ~])]
            ==
=/  soba-b  :~  [/foo/txt %del ~]
                [/bar/txt %del ~]
                [/baz/txt %del ~]
            ==
;<  ~  bind:m  (send-raw-card:strandio [%pass /info %arvo %c %info %home %& soba-a])
;<  ~  bind:m  (send-raw-card:strandio [%pass /info %arvo %c %info %home %& soba-b])
(pure:m !>(~))
```

Save to `ted/multi-change.hoon`, `|commit %home`, and run:

```hoon
> -multi-change
+ /~zod/home/37/foo/txt
+ /~zod/home/37/bar/txt
+ /~zod/home/37/baz/txt
- /~zod/home/38/foo/txt
- /~zod/home/38/bar/txt
- /~zod/home/38/baz/txt
```
