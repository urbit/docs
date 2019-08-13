+++
title = "Using Bridge"
weight = 1
template = "doc.html"
+++

[Bridge](https://github.com/urbit/bridge) is the application we built for interacting with [Azimuth](@/docs/concepts/azimuth.md), the Urbit PKI, and managing your Azimuth identities, also known as _points_. Importantly, Bridge also allows you to generate a keyfile that you will need to boot your ship so that it can use the Arvo network.

This guide assumes that you own an Azimuth identity, or that you have found someone to send an Azimuth identity to your Ethereum address and are looking to claim it.

## Online Bridge

To connect to Bridge, type `<identity-name>.azimuth.network` into your browser, where `<identity-name>` is the name of your Azimuth identity, minus the `~`. If you were invited to claim an Azimuth identity, it's very likely that you received an email that would direct you to Bridge, and you can simply follow the hyperlink in that email.

Once you arrive Proceed through the steps presented to you. You'll eventually arrive at a page with a few choices: `Invite`, `Admin`, and `Boot Arvo`. `Admin` is the only option that you're interested in right now; click on it. On the "Admin" page, click the `Download Arvo Keyfile` button. Once you have downloaded the keyfile, you can exit Bridge ands proceed to the guide to [installing Arvo](@/docs/getting-started/installing-urbit.md).

## Offline Bridge

Alternatively, Bridge can be run locally. It's more complicated, but we recommend this option for managing sufficiently valuable assets, such as several stars or more. To install local Bridge, navigate to the [release page](https://github.com/urbit/bridge/releases/) on GitHub. Download the `.zip` file of the latest version. After you download it, follow the instructions below.

### Installation

To use Bridge:

+ Unzip the `.zip` file that you downloaded (`bridge-$version.zip`).
+ Open up your command line interface (Terminal on OSX, Command Prompt on Windows).
+ Navigate to the `bridge-$version` directory, where `$version` is the appropriate version number.
+ Run this command: `python3 -m http.server 5000 --bind 127.0.0.1`
+ You can then use the Bridge app by navigating to `http://localhost:5000` in your internet browser.

**Note:** Bridge allows you both make reads and writes to the Ethereum blockchain. Writing to the blockchain, such as changing your networking keys, will incur a transaction cost that will require you to have some ETH in your address.

Once the program is running in your browser, go through each step presented according to what kind of wallet you have. There are a few login options you'll be presented with. A notable option is **Urbit Master Ticket**. This is for those who used our Wallet Generator software. If you bought points from an Urbit sale and then used the Wallet Generator, your networking keys will be set for you. All other login options will result in you needing to set your own networking keys.

### Accept Your Transfer

If you were given points by Tlon, you likely already fully own them. But if someone sent you a point, then you will first need to use Bridge to accept that transfer.

After you access your Ethereum address, if a point was sent to that address,
you'll come to a page that has an `Incoming Transfers` header, under which is
a graphic. Click the `Details ->` link under that graphic.

Now you'll be on the management page of your point. The transfer isn't completed
yet, so click `Accept incoming transfer`. Then check both boxes and and click
their associated `Sign Transaction` and `Send Transaction` buttons.

If you already own a point, then click on the `Details ->` under your sigil in the
`Your Points` section.

### Set Your Networking Keys

If you just accepted a point, you'll be returned to your point screen. Notice that that links and buttons are now clickable. You now own this point!

Click the link that says `Set network keys`. The field that is presented in the resulting page expects a 32-byte hexadecimal string. If it's filled already, no action is required. If this is empty, you will need to generate such a string. You can generate this data any way you please, but in the terminal on MacOS or Linux, you can write

```
hexdump -n 32 -e '4/4 "%08X"' /dev/random
```

and use the result.

It should be noted that setting your network keys is an event on the Ethereum network, and will therefore cost a trivial, but non-zero, amount of [gas](https://github.com/ethereum/wiki/wiki/Design-Rationale#gas-and-fees) to complete.

### Generate Your Keyfile

From the detail page associated with your point, click the `Generate Arvo Keyfile` link and you'll be taken to a page with a field titled `Network seed`. This field should already be filled in, and should match the hexadecimal string that you entered in the previous step. If its not filled in or does not match, fill it in with the correct string.

Click `Generate ->`, which will download a keyfile onto your machine.

With that keyfile in hand, you can now exit Bridge, and continue to the guide to [installing Arvo](@/docs/getting-started/installing-urbit.md).
