+++
title = "Cryptography"
weight = 10
template = "doc.html"
+++

Cryptography is central to the operation of Urbit. This section gives an
overview of where cryptographic methods are utilized in Arvo, what they are, and
how they are implemented.

There are five parts of the system involved with cryptography on Urbit. We
summarize each component here briefly, and then continue with a more detailed
exposition below.

[Ames](@/docs/arvo/ames/ames.md) is Arvo's networking vane. Associated to each
flow is a `+crypto-core`, an interface core into which one of the cryptosuites
in `zuse` may be implemented. The suite utilized by the `+crypto-core` is used
to encrypt all communications over the corresponding flow.

`zuse` is the Hoon standard library. It contains cryptographic primitives which
may be utilized by an Ames `+crypto-core`. All cryptographic primitives are
[jetted](@/docs/vere/jetting.md) in Vere with standard implementations of cryptographic
libraries.

[Vere](@/docs/vere/_index.md) is Urbit's Nock runtime system, written in C.
Correct implementation of cryptographic libraries is difficult, and so all
cryptographic primitives implemented in Hoon actually hint to the interpreter to
run vetted cryptographic libraries reviewed by experts.

[Jael](@/docs/arvo/jael/jael-api.md) is utilized for the safe storage and
retrieval of private and public keys utilized by Ames and Azimuth.

[Azimuth](@/docs/azimuth/_index.md) is Urbit's Ethereum-based public key
infrastructure.


