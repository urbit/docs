+++
title = "Developer's Guide"
description = "How to get started developing on Urbit."
weight = 3
template = "page_indiced.html"
aliases = ["/docs/using/creating-a-development-ship/", "/docs/getting-started/contributing"]
+++

You can develop on Urbit in three ways:

- [Applications using Urbit](#api), which use Urbit as the back-end to store data and communicate with others
- [Urbit Applications](#application), which are written in [Hoon](/docs/glossary/hoon/), and run as part of Urbit
- [Urbit Core](#core), which involves contributing to Urbit's operating system ([Arvo](https://github.com/urbit/urbit/tree/master/pkg/arvo)) or runtime ([Vere](https://github.com/urbit/urbit/tree/master/pkg/urbit))

This guide will start by getting you set up to run an Urbit ship, and then tell you everything you need to know to do either.

### Setting up your environment

We assume you’ve gotten a basic introduction to Urbit. If you haven’t, read the [Understanding Urbit](@/understanding-urbit/_index.md) series.

Once you’re ready, you can get started on the network right away and take some first steps, without acquiring an identity, by [creating a comet](@/using/install.md#comet).

When developing, however, we recommend [booting a development ship](#creating-a-development-ship) and working locally -- you may need to make changes that could, in the wrong hands, destroy the ship’s environment, and it’s best to do so in a safe, separate place.

## Applications using Urbit {#api}

Urbit ships with its own set of apps written in its own language, Hoon. However it is also meant to integrate with applications written in other languages via an API. The clearest example of an application using Urbit is Landscape, the default client. Although it does currently ship with Urbit, its front-end is a separate piece of software that uses Urbit's HTTP APIs to interact with an Urbit ship. You can create your own application that uses Urbit to store data and interact with other Urbit ships without writing any Hoon code thanks to Urbit's HTTP APIs. This could be a chat client, a writing app, a game, or anything else that can communicate over HTTP.

To get started quickly with the language of your choice, see the following libraries that provide HTTP interfaces to Urbit:

 - [Python](https://github.com/baudtack/urlock-py) (Stable)
 - [Swift](https://github.com/dclelland/UrsusAirlock) (Under development)
 - [Haskell](https://github.com/bsima/urbit-airlock) (Under active development)
 - [JavaScript](https://www.npmjs.com/package/urbit) (Under active development)
 - Go (Pending release)

[View details about using the API or creating your own implementation here.](@/docs/development/integrating-api.md)

## Urbit Applications {#application}

Urbit applications are still young, but can be fun to experiment with.

When creating user applications on Urbit, you aren’t tied to any particular user interface. They can work without providing a response to the user, or by printing to the Dojo, or with an interface in Landscape, which uses [Eyre](@/docs/arvo/eyre/eyre.md) (the Arvo vane that serves HTTP to serve a React-based interface to the application through a web browser).

When writing applications, you will often make use of [Gall](@/docs/tutorials/hoon/hoon-school/gall.md), the Arvo vane that manages user applications.

If you want to see examples of Urbit applications with common functionality requirements, you can see our [examples](https://github.com/urbit/examples) repository. If you want to get started building applications with a Landscape interface, check out our [create-landscape-app](https://github.com/urbit/create-landscape-app) repository.

## Urbit Core {#core}

Working on the core means improving the Urbit project itself, working with the existing community of Urbit developers. The kernel is much more stable, but generally more challenging from an engineering standpoint.

Just arrived and unsure what to work on? An ideal way to get started is by experimenting with the system, talking to other developers, and reading (or [contributing to](https://github.com/urbit/docs)) the [documentation](/docs/).

Prefer learning with an instructor? Our community runs an online course that covers the basics of Urbit development called [Hooniversity](https://hooniversity.org/). If course-based learning works well for you, we recommend you sign up.

The Urbit developer community congregates around [the urbit-dev mailing list](https://groups.google.com/a/urbit.org/forum/#!forum/dev), the `~bitbet-bolbel/urbit-community` group on Landscape, and [Urbit’s GitHub repository](https://github.com/urbit/urbit). It’s a good idea to sign up, see what people are talking about, and introduce yourself.

Once you’re comfortable working with Urbit, check out the [project’s issues on GitHub](https://github.com/urbit/urbit/issues) or some of our [contribution bounties](https://grants.urbit.org/).

If you’re looking for some guidance, need help, or would prefer direct communication for your ideas, you can also always reach out to us directly at [support@urbit.org](mailto:support@urbit.org).

## Creating a development ship {#creating-a-development-ship}

To do work with Hoon and with the system, we recommended using a "fake" ship -- one not connected to the network.

Because such a ship has no presence on the network, you don't need an Azimuth identity for its purposes. You just need to have [installed our software](/using/install).

To create a fake ship named `~zod`, run the command below. You can replace `zod` with any valid Urbit ship-name.

```
./urbit -F zod
```

Now you should see a block of boot messages, starting with the Urbit version number. Welcome!

## Community tutorials {#community-tutorials}

Here are some tutorials written by members of the Urbit community.

- [A Nock Interpreter](https://jtobin.io/nock) by `~nidsut-tomdun`
- [Basic Hoonery](https://jtobin.io/basic-hoonery) by `~nidsut-tomdun`
- [The Complete Guide to
  Gall](https://github.com/timlucmiptev/gall-guide/blob/master/overview.md) by
  `~timluc-miptev`
- [Nock for Everyday Coders](https://blog.timlucmiptev.space/part1.html) by `~timluc-miptev`
- [Rote - An Annotated Flashcard App](https://github.com/lukechampine/rote)

If you want to add something to the list, [shoot us an email](mailto:support@urbit.org) or make a pull request in the [docs repository](https://github.com/urbit/docs).

## How else can I contribute? {#how}

The Urbit project is a global community of developers, users, and fans. If you’re interested in getting involved, there’s space for you; you don’t have to be a developer to be a part of the project.

### Running stars and galaxies

There are two ways to participate in the Arvo network: as a user running a planet and as an infrastructure provider running a galaxy or a star.

For planets, Urbit is a peer-to-peer network where users can interact with each other via Landscape, or using custom applications that anyone can write.

Running a planet helps build Urbit’s community, surfaces bugs, and helps core developers improve Urbit under realistic conditions.

Stars and galaxies, however, have additional responsibilities and play a role in peer discovery as well as star and planet distribution. You can think of stars and galaxies as similar to the DNS system in the modern Internet. Most users don’t know it exists, but without it, the web wouldn’t work at all.

Running a reliable galaxy or star, and spawning stars and planets from them, are excellent ways to help bootstrap the Urbit network.

If you’re interested in running a galaxy or star, you’ll be reliably providing peer discovery for your children just by running your node – and we’re doing our best to make this both easy and profitable. If you’re interested in this, see [Star and Galaxy Operations](@/using/operations/stars-and-galaxies.md).

If you’re interested in distributing planets, read on.

### Distribute points

Want to get your friends and family into Urbit? Distribute planets using Bridge with a feature called **delegated sending**.

Here’s how it works: any star can grant a number of invites to any of its child planets. Those planets can then send one-time-use invite codes via email to anyone of their choosing.

For instructions on how to grant and send invites, check out [Using Bridge](@/using/operations/using-bridge.md).
