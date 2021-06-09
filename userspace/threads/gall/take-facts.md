+++
title = "Take Facts"
weight = 3
template = "doc.html"
+++

Most of the time you'll just want the final result like how we did previously. Sometimes, though, you might want to send out facts while the thread runs rather than just at the end.

Here we've added another card to subscribe for any facts sent by the thread and some small changes to `on-agent`:

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
        [%pass /thread/updates/[ta-now] %agent [our.bowl %spider] %watch /thread/[tid]/updates]
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
           %update
         =/  msg  !<  tape  q.cage.sign
         %-  (slog leaf+msg ~)
         `this
       ==
     ==
   ==
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--
```

We've also made some changes to the thread:

#### test-thread.hoon

```hoon
/-  spider 
/+  *strandio
=,  strand=strand:spider 
^-  thread:spider 
|=  arg=vase 
=/  m  (strand ,vase) 
^-  form:m
;<  =path   bind:m  take-watch
;<  ~       bind:m  (send-raw-card [%give %fact ~[path] %update !>("message 1")])
;<  ~       bind:m  %-  send-raw-cards
                    :~  [%give %fact ~[path] %update !>("message 2")]
                        [%give %fact ~[path] %update !>("message 3")]
                        [%give %fact ~[path] %update !>("message 4")]
                    ==
;<  ~       bind:m  (send-raw-card [%give %kick ~[path] ~])
|=  strand-input:strand
?+    q.arg  [~ %fail %not-foo ~]
    %foo
  [~ %done arg]
==
```

Save & `|commit`, then run `:thread-starter [%test-thread %foo]`. You should see:

```
Thread started successfully
message 1
message 2
message 3
message 4
Result: foo
```

Now try `:thread-starter [%test-thread %bar]`. You should see:

```
Thread started successfully
message 1
message 2
message 3
message 4
Thread failed: not-foo
```

## Analysis

In our agent's `on-poke` arm we've added another card to subscribe to `/thread/[tid]/updates`:

```hoon
[%pass /thread/updates/[ta-now] %agent [our.bowl %spider] %watch /thread/[tid]/updates]
```

**Note:** In practice you'll want to include some kind of tag in the wire so you can differentiate particular threads and subscriptions and test for it in `on-agent`.

Threads always send facts on `/thread/[tid]/some-path`. The thread itself will see the incoming subscription on `/some-path` though, not the full thing.

In the thread we've first added:

```hoon
;<  =path   bind:m  take-watch
```

...to take the subscription. Without something like this to handle the incoming `%watch`, spider will reject the subscription.

Then we've added:

```hoon
;<  ~       bind:m  (send-raw-card [%give %fact ~[path] %update !>("message 1")])
;<  ~       bind:m  %-  send-raw-cards
                    :~  [%give %fact ~[path] %update !>("message 2")]
                        [%give %fact ~[path] %update !>("message 3")]
                        [%give %fact ~[path] %update !>("message 4")]
                    ==
```

...to send some facts out to subscribers. Here we've used both `send-raw-card` and `send-raw-cards` to demonstrate both ways.

**Note:** in practice you'd probably want to send facts on a predetermined path and just test the path of the incoming subscription rather than just accepting anything.

Finally we've added:

```hoon
;<  ~       bind:m  (send-raw-card [%give %kick ~[path] ~])
```

...to kick subscribers. This is important because, unlike on `/thread-result`, spider will not automatically kick subscribers when the thread ends. You have to do it explicitly so your agent doesn't accumulate wires with repeated executions.

Back in our agent: In the `on-agent` arm we've added:

```hoon
  %update
=/  msg  !<  tape  q.cage.sign
%-  (slog leaf+msg ~)
`this
```

... to take the facts and print them.

One last thing: Notice how when we gave the thread an argument of `%bar` and made it fail, we still got the facts we sent. This is because such cards are sent immediately as the thread runs, they don't depend on the final result.
