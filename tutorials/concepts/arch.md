+++
title = "Landscape Architecture"
weight = 4
template = "doc.html"
insert_anchor_links = "none"
+++

# Landscape Architecture

Landscape is designed using a particular userspace architecture mode consisting of stores, hooks, and threads.

## Stores

Stores are the first of the two gall models to form this architecture. A store is intended to maintain all the state required for an application or set of applications. Stores are intended to be only accessible by the ship it's running on. A store may not send pokes, peeks, or watches. A store should be treated and thought of as a database. While this is not enforced, it is the convention. The primary example of a store is `graph-store` which can be found at `app/graph-store`

## Hooks

Hooks are the second gall application used in this architecture and are not always present. Hooks are used for inter-app communication. This allows a separation of access control concerns and a division between those things which are able to be done by a store itself and those done by another gall application. `graph-store` in particular has two hooks `graph-pull-hook` for outgoing requests, and `graph-push-hook` for incoming requests.

## Thread

Threads are used when you want to have a series of transactions on a store where the order of those transactions matters. No guarantees are made about the order in which individual requests to a gall applications are processed; threads were introduced to address this. Threads do not maintain their own state while inactive and are instead run only upon request. A good example is `ted/graph/create`