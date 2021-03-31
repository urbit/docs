+++
title = "Main-loop"
weight = 3
template = "doc.html"
+++

`main-loop` is a useful function included in `strandio` that:

1. lets you create a loop
2. lets you try the same input against multiple functions
3. queues input on `%skip` and then dequeues from the beginning on `%done`

`main-loop` takes a list of functions as its argument but only moves to the next item in the list on a `[%fail %ignore ~]` (whose usage we'll describe in the second example). In other cases it restarts from the top, so providing multiple functions is only useful for trying the same input against multiple functions.

## Create a loop

This is useful if you want to (for example) take an arbitrary number of facts.

Here's an example of a thread that subscribes to `graph-store` for updates and nicely prints the messages (an extremely basic chat reader):

#### chat-watch.hoon

```hoon
/-  spider
/+  *strandio, *graph-store
=,  strand=strand:spider
=>
|%
++  watcher
  =/  m  (strand ,~)
  ^-  form:m
  %-  (main-loop ,~)
  :~  |=  ~
      ^-  form:m
      ;<  =cage  bind:m  (take-fact /graph-store)
      =/  up=update  !<  update  q.cage
      ?.  ?=(%add-nodes -.q.up)
        (pure:m ~)
      =/  res=tape  "{(scow %p entity.resource.q.up)}/{(scow %tas name.resource.q.up)}"
      =/  node-list  `(list (pair index node))`~(tap by nodes.q.up)
      ?~  node-list
        (pure:m ~)
      ?:  (gth (lent node-list) 1)
        %-  (slog leaf+"{res}: <multi-node update skipped>" ~)
        (pure:m ~)
      =/  from=tape  (scow %p author.post.q.i.node-list)
      =/  conts  `(list content)`contents.post.q.i.node-list
      ?~  conts
        (pure:m ~)
      ?:  (gth (lent conts) 1)
        %-  (slog leaf+"{res}: [{from}] <mixed-type message skipped>" ~)
        (pure:m ~)
      ?.  ?=(%text -.i.conts)
        %-  (slog leaf+"{res}: [{from}] <non-text message skipped>" ~)
        (pure:m ~)
      =/  msg=tape  (trip text.i.conts)
      %-  (slog leaf+"{res}: [{from}] {msg}" ~)
      (pure:m ~)
  ==
--
^-  thread:spider
|=  arg=vase
=/  m  (strand ,vase)
^-  form:m
;<  now=@da  bind:m  get-time
;<  ~        bind:m  (watch-our /graph-store %graph-store /updates)
;<  ~        bind:m  watcher
(pure:m !>(~))
```

Save it in `/ted`, `|commit %home`, and run it with `-chat-watch`. Now try typing some messages in the chat and you should see them printed like:

```
~zod/test-8488: [~zod] x
~zod/test-8488: [~zod] blah blah blah
~zod/test-8488: [~zod] foo
~zod/test-8488: [~zod] some text
~zod/test-8488: [~zod] .
```

To stop this hit backspace and then run `:spider|kill`.

First we subscribe to graph-store for updates with `watch-our`, then we call the watcher arm of the core we have added. Watcher just calls `main-loop`:

```hoon
=/  m  (strand ,~)
^-  form:m
%-  (main-loop ,~)
...
```

...with a list of functions. In this case we've just given it one. Our function first calls `take-fact`:

```hoon
;<  =cage  bind:m  (take-fact /graph-store)
```

...to receive the fact and then the rest is just processing & printing logic which isn't too important.

Once this is done, main-loop will just call the same function again which will again wait for a fact and so on. So you see how it creates a loop. The only way to exit the loop is with a `%fail` or else by poking spider with a `%spider-stop` and the thread's `tid`.

## Try input against multiple functions

To try the same input against multiple function you must use another `strandio` function `handle`. Handle converts a `%skip` into a `[fail %ignore ~]`. When `main-loop` sees a `[fail %ignore ~]` it tries the next function in its list with the same input.

Here are two files: `tester.hoon` and `tested.hoon`. Save them both to `/ted`, `|commit %home` and run `-tester`. You should see:

```
> -tester
baz
~
```

#### tester.hoon

```hoon
/-  spider
/+  *strandio
=,  strand=strand:spider
^-  thread:spider 
|=  arg=vase 
=/  m  (strand ,vase) 
^-  form:m
;<  tid=tid:spider   bind:m  (start-thread %tested)
;<  our=ship         bind:m  get-our
;<  ~                bind:m  %-  poke
                             :-  [our %spider]
                             [%spider-input !>([tid `cage`[%baz !>("baz")]])]
(pure:m !>(~))
```

#### tested.hoon

```hoon
/-  spider
/+  *strandio
=,  strand=strand:spider
=>
|%
++  looper
  =/  m  (strand ,~)
  ^-  form:m
  %-  (main-loop ,~)
  :~  |=  ~
      ^-  form:m
      ;<  =vase  bind:m  ((handle ,vase) (take-poke %foo))
      =/  msg=tape  !<(tape vase)
      %-  (slog leaf+"{msg}" ~)
      (pure:m ~)
  ::
      |=  ~
      ^-  form:m
      ;<  =vase  bind:m  ((handle ,vase) (take-poke %bar))
      =/  msg=tape  !<(tape vase)
      %-  (slog leaf+"{msg}" ~)
      (pure:m ~)
  ::
      |=  ~
      ^-  form:m
      ;<  =vase  bind:m  ((handle ,vase) (take-poke %baz))
      =/  msg=tape  !<(tape vase)
      %-  (slog leaf+"{msg}" ~)
      (pure:m ~)
  ==
--
^-  thread:spider 
|=  arg=vase
=/  m  (strand ,vase) 
^-  form:m
;<  ~  bind:m  looper
(pure:m !>(~))
```

The first thread (tester.hoon) just starts the second thread and pokes it with a vase containing `"baz"` and the mark `%baz`.

The second thread (tested.hoon) has a `main-loop` with a list of three `take-poke` strands. As you can see it's the third one expecting a mark of `%baz` but yet it still successfully prints the message. This is because it tried the previous two which each saw the wrong mark and said `%skip`.

Notice we've wrapped the `take-poke`s in `handle` to convert the `%skip`s into `[%fail %ignore ~]`s, which `main-loop` takes to mean it should try the next function with the same input.
