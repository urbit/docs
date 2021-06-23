+++
title = "Cryptography"
weight = 5
template = "doc.html"
+++

Here we give a technical overview of how Ames implements cryptography.

## Summary

By default, all [packets are encrypted](#packets) with 256-bit
[AES](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard) symmetric key
encryption, whose key is obtained by [Diffie-Hellman key exchange](#key-exchange),
with public/private keys generated using elliptic curve
[Curve25519](https://en.wikipedia.org/wiki/Curve25519). The only exception to
this are comet [self-attestation packets](#comets), which are unencrypted.

All packets are also [signed](#packets) using [Elliptic Curve Digital Signature
Algorithm](https://en.wikipedia.org/wiki/Elliptic_Curve_Digital_Signature_Algorithm).

The `$ames-state` includes a [`+acru:ames`](#crypto-core) core, an interface
core into which one of the cryptosuites in `zuse` may be implemented. Some, but
not all, of the calls to cryptography-related tasks (encryption, signing,
decrypting, and authenticating) are peformed utilizing the `+acru` core.

## Packet encryption and authentication {#packets}

Each Urbit ship possesses two networking keypairs: one for encryption, and one
for authentication. We often refer to these two keypairs as though they were a
single keypair because they are stored as a single atom. [Elliptic Curve
Diffie-Hellman](https://en.wikipedia.org/wiki/Elliptic-curve_Diffie%E2%80%93Hellman)
is used for encryption, while [Elliptic Curve Digital Signature
Algorithm](https://en.wikipedia.org/wiki/Elliptic_Curve_Digital_Signature_Algorithm)
is used for authentication

The encrypted payload of each packet is a `$shut-packet`, which is the `+jam` of
a cell with the `bone`, message number, and message fragment or ack (see
[Ames](@/docs/arvo/ames/ames.md) for more information on packet structure). The
message fragment is signed using the authentication key. It is encrypted using
[`+en:crub:crypto`](@/docs/arvo/reference/cryptography.md#en) found in
`sys/zuse.hoon`, which utilizes the 256-bit AES-SIV algorithm.

## Diffie-Hellman key exchange {#key-exchange}

For each foreign ship a given ship has communicated with, `$ames-state` contains a
`$peer-state`, inside which the `$symmetric-key` (an atom which nests under
`@uw`) is utilized for encrypting all Ames packets shared between the two ships.
The `symmetric-key` is derived using [`+shar:ed:crypto`](@/docs/arvo/reference/cryptography.md#ed) found in `sys/zuse.hoon`,
which is an arm utilized for generating the symmetric key for elliptic curve
[Diffie-Hellman key
exchange](https://en.wikipedia.org/wiki/Diffie%E2%80%93Hellman_key_exchange)
with [curve25519](https://en.wikipedia.org/wiki/Curve25519). Briefly, each ship
in a two-way conversation computes the shared symmetric key for that
conversation by computing the product of their own private key and the public
key of the other party.

## Comet self-attestation {#comets}

Recall that the `@p` of a comet is the hash of their 128-bit public key cast as
a `@p`. Since the public key of a comet is not stored on Azimuth, a comet proves
its identity with an "attestation packet". This is an unencrypted packet whose
payload is the comet's signature created with its private key. This is the only
circumstance under which a ship will send an unencrypted packet. The signature
is generated with
[`+sign:as:crub`](@/docs/arvo/reference/cryptography.md#sign-as) found in
`sys/zuse.hoon`.

Upon hearing an attestation packet, the receiving ship will generate a symmetric
key for communications with the comet, according to the [key
exchange](#key-exchange) protocol.

The fact that the first packet exchanged between a comet and another ship must
be an attestation packet is why comets are unable to initiate communication with
one another, and also why comets must be the first to initiate communication
with a non-comet. This is a technical limitation with a planned workaround.

## `+acru:ames` {#crypto-core}

The `+crypto-core` in `$ames-state` is an `+acru:ames` core, a
[lead](@/docs/hoon/reference/advanced.md#dry-polymorphism-and-core-nesting-rules)
interface core for asymmetric cryptosuites found in `sys/lull.hoon` which
handles encryption, decryption, signing, and verifying. In practice, the only
cryptosuite in use is [`+crub:crypto`](#crub), which implements [Suite B
Cryptography](https://en.wikipedia.org/wiki/NSA_Suite_B_Cryptography).

```hoon
  ++  acru  $_  ^?                                      ::  asym cryptosuite
    |%                                                  ::  opaque object
    ++  as  ^?                                          ::  asym ops
      |%  ++  seal  |~([a=pass b=@] *@)                 ::  encrypt to a
          ++  sign  |~(a=@ *@)                          ::  certify as us
          ++  sure  |~(a=@ *(unit @))                   ::  authenticate from us
          ++  tear  |~([a=pass b=@] *(unit @))          ::  accept from a
      --  ::as                                          ::
    ++  de  |~([a=@ b=@] *(unit @))                     ::  symmetric de, soft
    ++  dy  |~([a=@ b=@] *@)                            ::  symmetric de, hard
    ++  en  |~([a=@ b=@] *@)                            ::  symmetric en
    ++  ex  ^?                                          ::  export
      |%  ++  fig  *@uvH                                ::  fingerprint
          ++  pac  *@uvG                                ::  default passcode
          ++  pub  *pass                                ::  public key
          ++  sec  *ring                                ::  private key
      --  ::ex                                          ::
    ++  nu  ^?                                          ::  reconstructors
      |%  ++  pit  |~([a=@ b=@] ^?(..nu))               ::  from [width seed]
          ++  nol  |~(a=ring ^?(..nu))                  ::  from ring
          ++  com  |~(a=pass ^?(..nu))                  ::  from pass
      --  ::nu                                          ::
    --  ::acru                                          ::
```

As the `+acru` core is merely an interface, the details on how it is implemented
may vary according to the cryptosuite. We summarize what each
core is utilized for here, but see
[`crub:crypto`](@/docs/arvo/reference/cryptography.md#crub) for more details on
how the specific cryptosuite utilized by Ames is implemented.

#### `+as:acru`

This core is used for the standard asymmetric cryptographic operations: encrypting
(`+seal`), signing (`+sign`), authenticating (`+sure`), and decrypting (`+tear`).

#### `+ex:acru`

This core is used to extract keys and their fingerprints. `+sec` is the secret key (which
may be empty), `+pub` is the public key associated to the secret key, `+pac` is
the fingerprint associated to the secret key, and `+fig` is the fingerprint
associated to the public key. We note that when the core contains both
encryption and authentication keys, they are typically concatenated to be
returned as a single atom.

#### `+nu:acru`

This core contains constructors for the `+acru` core. `+pit:nu` is used to
construct an `+acru` core with both a private and public key (i.e. both
`+sec:ex` and `+pub:ex` are set) from a bitlength and seed. `+nol:nu` can then be
called from an `+acru` core created with `+pit:nu` to get an `+acru` core with
only the secret key, while `+com:nu` can be called to get an `+acru` core with
only the public key.

#### `+en:acru`, `+de:acru`, and `+dy:acru`

These arms are for symmetric encryption (`+en`) and decryption (`+de` and
`+dy`). The difference between the decryption arms is that `+de` returns null
and `+dy` crashes upon failure.
