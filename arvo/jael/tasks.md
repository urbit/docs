+++
title = "API Reference"
weight = 2
template = "doc.html"
+++

This document details all the `task`s you may wish to send Jael, as well as the `gift`s you'll receive in response.

You may also wish to reference the [Data Types](@/docs/arvo/jael/data-types.md) document for details of the types referenced here, and the [Examples](@/docs/arvo/jael/examples.md) document for practical examples of using these `task`s.

# Contents
- [%dawn](#dawn) - *(Internal only)* - Boot from keys.
- [%fake](#fake) - *(Internal only)* - Boot fake ship.
- [%listen](#listen) - *(Usually internal)* - Set Ethereum Source.
- [%meet](#meet) - *Deprecated.*
- [%moon](#moon) - Register moon keys or otherwise administer a moon.
- [%nuke](#nuke) - Cancel subscription to public or private key updates.
- [%private-keys](#private-keys) - Subscribe to private key updates.
- [%public-keys](#public-keys) - Subscribe to public key (and related) updates from Jael.
- [%rekey](#rekey)- Update private keys.
- [%turf](#turf) - View domains.
- [%step](#step) - Reset web login code.

# `%dawn`

```hoon
[%dawn dawn-event]
```

Boot from keys.

This `task` is called once per ship during the vane initialization phase immediately following the beginning of the [adult stage](@/docs/arvo/overview.md#structural-interface-core). This `task` is `%pass`ed to Jael by Dill, as Dill is the first vane to be loaded for technical reasons, though we consider Jael to be the true "first" vane. This `task` is only used for ships that will join the Ames network - fake ships (i.e. made with `./urbit -F zod`) use the [%fake](#fake) `task` instead.

`%dawn` is used to perform a sequence of initialization tasks related to saving information about Azimuth and the Ames network and booting other vanes for the first time. Upon receipt of a `%dawn` `task`, Jael will:

 - record the Ethereum block the public key is registered to,
 - record the URL of the Ethereum node used,
 - save the signature of the parent planet (if the ship is a moon),
 - load the initial public and private keys for the ship,
 - set the DNS suffix(es) used by the network (currently just `urbit.org`),
 - save the public keys of all galaxies,
 - set Jael to subscribe to `%azimuth-tracker`,
 - `%slip` a `%init` `task` to Ames, Clay, Gall, Dill, and Eyre, and `%give` an `%init`
`gift` to Arvo, which then informs Unix that the initialization process has concluded.

This `task` takes a [$dawn-event](@/docs/arvo/jael/data-types.md#dawn-event) as its argument.

You would not use this `task` manually.

## Returns

Jael `%give`s an `%init` `gift` to Unix. This occurs after the Dill `%slip` init.

# `%fake`

```hoon
[%fake =ship]
```

Boot fake ship.

This `task` is used instead of [%dawn](#dawn) when creating a fake ship via the `-F` flag when calling the Urbit binary. It performs a subset of the actions that `%dawn` performs, modified to accommodate the fake ship.

`%fake` endows the ship with a private key and a public key deterministically derived from the ship's `@p`. It sets `fak.own.pki` to `%.y`, which is the bit that determines whether or not a ship is fake. Other parts of the Jael state, such as the sponsorship chain and galaxy public keys are left at their bunted values.

The `ship` field specifies the `@p` of the fake ship being created.

You would not use this `task` manually.

## Returns

Jael `%give`s a `%init` `gift` to Unix.

# `%listen`

```hoon
[%listen whos=(set ship) =source]  ::  set ethereum source
```

Set Ethereum source.

Sets the source that the public keys for a set of `ship`s should be obtained from. This can either be a Gall app that communicates with an Ethereum node such as `%azimuth-tracker`, as in the case of galaxies, stars, and planets, or a ship, as in the case of moons.

`whos` is the set of ships whose key data source is to be altered. The [$source](@/docs/arvo/jael/data-types.md#source) is either a ship or the name of a Gall app to use as a source. A `%listen` `task` with empty `whos` will set the default source. When the `source` is a ship, Jael will obtain public keys for ships in `(set ship)` from the given ship. By default, the `source` for a moon will be the planet that spawned that moon.

You are unlikely to use this `task` manually.

## Returns

Jael will not return any `gift`s in response to a `%listen` `task`.

# `%meet`

```hoon
[%meet =ship =life =pass]
```

This `task` is deprecated and does not perform any actions.

# `%moon`

```hoon
[%moon =ship =udiff:point]
```

Register moon keys or otherwise administer a moon.

This is what is sent to Jael by `%hood` behind the scenes when you run `|moon`, `|moon-breach` or `|moon-cycle-keys`. The `ship` field is the moon's `@p`. The [$udiff:point](@/docs/arvo/jael/data-types.md#udiff-point) will contain the bunt of an [$id:block](@/docs/arvo/jael/data-types.md#id-block) (since moons aren't registered in Azimuth) and one of the `udiff` actions depending on what you want to do.

## Returns

Jael does not return any `gift`s in response to a `%moon` `task`.

# `%nuke`

```hoon
[%nuke whos=(set ship)]
```

Cancel subscription to public or private key updates.

If you've subscribed to public or private key updates from Jael with a [%private-keys](#private-keys) or [%public-keys](#public-keys) `task`, you can unsubscribe and stop receiving updates with a `%nuke` `task`. The `(set ship)` is the `set` of `ship`s which you want to stop tracking. Jael organises subscriptions based on `duct`s, and will determine which subscription to cancel implicitly based on the `duct` the `%nuke` `task` came from. This means a `%nuke` `task` only works from the same thread or agent and on the same `path` as the original subscription request.

To cancel a subscription to a ship's private keys you must leave `whos` empty like `[%nuke ~]`.

## Returns

Jael does not return a `gift` in response to a `%nuke` `task`.

## Examples

See the [%public-keys and %nuke](@/docs/arvo/jael/examples.md#public-keys-and-nuke) section of the Examples document for an example of using `%nuke` to cancel a `%public-keys` subscription. See the thread in the [%private-keys](@/docs/arvo/jael/examples.md#private-keys) example for cancelling a `%private-keys` subscription.

# `%private-keys`

```hoon
[%private-keys ~]
```

Subscribe to private key updates.

An agent or thread can subscribe to be notified of private key updates for the local ship. The subscription will continue until Jael receives a [%nuke](#nuke) `task` to cancel it.

## Returns

Jael responds to a `%private-keys` `task` with a `%private-keys` `gift` which looks like:

```hoon
[%private-keys =life vein=(map life ring)]
```

The `life` is the current life of the ship and the `vein` `map` contains the private key for each life up to (and including) the current one. Upon first subscribing, Jael will immediately respond with a `%private-keys` `gift`. Then, whenever the ship's private keys are changed, it'll send a new and updated `%private-keys` `gift`.

## Example

See the [%private-keys](@/docs/arvo/jael/examples.md#private-keys) section of the Examples document for a practical example.

# `%public-keys`

```hoon
[%public-keys ships=(set ship)]
```

Subscribe to public key (and related) updates from Jael.

An agent or thread can subscribe to be notified of public key updates, sponsorship changes and continuity breaches for the `set` of `ship`s specified in the `ships` field. The subscription will continue until Jael receives a [%nuke](#nuke) `task` to cancel it.

## Returns

Jael responds to a `%public-keys` `task` with `%public-keys` `gift`s which look like:

```hoon
[%public-keys =public-keys-result]
```

The [$public-keys-result](@/docs/arvo/jael/data-types.md#public-keys-result) contains whatever changes have occurred.

Upon subscription, Jael will immeditely respond with a `%public-keys` `gift` containing a `%full` `public-keys-result` with the public key for each `life` up until the current one for each `ship` specified in the original `task`. After than, Jael will send a `%public-keys` `gift` with either a `%diff` or `%breach` `public-keys-result` each time a change occurs for any of the `ship`s to which you're subscribed.

## Example

See the [%public-keys and %nuke](@/docs/arvo/jael/examples.md#public-keys-and-nuke) section of the Examples document for a practical example.

# `%rekey`

```hoon
[%rekey =life =ring]
```

Update private keys.

This is what is send to Eyre by `%hood` implicitly when you run `|rekey` after rekeying via Bridge (or via `|cycle-moon-keys` on your planet in the case of a moon). It will update your `life` (key revision number) and private keys. The `life` field is the new `life` (typically an increment of the current `life`) and the `ring` is a private key `@`.

## Returns

Eyre does not return any `gift` in response to a `%rekey` `task`.

# `%turf`

```hoon
[%turf ~]
```

View domains.

The domains returned by a `%turf` `task` are used as the base for individual galaxy domain names (e.g. from `urbit.org` you get `zod.urbit.org`, `bus.urbit.org`, etc). Jael gets these from Azimuth, then Ames gets them from Jael and passes them to the runtime, which will perform the DNS lookups and give Ames back the galaxy IP addresses. A `%turf` task takes no additional arguments. You're unlikely to use this manually - if you want the current `turf`s you'd likely want to do a [turf scry](@/docs/arvo/jael/scry.md#turf) instead.

## Returns

Eyre will respond to a `%turf` `task` with a `%turf` `gift`, which looks like:

```hoon
[%turf turf=(list turf)]
```

The `turf` in the `(list turf)` is a domain as a `(list @t)`, TLD-first. The current default is `[['org' 'urbit' ~] ~]`.

## Example

See the [%turf section of the Examples document](@/docs/arvo/jael/examples.md#turf) for a practical example.

# `%step`

```hoon
[%step ~]
```

Reset web login code.

Jael maintains a `step` value that represents the web login code revision number, and uses it to derive the code itself. It begins at `0` and is incremented each time the code is changed.  When Jael updates the web login code, it sends Eyre a `%code-changed` `task:eyre` so that Eyre can throw away all of its current cookies and sessions. A `%step` task takes no additional argument.

## Returns

Jael does not return a `gift` in response to a `%step` `task`. 

## Example

See the [%step](@/docs/arvo/jael/examples.md#step) section of the Examples document for a practical example.
