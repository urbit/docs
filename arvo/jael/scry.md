+++
title = "Scry Reference"
weight = 3
template = "doc.html"
+++

Jael's scry endpoints never take a `care`. The particular endpoints are specified in the place of the desk in the path prefix, then additional arguments are specified in the path.

# Contents

- [step](#step) - Web login code revision number.
- [code](#code) - Web login code.
- [life](#life) - Key revision number (`life`).
- [lyfe](#lyfe) - Unitised `life`.
- [rift](#rift) - Continuity number (`rift`).
- [ryft](#ryft) - Unitised `rift`.
- [vein](#vein) - Private key.
- [vile](#vile) - Jammed `seed` boot parameters.
- [deed](#deed) - Public key and related details.
- [earl](#earl) - Derive moon keys.
- [sein](#sein) - Sponsor.
- [saxo](#saxo) - Sponsorship chain.
- [subscriptions](#subscriptions) - Public key trackers.
- [sources](#sources) - PKI sources.
- [turf](#turf) - Galaxy domain prefixes.

# `%step`

A `%step` scry gets the current web login code revision number. It takes your ship name as its `path` and the type returned is a `@ud`.

## Example

```
> .^(@ud %j /=step=/(scot %p our))
0
```

# `%code`

A `%code` scry gets the current web login code. It takes your ship name as its `path` and the type returned is a `@p`.

## Example

```
> .^(@p %j /=code=/(scot %p our))
~lidlut-tabwed-pillex-ridrup
```

# `%life`

A `%life` scry gets the current `life` (key revision number). It takes a ship as its `path` and the type returned is a `@ud`.

## Example

```
> .^(@ud %j /=life=/(scot %p our))
1
```

# `%lyfe`

A `%lyfe` scry gets the current unitized `life` (key revision number). It takes a ship as its `path` and the type returned is a `(unit @ud)`.

## Example

```
> .^((unit @ud) %j /=lyfe=/(scot %p our))
[~ 1]
```

# `%rift`

A `%rift` scry gets the current `rift` (continuity number). It takes a ship as its `path` and the type returned is a `@ud`.

## Example

```
.^(@ud %j /=rift=/(scot %p our))
1
```

# `%ryft`

A `%ryft`  scry gets the current unitized `rift` (continuity number). It takes a ship as its `path` and the type returned is a `(unit @ud)`.

## Example

```
> .^((unit @ud) %j /=ryft=/(scot %p our))
[~ 1]
```

# `%vein`

A `%vein` scry gets your ship's private key for the specified `life`. It takes a `life` `@ud` as its `path` and the type returned is a `ring`.

## Example

```
> .^(@uw %j /=vein=/1)
0w84.0MwlQ.y2Ly9.6HVmH.8SYwo.EvuLC.f5YRw.T2NzD.EHtjZ.gpHZb.J0Pu5.aTGVL.UugSA.EZ~E9.~PODC.cohVD.B1zWj.ZWnJ2
```

# `%vile`

A `%vile` scry gets your `jam`mmed private boot parameters at your ship's current `life`. It takes no additional arguments in its `path`. The type returned is a `@` which is a `jam`med [$seed](@/docs/arvo/jael/data-types.md#seed).

## Examples

```
> .^(@ %j /=vile=)
73.825.716.773.695.891.582.219.653.213.376.682.408.892.852.624.025.387.720.465.884.094.267.975.202.807.896.467.150.282.384.122.104.470.678.155.055.914.950.319.747.613.107.324.566.157.366.237.078.063.363.527.599.682.750.233
```

```
> ;;(seed:jael (cue .^(@ %j /=vile=)))
[ who=~zod
  lyf=1
    key
  1.729.646.917.183.337.262.068.568.133.450.460.269.618.308.934.734.494.661.340.450.478.360.301.077.532.415.587.141.242.844.893.269.500.211.196.916.184.768.225.437.577.083.064.475.012.067.992.317.942.521.494.338
  sig=~
]
```

# `%deed`

A `%deed` scry gets the `life`, pubkey and maybe a signature if the ship in question is a comet. It takes the target ship and life as its `path` like `/~sampel-palnet/1`and the type returned is a `[life pass (unit @ux)]`.

## Example

```
> .^([life pass (unit @ux)] %j /=deed=/(scot %p our)/1)
[ 1
  2.649.818.598.466.464.524.534.996.841.661.372.043.001.125.438.577.869.575.450.096.229.472.239.369.342.882.589.479.483.389.735.480.760.982.635.242.955.515.616.049.650.771.700.602.823.946.406.713.457.849.302.626
  ~
]
```

# `%earl`

A `%earl` scry deterministically derives a private key for a moon. Note the `|moon` generator doesn't use this and instead generates moon private keys non-deterministically. It takes the moon name and your ship's current `life` (not the moon's `life`) as its `path` like `/~doznec-dozzod-dozzod-dozzod/1`. The type returned is a [$seed](@/docs/arvo/jael/data-types.md#seed), the `life` of the moon in the `lyf` field of the `seed` will always be `1`.

## Example

```
> .^(seed:jael %j /=earl=/~doznec-dozzod-dozzod-dozzod/1)
[ who=~doznec-dozzod-dozzod-dozzod
  lyf=1
    key
  1.055.418.877.440.612.330.077.014.834.463.499.863.663.523.990.336.436.220.536.921.445.512.367.957.276.250.223.724.881.932.188.751.226.308.505.496.234.256.625.462.295.144.257.529.749.880.805.247.600.674.018.370
  sig=~
]
```

# `%sein`

A `%sein` scry gets the sponsor for the specified ship. This scry is used implicitly by `sein:title`. It takes the target ship as its `path` and the type returned is a `@p`.

## Example

```
> .^(@p %j /=sein=/~sampel-palnet)
~talpur
```

# `%saxo`

A `%saxo` scry gets the sponsorship chain for the target ship (including the target ship itself). For example, a `%saxo` scry for a planet will return the planet, its star and the star's galaxy. This scry is used implicitly by `sein:title`. It takes the target ship as its `path` and the type returned is a `(list @p)`.

## Example

```
> .^((list @p) %j /=saxo=/~sampel-palnet)
~[~sampel-palnet ~talpur ~pur]
```

# `%subscriptions`

A `%subscriptions` scry gets the current state of subscriptions to public key updates (typically initiated with a [%public-keys task](@/docs/arvo/jael/tasks.md#public-keys)). It takes a `life` as its `path` and returns a triple of the following:

```hoon
yen=(jug duct ship)  ::  trackers
ney=(jug ship duct)  ::  reverse trackers
nel=(set duct)       ::  trackers of all
```

The `yen` `jug` maps subscribed `duct`s to the `ship`s they're tracking, and `ney` is just the inverse, mapping tracked `ship`s to subscribed `duct`s. The `nel` set contains `duct`s track all public key updates.

## Example

```
.^([yen=(jug duct ship) ney=(jug ship duct) nel=(set duct)] %j /=subscriptions=/1)
[yen={} ney={} nel={}]
```

# `%sources`

A `%sources` scry gets the current state of Jael's sources for PKI updates. It takes no additional arguments in its `path` and returns a [$state-eth-node](@/docs/arvo/jael/data-types.md#state-eth-node).

## Example

```
> .^(state-eth-node:jael %j /=sources=)
[ top-source-id=0
  sources={}
  sources-reverse={}
  default-source=0
  ship-sources={}
  ship-sources-reverse={}
]
```

# `%turf`

A `%turf` scry gets the list of domain prefixes for galaxies. It takes no additional arguments in its `path`. It returns a `(list turf)`, where a `turf` is a TLD-first `(list @t)`, so `urbit.org` as a `turf` is `~['org' 'urbit']`.

## Example

```
> .^((list turf) %j /=turf=)
~[<|org urbit|>]
```
