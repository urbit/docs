+++
title = "Operating a Star"
weight = 6
template = "doc.html"
+++
A _ship_ is an instance of the Arvo operating system that is used as a personal server on the Arvo network. Stars are a type of ship that act as infrastructure for the Arvo network. In the Arvo ship-hierarchy, stars are below galaxies and above planets.

Parallel to the Arvo network is Azimuth, the Urbit identity system that uses the Ethereum blockchain. All ships must boot with a corresponding _point_ -- an Azimuth identity -- to use the Arvo network.

Important star operations happen on both the Arvo side and the Azimuth side. On the Arvo side, these operations come in the form of Dojo commands. On the Azimuth side, operations happen by making changes to smart-contracts on the blockchain via a point.

## Powers of a Star

Stars are above planets in the network hierarchy in the sense that each star sponsors some number of planets: stars discover peers for planets, route packets for planets, provide DNS routing for planets, and push software updates to planets. A star that fulfills this is called the **sponsor** of planets that receive such services from the star; those planets, in turn, are called **dependents** of that star.

Stars are also the "parents" of planets. A new planet comes into existence only when spawned by a parent star. A parent planet is the sponsor of its children planets by default. This can change if a planet chooses to find a new sponsor (see the "Escaping a Sponsor" section below).

Planets must have a sponsor star to use most features of the Arvo network. A planet cannot boot without a sponsor, and cannot make new connections to peers as long as it is not connected to a sponsor. Planets without a sponsor will still be able to message discovered peers until any such peers change their IP addresses.

## Responsibilities

Like with real-life infrastructure, the operation of Arvo infrastructure comes with unique responsibilities. For reasons stated above, stars should be always be online on a reliable cloud service, such as Amazon Web Services or Google Cloud Platform. These systems have layers of redundancies that make them much more resilient than local machines, so stars hosted on the cloud are unlikely to leave their dependents in the dark.

## Operations

Below are some handy operations for the use and maintenance of your star.

### arvo.network DNS Records

We have a system that lets users request a domain name for their star under `arvo.network`, in the form of `shipname.arvo.network`, where `shipname` is their ship's name, so that it can be accessed remotely via our Landscape web interface. To find out how to do this, take a look at the [DNS Proxying](../dns-proxying) documentation.

### Maintaining Connectivity

Occasionally, your star might lose network connectivity due to a known timer issue or by falling out of sync with the Ethereum blockchain. When this happens, there are a few things to try:

1. Enter the `|bonk` command in the Dojo to reset the timer and restore connectivity.
2. Run `|start %eth-manage`, then `:eth-manage %look-ethnode` to ensure that your star is synced up to the latest block.

When in doubt, contact [support@urbit.org](mailto:support@urbit.org).

### Escaping a Sponsor

Planets are, of course, able to change sponsors. To do this, they must request that a different star takes them on as a dependent and that star must accept the request. Planets cannot emancipate themselves from a sponsor without having a new sponsor lined up.

All of these actions happen on Azimuth. There will be Bridge functionality to handle these actions in the future, but for now users will need to interact directly with the contracts with MetaMask, through services such as [Etherscan.io](https://etherscan.io/address/ecliptic.eth#writeContract). A sketch of the process is listed below; for now, only the Ethereum-savvy should act on these steps.

+ The planet calls the `escape` function in the Ecliptic contract and writes the resulting data to the blockchain.
+ If the chosen star wants to become the planet's sponsor, it calls the `adopt` function in the Ecliptic contract.
+ The Arvo network notices the change, and the operation is complete.
