+++
title = "Claims"

template = "doc.html"
[extra]
category = "azimuth"
+++

The **Claims** [Azimuth](../azimuth) contract allows Urbit identities to make publicly visible assertions about their owner. Such assertions are most commonly about the owner's identity, real-world or otherwise. A claim has three fields: the claim itself, the _protocol_, and the _dossier_.

The claim itself is what you're attempting to assert the identity of, as in `@JohnDoe` for a Twitter account, or `1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa`

The _dossier_ is the proof of a claim. It could be something like a link to a tweet from a known Twitter account saying, "Hi! I'm ~lodleb-ritrul on Azimuth," or, in the case of cryptocurrency, claim itself signed with the relevant private key.

The _protocol_ indicates what kind of thing of the claim is. `Twitter` for a Twitter account, and `Bitcoin` for a Bitcoin address.

Points are limited to a maximum of 16 claims. It's good practice to remove any claims associated with a ship when it is about to be transferred to a new owner.

### Further Reading

- [The Claims contract](https://github.com/urbit/azimuth/blob/master/contracts/Claims.sol): The code on GitHub.
