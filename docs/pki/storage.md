---
navhome: /docs/
sort: 1
title: The Urbit HD Wallet
---

# The Urbit HD Wallet

On-chain Urbit assets can require many different keypairs for operation. To simplify this potentially complex process, we designed our own wallet specification. [This Urbit Proposal](https://github.com/urbit/fora-posts/blob/master/proposals/posts/~2018.11.8..19.31.59..ba77~.md) describes the spec in detail. There are no new cryptographic primitives: it's bascially a Type 2 HD wallet nested inside of a Type 1 HD wallet.

Note: As of `~2018.11` Urbit assets are not yet deployed to the Ethereum blockchain. This wallet structure is not yet in use for managing live assets.
