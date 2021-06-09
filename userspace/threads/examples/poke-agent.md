+++
title = "Poke Agent"
weight = 4
template = "doc.html"
+++

Here's a thread that lets you post a message to a chat in graph-store:

#### post-msg.hoon

```hoon
/-  spider
/+  *strandio, *graph-store, *resource
=,  strand=strand:spider
=>
|%
++  make-post
  |=  [our=ship now=@da res=resource msg=@t]
  ^-  cage
  ::
  =/  =post  *post
  =:  author.post     our
      index.post      ~[now]
      time-sent.post  now
      contents.post   ~[[%text msg]]
  ==
  ::
  :-  %graph-update
  !>  ^-  update
  :+  %0  now
  :+  %add-nodes  res
  %-  ~(gas by *(map index node))
  ~[[~[now] [post ~[%empty]]]]
--
^-  thread:spider
|=  arg=vase
=/  m  (strand ,vase)
=/  uarg  !<  (unit (pair resource @t))  arg
?~  uarg
  (strand-fail %no-arg ~)
=/  res  p.u.uarg
=/  msg  q.u.uarg
^-  form:m
;<  our=@p   bind:m  get-our
;<  now=@da  bind:m  get-time
;<  ~        bind:m  (poke [our %graph-push-hook] (make-post our now res msg))
(pure:m !>(~))
```

Save it in `/ted`, `|commit`, and run it like:

```
-post-msg [~zod %foo-9955] 'some message'
```

(obviously change the channel name to whatever you have)

## Analysis

Pretty simple, just use `on-poke` with an argument of `[ship term] cage` where `term` is the agent and `cage` is whatever the particular agent expects.
