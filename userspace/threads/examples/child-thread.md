+++
title = "Child Thread"
weight = 2
template = "doc.html"
+++

Here's a simple example of a thread that starts another thread: 

### parent.hoon

```hoon
/-  spider
/+  *strandio
=,  strand=strand:spider
^-  thread:spider 
|=  arg=vase 
=/  m  (strand ,vase) 
^-  form:m
;<  tid=tid:spider   bind:m  (start-thread %child)
(pure:m !>(~))
```

### child.hoon

```hoon
/-  spider
/+  *strandio
=,  strand=strand:spider
^-  thread:spider 
|=  arg=vase 
=/  m  (strand ,vase) 
^-  form:m
%-  (slog leaf+"foo" ~)
(pure:m !>(~))
```

Save `parent.hoon` and `child.hoon` in `/ted`, `|commit %home` and run `-parent`. You should see something like:

```
foo
> -parent
~
```

`parent.hoon` just uses the `strandio` function `start-thread` to start `child.hoon`, and `child.hoon` just prints `foo` to the dojo. Since we got `foo` we can tell the second thread did, in fact, run.

```hoon
;<  tid=tid:spider   bind:m  (start-thread %child)
```

See here how we gave `start-thread` the name of the thread to run. It returns the `tid` of the thread, which we could then use to poke it or whatever. 

`start-thread` handles creating the `tid` for the thread so is quite convenient.

Note that threads we start this way will be a child of the thread that started them, and so will be killed when the parent thread ends.

## Start thread and get its result

If we want to actually get the result of the thread we started, it's slightly more complicated:

### parent.hoon

```hoon
/-  spider
/+  *strandio
=,  strand=strand:spider
^-  thread:spider 
|=  arg=vase 
=/  m  (strand ,vase) 
^-  form:m
;<  =bowl:spider  bind:m  get-bowl
=/  tid  `@ta`(cat 3 'strand_' (scot %uv (sham %child eny.bowl)))
;<  ~             bind:m  (watch-our /awaiting/[tid] %spider /thread-result/[tid])
;<  ~             bind:m  %-  poke-our
                          :*  %spider
                              %spider-start
                              !>([`tid.bowl `tid %child !>(~)])
                          ==
;<  =cage         bind:m  (take-fact /awaiting/[tid])
;<  ~             bind:m  (take-kick /awaiting/[tid])
?+  p.cage  ~|([%strange-thread-result p.cage %child tid] !!)
  %thread-done  (pure:m q.cage)
  %thread-fail  (strand-fail !<([term tang] q.cage))
==
```

###  child.hoon

```hoon
/-  spider
/+  *strandio
=,  strand=strand:spider
=>
|%
++  url  "https://www.whatsthelatestbasehash.com/"
--
^-  thread:spider 
|=  arg=vase 
=/  m  (strand ,vase) 
^-  form:m
;<  =cord  bind:m  (fetch-cord url)
=/  hash-as-cord  `@t`(end [3 (sub (met 3 cord) 1)] cord)
=/  hash  `@uv`(slav %uv hash-as-cord)
(pure:m !>(hash))
```

`child.hoon` simply grabs the latest base hash from https://www.whatsthelatestbasehash.com/ and returns it. 

`parent.hoon` is a bit more complicated so we'll look at it line-by-line

```hoon
;<  =bowl:spider  bind:m  get-bowl
```

First we grab the bowl

```hoon
=/  tid  `@ta`(cat 3 'strand_' (scot %uv (sham %child eny.bowl)))
```

Then we generate a `tid` (thread ID) for the thread we're gonna start

```hoon
;<  ~             bind:m  (watch-our /awaiting/[tid] %spider /thread-result/[tid])
```

We pre-emptively subscribe for the result. Spider sends the result at `/thread-result/<tid>` so that's where we subscribe.

```hoon
;<  ~             bind:m  %-  poke-our
                          :*  %spider
                              %spider-start
                              !>([`tid.bowl `tid %child !>(~)])
                          ==
```

Spider takes a poke with a mark %spider-start and a vase containing `[parent=(unit tid) use=(unit tid) file=term =vase]` to start a thread, where:

* `parent` is an optional parent thread. In this case we say the parent is our tid. Specifying a parent means the child will be killed if the parent ends.
* `use` is the thread ID for the thread we're creating
* `file` is the filename of the thread we want to start
* `vase` is the vase it will be given as an argument when it's started

```hoon
;<  =cage         bind:m  (take-fact /awaiting/[tid])
```

We wait for a fact which will be the result of the thread.

```hoon
;<  ~             bind:m  (take-kick /awaiting/[tid])
```

Spider will kick us from the subscription when it ends the thread so we also take that kick.

```hoon
?+  p.cage  ~|([%strange-thread-result p.cage %child tid] !!)
  %thread-done  (pure:m q.cage)
  %thread-fail  (strand-fail !<([term tang] q.cage))
==
```

Finally we test whether the thread produced a `%thread-done` or a `%thread-fail`. These are the two possible marks produced by spider when it returns the results of a thread. A `%thread-done` will contain a vase with the result, and a `%thread-fail` will contain an error message and traceback, so we see which it is and then either produce the result with `pure` or trigger a `%thread-fail` with the error we got from the child.

## Stop a thread

### parent.hoon

```hoon
/-  spider
/+  *strandio
=,  strand=strand:spider
^-  thread:spider 
|=  arg=vase 
=/  m  (strand ,vase) 
^-  form:m
;<  =bowl:spider  bind:m  get-bowl
=/  tid  `@ta`(cat 3 'strand_' (scot %uv (sham %child eny.bowl)))
%-  (slog leaf+"Starting child thread..." ~)
;<  ~             bind:m  %-  poke-our
                          :*  %spider
                              %spider-start
                              !>([`tid.bowl `tid %child !>(~)])
                          ==
;<  ~             bind:m  (sleep ~s5)
%-  (slog leaf+"Stopping child thread..." ~)
;<  ~             bind:m  %-  poke-our
                          :*  %spider
                              %spider-stop
                              !>([tid %.y])
                          ==
;<  ~             bind:m  (sleep ~s2)
(pure:m !>("Done"))
```

### child.hoon

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
      ;<  ~  bind:m  (sleep `@dr`(div ~s1 2))
      %-  (slog leaf+"child thread" ~)
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

`child.hoon` just prints to the dojo in a loop.

`parent.hoon` starts `child.hoon`, and then pokes spider like:

```hoon
;<  ~             bind:m  %-  poke-our
                          :*  %spider
                              %spider-stop
                              !>([tid %.y])
                          ==
```

* `%spider-stop` is the mark that tells spider to kill a thread.
* `tid` is the tid of the thread to kill
* `%.y` tells spider to suppress traceback in the result of the killed thread. If you give it `%.n` it will include the traceback.
