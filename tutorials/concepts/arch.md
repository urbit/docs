+++
title = "Landscape Architecture"
weight = 4
template = "doc.html"
+++

# Landscape Architecture

Landscape is designed using a particular userspace architecture model known as store/hook/thread. This model divides applications into multiple parts, two gall applications and threads.

## Stores

Stores are the first of the two gall models to form this architecture. A store is intended to maintain all the state required for an application or set of applications. Stores are intended to be only accessible by the ship it's running on. While this is not enforced, it is the convention. The primary example of a store is `graph-store` which can be found at `app/graph-store`

## Hooks

Hooks are the second gall application used in this architecture and are not always present. Hooks are used for inter-ship communication. Anything that needs to speak to a store on another ship does so through a hook. This allows a separation of access control concerns and a division between those things which are able to be done to a remove ship and those which may be performed by the host. `graph-store` in particular has two hooks `graph-pull-hook` for outgoing requests, and `graph-push-hook` for incoming requests.

## Thread

Threads are used when you want to have a series of transactions to a store where the order of those transactions matters. No guarantees are made about what order things process in for individual requests to a gall application and threads are intended to address this. Threads do not maintain their own state while inactive and are instead run only upon request. A good example is `ted/graph/create`