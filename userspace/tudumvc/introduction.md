+++
title = "Intro to Earth Apps"
weight = 2
sort_by = "weight"
template = "doc.html"
insert_anchor_links = "right"
+++

`%tudumvc` is an implementation of the React.js + Hooks version of [TodoMVC](https://jacob-ebey.js.org/hooks-todo/#/) that uses Urbit as a back-end. The pervasiveness of React.js as a framework for front-end development informs our choice of implementations of TodoMVC to incorporate with urbit. The Urbit backend supports all of the open-web functionality _including_ serving the front-end without any need for client-side storage. With minimal changes to the existing, "Earth web" source code and less than 400 lines of back-end hoon code, `%tudumvc` is responsive, lightweight, and extensible.

`%tudumvc` is a simple example of the advantages of incorporating Urbit in your stack. The React.js + Hooks implementation of TodoMVC is a stateful application that updates its presentation layer on state change, following the Model-View-Controller design pattern. Urbit is a deterministic operating system, sometimes called an operating function, and it functions off of a basic pattern of state -> event -> effects -> new state (hence, operating function). `%tudumvc` compliments this basic pattern by using the React.js front end to produce events, using Urbit to interpret those events and produce effects and a new state and returning the state to React.js to be displayed.

The back-end development required to host an app like `%tudumvc` is light-weight and straightfoward, as are the changes we have to make to the React.js + Hooks TodoMVC implementation. Additionally, Urbit's `%gall` agents (which are something like microservices) are inherently capable of cross-integration, so it would be a relatively straightforward task to integrate the functionality of `%tudumvc` into other Urbit apps, like "groups".

# Tutorial Structure

This tutorial walks, step by step, through the development process of `%tudumvc` tho show how one might design their own applications on the Urbit stack. These steps are divided into the following chapters:
* [Preparing a Development Environment](@/docs/userspace/tudumvc/preparing-development.md)
* [Hosting a Web App on Urbit](@/docs/userspace/tudumvc/hosting-on-urbit.md)
* [Configuring a %gall Agent to Interact with TodoMVC](@/docs/userspace/tudumvc/agent-supported-hosting.md)
* [Managing Upgrades to %gall Agents](@/docs/userspace/tudumvc/updating-the-agent.md)
* [Connecting a %gall Agent as a Back-End to an "Earth" Web App](@/docs/userspace/tudumvc/earth-to-mars-comms.md)
* [Networking %gall Agents](@/docs/userspace/tudumvc/tudumvc-proper.md)

# Breakout Lessons
The tutorial also includes [Breakout Lessons](@/docs/userspace/tudumvc/breakout-lessons/_index.md) that are not necessary to understand the basics, but can be helpful for those who want to understand at a deeper level.

# Prerequisites
* A *nix computer (assumed - could be completed on other platforms w/ some slight modifications)
* Node v14.16.0
* A copy of the source files (we'll walk you through getting these)