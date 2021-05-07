+++
title = "Permissions"
weight = 10
template = "doc.html"
+++

Here we'll look at file permissions.

## Contents
- [Introduction](#introduction)
- [%perm](#perm) - Set file permissions.
- [%cred](#cred) - Add permission group.
- [%crew](#crew) - Get permission groups.
- [%crow](#crow) - Get group usage.

## Introduction

For each file or directory, there is both a read permission and a write permission. Each may be set separately and is either a whitelist or a blacklist (but not both). The whitelist/blacklist contains a `set` of ships and/or groups which are allowed or banned respectively. If it's an empty whitelist it means all foreign ships are denied. If it's an empty blacklist it means all foreign ships are allowed.

If permissions are not set for a particular file, they will be inherited from the directory in which it resides. If *that* directory has no permissions set, they will be inherited from another level up, and so on to the desk's root directory. If the root directory has no permissions set, it will have the default permissions of an empty whitelist, meaning "deny all".

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

So if we scry for permissions with a `%p` care, it'll look like:

```hoon
> .^([r=dict:clay w=dict:clay] %cp /===/lib/strandio/hoon)
[r=[src=/ rul=[mod=%white who=[p={} q={}]]] w=[src=/ rul=[mod=%white who=[p={} q={}]]]]
```

There are four permission-related tasks which you can pass to clay.

A `%perm` task is for setting permissions, and the other three are for managing groups:

- `%cred` - add permission group
- `%crew` - get permission groups
- `%crow` - get group usage

We'll look at each of these in turn.

## %perm

This sets permissions for the target file or directory.

Note this will replace existing permissions rather than add to them, so if you want to add a ship to an existing whitelist or whatever you'll have to first read the existing permissions, add the ship, then send the whole lot back.

A `%perm` tagged `task:clay` looks like:

```hoon
[%perm des=desk pax=path rit=rite]  ::  change permissions
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

Example:

Here's a generic thread that just sends the given `task:clay` to clay so we can try a few different things:

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

Save it to `ted/send-clay-task.hoon` and `|commit %home`. Now, let's allow `~nes` to read `/gen/hood/hi/hoon`:

```hoon
> -send-clay-task [%perm %home /gen/hood/hi/hoon %r ~ %white (sy [%.y ~nes]~)]
```

...and we'll do a `%p` scry to see that the permission was set:

```hood
> .^([r=dict:clay w=dict:clay] %cp /===/gen/hood/hi/hoon)
[r=[src=/gen/hood/hi/hoon rul=[mod=%white who=[p={~nes} q={}]]] w=[src=/ rul=[mod=%white who=[p={} q={}]]]]
```

You can see that `~nes` is now in the read whitelist. Next, let's try a write permission:

```hoon
> -send-clay-task [%perm %home /ted %w ~ %white (sy [%.y ~nes]~)]
```

You can see `~nes` can now write to `/ted`:

```hoon
> .^([r=dict:clay w=dict:clay] %cp /===/ted)
[r=[src=/ rul=[mod=%white who=[p={} q={}]]] w=[src=/ted rul=[mod=%white who=[p={~nes} q={}]]]]
```

Since we've set it for the whole `/ted` directory, if we check a file inside it we'll see it also has this permission:

```hoon
> .^([r=dict:clay w=dict:clay] %cp /===/ted/aqua/ames/hoon)
[r=[src=/ rul=[mod=%white who=[p={} q={}]]] w=[src=/ted rul=[mod=%white who=[p={~nes} q={}]]]]
```

...and you'll notice that `src` tells us it's inherited the rule from `/ted`.

Now let's try setting both read and write permissions:

```hoon
> -send-clay-task [%perm %home /gen/help/hoon %rw `[%black (sy [%.y ~nes]~)] `[%white (sy [%.y ~nes]~)]]
```

```hoon
 .^([r=dict:clay w=dict:clay] %cp /===/gen/help/hoon)
[r=[src=/gen/help/hoon rul=[mod=%black who=[p={~nes} q={}]]] w=[src=/gen/help/hoon rul=[mod=%white who=[p={~nes} q={}]]]]
```

Lastly, let's look at deleting a permission rule we've previously set. To do that, we just send a null `(unit rule)` in the `rite`.

For example, to remove a read permission (or write if you specify `%w`):

```hoon
> -send-clay-task [%perm %home /gen/help/hoon %r ~]
```

```hoon
> .^([r=dict:clay w=dict:clay] %cp /===/gen/help/hoon)
[r=[src=/ rul=[mod=%white who=[p={} q={}]]] w=[src=/gen/help/hoon rul=[mod=%white who=[p={~nes} q={}]]]]
```

...and to remove both read and write at the same time:

```hoon
> -send-clay-task [%perm %home /gen/help/hoon %rw ~ ~]
```

```hood
> .^([r=dict:clay w=dict:clay] %cp /===/gen/help/hoon)
[r=[src=/ rul=[mod=%white who=[p={} q={}]]] w=[src=/ rul=[mod=%white who=[p={} q={}]]]]
```

As you can see it's back to the default inherited from `/`.

Here's a breakdown of a `%perm` task:

![perm diagram](https://pub.m.tinnus-napbus.xyz/perm-diagram.png) 

## %cred

This simply creates a permission group. The task looks like this:

```hoon
[%cred nom=@ta cew=crew]  ::  set permission group
```

The `nom` is a name for the group and the `crew` is just a `(set ship)`:

```hoon
+$  crew  (set ship)  ::  permissions group
```

Example:

We'll use the same thread from the [%perm](#perm) example. Try:

```hoon
-send-clay-task [%crew 'foo' (sy ~[~zod ~nec ~bud ~wes ~sev])]
```

We'll check it with the next kind of task: [%crew](#crew).

## %crew

This retrieves all permission groups. It looks like:

```hoon
[%crew ~]  ::  permission groups
```

Clay wil return a sign containing a `gift:clay` with a `%cruz` tag. It looks like:

```hoon
[%cruz cez=(map @ta crew)]  ::  permission groups
```

The `cez` is just a map from group name to `crew` which is just a `(set ship)`.

Example:

Here's a generic thread that sends the given `task:clay` and receives a gift which it just prints to the dojo.

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

Save the above to `ted/send-task-take-gift.hoon` and `|commit %home`. Now we'll check for the permission group we created in the [%cred](#cred) example:

```hoon
> -send-task-take-gift [%crew ~]
[%cruz cez={[p=~.foo q={~nec ~bud ~wes ~zod ~sev}]}]
```

## %crow

This is the last group task. It retrieves all files and directories in all desks which have permissions set for the group in question. It will not return inherited permissions, only those explicitly set. It looks like:

```hoon
[%crow nom=@ta]  ::  group usage
```

The `gift:clay` you get back is a `%croz` which looks like:

```hoon
[%croz rus=(map desk [r=regs w=regs])]  ::  rules for group
```

...where `regs` is this structure:

```hoon
+$  regs  (map path rule)  ::  rules for paths
```

Example:

First we'll set a couple of permissions for the `foo` group we created in the [%cred](#cred) section using the `send-clay-task.hoon` thread from the [%perm](#perm) section:

```hoon
> -send-clay-task [%perm %home /gen/hood/hi/hoon %w ~ %white (sy [%.n 'foo']~)]
> -send-clay-task [%perm %home /ted %w ~ %white (sy [%.n 'foo']~)]
```

Notice we use a `%.n` in the `whom:clay` to indicate a group rather than the `%.y` of a group.

Now we'll use the `send-task-take-gift.hoon` thread from the [%crew](#crew) section to try `%crow`:

```hoon
> -send-receive-task [%crow 'foo']
[ %croz
    rus
  { [ p=%home
        q
      [ r={}
          w
        { [p=/gen/hood/hi/hoon q=[mod=%white who={[%.n p=~.foo]}]]
          [p=/ted q=[mod=%white who={[%.n p=~.foo]}]]
        }
      ]
    ]
  }
]
```
