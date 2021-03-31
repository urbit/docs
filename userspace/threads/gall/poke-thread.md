+++
title = "Poke Thread"
weight = 5
template = "doc.html"
+++

Here's a modified agent that pokes our thread. I've replaced some off the previous stuff because it was getting a little unwieldly.

#### thread-starter.hoon

```hoon
/+  default-agent, dbug
=*  card  card:agent:gall
%-  agent:dbug
^-  agent:gall
|_  =bowl:gall
+*  this      .
    def   ~(. (default-agent this %|) bowl)
::
++  on-init  on-init:def
++  on-save  on-save:def
++  on-load  on-load:def
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?+    mark  (on-poke:def mark vase)
      %noun
    ?+    q.vase  (on-poke:def mark vase)
        (pair term term)
      =/  tid  `@ta`(cat 3 'thread_' (scot %uv (sham eny.bowl)))
      =/  ta-now  `@ta`(scot %da now.bowl)
      =/  start-args  [~ `tid p.q.vase !>(q.q.vase)]
      :_  this
      :~
        [%pass /thread/[ta-now] %agent [our.bowl %spider] %watch /thread-result/[tid]]
        [%pass /thread/[ta-now] %agent [our.bowl %spider] %poke %spider-start !>(start-args)]
        [%pass /thread/[ta-now] %agent [our.bowl %spider] %poke %spider-input !>([tid %foo !>(q.q.vase)])]
      ==
    ==
  ==
++  on-watch  on-watch:def
++  on-leave  on-leave:def
++  on-peek   on-peek:def
++  on-agent
   |=  [=wire =sign:agent:gall]
   ^-  (quip card _this)
   ?+    -.wire  (on-agent:def wire sign)
       %thread
     ?+    -.sign  (on-agent:def wire sign)
         %fact
       ?+    p.cage.sign  (on-agent:def wire sign)
           %thread-fail
         =/  err  !<  (pair term tang)  q.cage.sign
         %-  (slog leaf+"Thread failed: {(trip p.err)}" q.err)
         `this
           %thread-done
         ?:  =(q.cage.sign *vase)
           %-  (slog leaf+"Thread cancelled nicely" ~)
         `this
         =/  res  (trip !<(term q.cage.sign))
         %-  (slog leaf+"Result: {res}" ~)
         `this
       ==
     ==
   ==
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--
```

And here we've modified the thread to take the poke and return it as the result:

#### test-thread.hoon

```hoon
/-  spider 
/+  *strandio
=,  strand=strand:spider 
^-  thread:spider 
|=  arg=vase 
=/  m  (strand ,vase) 
^-  form:m
;<  vmsg=vase   bind:m  (take-poke %foo)
(pure:m vmsg)
```

Save them, `|commit` and run it like `:thread-starter [%test-thread %blah]`. You should see:


```
Result: blah
> :thread-starter [%test-thread %blah]
```

## Analysis

In our agent we've added this card:

```hoon
[%pass /thread/[ta-now] %agent [our.bowl %spider] %poke %spider-input !>([tid %foo !>(q.q.vase)])]
```

To poke a particular thread you poke `%spider` with a mark of `%spider-input` and a vase of `[tid cage]` where:

- `tid` is the thread you want to poke
- `cage` has whatever mark and vase of data you want to give the thread

In our case we've given it a mark of `%foo` and a vase of whatever `term` we poked our agent with.

In our thread we've added:

```hoon
;<  vmsg=vase   bind:m  (take-poke %foo)
```

`take-poke` is a `strandio` function that just waits for a poke with the given mark and skips everything else. In this case we've specified a mark of `%foo`. Once our thread gets a poke with this mark it returns it as a result with `(pure:m vmsg)`. When our agent gets that it just prints it.
