+++
title = "Overview"
weight = 1
template = "doc.html"
+++

Eyre is the webserver vane.

HTTP messages come in from outside and Eyre produces HTTP messages in response. In general, apps do not call Eyre; rather, Eyre calls apps. Eyre has a number of ways to handle such HTTP requests which we'll briefly describe.

# Authentication

Most types of requests require the client provide a valid session cookie which is obtained by authenticating with your ship's web login code. Authentication is documented in the [Authentication](@/docs/arvo/eyre/external-api-ref.md#authentication) section of the [External API Reference](@/docs/arvo/eyre/external-api-ref.md) documentation.

# The Channel System

Eyre's channel system is the primary way of interacting with Gall agents from outside of Urbit. It provides a simple JSON API that allows you to send data to apps and subscribe for updates from apps. Updates come back on a SSE ([Server Sent Event](https://html.spec.whatwg.org/#server-sent-events)) stream which you can easily handle with an EventSource object in Javascript or the equivalent in whichever language you prefer.

The channel system is designed to be extremely simple with just a handful of `action` and `response` JSON objects to deal with so you can focus on the logic and data structures of your external app and the Gall agent with which you're interacting.

Detailed documentation of the channel system's JSON API is provided in the [External API Reference](@/docs/arvo/eyre/external-api-ref.md) document with corresponding examples in the [Examples](@/docs/arvo/eyre/examples.md#using-the-channel-system) document.

# Scrying

Along with the channel system, Eyre also provides a way to make read-only requests for data which are called scries. While not technically part of the channel system, you'll likely use scries in conjunction with channel `action`s.

Details of Eyre's scry API are in the [Scry](@/docs/arvo/eyre/external-api-ref.md#scry) section of the [External API Reference](@/docs/arvo/eyre/external-api-ref.md) document.

# Spider Threads

Threads are like transient Gall agents which typically handle complex IO operations for Gall agents (you can read more about them [here](@/docs/userspace/threads/overview.md)). Spider (the Gall agent that manages threads) has an Eyre binding that allows you to run threads through Eyre.

The [Spider](@/docs/arvo/eyre/external-api-ref.md#spider) section of the [External API Reference](@/docs/arvo/eyre/external-api-ref.md) document explains their usage, and the [Running Threads With Spider](@/docs/arvo/eyre/examples.md#running-threads-with-spider) section of the [Examples](@/docs/arvo/eyre/examples.md) document provides a practical example.

# Generators

Generators, which are like hoon scripts, can also be used through Eyre. Rather than having a predefined JSON API, they instead handle HTTP requests and return HTTP responses directly, and are therefore a more complex case that you're less likely to use.

Their usage is explained in the [%serve](@/docs/arvo/eyre/tasks.md#serve) section of the [Internal API Reference](@/docs/arvo/eyre/tasks.md) documentation and a practical example is provided in the [Generators](@/docs/arvo/eyre/examples.md#generators) section of the [Examples](@/docs/arvo/eyre/examples.md) document.

# Direct HTTP Handling With Gall Agents

As well as the [Channel System](#the-channel-system) and [Scries](#scrying), it's also possible for Gall Agents to deal directly with HTTP requests. This method is much more complicated that the channel system so you're unlikely to use it unless you want to build a custom HTTP-based API or something like that.

This method is explained in the [%connect](@/docs/arvo/eyre/tasks.md#connect) section of the [Internal API Reference](@/docs/arvo/eyre/tasks.md) document and a detailed example is provided in the [Direct HTTP Handling With Gall Agents](@/docs/arvo/eyre/examples.md#direct-http-handling-with-gall-agents) section of the [Examples](@/docs/arvo/eyre/examples.md) document.

# Eyre Documentation Sections

- [External API Reference](@/docs/arvo/eyre/external-api-ref.md) - Details of Eyre's external API including the channel system's JSON API.

- [Internal API Reference](@/docs/arvo/eyre/tasks.md) - The `task`s Eyre takes and the `gift`s it returns.

- [Scry Reference](@/docs/arvo/eyre/scry.md) - The scry endpoints of Eyre.

- [Data Types](@/docs/arvo/eyre/data-types.md) - Reference documentation of the various data types used by Eyre.

- [Examples](@/docs/arvo/eyre/examples.md) - Practical examples of the different ways of using Eyre.
