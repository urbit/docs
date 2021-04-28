+++
title = "TuduMVC - a React.js + Hooks Implementation of TodoMVC with Urbit Backend"
weight = 5
template = "doc.html"
+++

# Introduction

`%tudumvc` is an implementation of the React.js + Hooks version of [TodoMVC](https://jacob-ebey.js.org/hooks-todo/#/) that uses Urbit as a back-end. The Urbit backend supports all of the open-web functionality _including_ serving the front-end without any need for client-side storage. With minimal changes to the existing source code and less than 400 lines of back-end code, `%tudumvc` is responsive, lightweight, and expandable. The pervasiveness of React.js as a framework for front-end development informs our choice of implementations of TodoMVC to incorporate with urbit.

`%tudumvc` is a simple example of the advantages of incorporating Urbit in your stack. The React.js + Hooks implementation of TodoMVC is a stateful application that updates its presentation layer on state change. Urbit is a deterministic operating system, sometimes called an operating function, and it functions off of a basic pattern of state -> event -> effects -> new state. `%tudumvc` compliments this basic pattern by using the React.js front end to produce events, using Urbit to interpret those events and produce effects and a new state and returning the state to React.js to be displayed.

The back-end development required to host an app like `%tudumvc` is minimal and straightfoward, as are the changes we have to make to the React.js + Hooks TodoMVC implementation. Further, Urbit's `%gall` applications are inherently capable of cross-integration, so it would be a relatively straightforward task to integrate the functionality of `%tudumvc` into other Urbit apps, like "groups".

# Guide Structure

This guide will take you through the following development phases:
* [Preparing a Development Environment](./tudumvc/preparing-development.md)
* [Hosting a web app on Urbit](./tudumvc/hosting-on-urbit.md)
* [Configuring a %gall agent to interact with TodoMVC](./tudumvc/agent-supported-hosting.md)
* [Managing upgrades to %gall agents](./tudumvc/updating-the-agent.md)
* [Connecting a %gall agent as a back-end to a web app](./tudumvc/earth-to-mars-comms.md)
* [Networking %gall agents](./tudumvc/tudumvc-proper.md)

# Prerequisites
* A *nix computer (assumed - could be completed on other platforms w/ some slight modifications)
* Node v14.16.0
* A copy of the source files (we'll walk you through getting these)