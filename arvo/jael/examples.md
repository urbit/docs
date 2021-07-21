+++
title = "Examples"
weight = 5
template = "doc.html"
+++

This documents contains practical examples of a number of Jael's `task`s.

General documentation of the `task`s demonstrated here can be found in the [API Reference](@/docs/arvo/jael/tasks.md) document, and details of the data types mentioned can be found in the [Data Types](@/docs/arvo/jael/data-types.md) document.

# Contents

- [%private-keys](#private-keys)
- [%public-keys and %nuke](#public-keys-and-nuke)
- [%turf](#turf)
- [%step](#step)

# `%private-keys`

Here we'll look at subscribing to private key updates from Jael. We'll use a thread to pass Jael a `%private-keys` `task`, take the `%private-keys` `gift` it returns, debug print it to the terminal and finally unsubscribe with a `%nuke` `task`.

`sub-priv.hoon`

```hoon
/-  spider
/+  strandio
=,  strand=strand:spider
=,  card=card:agent:gall
^-  thread:spider
|=  arg=vase
=/  m  (strand ,vase)
^-  form:m
;<  ~  bind:m  (send-raw-card:strandio %pass /sub-priv %arvo %j %private-keys ~)
;<  res=[=wire =sign-arvo]  bind:m  take-sign-arvo:strandio
?>  ?=([%sub-priv ~] wire.res)
?>  ?=([%jael *] sign-arvo.res)
~&  +.sign-arvo.res
;<  ~  bind:m  (send-raw-card:strandio %pass /sub-priv %arvo %j %nuke ~) 
(pure:m !>(~))
```

Save the above thread in the `/ted` directory of your `%home` desk and `|commit %home`.

Now let's run the thread:

```
> -sub-priv
```

You should see the `%private-key` `gift` it returns in the Dojo:

```
[ %private-keys
  life=1
    vein
  { [ p=1
        q
      1.729.646.917.183.337.[...truncated for brevity]
    ]
  }
]
```

At this point our thread unsubscribes again with a `%nuke` `task` but without that it would send a new `%private-key` `gift` each time the private keys were changed.

# `%public-keys` and `%nuke`

Here we'll look at both subscribing and unsubscribing to updates of a ship's public keys in Jael. We'll subscribe by sending Jael a `%public-keys` `task`, take the `%public-keys` `gift` it responds with, print it to the terminal, scry for the `set` of `duct`s subscribed to the ship in question, print them to the terminal, and finally send Jael a `%nuke` `task` to unsubscribe.

Here's a thread that performs these actions:

`sub-pub.hoon`

```hoon
/-  spider
/+  strandio
=,  strand=strand:spider
=,  card=card:agent:gall
=>
|%
+$  subs 
  $:  yen=(jug duct ship)
      ney=(jug ship duct)
      nel=(set duct)
  ==
--
^-  thread:spider
|=  arg=vase
=/  m  (strand ,vase)
^-  form:m
=/  =@p  (need !<((unit @p) arg))
::
::  sub to public updates for specified ship
=/  c1=card  [%pass /sub-pubkeys %arvo %j %public-keys (silt ~[p])]
;<  ~  bind:m  (send-raw-card:strandio c1)
::
::  take response from jael & print it
;<  res=[=wire =sign-arvo]  bind:m  take-sign-arvo:strandio
?>  ?=([%sub-pubkeys ~] wire.res)
?>  ?=([%jael %public-keys *] sign-arvo.res)
~&  +.sign-arvo.res
::
::  scry for tracking subs for specified ship in jael & print
;<  =subs  bind:m  (scry:strandio ,subs /j/subscriptions/1)
=/  ducts=(set duct)  (~(get ju ney.subs) p)
~&  ducts
::
::  unsub from public updates for specified ships
=/  c2=card  [%pass /sub-pubkeys %arvo %j %nuke (silt ~[p])]
;<  ~  bind:m  (send-raw-card:strandio c2)
(pure:m !>(~))
```

Note this example was performed on a comet as a fake ship won't have the required information in Jael.

Save the above thread in the `/ted` directory and `|commit %home`. The thread takes a `ship` as an argument, so we'll try to subscribe to pubkey updates for `~dopzod`. Let's run the thread:

```
> -sub-pub ~dopzod
```

It first passes a `%public-keys` `task` to Jael that looks like `[%public-keys (silt ~[~dopzod])]` in order to subscribe. Jael will immediately respond with a `%public-keys` `gift` that contains a `%full` [$public-keys-result](@/docs/arvo/jael/data-types.md#public-keys-result). The `(map ship point)` contained will (for each ship specified in the `task`) include the current pubkeys for the ship's current life as well as previous keys for previous `life`s. It thus contains a complete record of keys up to the present for each ship. Our thread will print these out to the terminal like so:

```
[ %public-keys
    public-keys-result
  [ %full
      points
    { [ p=~dopzod
          q
        [ rift=2
          life=3
            keys
          { [ p=1
                q
              [ crypto-suite=1
                  pass
                939.529.329.928[...truncated for brevity...]
              ]
            ]
            [ p=2
                q
              [ crypto-suite=1
                  pass
                2.215.774.809.906.200.376.0[...truncated for brevity...]
              ]
            ]
            [ p=3
                q
              [ crypto-suite=1
                  pass
                707.070.568.606.374.[...truncated for brevity...]
              ]
            ]
          }
          sponsor=~
        ]
      ]
    }
  ]
]
```

Along with giving us the current information, Jael will also subscribe us to any future updates for the ships in question. Such updates will come as additional `%public-keys` `gift`s, but rather than a `%full` `public-keys-result`, they'll instead contain either a `%diff` or `%breach` `public-keys-result`, depending on what's happened to the ship in question. It's difficult to simulate such events for demonstrative purposes so an example is not included, but you can look at the [$public-keys-result](@/docs/arvo/jael/data-types.md#public-keys-result) to get an idea.

Jael maintains a `(jug duct ship)` and its reverse `(jug ship duct)` in its state to track subscriptions. If we do a [subscriptions](@/docs/arvo/jael/scry.md#subscriptions) scry and filter the result for `~dopzod`, we can see the duct of our thread has now been added to the `~dopzod` `set`. Our thread does this, and will output something like:

```
{~[/gall/use/spider/0w1.vGVi-/~sampel-palnet/thread/~.dojo_0v6.0hlak.dam1b.bcdou.ai7gq.19fi8/sub-pubkeys /dill //term/1]}
```

At this point our thread will send a `%nuke` `task` like `[%nuke (silt ~[~dopzod])]` to cancel our subscription. Jael doesn't respond to it, but now, with our thread having finished and exited, we can again scry & filter for subscriptions to `~dopzod`:

```
> =/(a .^([yen=(jug duct ship) ney=(jug ship duct) nel=(set duct)] %j /=subscriptions=/1) (~(get ju ney.a) ~dopzod))
~
```

As you can see the `set` is now empty, so we know the `%nuke` succeeded and Jael will no longer send us pubkey updates for `~dopzod`. One thing to note about `%nuke` is that it *must* come from the same `duct` as the original subscription. You can't unsubscribe another app, ship, thread or what have you, so if we'd tried `%nuke`ing the subscription from a separate thread it wouldn't have worked.

# `%turf`

Here we'll look at using a `%turf` `task` to get Jael's list of domains. Note on a fake ship the list will be empty, so you may with to run it on a comet or moon.

Here's a simple thread that'll pass Jael a `%turf` `task`, take the `%turf` `gift` it sends back and print it to the terminal:

`turf.hoon`

```hoon
/-  spider
/+  strandio
=,  strand=strand:spider
^-  thread:spider
|=  arg=vase
=/  m  (strand ,vase)
^-  form:m
=/  =task:jael  [%turf ~]
=/  =card:agent:gall  [%pass /get-domains %arvo %j task]
;<  ~  bind:m  (send-raw-card:strandio card)
;<  resp=[=wire =sign-arvo]  bind:m  take-sign-arvo:strandio
?>  ?=([%get-domains ~] wire.resp)
?>  ?=([%jael %turf *] sign-arvo.resp)
~&  +.sign-arvo.resp
(pure:m !>(~))
```

Save in in the `/ted` directory of your ship and `|commit %home`. Next, let's try running it:

```
> -turf
[%turf turf=~[<|org urbit|>]]
```

As you see, the `%turf` `gift` contains `urbit.org` as `~['org' 'urbit']`.

# `%step`

Here we'll look at changing the web login code with a `%step` task.

First, let's see the current `step` with a `%step` scry:

```
> .^(@ud %j /=step=/(scot %p our))
0
```

...and the current code with the `+code` generator:

```
> +code
lidlut-tabwed-pillex-ridrup
```

Now, let's pass Jael a `%step` task by using `|pass` in the dojo:

```
> |pass [%j %step ~]
```

Jael will `pass` Eyre a `%code-changed` `task:eyre` to let Eyre know the code's changed so you'll see a message from Eyre in the terminal:

```
eyre: code-changed: throwing away cookies and sessions
```

Now let's again scry for the `step` and see that it's been incremented:

```
> .^(@ud %j /=step=/(scot %p our))
1
```

And finally, let's again run `+code` and see there's now a new web login code:

```
> +code
raldev-topnul-mirnut-lablut
```
