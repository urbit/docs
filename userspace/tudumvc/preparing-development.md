+++
title = "Preparing to Develop"
weight = 3
template = "doc.html"
+++

# Introduction {#introduction}
Each chapter of this tutorial, including this one, will include the following sections:
* Required Files
  * _The final product of the lesson - inclusive of Earth web app and hoon files, where appropriate._
* Learning Checklist
  * _A list of things you should know or understand by the time you complete the chapter._
* Goals
  * _A list of things you will be able to do on your own by the end of the chapter._
* Prerequisites
  * _What you'll need to complete the chapter._
* Chapter Text
  * _The actual contents of the specific chapter._
* Additional Materials
  * _Things to read or do, in addition to the chapter itself, for enrichment._
* Exercises
  * _Tests for understanding of the material covered - the difficulty of these exercises will vary._
  * _When the difficulty is really high, the tutorial will include a breakout lesson that will walk you through the exercise, but you should try it on your own first!_
* _Optional_ Breakout Lessons
  * _Some of the chapters will include optional breakouts of complex subjects into sub-chapters._
  * _It is not necessary to complete these optional chapters to progress through the tutorial, but if you want to learn more, these will be there for you. Enter if you dare._

While it's possible to develop on a live Ship, it's highly discouraged for a variety of reasons. Instead development should be done on a test instance of an urbit, also known as a Fake Ship. This chapter will discuss setting up a Fake Ship for development purposes, and establishing up an efficient workflow using this Fake Ship. If you're already familiar with Urbit, you might be able to skim this lesson, but you should at least give it a once over before proceeding.

