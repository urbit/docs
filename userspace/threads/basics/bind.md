+++
title = "Bind"
weight = 2
template = "doc.html"
+++


Having looked at `form` and `pure`, we'll now look at the last `strand` arm `bind`. Bind is typically used in combination with micgal (`;<`).

## Micgal

Micgal takes four arguments like `spec hoon hoon hoon`. Given `;<  a  b  c  d`, it composes them like `((b ,a) c |=(a d))`. So, for example, these two expressions are equivalent:

```hoon
;<  ~  bind:m  (sleep:strandio ~s2)
(pure:m !>(~))
```

and

```hoon
((bind:m ,~) (sleep:strandio ~s2) |=(~ (pure:m !>(~))))
```

Micgal exists simply for readability. The above isn't too bad, but consider this:

```hoon
;<  a  b  c
;<  d  e  f
;<  g  h  i
j
```
...as opposed to this monstrosity: `((b ,a) c |=(a ((e ,d) f |=(d ((h ,g) i |=(g j))))))`

## bind

Bind by itself must be specialised like `(bind:m ,<type>)` and it takes two arguments:

- The first argument is a function that returns the `form` of a strand which produces `<type>`.
- The second argument is a gate whose sample is `<type>` and which returns a `form`.

Since you'll invariably use it in conjunction with micgal, the `<type>` in `;<  <type>  bind:m  ...` will both specialise `bind` and specify the gate's sample.

Bind calls the first function then, if it succeeded, calls the second gate with the result of the first as its sample. If the first function failed, it will instead just return an error message and not bother calling the next gate. So it's essentially "strand A then strand B".

Since the second gate may itself contain another `;<  <type>  bind:m  ...`, you can see how this allows you to glue together an arbitrarily large pipeline, where subsequent gates depend on the previous ones.

## strandio

`/lib/strandio/hoon` contains a large collection of useful, ready-made functions for use in threads. For example:

- `sleep` waits for the specified time.
- `get-time` gets the current time.
- `poke` pokes an agent.
- `watch` subscribes to an agent.
- `fetch-json` produces the JSON at a particular URL.
- `retry` tries a strand repeatedly with exponential backoff until it succeeds.
- `start-thread` starts another thread.
- `send-raw-card` sends any card.

...and many more.

## Putting it together

Here's a simple thread with a couple of `strandio` functions:

```hoon
/-  spider
/+  strandio
=,  strand=strand:spider 
^-  thread:spider 
|=  arg=vase 
=/  m  (strand ,vase) 
^-  form:m
;<  t=@da   bind:m  get-time:strandio
;<  s=ship  bind:m  get-our:strandio
(pure:m !>([s t]))
```

Save it as `/ted/mythread.hoon`, `|commit` it and run it with `-mythread`. You should see something like:

```
> -mythread
[~zod ~2021.3.8..14.52.15..bdfe]
```

## Analysis

To use `strandio` functions we've imported the library with `/+  strandio`.

`get-time` and `get-our` get the current time & ship from the bowl in `strand-input`. We'll discuss `strand-input` in more detail later.

Note how we've specified the face and return type of each strand like `t=@da`, etc. 

You can see how `pure` has access to the results of previous strands in the pipeline. Note how we've wrapped `pure`'s argument in a `!>` because the thread must produce a `vase`.

Next we'll look at `strand-input` in more detail.
