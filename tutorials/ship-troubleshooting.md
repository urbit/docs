+++
title = "Ship Troubleshooting"
weight = 8
template = "doc.html"
aliases = ["docs/using/ship-troubleshooting/"]
insert_anchor_links = "right"
+++

Urbit is still in the development stage, so there's a chance that your ship won't start properly, or will stop working properly when you're running it. That's ok! This document is intended to help you in such an event.

This page contains resolutions to many of the most commonly encountered issues.
If your issue is not covered here, please check out our [Troubleshooting Knowledgebase](https://github.com/urbit/support/wiki).

## Table of Contents

- [Best practices](#best-practices)
- [Operation issues](#operation-issues)
- [Connectivity issues](#connectivity-issues)
- [Booting issues](#booting-issues)
- [Crashing issues](#crashing-issues)

## Best Practices {#best-practices}

An ounce of prevention is worth a pound of cure, so let's first go over some best practices to keep your ship in working order.

### Only boot with your keyfile once

Once your ship is booted with your keyfile, you should never use that same keyfile again. If you do boot with the same keyfile twice, any other ship on the network that your ship has communicated with will not be able to talk to your ship.

If you accidentally booted with the same keyfile twice, the only remedy is performing a [personal breach](#personal-breach), which is explained in the next section.

### Do not delete your pier

Urbit is stateful, meaning that it needs to hold onto all your data. If you delete your pier and start your ship again, you won't be able to talk to any ship you've talked to before. The only solution to this is performing a [personal breach](#personal-breach)

### Keep track of the directory that you put your ship in

When you first start your ship, you should make sure you put it a place where you can find it again and where it won't get accidentally deleted. Remember that you must perform `|mount %` in your ship's Dojo to make your ship visible as a directory in the Unix file system.

### Keep up-to-date builds

Check for latest Urbit version at https://github.com/urbit/urbit/releases. If you're behind, update using [this guide](@/using/install.md#updating).

### `|hi` your star to see if you're connected

Find out who your star is by running `(sein:title our now our)` in the Dojo. Then, run `|hi ~star`, where `~star` is the star's name, and if things are working properly, you should get the message `hi ~star successful`. It could also be helpful to use `|hi` to check connectivity with `~zod` or another planet that you're in a Chat channel with.

### Turn your ship off and on again

Use `ctrl-d` to gracefully exit your ship, and then start it again. This can solve many issues.

### Use the `|knob` command to customize your error messages

Error messages can be by overwhelming, so the `|knob` command is intended to remedy this. It's used to silence errors that aren't important.

The command takes two arguments, and comes in the form of `|knob %error-tag %level`.

`%error-tag` is the name of the error in question. It's usually printed at the top of the stack trace, such as in `crud: %hole event failed` -- `%hole` here is an example of an error tag.

`%level` determines how much you will see of errors with your chosen `%error-tag`. There are three levels:

- `%hush`: no output.
- `%soft`: one line of output, just containing the error tag.
- `%loud`: full output.

So for example, to silence all Ames packet-related errors, try `|knob %hole %hush`.

### Perform a personal breach. {#personal-breach}

A personal breach is when a ship tells all the other ships that have communicated with it to treat it as though the ship was just started for the first time again, since everyone on the network has forgotten about it.

Personal breaches often fix connectivity issues, but should only be used as a
last resort. To find out how to perform a personal breach, check out our [Guide
to Breaches](../guide-to-breaches). Before taking such a drastic measure, try
other methods in this guide. You can also ask for help on
in the Help channel in the Urbit Community group at `~bitbet-bolbel/urbit-community` or, failing that, in the `#ship-starting-support`
channel in our [Discord server](https://discord.gg/n9xhMdz).

### Reset `+code`

You login to Landscape using the camel-case phrase obtained from dojo by
entering `+code`. For security reasons you may wish to change this code
regularly. You may do so by entering `|code %reset` into dojo. Doing this
will prevent [Bridge](@/docs/glossary/bridge.md) from being to derive your code,
meaning you will only be able to check it from dojo in the future.

## Operation Issues {#operation-issues}

### My urbit is very slow

Run `|wash-gall`. This clears caches in Gall, and may result in steep performance improvements.

### My urbit is frozen

Sometimes this happens if you're processing a very large event, or if you're in an infinite loop, or for a variety of other reasons.

Before doing anything, try waiting for a minute: an event might finish processing. If it doesn't clear up, then use the Unix kill-command, `ctrl-z`, to end your ship's process. Then restart your ship.

### When I try to type into the Dojo, it prints `dy-noprompt`

This happens when your Dojo is waiting on a request, such as an HTTP request. You can fix it simply by typing `backspace` or (`delete` on Mac).

### My ship doesn't recognize file changes that I make in my pier

Since version `0.8.0`, changes no longer automatically sync between the Unix side (your pier) and your ship. To sync your file changes, you must run `|commit %desk` in your Dojo, where `%desk` is the desk you'd like to sync.

## Connectivity Issues {#connectivity-issues}

### I can't communicate with anyone

You may have booted a ship with your keyfile twice in the same era. To fix this, you must perform a [personal breach](#personal-breach).

### I don't have the latest OTA

You can check what build your ship is on by entering `+trouble` into dojo and
reading the `%base` hash. If this does not match the latest hash published in
the `urbit-dev` mailing list, you are behind.

Your sponsor may just be lagging behind, so sometimes this will resolve on its
own with patience. Otherwise, try the procedure outlined [here](https://github.com/urbit/support/wiki/Missing-OTA).

### I keep getting an `ames` error stack-trace

You may see a message like this one: `/~zod/home/~2019.7.22..18.55.46..83a3/sys/vane/ames:<[line column].[line column]>`. This is a clay path to a Hoon file, pointing to the line and column where an expression crashed. This kind of error might be accompanied by a `crud` message.

This means that another ship is sending invalid packets to you. This could be because one of the ships has not updated the other ship's "life number", which is the number that starts at one and increments every time that ship performs a personal breach.

This can happen if they have the wrong keys of yours, or if you have the wrong keys of theirs. You can figure out who has the wrong keys by running this scry command in your dojo: `.^(* %j /=life=/shipname)`, where shipname is the other ship's name. Save that information. Then, go to the [Azimuth contract on Etherscan](https://etherscan.io/address/0x223c067f8cf28ae173ee5cafea60ca44c335fecb#readContract), scroll down to `32. points`, and put in the hexadecimal representation of the other ship's `@p`. You can find the hexadecimal representation by running ...

```
`@ux`~sampel-palnet
```

... in the Dojo, where `~sampel-palnet` is the other ship's name. Then, compare it to the scry information that you saved. If that information matches up, it means that the other ship is the problem. If it **doesn't** match up, your ship has wrong information about the other ship. If you have such wrong information, you can fix this by running:

```
:azimuth-tracker|listen ~ %app %azimuth-tracker
```

The last line above syncs from an Ethereum node for _all_ ships on the network. If you only wanted to sync with certain ships, run:

```
:azimuth-tracker|listen ~[~sampel-palnet ~zod ~marzod] %app %azimuth-tracker
```

`~sampel-palnet ~zod ~marzod` are example ship-names; replace these with any number of desired ships-names.

The above commands work if you have the wrong keys of other ships. If other ships have wrong keys of _yours_, you need to somehow ask them to to run such a command.

### I can talk to some ships, but I can't talk to my sponsor and some other ships

This is the result of deleting your pier and starting your ship again. To fix this, you must perform a [personal breach](#personal-breach).

## Booting Issues {#booting-issues}

### My ship booted for the first time, but it turned into a comet instead of my planet or star

You may have used the wrong arguments when booting your ship for the first time. Delete this comet and try again.

### My development ship ("fakezod") gets a `boot: malformed` failure

This means that you gave your development ship an invalid `@p`. So, you will get this error if you write, for example, `urbit -F zodzod` instead of `urbit -F zod`.

## Crashing Issues {#crashing-issues}

### I got a `bail` error and my ship crashed

Try bringing it back up; it will often start working just fine again.

However, if you get a `bail` error again, you should perform a [personal breach](#personal-breach).

#### Making a GitHub issue out of your `bail`

You can get help with you problem by creating an issue at [github.com/urbit/urbit](https://github.com/urbit/urbit/issues). But to make a good issue, you need to include some information.

When your urbit crashes with a `bail`, you'll probably get a core dump, which is a file that contains the program state of your urbit when it crashed. On Mac, core dumps can be found in `/cores`. On Linux, cores can often be found in `/var/crash`, or the home directory.

Navigate to the folder containing your core dumps. Find the most recent core dump by looking at the dates after you run `ls -l`. Then `lldb -c <corename>`. Once that loads, you'll be at an `(lldb)` prompt; type `bt` at this prompt. This will create a stack trace that looks like this:

```
(lldb) bt
* thread #1, stop reason = signal SIGSTOP
  * frame #0: 0x000000010583d871 urbit`_box_free + 17
    frame #1: 0x0000000105845ee6 urbit`u3j_boot + 182
    frame #2: 0x000000010584d1f9 urbit`u3m_boot + 89
    frame #3: 0x000000010583d15d urbit`main + 2765
    frame #4: 0x00007fff75cb83d5 libdyld.dylib`start + 1
(lldb)
```

Copy this stack trace and include it in your GitHub issue.

### My ship crashed with a `bail: meme` error.

This means that your ship ran out of memory.

1. Make sure you are running the latest binary if you are not already on it.

2. Restart your ship. If you don't crash again, everything may be fine.

3. Try the procedure outlined [here](https://github.com/urbit/support/wiki/ship-exits-with-a-bail:-meme-error).

4. If you **do** crash again, then you should perform a [personal breach](#personal-breach).

### My ship crashed with a `bail: oops` error

Restart your ship. These issues often just go away on their own. If this error repeats after restart two or more times, post the messages in an issue at [github.com/urbit/urbit](https://github.com/urbit/urbit/issues).

This same error might also appear with a message like `Assertion '0'`.

### My ship crashed with an `pier: work error` error

This means that the Urbit worker process has shut down for one reason or another. Just restart your ship; this is not a notable or reportable error.
