+++
title = "Graph Store"
weight = 3
template = "doc.html"
insert_anchor_links = "none"
+++

# What is Graph Store?

Graph Store is a gall implementation of a tree with additional virtual edges by allowing nodes to reference other nodes. It is most comparable to modern NoSQL databases in structure, though it allows for schemas to be written in the form of marks. It is used as the backend for an increasing number of Landscape applications, and is considered to be best used for social data.

## Data types

`graphs` is a map of `resource` to `marked-graph`

`resource` is a pair of ship and term which is where the graph is hosted and the name of the resource. Every graph is it's own resource.

`marked-graph` is a pair of `graph` and `(unit mark)`. The semantics of a graph are defined by the mark. This is just for validating the structure of the graph. 

`graph` is a `mop`, a mold builder for order map, of an atom and a `node`.

`node` is a pair of `post` and `children`.

`post` is defined in `sur/post`. It contains:

```hoon
+$  post
  $:  author=ship
      =index
      time-sent=time
      contents=(list content)
      hash=(unit hash)
      =signatures
  ==
```


Most of these elements are self explanatory.

`contents` is a `list` of `content` where `content` is a tagged union of text, url, code, or reference. This is where the contents of a publish post or an entry from links would be stored.

`hash` is a `sham` hash of `validated-portion` which includes the parent hash, author, time sent, and contents.

`signatures` is a set of `signature` which is used to cryptographically sign graph-store messages.

When interacting with `graph-store` you will need to create an `update`

`update` is a tagged union that currently only has one option

`[%0 p=time q=update-0]`

The reason this is a union is to serve as future proofing for version changes.

An `update-0` can either be logged in the case of adding/removing nodes or signatures, or non-logged as in the case of adding/removing a graph. This logging refers to if this action adds an entry to the update log that is used to synchronize state between ships.

Below is an excerpt of `sur/graph-store.hoon` at the time of writing, showing the definition of `logged-update-0` and `update-0` which should now be readable.

```hoon
+$  logged-update-0
  $%  [%add-nodes =resource nodes=(map index node)]
      [%remove-nodes =resource indices=(set index)]
      [%add-signatures =uid =signatures]
      [%remove-signatures =uid =signatures]
  ==
::
+$  update-0
  $%  logged-update-0
      [%add-graph =resource =graph mark=(unit mark)]
      [%remove-graph =resource]
    ::
      [%add-tag =term =resource]
      [%remove-tag =term =resource]
    ::
      [%archive-graph =resource]
      [%unarchive-graph =resource]
      [%run-updates =resource =update-log]
    ::
    ::  NOTE: cannot be sent as pokes
    ::
      [%keys =resources]
      [%tags tags=(set term)]
      [%tag-queries =tag-queries]
  ==
```


## Pokes

Graph Store can be poked with a `graph-update`, which can:
 - add and remove a graph
 
 `[%add-graph =resource =graph mark=(unit mark)]`
 
 `[%remove-graph =resource]`
 
 - add and remove a node to a graph
 
 `[%add-nodes =resource nodes=(map index node)]`

 `[%remove-nodes =resource indices=(set index)]`
 
 - add and remove signatures
 
 `[%add-signatures =uid =signatures]`
 
 `[%remove-signatures =uid =signatures]`
 
 - add and remove tags
 
 `[%add-tag =term =resource]`
 
 `[%remove-tag =term =resource]`
 
 - archive and unarchive a graph
 
 `[%archive-graph =resource]`
 
 `[%unarchive-graph =resource]`

## Scries

What follows is a summary of the scrys available in graph-store

- Fetch keys
 `[%x %keys ~]`

- Fetch tags
 `[%x %tags ~]`
 
- Fetch tag queries
 `[%x %tag-queries ~]`

- Fetch a specific graph by resource
 `[%x %graph @ @ ~]`
 
- Archive a specific graph by resource
 `[%x %archive @ @ ~]`
 
- Fetch a subset of the graph by resource and start and end indices
 `[%x %graph-subset @ @ @ @ ~]`

- Select a node from a graph by resource and index
 `[%x %node @ @ @ *]`
 
- Fetch a subset of the children of a node by resource, index, and start and end indices
 `[%x %node-children-subset @ @ @ @ @ *]`
 
- Fetch a subset of the update log by resource and start and end indices
 `[%x %update-log-subset @ @ @ @ ~]`
 
- Fetch the update log by resource
 `[%x %update-log @ @ ~]`
 
- Fetch the time of the last entry of the update log
 `﻿﻿[%x %peek-update-log @ @ ~]`

## Marks

There are marks in `mar/graph/validator` that are worth reviewing. They are each short enough to read quickly. They are used to validate the shapes of various nouns to be stored in the graph-store.