+++
title = "OTA Updates"

template = "doc.html"
[extra]
category = "arvo"
+++

[Ships](../ship) have the ability to upgrade themselves **over the air**. They receive updates from a sponsor [star](../star) or [galaxy](../galaxy).

By default, you will automatically receive updates (OTAs) from your sponsor. To check your OTA source, run `|ota` in the [dojo](../dojo).

If for some reason (for example, if your sponsor is out of date), you can switch OTA sources by running `|ota ~otasrc %kids` in the dojo, where `~otasrc` is the ship from which you want to receive updates. It is a good idea to contact the source ship and ask permission to sync from them.

If OTAs are not succeeding, or if you are on an version of Urbit before the `|ota` command was introduced, you can run `|merge %kids (sein:title our now our) %kids, =gem %that`. **Warning:** this will wipe out any documents in the publish app, as well as any custom code. It will leave chats, links, and group memberships intact.