+++
title = "Jael Public API"
weight = 5
template = "doc.html"
+++

# Jael

In this document we describe the public interface for Jael.  Namely, we describe
each `task` that Jael can be `%pass`ed, and which `gift`(s) Jael can `%give` in return.


## Tasks

### `%dawn`

This `task` is called only a single time per ship during the vane initialization
phase immediately following the beginning of the [adult
stage](@/docs/tutorials/arvo/arvo.md#structural-interface-core) to load Azimuth information such as private keys and the sponsor into
Jael. This `task` is `%pass`ed to Jael by Dill, as Dill is the first vane to be loaded for
technical reasons, though we consider Jael to be the true "first" vane.

#### Accepts

`%dawn` accepts a `dawn-event`:

```hoon
    +$  dawn-event
      $:  =seed
          spon=(list [=ship point:azimuth-types])
          czar=(map ship [=rift =life =pass])
          turf=(list turf)
          bloq=@ud
          node=(unit purl:eyre)
      ==
```

The `seed` is `[who=ship lyf=life key=ring sig=(unit oath:pki)]`. `who` is the
`@p` of the ship running the `task`, `lyf` is the current ship key revision, `key`


`spon` is a list (why?) of sponsors for the ship, `czar` is a map of ships you
know to their rift, life, and public key? 

`turf` is a `(list @t)` "::  domain, tld first" ?? something to do with DNS?

#### Returns


### `%fake`

#### Accepts

```hoon
[=ship]
```

#### Returns


### `%listen`

set ethereum source?

#### Accepts

```hoon
[whos=(set ship) =source]
```

A `$source` is `(each ship term)`.

```
++  each
  |$  [this that]
  ::    either {a} or {b}, defaulting to {a}.
  ::
  ::  mold generator: produces a discriminated fork between two types,
  ::  defaulting to {a}.
  ::
  $%  [%| p=that]
      [%& p=this]
  ==
```
`term=@tas`


#### Returns


### `%meet`

This `task` is a placeholder that currently does nothing.

#### Accepts

```hoon
[=ship =life =pass]
```

#### Returns

This `task` returns no `gift`s.


### `%moon`

#### Accepts

```hoon
[=ship =udiff:point]
```

#### Returns


### `%nuke`

#### Accepts

```hoon
[whos=(set ship)]
```

#### Returns


### `%plea`

#### Accepts

```hoon
[=ship =plea:ames]
```

#### Returns


### `%private-keys`

#### Accepts

```hoon
[~]
```

#### Returns


### `%public-keys`

#### Accepts

```hoon
[ships=(set ship)]
```

#### Returns


### `%rekey`

This `task` updates the ship's private keys.

#### Accepts

```hoon
[=life =ring]
```

`life` is a `@ud` that is the new ship key revision number. `ring` is an `@` that is the new private key.

#### Returns

```hoon
[%private-keys =life vein=(map life ring)]
```

In response to a `%rekey` `task`, Jael `%give`s a `%private-keys` `gift`. `life`
is the new `life` given in the original `task`, and `vein` is a `map` from
`life`s to `ring`s that keeps track of all `life`-`ring` pairs throughout the
history of the ship.


### `%trim`

This `task` is sent by the interpreter in order to free up memory.
 This `task` is empty for Jael, since it is not a good idea to forget your
 private keys and other cryptographic data.

#### Accepts

```hoon
[p=@ud]
```
This argument is unused by Jael.

#### Returns

This task returns nothing.



### `%turf`

#### Accepts

```hoon
[~]
```

#### Returns


### `%vega`

`%vega` is called whenever the kernel is updated. Jael currently does not do
anything in response to this.

#### Accepts

`%vega` takes no arguments.

#### Returns

This `task` returns no `gift`s.



### `%wegh`

This `task` is a request to Jael to produce a memory usage report.

#### Accepts

This `task` has no arguments.

#### Returns

In response to this `task,` Jael `%give`s a `%mass` `gift` containing Ames'
current memory usage.
