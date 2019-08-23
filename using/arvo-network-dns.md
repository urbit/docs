+++
title = "Arvo.network DNS"
weight = 2
template = "doc.html"
+++

We have a system that lets you request a domain name for your ship in the form of `ship.arvo.network`, where `ship` is your ship's name minus the `~`. This allows users to access their ships remotely using Landscape, our graphical web interface.

Stars and planets follow the same process DNS proxying process, and galaxies have their own requirements. Moons and comets are not supported.

## Planets and Stars

For a planet or star's DNS proxying request to be made and fulfilled, they must be hosting their ship someplace with a public IP address, and its HTTP server must be listening on port 80.

To get `ship.arvo.network` on a planet or star, you must set up DNS routing with its parent ship by starting the `:dns` app.
To do so, simply run this command in your ship's Dojo:

```
> :dns|request
```

You'll then be prompted to enter the public IP address of your ship. You can also pass the IP address as an argument, using the .0.0.0.0 (`@if`) syntax. For example:

```
> :dns|request .1.2.3.4
```

`:dns`, running locally, will make an HTTP request to that IP address on port 80 to confirm that it is itself available at that IP and port. If that fails, you'll receive a `%bail-early` message in `:talk`; this request will retry a few times. If the self-check is successful, the request is relayed to `~zod`, and you'll receive a message saying, `request for DNS sent to ~zod`. Once `~zod` has acknowledged receipt of the request, your local `:dns` app will send a `:talk` message saying `awaiting response from ~zod`.

The request will be picked up shortly, and the `ship.arvo.network` DNS record will be set to the given IP address. Once that's setup, `~zod` will be notified, and `~zod` will, in turn, notify your ship. That ship will now try to verify that it can reach itself on `ship.arvo.network` over port 80. If it can't, it'll send a message saying `unable to access via ship.arvo.network`. If it can, it will configure itself with that domain, and say `confirmed access via ship.arvo.network`.

Great! You're set up now. Try accessing your `ship.arvo.network` in your browser to use Landscape; we recommend using Chrome or Brave.

## Galaxies

Galaxies are already required to have separate DNS entry at galaxy.urbit.org. There's no automated process for getting that binding, so if you're a galaxy-holder, get in touch with us at support@urbit.org.

There is a command for galaxies that will try to re-use their already-necessary Ames DNS entry for HTTPS:

```
> :dns|auto
```

This will make HTTP-requests to self-check availability over `galaxy.$AMES-DOMAIN` (currently galaxy.urbit.org), where `galaxy` is the galaxy's name minus the `~`.

Otherwise, `:dns|auto` works the same as `:dns|ip` does with stars and planets: if it's available or unavailable, talk messages, and so on.

## More Information

Configuring a ship's domain causes the `:acme` app to request an HTTPS certificate for that domain from LetsEncrypt. Note that LetsEncrypt also requires that the HTTP server be listening on port 80. If the certificate request fails, `:acme` will send a `:talk` message with an explanation. Once the certificate is successfully retrieved, `:acme` will install it, causing the HTTP servers to restart. A secure server will be started on port 443 (the HTTPS default) if it's available. Otherwise, it will try 8443, and then increment to the next port until it can successfully bind one.

The built-in logic for listening on port 80 similar. Urbit tries to bind port 80; if it cannot, it tries 8080, then increments until it can bind a port. Port 80 is available to unprivileged process on recent version of macOS. Otherwise, the process needs to either be run as root, or be given special permission (CAP\_NET_BIND on Linux).
