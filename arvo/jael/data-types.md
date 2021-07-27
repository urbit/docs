+++
title = "Data Types"
weight = 4
template = "doc.html"
+++

Jael's section in `lull.hoon` contains three ancillary cores with their own type definitions as well as Jael's general types, so this reference is divided as follows:

- [jael](#public-keys-result) - General structures.
- [block:jael](#block) - Structures for Ethereum blocks.
- [point:jael](#point) - Structures for points (Ship IDs in Azimuth).
- [pki:jael](#pki) - Largely unused apart from [$oath:pki](#oath-pki).

## `$public-keys-result`

```hoon
+$  public-keys-result
  $%  [%full points=(map ship point)]
      [%diff who=ship =diff:point]
      [%breach who=ship]
  ==
```

This is what Jael gives (in a [%public-keys](@/docs/arvo/jael/tasks.md#public-keys) `gift`) to subcribers who are tracking public key information for a `set` of `ship`s.

Typically the `%full` kind with a `map` of `ship`s to [$point:point](#point-point)s is given immediately upon subscription and contains all public key records for the ships in question. After the `%full`, a `%diff` (including a [$diff:point](#diff-point)) will be given whenever a change (such as the sponsor or pubkey) has occurred for one of the ships being tracked, and a `%breach` will be given whenever a continuity breach for a tracked ship occurs.

## `$seed`

```hoon
+$  seed  [who=ship lyf=life key=ring sig=(unit oath:pki)]
```

Private boot parameters. The `who` field is the name of the ship, `lyf` is the `life` (key revision number), `key` is the private key and `sig` is the signature of the parent ship if it's a moon, and `~` otherwise.

## `$dawn-event`

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

Ship initialisation parameters.

- [$seed](#seed) contains the private boot parameters.
- `spon` is a `list` of ships and their [$point](#point-point)s in the ship's sponsorship chain, all the way to the galaxy level.
- `czar` is a map from each galaxy's `@p` to its `rift`, `life`, and public key (`pass`).
- `turf` is a `list` of DNS suffixes used for galaxies, which is `urbit.org` by default. 
- `bloq` is the number of the Ethereum block in which the ship registered its keys with the Azimuth smart contract.
- `node` is the URL of the Ethereum node used to monitor Azimuth.

## `$source`

```hoon
+$  source  (each ship term)
```

Source of public key updates for Jael. If it's a `term` it's a Gall agent e.g `%azimuth-tracker`. If it's a `ship`, Jael will subscribe to that ship's Jael for updates - e.g. Jael will subscribe to the parent planet of moons for updates about the moons.

## `$source-id`

```hoon
+$  source-id  @udsourceid
```

Numerical index for Jael to organise its `source`s. Jael assigns its `source-id`s sequentially, starting from `0`.

## `$state-eth-node`

```hoon
+$  state-eth-node  ::  node config + meta
  $:  top-source-id=source-id
      sources=(map source-id source)
      sources-reverse=(map source source-id)
      default-source=source-id
      ship-sources=(map ship source-id)
      ship-sources-reverse=(jug source-id ship)
  ==
```

Jael's data about `source`s for PKI updates about ships.

- `top-source-id` tracks the highest `source-id` so Jael can easily determine what the next `source-id` should be.
- `sources` is a `map` of [$source-id](#source-id)s to [$source](#source)s.
- `sources-reverse` the same as `sources` but in reverse.
- `default-source` is the default `source` to use (typically `0` - `%azimuth-tracker`).
- `ship-sources` is a `map` from `ship`s to `source-id`s and records where to get updates from for the ships in question. Typically these will map moons to their parent ships.
- `ship-sources-reverse` is the same as `ship-sources` but in reverse.

# block

Structures for Ethereum blocks.

## `$hash:block`

```hoon
+$  hash  @uxblockhash
```

Ethereum block hash.

## `$number:block`

```hoon
+$  number  @udblocknumber
```

Ethereum block number.

## `$id:block`

```hoon
+$  id  [=hash =number]
```

Ethereum block identifier - contains both the [$hash:block](#hash-block) and [$number:block](#number-block).

## `$block:block`

```hoon
+$  block  [=id =parent=hash]
```

A reference to an Ethereum block - contains the [$id:block](#id-block) and the [$hash:block](#hash-block) of its parent for ordering purposes.

# point

Structures for points (Ship IDs in Azimuth).

## `$point:point`

```hoon
+$  point
  $:  =rift
      =life
      keys=(map life [crypto-suite=@ud =pass])
      sponsor=(unit @p)
  ==
```

Public key data for a particular ship. The `rift` is the current continuity breach number and `life` is the current key revision number. The `keys` `map` contains the public key (`pass`) for each `life` up to the current one. The `sponsor` is the current sponsor of the ship in question, if it has one.

## `$key-update:point`

```hoon
+$  key-update  [=life crypto-suite=@ud =pass]
```

An update to a ship's keys. The `life` is the key revision number, `crypt-suite` is a version number for the cryptographic suite used for keys in Azimuth, and `pass` is the public key itself.

## `$diffs:point`

```hoon
+$  diffs  (list diff)
```

A list of invertible [$diff:point](#diff-point)s.

## `$diff:point`

```hoon
+$  diff
  $%  [%rift from=rift to=rift]
      [%keys from=key-update to=key-update]
      [%spon from=(unit @p) to=(unit @p)]
  ==
```

An invertible diff for public key (and related) changes to the state of an Azimuth point (ship ID).

- `%rift` is a change to the `rift` (continuity breach number) that occurs when a ship undergoes a continuity breach.
- `%keys` is a change to a ship's `life` and public key, specified in the [$key-update:point](#key-update-point).
- `%spon` is a change to a ship's sponsor.

The `from` and `to` field specify the old a new values respectively.

## `$udiffs:point`

```hoon
+$  udiffs  (list [=ship =udiff])
```

A list of non-invertible [$udiff:point](#udiff-point)s.

## `$udiff:point`

```hoon
+$  udiff
  $:  =id:block
  $%  [%rift =rift]
      [%keys key-update]
      [%spon sponsor=(unit @p)]
      [%disavow ~]
  ==  ==
```

A non-invertible diff for public key (and related) changes to the state of an Azimuth point (ship ID).

The [$id:block](#id-block) contains the block number and block hash of the Ethereum block in which the change occurred. The next part specifies what changed, where:

- `%rift` means the ship has undergone a continuity breach and therefore the `rift` (continuity revision number) has changed.
- `%keys` means the ship's `life` (key revision number) has changed, the [$key-update:point](#key-update-point) contains the new `life` and pubkeys.
- `%spon` means the ship's sponsor has changed.
- `%disavow` means a previous Ethereum block has been disavowed.

A `udiff:point` can be converted to a [$diff:point](#diff-point) with the `+udiff-to-diff:point` function.

# pki

This structure is mostly a holdover from prior versions of Jael and is unused apart from [$oath:pki](#oath-pki).

## `$hand:pki`

```hoon
+$  hand  @uvH
```

128-bit Hash.

## `$mind:pki`

```hoon
+$  mind  [who=ship lyf=life]
```

Key identifier.

## `$name:pki`

```hoon
+$  name  (pair @ta @t)
```

Name in both ASCII and Unicode.

## `$oath:pki`

```hoon
+$  oath  @
```

Signature. This type is used in the [$seed](#seed) for moons as a signature from the moon's parent.
