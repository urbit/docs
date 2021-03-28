+++
title = "Take Fact"
weight = 6
template = "doc.html"
+++

Taking a fact from an agent, arvo or whatever is easy. First you subscribe using `watch:strandio` or `watch-our:strandio`, then you use `take-fact:strandio` to receive the fact. Here's an example that takes an update from `graph-store` and prints the message to the dojo:

#### print-msg.hoon

```hoon
/-  spider
/+  *strandio, *graph-store
=,  strand=strand:spider
=>
|%
++  take-update
  =/  m  (strand ,~)
  ^-  form:m
  ;<  =cage  bind:m  (take-fact /graph-store)
  =/  =update  !<  update  q.cage
  ?.  ?=(%add-nodes -.q.update)
    (pure:m ~)
  =/  nodes=(list [=index =node])  ~(tap by nodes.q.update)
  ?~  nodes
    (pure:m ~)
  =/  contents=(list content)  contents.post.node.i.nodes
  ?~  contents
    (pure:m ~)
  ?.  ?=(%text -.i.contents)
    (pure:m ~)
  =/  msg  (trip text.i.contents)
  %-  (slog leaf+msg ~)
  (pure:m ~)
--
^-  thread:spider
|=  arg=vase
=/  m  (strand ,vase)
^-  form:m
;<  ~        bind:m  (watch-our /graph-store %graph-store /updates)
;<  ~        bind:m  take-update
(pure:m !>(~))
```

Create a chat on your fake zod if you don't have one already, then save it in `/ted`, `|commit %home`, and run `-print-msg`. Next, type some message in your chat and you'll see it printed in the dojo.

## Analysis

First we call `watch-our` to subscribe:

```hoon
;<  ~        bind:m  (watch-our /graph-store %graph-store /updates)
```

We've spun the next part out into its own core, but it's just a `take-fact` to receive the update:

```hoon
  ;<  =cage  bind:m  (take-fact /graph-store)
```

The rest of the code is just to pull the message out of the complicate data structure returned by graph-store and isn't important.

Spider will automatically leave the subscription once the thread finishes.

Note that `take-fact` only takes a single fact, so you'd need one for each message you're expecting. Alternatively you can use `main-loop` to take an arbitrary number of facts.
