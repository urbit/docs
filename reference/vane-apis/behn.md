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

This `task` returns `[moves state]`.


### `%vega`

This `task` informs the vane that the kernel has been upgraded. Behn does not do
anything in response to this.

#### Accepts

This `task` has no arguments.

#### Returns

This `task` returns `[moves state]`.



### `%wait`

This `task` takes in a `@da` which Behn then adds to `timers.state`, the list of timers.

#### Accepts

```hoon
@da
```
 
#### Returns

This `task` returns nothing.



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