## Required Files {#required-files}
* Download the full [repo of this tutorial to your Urbit host](https://github.com/rabsef-bicrym/tudumvc).
  * Use `git clone https://github.com/rabsef-bicrym/tudumvc` to pull a copy of the required files for this tutorial.
  * These files will be used in subsequent chapters of this tutorial.

## Learning Checklist {#learning-checklist}
* How is an Urbit ship launched?
* What is an efficient workflow for developing on Urbit?
* What additional materials are needed for completing this tutorial?
* What will the `%tudumvc` end product design look like?

## Goals {#goals}
* Create an Urbit development environment.
* Backup the development environment, allowing for restoration of a clean Fake Ship should the existing one break during development.
* Access source materials quickly and efficiently from the local development environment.
* Use a Fake Ship for simple things like logging into Landscape.

## Prerequisites {#prerequisites}
* A copy of the `%tudumvc` repository.
* You will need some things _from_ this lesson to continue forward, but we're going to tell you how to get those things.
* An assumed-minimal knowledge of using Linux or search-engine proficiency to self-help where some Linux terminology may be confusing or not fully explained.

## Chpater Text {#chapter-text}
[Urbit](https://urbit.org/understanding-urbit/) is a virtual personal server that runs on *nix (Unix based platforms, like MacOS, Linux or the Windows Linux Subsystem). The binary, or program, that makes Urbit work has to have an appropriate *nix environment on which to run. Developing for Urbit on a Linux or MacOS host system is easy, but not necessary

There are many options for Urbit hosting including a local MacOS or Linux computer, [the Linux subsystem for Windows box](https://subject.network/posts/urbit-wsl2/), or even a [Raspberry Pi](https://botter-nidnul.github.io/Steps_to_Urbit_on_Raspberry_Pi.html). Running Urbit in the cloud is also viable; check out this brief [breakout lesson](@/docs/userspace/tudumvc/breakout-lessons/hosting-options.md) for more details.

### Installing the Urbit Binary
The best way of getting always-up-to-date instructions is by referencing urbit.org's tutorial [here](@/getting-started/_index.md). This tutorial will assume the Urbit binary is installed at `~/urbit` on the chosen host system.

**NOTE:** Creating an `~/urbit` directory is optional, but the current tarball unpacks all of its files directly to its parent directory, so it's helpful for containing the files.

### Booting a Fake Ship {#booting-a-fake-ship}
While real Urbit IDs are [_owned_ by an individual](https://urbit.org/blog/the-urbit-address-space/) (or perhaps a [collective](https://dalten.org/)), when booting a Fake Ship, any ID will do. This tutorial will use the galaxy-class ship `~nus`, and later `~zod`, but any ID would do - even `~rabsef-bicrym`, or (quite literally) any of the millions of other valid Urbit ID. `~nus` could be booted using the following command from where the Urbit binary was unpacked:
```
urbit -F nus
```

The ship will take a few minutes to boot, while the ship downloads additional data (pill(s)) and bootstraps itself.  You'll see something like this:
```hoon
~
urbit 1.0
boot: home is /home/new-hooner/urbit/nus
loom: mapped 2048MB
lite: arvo formula 79925cca
lite: core 59f6958
lite: final state 59f6958
loom: mapped 2048MB
boot: protected loom
live: loaded: MB/110.182.400
boot: installed 286 jets
vere: checking version compatibility
ames: live on 31499 (localhost only)
http: web interface live on http://localhost:8080
http: loopback live on http://localhost:12321
pier (48): live
~nus:dojo> 
```

From here, the Urbit can be:
* Shutdown using `CTRL+D` (normal shutdown) or `CTRL+Z` (crashing shutdown).
* Restarted thereafter using just `urbit nus` (**NOTE:** the `-F` switch is no longer needed after first boot).
* Switched between the dojo (which is like the command prompt for Urbit) and  the `chat-cli` (or the terminal chat client for Urbit) using `CTRL+X`.
* Accessed through Landcape using the IP address of the ship's host system and the port number to which it has bound:
  * The ship's currently bound port number is noted in the boot sequence.
  * In the above sequence, port 8080 is bound, see:

    `http: web interface live on http://localhost:8080`

With a fake ship running, it can be accessed through [Landscape](https://urbit.org/docs/glossary/landscape/) at the web interface address from above. The password for logging in to Landscape can be found by entering `+code` in dojo.

The following steps make this setup more convenient for development:

### Prepare for Development {#developing-on-urbit}
On a live ship, a breaking mistake risks having to [breach the ship](https://urbit.org/using/id/tutorial-to-breaches/) and boot from the ground up. In contrast, a Fake Ship can be backed up in the freshly booted state and infinitely restored and rebooted.

Making a backup of a fake ship is easy - but we want to get it into an ideal state before backing it up:

#### Mount the Filesystem
The filesystem of Urbit is not immediately visible from the *nix host filesystem. It needs to be mounted to *nix to be made available to edit/change during development. 

After booting our Fake Ship for the first time, mount the file system by entering `|mount %` in the dojo.
```hoon
> |mount %
>=
~nus:dojo> 
```

Shutting down the ship (using `CTRL-D`), and navigating to the pier folder in *nix, there will be a /home folder that contains its own sub folders; /app, /gen, /lib, /mar, /sur, /sys, /ted, and /tests. These sub-folders can also be found by entering `+ls /===` in dojo:
```hoon
> +ls /===
app/ gen/ lib/ mar/ sur/ sys/ ted/ tests/
~nus:dojo> 
```

If you'd like to know more about what's going on with the filesystem from the Urbit side, take a look at this [breakout lesson on Urbit's filesystem, `%clay`](@/docs/userspace/tudumvc/breakout-lessons/a-brief-primer-on-clay.md). This breakout is relatively deep for a beginner, and you don't need to know all of this to proceed (but it can't hurt!).

**NOTE:** Changes to the filesystem made on the *nix side will not immediately be reflected in our urbit. Instead, they need to be 'committed' to Urbit using `|commit %home`, which "uptakes" those changed *nix side files into the %clay filesystem.

#### Create a Backup
With the Fake Ship in pristine working order, we'll make a backup from the *nix shell using `cp -r nus nus-bak`. This copy can now be restored should we make any breaking changes along our development path. If the running version of `~nus` breaks, simply erase it (`rm -r nus`) and replace it (`cp -r nus-bak nus`).

To preserve development files, we'll use a bash script to sync development files from a folder separate to the pier to the ship, so that the ship can be broken with impugnity, replaced with a backup and resent the (now corrected) development files to the new Ship copy.

#### Add a Development Folder
Creating a Development folder and a bash script to copy the development files to the Fake Ship is simple. Development in this way affords free reign to blow up the pier directory, replace it with a backup and restart the copy routine. Our Development routine will work like this:
   * Creating a folder (`mkdir <folder-name>`) to hold development files. This tutorial assumes a dev folder of `~/urbit/devops` and a Fake Ship pier of `~/urbit/nus`.
      * Within `~/urbit/devops`, creating an /app, /sur, /mar, /gen and /lib folder, to mirror those same folders found in the Fake Ship's pier's /home directory.
   * Creating a shell script file like [this script, found in the supplemental folder of the repo you downloaded above](https://github.com/rabsef-bicrym/tudumvc/blob/main/supplemental/dev.sh) that takes a directory as an argument and `rsync`s the contents of the /devops folder to the Fake Ship's /home directory.
   * Using two terminal session to boot the urbit in one and start up the shell script in the other. Assuming the above configuration, the script would be started with `bash dev.sh ~/urbit/nus/home`, resulting in a configuration that will look something like this:
   
      ![Image of Dev Environment](@/docs/userspace/tudumvc/devops.png)

If you're following along on your own, you can test your functionality by trying to install a simple Towers of Hanoi generator - check out this [breakout lesson](@/docs/userspace/tudumvc/breakout-lessons/towers-of-hanoi.md). 

### Downloading this Repository
Again, if you want to follow along with this tutorial, in some folder of your development environment (not your pier), run `git clone https://github.com/rabsef-bicrym/tudumvc.git` in your computer's shell to make a copy of the repository. This will make it very easy to copy files into your /devops folder as you move forward.

## Additional Materials {#additional-materials}
* Read about [how cores work](https://urbit.org/docs/hoon/hoon-school/arms-and-cores/).
  * Writing Hoon Cores will be central to the rest of this tutorial, and having some background will be of great utility.
* Read about [generators and how to install files to your Urbit](https://urbit.org/docs/hoon/hoon-school/setup/#generators).
  * This reading supplements understanding about Hoon Cores, as well as development processes.
* Make sure your syncing functionality is working by adding a file or [generator](@/docs/userspace/tudumvc/breakout-lessons/towers-of-hanoi.md) to the /devops sub-folders and syncing it over to your ship. Make sure you can see the file copied over into your home directory.

## Exercises {#exercises}
* Write the generator as described in the Homework reading and sync it to your ship using our sync method.
**OR**
* Make sure your syncing functionality is working by adding a file or [generator](@/docs/userspace/tudumvc/breakout-lessons/towers-of-hanoi.md) to the /devops folders and syncing it over to your ship. Make sure you can see the file copied over into your home directory.

## Summary and Addenda {#summary}
We're ready to begin development work on Urbit. There are several things you might want to know or do before continuing to the next chapter, such as:
* [How to a ship that has data from the live network, also known as an `-L` ship](@/docs/userspace/tudumvc/breakout-lessons/L-ships.md).
* [How to the /devops sync functionality described in this lesson](@/docs/userspace/tudumvc/breakout-lessons/towers-of-hanoi.md).
* [How %clay works generally](@/docs/userspace/tudumvc/breakout-lessons/a-brief-primer-on-clay.md).

These optional addenda aren't necessary to continue, but you should:
* Know how to boot an Urbit ship.
* Know how to use our development workflow, including:
  * Using the sync function to move files from our development folder to our ship.
  * Erasing the existing dev ship and replacing it with the backup, clean dev ship.
* Have access to the tutorial's materials (either locally or just on GitHub).