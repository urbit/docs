+++
title = "Merge Desks"
weight = 9
template = "doc.html"
+++

Here we'll look at merging desks programmatically.

A `%merg` tagged `task:clay` will merge the specified source desk into the target local desk. It looks like:

```hoon
$:  %merg                       ::  merge desks
    des=desk                    ::  target
    her=@p  dem=desk  cas=case  ::  source
    how=germ                    ::  method
==                              ::
```

The `germ` specifies the merge strategy and looks like:

```hoon
+$  germ          ::  merge style
  $?  %init       ::  new desk
      %fine       ::  fast forward
      %meet       ::  orthogonal files
      %mate       ::  orthogonal changes
      %meld       ::  force merge
      %only-this  ::  ours with parents
      %only-that  ::  hers with parents
      %take-this  ::  ours unless absent
      %take-that  ::  hers unless absent
      %meet-this  ::  ours if conflict
      %meet-that  ::  hers if conflict
  ==                                                  ::
```

You can refer to the [Strategies](@/docs/arvo/clay/using.md#strategies) section of the [Using Clay](@/docs/arvo/clay/using.md) document for details of each `germ`.

If you're merging into a new desk you must use `%init`, all other strategies will fail. If the desk already exists, you cannot use `%init`. Otherwise, you're free to use whichever you'd like.

Clay will respond to the request with a `%mere` tagged `gift:clay` which looks like:

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

Example:

Here's a thread that sends the given `task:clay` to clay and prints the `gift:clay` response:

`send-task.hoon`

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

Save it to `ted/send-task.hoon` and `|commit %home`.

First, let's try creating a new desk:

```hoon
> -send-task-take-gift [%merg %foo our %home da+now %init]
[%mere p=[%.y p={}]]
```

Now if we scry for our desks we'll see `%foo` is there:

```hoon
> .^((set desk) %cd /===)
{%home %foo %kids}
```

Next, we'll create a merge conflict and try a couple of things. Mount `%foo` with `|mount /=foo=`, then add a `foo.txt` to both desks but with different text in each and `|commit` them.

Now we'll try merging `%home` into `%foo` with a `%mate` strategy:

```hoon
> -send-task-take-gift [%merg %foo our %home da+now %mate]
[ /foo
  [ %clay
    [ %mere
        p
      [ %.n
          p
        [ p=%mate-conflict
          q=~[[%rose p=[p="/" q="/" r=""] q=[i=[%leaf p="foo"] t=[i=[%leaf p="txt"] t=~]]]]
        ]
      ]
    ]
  ]
]
```

As you can see, the merge has failed. Let's try again with a `%meld` strategy:

```hoon
> -send-task-take-gift [%merg %foo our %home da+now %meld]
[/foo [%clay [%mere p=[%.y p={/foo/txt}]]]]
```

Now the merge has succeeded and the `%mere` notes the file with a merge conflict. If we try with a `%only-that` strategy:

```hoon
> -send-task-take-gift [%merg %foo our %home da+now %only-that]
[/foo [%clay [%mere p=[%.y p={}]]]]
: /~zod/foo/6/foo/txt
```

...you can see it's overwritten the `foo/txt` in the `%foo` desk and the `%mere` now has an empty set, indicating no merge conflicts.

Next, let's look at subscribing for future changes. Since the `case` is specified explicitly in the `%merge` task, we can set in in the future:

```hoon
> -send-task-take-gift [%merg %foo our %home da+(add ~m2 now) %only-that]
```

Now change the text in the `foo.txt` in the `%home` desk, hit backspace to detach the thread and `|commit %home`. After the two minutes pass you should see:

```hoon
[/foo [%clay [%mere p=[%.y p={}]]]]
: /~zod/foo/7/foo/txt
```

You can also specify it by revision number or label.
