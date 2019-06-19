+++
title = "Creating a Comet"
weight = 1
template = "doc.html"
+++

**Comets** are urbits whose names are 128-bits or 16 syllables, such as:

`~dasres-ragnep-lislyt-ribpyl--mosnyx-bisdem-nidful-marzod`

Comet names aren't quite as memorable as others, but they're disposable identities that anyone can make for free to join the live network.

## Booting a Comet

To boot your comet, go into the command line and run the following command from the directory that was created during Urbit installation:

```
$ urbit -c mycomet
```

This will take a few minutes and will spin out a bunch of boot messages. Toward the end, you'll see something like:

```
ames: on localhost, UDP 31337.
http: live (insecure, public) on 8080
http: live ("secure", public) on 8443
http: live (insecure, loopback) on 12321
~dasres_marzod:dojo>
```
