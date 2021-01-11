+++
title = "claz"
weight = 4
template = "doc.html"
+++

This document outlines some advanced techniques for generating, signing, and sending Azimuth-related transactions from within Urbit itself. It's strongly discouraged to do this unless you're very confident as Azimuth transactions are permanent and will cost ETH to complete. However, until you upload a signed transaction to the blockchain no transaction will take place so it's safe to explore these tools. It will also be very helpful to have at least a rudimentary understanding of Hoon in order to read and modify parts of the code.

First you will want to [boot a fakezod](https://urbit.org/using/develop/#creating-a-development-ship). You can do this with your live running ship but at this time this will need you to modify the code so it's best to do this on a ship you can make mistakes on.

Be sure to have mounted your home desk so you can easily edit files on it.
The first edit that will probably need to be made is in [`app/claz.hoon`](https://github.com/urbit/urbit/blob/master/pkg/arvo/app/claz.hoon#L14). The listed url will need to be changed to a valid Ethereum endpoint. infura.io provides an Ethereum API that you can use.

The second change that may potentially be needed is to modify the [gas limit](https://github.com/urbit/urbit/blob/master/pkg/arvo/app/claz.hoon#L179). This number here is the maximum number of gas units that will be used. In future this will be configurable but for now you may need to change this manually. For a guide to what to set it to you can use the [constants in bridge](https://github.com/urbit/bridge/blob/master/src/lib/constants.js#L23) as a guide based on what action you are going to be performing. The maximum cost of your transaction will be the maximum gas units multiplied by the gwei you're going to set later. You'll need at least this much in your account.

Once you have made these changes be sure to run `|commit %home` to get them into your ship.

Next run `|start %claz` after which you'll be able to generate transactions.

```
:claz [%generate %/spawn/eth-txs %mainnet author %single %spawn ~ship to]
```

Here we have an example of generating a transaction to spawn a ship. Something to note is that for this to be successful you'll need to actually have the right to spawn the ship in question. Let's break down the command.


`%generate` is how all commands to `claz` are going to start.

`%/spawn/eth-txs` is simply the path for the output file

`%mainnet` specifies which network this is going to sent out on. Other options are possible including the test-net `%ropsten`.

`author` here is an Ethereum address that is issuing the transaction. It will need to be written in `@ux` notation, e.g. `0x3b17.d097.d9dd.711e.4ef8.517a.bbf1.8b2b.a643.81fe`.

`%single` specifies what kind of batch that will be created. If you are going to do multiple transactions you will need to either set this to `%more` and create a list of batches or upload them before generating the next one. The reason this ship needs to have internet access is because it needs to look up the nonce for the specified address.

`%spawn` is the command we want to issue. After this what the arguments are will vary based on the command.

`~ship` will be the ship to be spawned.

`to` is the Ethereum address to spawn the ship to.

You will want to read `sur/claz.hoon` which you can find [here](https://github.com/urbit/urbit/blob/master/pkg/arvo/sur/claz.hoon).
This will contain more details about the various kinds of transactions you can perform particularly `++call`

After running this command you should find a csv file at the specified path. You can examine this file to learn how they are constructed. You are able to modify the nonces, gas limit and price without changing the function of the transaction but it's not important for this guide. 

This file can now be signed and uploaded. At this point, you can transfer this file to an airgapped machine which has your keys, if you want. If you choose to do that you will need to download the `urbit` binary as well as the most recent pill file or a copy of the fakezod pier you have already booted.

For this guide, we'll continue on the same ship.

Run `|start %eth-sender` and then you can use it to sign the transaction file.

```
:eth-sender [%sign %/spawn-signed/txt %/spawn/eth-txs %/mykey/txt ~[40 80]]
```

Let's break this down again.

`%sign` is the action we are going to perform here. `eth-sender` can also be used to submit batches of transactions to the network in various ways, but details on that are outside of the scope of this guide.

`%/spawn-signed/txt` is the path to the output file.

`%/spawn/eth-txs` is the path to the transaction file we generated earlier. It will need to be accessible so don't forget to `|commit %home` if you moved it to a different pier.

`%/mykey/txt` is the path to your private key file. It should contain your private key beginning with 0x and followed by a hex string with no dots, and where capital letters are fine. This file is most likely the reason you will want to use an airgapped machine so that your private key never touches a networked computer. Opsec is left to the reader.

`~[40 80]` is a list of possible gwei costs; a signed transaction file will be created for each one listed. Here we just specify 40 and 80 gwei. You may need to use the higher value based on current Ethereum network traffic and average gas costs.

Now you should have a directory in your pier that contains one file for each of the specified gwei costs.

To actually transmit the transaction, paste the contents of one of these files into https://etherscan.io/pushTx or whatever other transmission system you would like to use. **This is the action that will actually cost you ETH and perform the transaction on the network. Only do this step if you want to actually perform the action.**
