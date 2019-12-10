+++
title = "Wallet-Generator"
weight = 24
template = "doc.html"
[extra]
category = "azimuth"
+++

The **Wallet Generator** is a planned open-source app developed for generating an [Urbit HD Wallet](../hdwallet) to secure your [Azimuth](../Azimuth) identities.  Wallet Generator will be part of the [Bridge](../bridge) software, and it's a graphical user interface that handles the entire process of creating a new [Urbit HD Wallet](../hdwallet), starting with the entropy-creation step.

The Wallet Generator must be used offline for security reasons. If an internet connection is detected at any time, the program will end, forcing the user to start from the beginning. As a final step, Wallet Generator will produce PDF files containing all of the aforementioned seeds, as well as a PDF that contains ownership Ethereum public addresses for receiving ships.
