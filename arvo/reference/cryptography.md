+++
title = "Cryptography"
weight = 10
template = "doc.html"
+++

This is a summary of the cryptography functions found in `sys/zuse.hoon`, Arvo's
standard library. This page currently only documents cryptographic functions
directly utilized by [Ames](@/docs/arvo/ames/ames.md). `zuse` also contains
cryptographic functions relevant to Ethereum such as the `+keccak:crypto` core,
but they are currently undocumented.

Documentation for [Insecure Hashing](@/docs/hoon/reference/stdlib/2e.md) and the
[SHA Hash Family](@/docs/hoon/reference/stdlib/3d.md) is found in the Hoon standard
library reference.

## Summary

`zuse` contains several cryptosuites. The ones utilized by Ames are
[`+ed:crypto`](#ed), [`+aes:crypto`](#aes), and [`+crub:crypto`](#crub), with
the latter being the only one which is implemented as an [`+acru:ames`](@/docs/arvo/ames/cryptography.md#crypto-core)-shaped core.

## `+crub:crypto` {#crub}

`+crub:crypto` implements an
[`+acru:ames`](@/docs/arvo/ames/cryptography.md#crypto-core) core that implements
[Suite B Cryptography](https://en.wikipedia.org/wiki/NSA_Suite_B_Cryptography).

It utilizes AES symmetric key encryption and decryption from [`+aes:crypto`](#aes)
implemented using the Diffie-Hellman key exchange protocol, elliptic curve
digital signature algorithm (ECDSA) signing and verification with [`+ed:crypto`](#ed),
and generates public/private key pairs using elliptic curve cryptography with
`+ed:crypto`.

A `+crub:crypto` core's payload contains public encryption and authentication
keys and optional secret encryption and authentication keys.
```hoon
  ++  crub  !:
    ^-  acru
    =|  [pub=[cry=@ sgn=@] sek=(unit [cry=@ sgn=@])]
    |%
    ...
```
`+crub` cores (because they follow the `+acru` interface) are typically created using one of the constructors in [`+nu:crub`](#nu).

### `+seal:as`

```hoon
      ++  seal                                          ::
        |=  [bpk=pass msg=@]
        ...
```

Forms a symmetric key using Diffie-Hellman key exchange with the secret key
stored at `sgn.u.sek` and a public key `bpk`. Then `+sign`s `msg`, encrypts the
signed message using `+en:siva:aes` with the symmetric key, and then `+jam`s it.

Crashes if `sek` is null.

### `+sign:as` {#sign:as}

```hoon
      ++  sign                                          ::
        |=  msg=@
        ...
```

Signs message `msg=@` using the secret authentication key `sgn.u.sek`, then forms a
cell `[signed-message msg]` and `+jam`s it.

Crashes if `sek` is null.

### `+sure:as`

```hoon
      ++  sure                                          ::
        |=  txt=@
        ...
```

`+cue`s `txt` to get a signature `sig=@` and message `msg=@`. Verifies that
`sig` was `msg` signed using the secret key associated to the public key stored
at `sgn.pub`. Returns `(unit msg)` if so, null otherwise.

### `+tear:as`

```hoon
      ++  tear                                          ::
        |=  [bpk=pass txt=@]
        ...
```

Forms a secret symmetric key using Diffie-Hellman key exchange using the secret
key `cry.u.sek` and encryption key part of the public key `bpk` (which here is a
concatenation of both the encryption and authentication public keys). `+cue`s
`txt` and decrypts it using `+de:siva:aes` with the symmetric key. If decryption
is successful, verifies the decrypted message using authentication key part of
`bpk`, and returns it if so. Returns null otherwise.

Crashes if `sek` is null.

### `+de`

```hoon
    ++  de                                              ::  decrypt
      |=  [key=@J txt=@]
      ...
```

`+cue`s `txt` then decrypts with the symmetric key `key` using `+de:sivc:aes`.
Returns null in case of failure.

### `+dy`

```hoon
    ++  dy                                              ::  need decrypt
      |=  [key=@J cph=@]
      ...
```

Same as `+dy`, but crashes in case of failure.

### `+en` {#en}

```hoon
    ++  en                                              ::  encrypt
      |=  [key=@J msg=@]
```

Encrypts `msg` with the symmetric key `key` using `en:sivc:aes`, then `+jam`s
it.

### `+fig:ex`

Returns the fingerprint (SHA-256) of `+pub:ex`.

### `+pac:ex`

Returns the fingerprint (SHA-256) of `+sec:ex`. Crashes if `sek` is null.

### `+pub:ex`

Returns the concatenation of `sgn.pub` and `cry.pub`.

### `+sec:ex`

Returns the concatenation of `sgn.u.sek` and `cry.u.sek`.

### `+pit:nu` {#nu}

```hoon
      ++  pit                                           ::  create keypair
        |=  [w=@ seed=@]
        ...
```

Creates a `+crub` core with encryption and authentication public/private keypairs
generated from a bitwidth `w` and `seed`. The private keys are generated with
SHA-512, while `+puck:ed:crypto` is used to derive the public keys from the
private keys.

This is how one typically generates a brand new `+crub` core for signing and
encrypting your own messages.

### `+nol:nu`

```hoon
      ++  nol                                           ::  activate secret
        |=  a=ring
        ...
```

Takes in a `ring` from a `+sec:ex:crub` and generates a new `+crub` core with
`sek` taken from `+sec:ex` and `pub` generated with `+puck:ed:crypto`. Crashes
if `+sec:ex` is not a `+crub` secret key.

### `+com:nu`

```hoon
      ++  com                                           ::  activate public
        |=  a=pass
        ...
```

Takes in a `pass` from a `+pub:ex:crub` and generates a new `+crub` core with
`pub` taken from `+pub:ex` and null `sek`.

## `+ed:crypto` {#ed}

This core contains cryptographic primitives and helper functions for elliptic
curve cryptography with [Curve25519](https://en.wikipedia.org/wiki/Curve25519).

`+ed:crypto` is primarily used to generate public/private keypairs from a seed
for use with [elliptic curve
Diffie-Hellman](https://en.wikipedia.org/wiki/Elliptic-curve_Diffie%E2%80%93Hellman)
key agreements as well as [Elliptic Curve Digital Signature
Algorithm](https://en.wikipedia.org/wiki/Elliptic_Curve_Digital_Signature_Algorithm).
These functionalities are ultimately utilized by [`+crub:crypto`](#crub), the
only cryptosuite which [Ames](@/docs/arvo/ames/ames.md) makes use of.

Most gates in `+ed:crypto` are [jetted](@/docs/vere/jetting.md), meaning that an
external reference library is utilized whenever these functions are called,
rather than running in Nock natively. See the [Vere
documentation](@/docs/vere/cryptography.md#ed) for more information about the
library utilized by jets.

## `+aes:crypto` {#aes}

This core contains cryptographic primitives and helper functions for
[AES](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard) symmetric key
encryption and decryption. As is the case with `ed:crypto`, these
functionalities are utilized by [`+crub:crypto`](#crub), and most gates are
jetted. See also the Vere documentation on [AES
SIV](@/docs/vere/cryptography.md#aes) for more information about the library
utilized by jets.

This core contains several doors, each one used for a different variation of AES
according to key size and mode. The only ones currently in use are
`+siva:aes:crypto` and `+sivc:aes:crypto`, which are 128-bit and
256-bit modes of [`AES-SIV`](https://www.aes-siv.com) respectively.
