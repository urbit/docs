+++
title = "Start Thread"
weight = 1
template = "doc.html"
+++

Here's an example of a barebones gall agent that just starts a thread:

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
     ==
   ==
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--
```

And here's a minimal thread to test it with:

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

Save them as `/app/thread-starter.hoon` and `/ted/test-thread.hoon` respectively, `|commit %home`, and start the app with `|start %thread-starter`.

Now you can poke it with a pair of thread name and argument like:

```
:thread-starter [%test-thread %foo]
```

You should see `Thread started successfully`.

Now try poking it with `[%fake-thread %foo]`, you should see something like:

```
Thread failed to start
/app/spider/hoon:<[355 5].[355 60]>
[%no-file-for-thread %fake-thread]
/app/spider/hoon:<[354 5].[355 60]>
/app/spider/hoon:<[353 3].[359 19]>
/app/spider/hoon:<[350 3].[359 19]>
/app/spider/hoon:<[346 3].[359 19]>
/app/spider/hoon:<[343 3].[359 19]>
/app/spider/hoon:<[341 3].[359 19]>
/app/spider/hoon:<[340 3].[359 19]>
/app/spider/hoon:<[336 3].[359 19]>
/app/spider/hoon:<[335 3].[359 19]>
/app/spider/hoon:<[202 24].[202 68]>
/app/spider/hoon:<[200 7].[207 9]>
/app/spider/hoon:<[199 5].[208 17]>
/app/spider/hoon:<[197 5].[208 17]>
/app/spider/hoon:<[196 5].[208 17]>
/sys/vane/gall/hoon:<[1.370 9].[1.370 37]>
```

## Analysis

We can ignore the input logic, here's the important part:

```hoon
=/  tid  `@ta`(cat 3 'thread_' (scot %uv (sham eny.bowl)))
=/  ta-now  `@ta`(scot %da now.bowl)
=/  start-args  [~ `tid p.q.vase !>(q.q.vase)]
:_  this
:~
  [%pass /thread/[ta-now] %agent [our.bowl %spider] %poke %spider-start !>(start-args)]
==
```

You can generate a tid any way you like, just make sure it's unique. Here we just use the hash of some entropy prefixed with `thread_`.

Then it's just a poke to `%spider` with the mark `%spider-start` and a vase containing [start-args](../reference.md#start-thread). Spider will then respond with a `%poke-ack` with a `(unit tang)` which will be `~` if it started successfully or else contain an error and a traceback if it failed. Here we test for this and print the result:

```hoon
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
     ==
   ==
```
