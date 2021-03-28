+++
title = "Take Result"
weight = 2
template = "doc.html"
+++

Here we've added an extra card to subscribe for the result and a couple of lines in on-agent to test if it succeeded:

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
         %poke-ack
       ?~  p.sign
         %-  (slog leaf+"Thread started successfully" ~)
         `this
       %-  (slog leaf+"Thread failed to start" u.p.sign)
       `this
     ::
         %fact
       ?+    p.cage.sign  (on-agent:def wire sign)
           %thread-fail
         =/  err  !<  (pair term tang)  q.cage.sign
         %-  (slog leaf+"Thread failed: {(trip p.err)}" q.err)
         `this
           %thread-done
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

#### test-thread.hoon

```hoon
/-  spider 
=,  strand=strand:spider 
^-  thread:spider 
|=  arg=vase 
=/  m  (strand ,vase) 
^-  form:m
|=  strand-input:strand
?+    q.arg  [~ %fail %not-foo ~]
    %foo
  [~ %done arg]
==
```

Save these, `|commit` and then poke the app with `:thread-starter [%test-thread %foo]`. You should see:

```
Thread started successfully
Result: foo
```

Now try `:thread-starter [%test-thread %bar]`. You should see:

```
Thread started successfully
Thread failed: not-foo
```

## Analysis

In `on-poke` we've added an extra card *before* the `%spider-start` poke to subscribe for the result:

```hoon
[%pass /thread/[ta-now] %agent [our.bowl %spider] %watch /thread-result/[tid]]
```

If successful the thread will return a cage with a mark of `%thread-done` and a vase containing the result.

If the thread failed it will return a cage with a mark of `%thread-fail` and a vase containing `[term tang]` where `term` is an error message and `tang` is a traceback. In our case our thread fails with error `%not-foo` when its argument is not `%foo`.

Note that spider will automatically `%kick` us from the subscription after ending the thread and returning the result.

```hoon
  %fact
?+    p.cage.sign  (on-agent:def wire sign)
    %thread-fail
  =/  err  !<  (pair term tang)  q.cage.sign
  %-  (slog leaf+"Thread failed: {(trip p.err)}" q.err)
  `this
    %thread-done
  =/  res  (trip !<(term q.cage.sign))
  %-  (slog leaf+"Result: {res}" ~)
  `this
==
```

Here in on-agent we've added a test for `%thread-fail` or `%thread-done` and print the appropriate result.
