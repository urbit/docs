+++
title = "Behn"
weight = 2
template = "doc.html"
+++

# Behn

In this document we describe the public interface for Behn. Namely, we describe
each `task` that Behn can be `pass`ed, and which `gift`(s) Behn can `give` in return.


## Tasks

### `%born`

Each time you start your Urbit, the Arvo kernel calls the `%born` task for Behn. When
called, Behn gets the current time from Unix and updates its list of timers
accordingly.

#### Accepts

```hoon
[~]
```

#### Returns

`%born` does not return a `gift`.

#### Source
```hoon
::  +born: urbit restarted; refresh :next-wake and store wakeup timer duct
  ::
  ++  born  set-unix-wake(next-wake.state ~, unix-duct.state duct)
```


### `%crud`

`%crud` is called whenever an error involving Behn occurs, which for now means
that Behn has no timers in its state.

When called, it checks to see if the set of timers is empty. If so, it prints
and error report containing `error`, otherwise it passes the error to `+wake`.

Behn should be the first vane to be activated in a `%wake`. Occasionally this does not
happen, but we do not yet handle this error.

#### Accepts

```hoon
[tag=@tas error=tang]
```
Here, `tag` is a `@tas` denoting the type of error, and `error` is an error message.

#### Returns

If the set of timers is nonempty when Behn is `%pass`ed a `%crud` `task`, Behn
`%give`s a `%wake` `card` to itself.

```hoon
[%wake %behn-crud-no-timer tag error]
```
 

#### Source
```hoon
++  crud
    |=  [tag=@tas error=tang]
    ^+  [moves state]
    ::  behn must get activated before other vanes in a %wake
    ::
    ::    TODO: uncomment this case after switching %crud tags
    ::
    ::    We don't know how to handle other errors, so relay them to %dill
    ::    to be printed and don't treat them as timer failures.
    ::
    ::  ?.  =(%wake tag)
    ::    ~&  %behn-crud-not-first-activation^tag
    ::    [[duct %slip %d %flog %crud tag error]~ state]
    ::
    ?:  =(~ timers.state)  ~|  %behn-crud-no-timer^tag^error  !!
    ::
    (wake `error)
 ```
 

### `%drip`

`%drip` is utilized to delay `%give`ing a `gift`.

`%drip` allows one to delay `gift`s until a given condition is met. For example,
if Clay crashes and you do not wish for an app to then crash when it tries to
access Clay before it is restarted, `%drip` can delay that access until Clay has
been restored. 

`%drip` only handles `gift`s, and can only schedule `gift`s for as soon as
possible after the prescribed condition is met.

#### Accepts

```hoon
mov=vase
```

`%drip` takes in a `%give` `move` in a `vase`.

#### Returns

In response to a `%drip` `task`, Behn will `%give` a `%meta` `gift` containing
the `gift` originally `%give`n to Behn when `%drip` was first called.

Is that really correct? It looks like the gift returned is actually a response to
a pass it passed itself, not the original event?

#### Source

```hoon
  ::  +drip:  XX
  ::
  ++  drip
    |=  mov=vase
    =<  [moves state]
    ^+  event-core
    =.  moves
      [duct %pass /drip/(scot %ud count.drips.state) %b %wait +(now)]~
    =.  movs.drips.state
      (~(put by movs.drips.state) count.drips.state mov)
    =.  count.drips.state  +(count.drips.state)
    event-core
```



### `%huck`

Immediately gives back an input move.

#### Accepts

```hoon
mov=vase
```

Behn takes in a `move` contained in a `vase`.

#### Returns

```hoon
[%give %meta mov]
```

Behn returns the input `move` as a `%meta` `gift`.

#### Source

```hoon
  ::  +huck: give back immediately
  ::
  ::    Useful if you want to continue working after other moves finish.
  ::
  ++  huck
    |=  mov=vase
    =<  [moves state]
    event-core(moves [duct %give %meta mov]~)
