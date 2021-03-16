+++
title = "Cryptography"
weight = 10
template = "doc.html"
+++

Cryptography is central to the operation of Urbit. This section gives an
overview of where cryptographic methods are utilized in Arvo, what they are, and
how they are implemented.

This document does not describe any algorithmic details of cryptographic
functions, only how they are utilized. This document also does not cover
hashing - see [Insecure Hashing](@/docs/hoon/reference/stdlib/2e.md) and [SHA
Hash Family](@/docs/reference/stdlib/3d.md) for reference material on hash
functions in the standard library.

## Summary

There are five parts of the system involved with cryptography on Urbit. We
summarize each component here briefly, and then continue with a more detailed
exposition below.

[Ames](@/docs/arvo/ames/ames.md) is Arvo's networking vane. All packets sent by
Ames are encrypted utilizing a cryptosuite found in `zuse`. Ames is responsible
for encryption and decryption of all packets. By default, this utilizes AES
symmetric key encryption, whose key is got by elliptic curve Diffie-Hellman key exchange.

`zuse` is the Hoon standard library. It contains cryptographic primitives which
may be utilized by an Ames `+crypto-core`. All cryptographic primitives are
[jetted](@/docs/vere/jetting.md) in Vere with standard implementations of cryptographic
libraries.

[Vere](@/docs/vere/_index.md) is Urbit's Nock runtime system, written in C.
Correct implementation of cryptographic libraries is difficult, and so all
cryptographic primitives implemented in Hoon actually hint to the interpreter to
run vetted cryptographic libraries reviewed by experts.

[Jael](@/docs/arvo/jael/jael-api.md) is utilized for the safe storage and
retrieval of private and public keys utilized by Ames and Azimuth. The Jael vane
of a planet is responsible for distributing the public keys of its moons
(ultimately via Ames), while the Jael vane of a comet is responsible for
distributing its own public key (also ultimately via Ames).

[Azimuth](@/docs/azimuth/_index.md) is Urbit's Ethereum-based public key
infrastructure. `azimuth-tracker` obtains public keys for planets, stars, and
galaxies from this store, which are then stored in Jael and utilized by Ames for
end-to-end encrypted communication.

## Ames

The `$ames-state` includes a `+crypto-core`, an interface core into which one of
the cryptosuites in `zuse` may be implemented. The suite utilized by the
`+crypto-core` is used to encrypt all communications utilized by Ames. By
default, all packets are encrypted with AES symmetric key encryption, whose key
is got by Diffie-Hellman key exchange, with public/private keys generated using
elliptic curve ed25519.

### +crypto-core

The `+crypto-core` is an `+acru:ames`, a
[lead](@/docs/hoon/reference/advanced.md#dry-polymorphism-and-core-nesting-rules)
interface core for asymmetric cryptosuites found in `sys/lull.hoon` which
handles encryption and signing.

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

### Diffie-Hellman key exchange {#key-exchange}

For each `@p` a given ship has met, `$ames-state` contains a `$peer-state`,
inside which the `$symmetric-key` (an atom which nests under `@uw`) utilized for
encrypting all Ames packets shared between the two ships. The `symmetric-key` is
derived using `shar:ed:crypto` found in `sys/zuse.hoon`, which is an arm
utilized for generating the symmetric key for elliptic curve Diffie-Hellman key
exchange with [curve25519](https://en.wikipedia.org/wiki/Curve25519); see
[below](#ed) for more information on the `ed:crypto` core.

### Packet encryption

The encrypted payload of each packet is a `$shut-packet`, which is the `+jam` of
a cell with the `bone`, message number, and message fragment or ack (see
[Ames](@/docs/ames/ames.md) for more information on packet structure). It is
encrypted using `++sivc:aes:crypto` found in `sys/zuse.hoon`, which is an arm
utilized for 256-bit AES SIV symmetric encryption; see [below](#aes) for more
information on the `aes:crypto` core.

### Comet self-attestation

Recall that the `@p` of a comet is simply casting their 128-bit public key as a
`@p`. Since the public key of a comet is not stored on Azimuth, a comet proves
its identity with an "attestation packet". This is an unencrypted packet whose
payload contains the comet's signature created with its private key. This is the
only situation in which a ship will send an unencrypted packet. The signature is
generated with `sign:as:acru`, and thus which signature algorithm is utilized
depends on the `+crypto-core`.

Upon hearing an attestation packet, the receiving ship will generate a symmetric
key for communications with the comet, according to the [key
exchange](#key-exchange) protocol.

The fact that the first packet exchanged between a comet and another ship must
be an attestation packet is why comets are unable to initiate communication with
one another, and also why comets must be the first to initiate communication
with a non-comet.


## `zuse`

### `++ed:crypto` {#ed}

### `++aes:crypto` {#aes}


