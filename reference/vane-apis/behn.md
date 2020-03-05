+++
title = "Behn"
weight = 2
template = "doc.html"
+++

# Behn

In this document we describe the public interface for Behn. Namely, we describe
each `task` that Behn can be `pass`ed, and which `gift`(s) Behn can `give` in return.


## Tasks

### %born

Each time you start your Urbit, the Arvo kernel calls the `%born` task for Behn.

#### Task

`%born` is a [vane-task](@/docs/references/vane-apis/common-tasks.md) that takes
in an empty card `[~]`. When
called, Behn gets the current time from Unix and updates its list of timers
accordingly.

#### Gift

`%born` does not return a `gift`.

#### Source
```hoon
::  +born: urbit restarted; refresh :next-wake and store wakeup timer duct
  ::
  ++  born  set-unix-wake(next-wake.state ~, unix-duct.state duct)
```


### %crud

`%crud` is called whenever an error involving Behn occurs, which for now means
that it appears that Behn has no timers in its state. It takes in an error
report and either returns that error report with additional information, or
calls the `+wake` `task` with the error report as an argument.

#### Task

`%crud` is a [vane-task](@/docs/references/vane-apis/common-tasks.md) that takes
in a card `[tag=@tas error=tang]`. Here, `tag` is a `@tas` denoting the
type of error, and `error` is an error message. When
called, it checks to see if the set of timers is empty. If so, it returns an
error report containing `error`, otherwise it passes the error to `+wake`.

Behn should be the first vane to be activated in a `%wake`. Occasionally this does not
happen, but we do not yet handle this error.

#### Gift
 
If the set of timers is empty when Behn is `%pass`ed a `%crud` `task`, Behn `%give`s a `%wake` `card` given by
`[%behn-crud-no-timer tag error]`.

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
 

### %drip

`%drip` is utilized for event scheduling to ensure that they occur in the proper
order.

#### Task

`%drip` allows one to delay `gift`s until a given condition is met. For example,
if Clay crashes and you do not wish for an app to then crash when it tries to
access Clay before it is restarted, `%drip` can delay that access until Clay has
been restored. 

`%drip` only handles `gift`s, and can only schedule `gift`s for as soon as
possible after the prescribed condition is met.

`%drip` takes in a `%give` `move` in a `vase`.

#### Gift

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



### %huck

Gives back an input move.

#### Task

Behn takes in a `move` contained in a `vase`.

#### Gift

Behn returns the input `move` as a `%meta` `gift`.

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



### %rest

Cancels a timer.

#### Task

Behn takes in a `@da` and cancels the timer at that time if it exists, then
adjusts the next wakeup call from Unix if necessary.

#### Gift

This `task` returns no `gift`s.

```hoon
::  +rest: cancel the timer at :date, then adjust unix wakeup
++  rest  |=(date=@da set-unix-wake(timers.state (unset-timer [date duct])))
```



### %trim

This `task` is sent by the interpreter in order to free up memory.

#### Task

This `task` is empty, since it is not a good idea to forget your timers.

#### Gift

This `task` returns no `gift`s.

#### Source

```hoon
  ::  +trim: in response to memory pressue
  ::
  ++  trim  [moves state]
```



### %vega

This `task` informs the vane that the kernel has been upgraded.

#### Task

This `task` has no arguments, and Behn does not do anything in response to a kernel upgrade.

#### Gift

This `task` returns no `gift`s.

#### Source

```hoon
  ::  +vega: learn of a kernel upgrade
  ::
  ++  vega  [moves state]
```



### %wait

This `task` instructs Behn to start a new timer.

#### Task

This `task` takes in a `@da` which Behn then adds to `timers.state`.
 
#### Gift

This `task` produces no `gift`s.


```hoon
::  +wait: set a new timer at :date, then adjust unix wakeup
++  wait  |=(date=@da set-unix-wake(timers.state (set-timer [date duct])))
```



### %wake

This `task` is sent by the kernel when the Unix timer tells the kernel that it
is time for Behn to wake up. It is also called by Behn to emit an error message.

#### Task

Upon receiving this `task`, Behn processes the elapsed timer and then sets
`:next-wake`.

#### Gift

In response to receiving this `task`, Behn may `%give` a `%doze` `gift`
containing the `@da` of the next timer to elapse. Behn may also `%give` a
`%wake` `gift` to itself.


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



### %wegh

This `task` asks Behn to product a memory usage report.

#### Task

This `task` has no input arguments.

#### Gift

When Behn is `%pass`ed this `task`, it will `%give` a `%mass` `gift` in response
containing Behn's current memory usage.


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

