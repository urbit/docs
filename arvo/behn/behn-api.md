+++
title = "Behn"
weight = 3
template = "doc.html"
+++

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


### `%crud`

`%crud` is called whenever an error involving Behn occurs, such as trying to
`%wake` a program that has crashed.

When called, it checks to see if the set of timers is empty. If so, it prints
an error report containing `error`, otherwise it passes the error to `+wake`.

#### Accepts

```hoon
[tag=@tas error=tang]
```
Here, `tag` is a `@tas` denoting the type of error, and `error` is an error message.

#### Returns

```hoon
[%wake %behn-crud-no-timer tag error]
```

If the set of timers is nonempty when Behn is `%pass`ed a `%crud` `task`, Behn
`%give`s a `%wake` `card` containing the error to the next client in the set of timers.


#### Example

The most common error that occurs is when Behn tries to `%wake` up a program that has crashed. When this happens
the entire event (i.e. sequence of `move`s) that led up to the `%wake` is thrown
away, and Vere then causes the kernel to `pass` Behn a `%crud` `task` containing
the stack trace.


### `%drip`

`%drip` allows one to delay a `gift` until a timer set for `now` fires.

A Client `%slip`s Behn a `%drip` task wrapping a `gift` to be `give`n to a Target.
This launches a sequence of `move`s as written here:

```
Client -- %slip %drip --> Behn -- %pass %wait --> Behn -- %give %wake --> Behn -- %give %meta --> Target
```
Here the `%meta` `move` is a wrapper for the `%gift` inside of the initial `%drip` wrapper.

`%drip` only handles `gift`s, and can only schedule `gift`s for as soon as
possible after the prescribed timer fires.


#### Accepts

```hoon
mov=vase
```

`%drip` takes in a `%give` `move` in a `vase`.

#### Returns

In response to a `%drip` `task`, Behn will `%pass` a `%wait` to itself, which
then triggers a `%wake` `gift` to itself, which then causes Behn to `%give` a `%meta` `gift` containing
the `gift` originally `%give`n to Behn when `%drip` was first called. That makes
Behn its own client for `%drip`.

#### Example


Say an app (the Target) is subscribed to updates from Clay (the Client). If Clay `%give`s
updates to the app directly and the app crashes, this may cause Clay to crash as
well. If instead Clay `%pass`es Behn a `%drip` `task` wrapping the update
`gift`, Behn will set a timer for `now` that, when fired, will cause the update
`gift` to be given. If it causes a crash then it will have been in response to
the `%drip` move, thereby isolating Clay from the crash. Thus `%drip` acts as a sort of buffer against cascading
sequences of crashes.



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



### `%trim`

This `task` is sent by the interpreter in order to free up memory.
 This `task` is empty for Behn, since it is not a good idea to forget your timers.

#### Accepts

This `task` has no arguments.

#### Returns

This task returns nothing.

### `%vega`

This `task` informs the vane that the kernel has been upgraded. Behn does not do
anything in response to this.

#### Accepts

This `task` has no arguments.

#### Returns

This `task` returns nothing.



### `%wait`

This `task` takes in a `@da` which Behn then adds to `timers.state`, the list of timers.

#### Accepts

```hoon
@da
```

#### Returns

This `task` returns a `%wake` `gift` once the timer has fired.


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



