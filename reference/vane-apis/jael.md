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

This `task` is called once per ship during the vane initialization
phase immediately following the beginning of the [adult
stage](@/docs/tutorials/arvo/arvo.md#structural-interface-core). This `task` is `%pass`ed to Jael by Dill, as Dill is the first vane to be loaded for
technical reasons, though we consider Jael to be the true "first" vane. This
`task` is only used for ships that will join the Ames network - fake ships (i.e.
made with `./urbit -F zod`) use the `%fake` `task` instead.

`%dawn` is used to perform a sequence of initialization tasks related to saving
information about Azimuth and the Ames network and booting other vanes for the first time. Upon
receipt of a `%dawn` `task`, Jael will:
 - record the Ethereum block the public key is registered to,
 - record the URL of the Ethereum node used,
 - save the signature of the parent planet (if the ship is a moon)
 - load the initial public and private keys for the ship
 - set the DNS suffix(es) used by the network (currently just `arvo.network`)
 - save the public keys of all galaxies
 - set Jael to subscribe to `%azimuth-tracker`
 - `%slip` a `%init` `task` to Ames, Clay, Gall, Dill, and Eyre, and `%give` an `%init`
`gift` to Unix??. 

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
`@p` of the ship running the `task`, `lyf` is the current ship key revision,
`key` is the ship's private key, and `sig` is the signature of the ship's parent
planet if the ship is moon and `[~]` otherwise.

`spon` is a `list` of ships and their `point`s in the ship's sponsorship chain,
all the way to the galaxy level. `point:azimuth-types` contains all Azimuth
related data and can be found in `zuse.hoon`.

`czar` is a map from each galaxy's `@p` to its `rift`, `life`, and public key (`pass`).

`turf` is a `list` of DNS suffixes used by the Ames network, which for now is
just `arvo.network`. 

`bloq` is the number of the Ethereum block in which the ship registered its keys
with the Azimuth smart contract.

`node` is the URL of the Ethereum node used to register the ship's keys with Azimuth.

#### Returns

As mentioned above, this `task` `%slip`s `%init` `task`s to most other vanes and
`%give`s an `%init` `gift` to Unix.


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

This `task` cancels all trackers from a given set of ships.

#### Accepts

```hoon
[whos=(set ship)]
```
`whos` is the `set` of `ship`s for which trackers are to be canceled.

#### Returns

```hoon
[%done ~]
```

After a `%nuke` `task`, Jael `%give`s a `%done` `gift` in response. This is an acknowledgement that the task was completed successfully. 


### `%plea`

#### Accepts

```hoon
[=ship =plea:ames]
```

#### Returns


### `%private-keys`

This `task` creates a subscription to the private keys kept by Jael.

We note that there are two `+private-keys` arms in Jael - one located in the
`+feed` core and the other located in the `+feel` core. This `task` calls the
arm in the `+feed` core.

#### Accepts

```hoon
[~]
```

#### Returns

```hoon
[%private-keys =life vein=(map life ring)]
```

In response to a `%private-keys` `task`, Jael `%give`s a `%private-keys` `gift`.
`life=@ud` is the current `life` of the ship, and `vein` is a `map` from
`life`s to `ring`s that keeps track of all `life`-`ring` pairs throughout the
history of the ship.


### `%public-keys`

This `task` creates a subscription for the callee to a selection of the public keys kept by Jael.

#### Accepts

```hoon
[ships=(set ship)]
```
`ships` is the `set` of `ship`s whos' public keys are being subscribed to.

#### Returns

```hoon
[%public-keys =public-keys-result]
```


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
