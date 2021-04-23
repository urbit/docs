+++
title = "Hosting your Urbit in the Cloud"
weight = 2
template = "doc.html"
+++

You do not have to run your Urbit from a cloud computer. Many people run theirs on their local laptop. Going off- and on-line is absolutely fine and each time your Urbit connects to the general Urbit network it will receive all incoming messages that have been pending for it. While this guide assumes you're running Urbit locally, you can easily use one of the platforms below and do your dev remotely.

## Getting a Hosting Platform
There are several options that you can choose from for cloud-hosted Linux systems, but the most common are linked below.  Get one:

**Tlon**
[Reserve your space now](https://urbit.typeform.com/to/zQ9QOV3Z#source=tlon_io).

**DigitalOcean**
1. Create a [DigitalOcean Account and Add a Project and Droplet to your Account](https://www.digitalocean.com/docs/droplets/how-to/create/#:~:text=You%20can%20create%20one%20from,open%20the%20Droplet%20create%20page.)
    * **NOTE:** You likely only need the the $10/mo (2GB RAM, 1 CPU, 50 GB SSD, 2 TB Transfer) and could even possibly get away with the $5/mo option, if you want to fiddle with the swap space.
2. Generate [SSH Keys and Add Them to Your Droplet](https://www.digitalocean.com/docs/droplets/how-to/add-ssh-keys/)
3. Connect to your [Droplet (potentially using VS Code as per this guide)](https://www.digitalocean.com/community/tutorials/how-to-use-visual-studio-code-for-remote-development-via-the-remote-ssh-plugin)

**SSDNodes**
1. Create a [SSDNodes Account and Create a Server](https://www.ssdnodes.com/)
    * **NOTE:** Again, you likely only need the minimal service they provide - choose as you see fit, though
2. Generate [SSH Keys and Connect to Your SSDNode Securely](https://blog.ssdnodes.com/blog/connecting-vps-ssh-security/)