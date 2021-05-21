+++
title = "Cryptography"
weight = 6
template = "doc.html"
aliases = ["/docs/learn/vere/jetting/"]
+++

All cryptographic primitives utilized by Arvo are
[jetted](@/docs/vere/jetting.md). This is done for performance-related reasons
in other parts of the system, but for cryptography this is also extremely
important because it allows us to utilize standard reference implementations for
the primitives written in C.

All jets related to encryption may be found in `pkg/urbit/jets/e/`.

In this section we review what specific implementations are utilized.

### Ed25519 {#ed}

Urbit implements [Ed25519](http://ed25519.cr.yp.to/) based on the SUPERCOP
"ref10" implementation. Additionally there is key exchanging and scalar addition
included to further aid building a PKI using Ed25519. All code is licensed under
the permissive zlib license.

All code is pure ANSI C without any dependencies, except for the random seed
generation which uses standard OS cryptography APIs (CryptGenRandom on Windows,
`/dev/urandom` on nix).

### AES SIV {#aes}

The library we utilize for AES SIV is an
[RFC5297](https://tools.ietf.org/html/rfc5297)-compliant C implementation of
AES-SIV written by Daniel Franke on behalf of [Akamai
Technologies](https://www.akamai.com). It is published under the [Apache License
(v2.0)](https://www.apache.org/licenses/LICENSE-2.0). It uses OpenSSL for the
underlying [AES](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard) and
[CMAC](https://en.wikipedia.org/wiki/One-key_MAC) implementations and follows a
similar interface style.

While the jets are found in `pkg/urbit/jets/e`, the statically-linked package is
found at `pkg/libas_siv/`.

