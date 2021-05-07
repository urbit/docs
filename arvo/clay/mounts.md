+++
title = "Manage Mounts"
weight = 8
template = "doc.html"
+++

Here we'll look at managing clay unix mounts programmatically.

## Contents

There are four `task:clay` tags relevant to mounts:

- [%boat](#boat) - List mounts.
- [%mont](#mont) - Mount something.
- [%ogre](#ogre) - Unmount something.
- [%dirk](#dirk) - Commit changes.

## %boat

This type of `task:clay` will request the list of existing mounts. It looks like:

```hoon
[%boat ~]
```

Pretty simple. The type it returns is a `%hill` tagged `gift:clay`, which looks like:

```hoon
[%hill p=(list @tas)]
```

...where the `@tas` is the name of the mount point.

Example:

Here's a thread that sends a `task:clay` and takes a `gift:clay` in response:

**`send-task-take-gift.hoon`**

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

Save it to `ted/send-task-take-gift.hoon`, `|commit %home`, and run it like:

```hoon
> -send-task-take-gift [%boat ~]
[%hill p=~[%home]]
```

## %mont

This type of `task:clay` mounts the specified `beam:clay` to the specified `term` mount point. It looks like:

```hoon
[%mont pot=term bem=beam]
```

A `beam:clay` is the following structure:

```hoon
+$  beam  [[p=ship q=desk r=case] s=path]  ::  global name
```

You can mount the whole desk with a `path` of `/`, and you can also mount subdirectories or even individual files. If you want to mount an individual file, you must exclude its `mark` from the path. For example, if you want to mount `/gen/hood/hi/hoon`, you'd specify `/gen/hood/hi`. It will automatically be given the correct file extension when mounted. If you include the `hoon` mark it will crash (and currently crash your ship).

Example:

Here's a thread which will send the given `task:clay` to clay.

**`send-task.hoon`**

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

Save it to `ted/send-task.hoon`, `|commit %home` and run it like:

```hoon
> -send-task [%mont %kids [our %kids da+now] /]
```

If you look in your pier, you should now see a `kids` folder which contains the contents of that desk.

If we make a `%boat` request as detailed in the [%boat](#boat) section, we'll now see the mount point listed:

```hoon
> -send-task-take-gift [%boat ~]
[%hill p=~[%kids %home]]
```

Note the mount point doesn't need to match a desk, file or directory. We can also do:

```hoon
> -send-task [%mont %wibbly-wobbly [our %home da+now] /]
```

And you'll now see that there's a `wibbly-wobbly` folder with the contents of the `%home` desk. You'll also notice we can mount the same file or directory more than once. There's no problem having `%home` mounted to both `home` and `wibbly-wobbly`. The only requirement is that their mount points be unique.

Let's try mounting a subdirectory and a single folder:

```hoon
> -send-task [%mont %gen [our %home da+now] /gen]
> -send-task [%mont %hi [our %home da+now] /gen/hood/hi]
```

If you look in your pier you'll now see a `gen` folder with the contents of `/gen` and a `hi.hoon` file by itself. Notice how the file extension has been automatically added.

## %ogre

This type of `task:clay` unmounts the specified mount. It's defined in `lull.hoon` as:

```hoon
[%ogre pot=$@(desk beam)]
```

But in fact it will only unmount the target when specified as a `term` mount name. Passing it a `desk` will incidentally work if the mount is named the same as the desk but otherwise it won't work. Passing it a `beam:clay` will simply not work.

Using the thread from the [%mont](#mont) section, we can unmount `%kids` like:

```hoon
-send-task [%ogre %kids]
```

Our custom mount point `%wibbly-wobbly` like:

```hoon
-send-task [%ogre %wibbly-wobbly]
```

And the single `hi.hoon` we previously mounted by specifying its mount point `%hi`:

```hoon
-send-task [%ogre %hi]
```

If we specify a non-existent mount point it will fail with an error printed to the dojo like:

```hoon
> -send-task [%ogre %kids] 
[%not-mounted %kids]
```

If we give it an unmounted `beam:clay` it will not print an error but still won't work.

## %dirk

This type of `task:clay` commits changes in the target mount. It's defined in `lull.hoon` as:

```hoon
[%dirk des=desk]
```

... but like [%ogre](#ogre), it actually takes the name of a mount point rather than a `desk` as is specified.

Example:

With your `%home` desk mounted, try adding a file and, using the thread from the [%mont](#mont) section, send a `%dirk` to commit the change:

```hoon
> -send-task [%dirk %home]
+ /~zod/home/12/foo/txt
```

Clay will print the changed files to the dojo with a leading `+`, `-` or `:` to indicate a new file, deleted file and changed file respectively.

If you have the same desk mounted to multiple points, a committed change in one mount will also update the others.
