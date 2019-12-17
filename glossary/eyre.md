+++
title = "Eyre"

template = "doc.html"
[extra]
category = "arvo"
+++

**Eyre** is the web-server [vane](../vane) that handles client-facing HTTP operations. Unix sends HTTP messages though to Eyre and Eyre produces HTTP messages in response. It is the counterpart to [Iris](../iris), which is the server-facing HTTP vane.

In general, apps and vanes do not call Eyre; rather, Eyre calls apps and vanes. Eyre uses [Ford](../ford) and [Gall](../gall) to functionally publish pages and facilitate communication with apps.

Eyre is located at `/home/sys/vane/eyre.hoon` within [Arvo](../arvo).

### Further Reading

- [The Eyre tutorial](@/docs/tutorials/arvo/eyre.md): A technical guide to the Eyre vane.
