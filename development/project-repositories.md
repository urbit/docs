+++
title = "Project Repositories"
weight = 30
template = "doc.html"
+++

Here's a breakdown of the various repositories the project comprises. All of
our code is hosted on GitHub, so you can of course peruse it there at
[https://github.com/urbit](https://github.com/urbit).

### Urbit

Urbit OS, the Landscape interface and Vere are all contained in one monolithic
repository that can be found [here](https://github.com/urbit/urbit). The repo is
large, so here's some links to its various high-level components

- [Arvo](https://github.com/urbit/urbit/tree/master/pkg/arvo): the part of the
  urbit repo that contains Arvo, the Urbit OS.
- [Vere](https://github.com/urbit/urbit/tree/master/pkg/urbit): the part of the
  urbit repo that contains the C and Haskell interpreters.
- [Landscape
  interface](https://github.com/urbit/urbit/tree/master/pkg/interface): the part
  of the urbit repo that contains the interface code for Landscape.
  - [Issue Tracker](https://github.com/urbit/landscape/issues): the Landscape issue
    tracker is a separate repository.
  
### Urbit ID

- [azimuth](https://github.com/urbit/azimuth): the public-key infrastructure
  (PKI) that implements Urbit ID, live on the Ethereum blockchain.
- [bridge](https://github.com/urbit/bridge): an application for interacting with
  Azimuth that can be accessed at [bridge.urbit.org](https://bridge.urbit.org).
- [urbit-key-generation](https://github.com/urbit/urbit-key-generation): a javascript library for key derivation and HD
  wallet generation functions.
- [sigil-js](https://github.com/urbit/sigil-js): a javascript library for
  generating sigils.

### Content

- [urbit.org](https://github.com/urbit/urbit.org): the source for the urbit.org
  website.
- [docs](https://github.com/urbit/docs): the source for the documentation that
  you're currently reading.
  - *Note:* the documentation is loaded into the
    [urbit.org](https://github.com/urbit/urbit.org) repo as a submodule.

### Community

The best way to keep track of the various community projects is via our
[**awesome-urbit**](https://github.com/urbit/awesome-urbit) repository.
