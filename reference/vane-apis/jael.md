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

#### Returns


### `%listen`

#### Accepts

#### Returns


### `%meet`

#### Accepts

#### Returns


### `%moon`

#### Accepts

#### Returns


### `%nuke`

#### Accepts

#### Returns


### `%plea`

#### Accepts

#### Returns


### `%private-keys`

#### Accepts

#### Returns


### `%public-keys`

#### Accepts

#### Returns


### `%rekey`

#### Accepts

#### Returns


### `%trim`

#### Accepts

#### Returns


### `%turf`

#### Accepts

#### Returns


### `%vega`

#### Accepts

#### Returns


### `%wegh`

#### Accepts

#### Returns