```



### `%rest`

Cancels a timer that was previously set.

Behn takes in a `@da` and cancels the timer at that time if it exists, then
adjusts the next wakeup call from Unix if necessary.

#### Task

```hoon
@da
```


#### Gift

This `task` returns no `gift`s.


#### Source

```hoon
::  +rest: cancel the timer at :date, then adjust unix wakeup
++  rest  |=(date=@da set-unix-wake(timers.state (unset-timer [date duct])))
```



### `%trim`

This `task` is sent by the interpreter in order to free up memory.
 This `task` is empty for Behn, since it is not a good idea to forget your timers.

#### Accepts

This `task` has no arguments. 

#### Returns

This `task` returns `[moves state]`.

#### Source

```hoon
  ::  +trim: in response to memory pressue
  ::
  ++  trim  [moves state]
```



### `%vega`

This `task` informs the vane that the kernel has been upgraded. Behn does not do
anything in response to this.

#### Accepts

This `task` has no arguments.

#### Returns

This `task` returns `[moves state]`.

#### Source

```hoon
  ::  +vega: learn of a kernel upgrade
  ::
  ++  vega  [moves state]
```



### `%wait`

This `task` takes in a `@da` which Behn then adds to `timers.state`, the list of timers.

#### Accepts

```hoon
@da
```
 
#### Returns

This `task` returns nothing.

#### Source

```hoon
::  +wait: set a new timer at :date, then adjust unix wakeup
++  wait  |=(date=@da set-unix-wake(timers.state (set-timer [date duct])))
```



### `%wake`

This `task` is sent by the kernel when the Unix timer tells the kernel that it
is time for Behn to wake up. This is often caused by a `%doze` `gift` that
Behn originally sent to the kernel that is then forwarded to Unix, which is
where the real timekeeping occurs. 

Upon receiving this `task`, Behn processes the elapsed timer and then sets
`:next-wake`.

`%wake` is also a `gift` that Behn can `%give`. This is done to inform other
vanes or apps that a timer has expired, and may include an error message.

#### Accepts

As a `task`, `%wake` takes in `~`.

As a `gift`, `%wake` may include an error message.

```hoon
error=(unit tang)
```


#### Returns

In response to receiving this `task`, Behn may `%give` a `%doze` `gift`
containing the `@da` of the next timer to elapse. Behn may also `%give` a
`%wake` `gift` to itself.

#### Source

```hoon
  ::  +wake: unix says wake up; process the elapsed timer and set :next-wake
  ::
  ++  wake
    |=  error=(unit tang)
    ^+  [moves state]
    ::  no-op on spurious but innocuous unix wakeups
    ::
    ?~  timers.state
      ~?  ?=(^ error)  %behn-wake-no-timer^u.error
      [moves state]
    ::  if we errored, pop the timer and notify the client vane of the error
    ::
    ?^  error
      =<  set-unix-wake
      (emit-vane-wake(timers.state t.timers.state) duct.i.timers.state error)
    ::  if unix woke us too early, retry by resetting the unix wakeup timer
    ::
    ?:  (gth date.i.timers.state now)
      set-unix-wake(next-wake.state ~)
    ::  pop first timer, tell vane it has elapsed, and adjust next unix wakeup
    ::
    =<  set-unix-wake
    (emit-vane-wake(timers.state t.timers.state) duct.i.timers.state ~)

```



### `%wegh`

This `task` asks Behn to product a memory usage report.

#### Accepts

This `task` has no arguments.

#### Returns

```hoon
:_  state  :_  ~
    :^  duct  %give  %mass
    :+  %behn  %|
    :~  timers+&+timers.state
        dot+&+state
```

When Behn is `%pass`ed this `task`, it will `%give` a `%mass` `gift` in response
containing Behn's current memory usage.

#### Source

```hoon
  ::  +wegh: produce memory usage report for |mass
  ::
  ++  wegh
    ^+  [moves state]
    :_  state  :_  ~
    :^  duct  %give  %mass
    :+  %behn  %|
    :~  timers+&+timers.state
        dot+&+state
    ==
```



