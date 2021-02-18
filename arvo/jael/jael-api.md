+++
title = "Jael"
weight = 5
template = "doc.html"
+++

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
 - save the signature of the parent planet (if the ship is a moon),
 - load the initial public and private keys for the ship,
 - set the DNS suffix(es) used by the network (currently just `arvo.network`),
 - save the public keys of all galaxies,
 - set Jael to subscribe to `%azimuth-tracker`,
 - `%slip` a `%init` `task` to Ames, Clay, Gall, Dill, and Eyre, and `%give` an `%init`
`gift` to Arvo, which then informs Unix that the initialization process has concluded.

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

Jael `%give`s an `%init` `gift` to Unix. This occurs after the Dill `%slip`
init.

#### Slips

Jael `%slip`s `%init` `task`s to each of Eyre, Dill, Gall, Clay, and Ames, in
that order.


### `%fake`

This `task` is used instead of `%dawn` when creating a fake ship via the `-F`
flag when calling the Urbit binary. It performs a subset of the actions that
`%dawn` performs, modified to accommodate the fake ship.

`%fake` endows the ship with a private key and a public key deterministically derived from the
ship's `@p`. It sets `fak.own.pki` to `%.y`, which is the bit that determines
whether or not a ship is fake. Other parts of the Jael state, such as the
sponsorship chain and galaxy public keys are left at their bunted values.

#### Accepts

```hoon
[=ship]
```
`ship` is the `@p` of the fake ship being created.

#### Returns

Jael `%give`s a `%init` `gift` to Unix.

#### Slips

In response to a `%fake` `task`, Jael `%slip`s a `%init` `task` to each of Eyre, Dill, Gall,
Clay, and Ames, in that order.


### `%listen`

Sets the source that the public keys for a set of `ship`s should be obtained
from. This can either be a Gall app that communicates with an Ethereum node such
as `%azimuth-tracker`, as in the case for galaxies, stars,
and planets, or a ship, as in the case of a moon or comet.

After setting the source, Jael will then subscribe to the source for updates on
public keys for the given ships.


#### Accepts

```hoon
[whos=(set ship) =source]
```

`whos` is the set of ships whose key data source is to be altered. `source` is
`(each ship term)`, where `term` will ultimately be treated as a handle for a
Gall app.

A `%listen` `task` with empty `whos` will set the default source to `source`.
This is the source used for all ships unless otherwise specified.

When the `source` is a `term`, Jael looks into its state to find what source has
been previously assigned to that `term` and will henceforth obtain public keys for
ships in `(set ship)` from there. In practice, this is always
`%azimuth-tracker`, but the ability to use other sources is present.

When the `source` is a ship, Jael will obtain public keys for ships in `(set ship)` from
the given ship. By default, the `source` for a moon will be the planet that
spawned that moon, and the `source` for a comet will be the comet itself.

#### Returns

This `task` returns no `gift`s.

#### Passes

If the `source` is a `term`, Jael will `%pass` a `%deal` `task` to Gall asking to
`%watch` the app given by `source` at path `/`.

If the `source` is a `ship`, Jael will `%pass` a `%plea` `task` to Ames wrapping
a `%public-keys` `task` intended for Jael on the `ship` specified by `source`.


### `%meet`

This `task` is deprecated and does not perform any actions.

#### Accepts

```hoon
[=ship =life =pass]
```

#### Returns

This `task` returns no `gift`s.


### `%moon`

This `task` sets the public keys of a moon.

#### Accepts

```hoon
[=ship =udiff:point]
```

The `ship` is the `@p` of the moon. The `task` will be a no-op if the `@p` is not that
of a moon, or if the moon does not belong to the ship.

`udiff:point` contains the new public keys to be stored for the moon.

#### Returns

This `task` returns no `gift`s.


### `%nuke`

This `task` cancels subscriptions to Jael's state from a given set of `ship`s.
This `task` works differently depending on whether the `task` originated locally
or remotely.

#### Accepts

```hoon
[whos=(set ship)]
```
`whos` is the `set` of `ship`s from which subscriptions are to be canceled.

#### Returns

This `task` returns no `gift`s.


### `%plea`

This `task` is `%pass`ed to Jael from Ames. `%plea`s are wrappers for `task`s
that originate from a remote source, as the `%plea` pattern
is used to extend the `%pass`/`%give` semantics over the Ames network. Jael
attempts to perform the `task` wrapped in the `%plea`.

Jael accepts two kinds of `%plea`s: [`%nuke`](#nuke) and
[`%public-keys`](#public-keys) and will crash if passed anything else. See the
relevant entries to learn how Jael responds to these.

#### Accepts

```hoon
[=ship =plea:ames]
```
`ship` is the origin of the plea, and `plea:ames` is `[vane=@tas =path
payload=*]`. Here, `vane=%j`, `path` is the internal route on the receiving ship, and `payload` is either a `%nuke` or
a `%public-keys` `task`.

#### Returns

Jael `%give`s a `%done` `gift` in response to a `%plea` `task`. 

#### Passes

Jael `%pass`es itself the wrapped `task`.


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

This `task` creates a subscription for the callee to a selection of the public
keys kept by Jael. This `task` can originate locally or remotely.

#### Accepts

```hoon
[ships=(set ship)]
```
`ships` is the `set` of `ship`s whos' public keys are being subscribed to.

#### Returns

```hoon
[%public-keys =public-keys-result]
```
If the `task` originated locally, Jael `%give`s a `%public-keys` `gift` in
response. If it originated remotely, Jael `%give`s a `%boon` `gift` to back
to Ames wrapping a `%public-keys` `gift`.
    
A `$public-keys-result` is the following.
```hoon
    +$  public-keys-result
      $%  [%full points=(map ship point)]
          [%diff who=ship =diff:point]
          [%breach who=ship]
```
The first time Jael receives a `%public-keys` `task` from a ship it will return
a `[%public-keys-result %full]` `gift`, which contains all information about ships and
their associated points that Jael knows. Subsequent updates will typically be
`[%public-keys-result %diff]`, which tells the caller what has changed
since last time they sent a `%public-keys` `task`, and `[%public-keys-result
%breach]`, which informs the caller of ship breaches.


### `%rekey`

This `task` updates the ship's private keys.

#### Accepts

```hoon
[=life =ring]
```

`life` is a `@ud` that is the new ship key revision number. `ring` is a `@` that is the new private key.

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

This `task` is a request for Jael to provide its list of `turf`s, e.g. DNS
suffixes for the Ames network. Currently `arvo.network` is the only `turf` in use.

#### Accepts

```hoon
[~]
```

#### Returns

```hoon
[%turn tuf.own.pki]
```

Jael `%give`s a `%turf` `gift` in response to a `%turf` `task`. `tuf.own.pki` is
a `(list turf)`, which is Jael's list of `turf`s.


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





