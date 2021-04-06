+++
title = "`sur` File Walkthrough"
weight = 2
sort_by = "weight"
template = "doc.html"
insert_anchor_links = "right"
+++


Let's go through the type definitions of some of the most used types when working with Graph Store.

## Post
Here's `sur/post.hoon`
```
+$  index       (list atom)
+$  uid         [=resource =index]
::
::  +sham (half sha-256) hash of +validated-portion
+$  hash  @ux
::
+$  signature   [p=@ux q=ship r=life]
+$  signatures  (set signature)
+$  post
  $:  author=ship
      =index
      time-sent=time
      contents=(list content)
      hash=(unit hash)
      =signatures
  ==
::
+$  indexed-post  [a=atom p=post]
::
+$  validated-portion
  $:  parent-hash=(unit hash)
      author=ship
      time-sent=time
      contents=(list content)
  ==
::
+$  content
  $%  [%text text=cord]
      [%mention =ship]
      [%url url=cord]
      [%code expression=cord output=(list tank)]
      [%reference =uid]
      ::  TODO: maybe use a cask?
      ::[%cage =cage]
  ==
```


### Index
```
+$  index       (list atom)
+$  uid         [=resource =index]
```

`index` is a list of atoms (big integers). It represents a path to a specific node on a graph that is nested arbitrarily deep.

`uid` is simply a pair of a `resource` and an `index`. These two pieces of information combine to form an unambiguous way to identify and reference a node. It is used in the `content` type to model a reference.

An index fragment is not an explicitly defined type, but since an index is `(list atom)`, it follows that the type of an index fragment is `atom`. This is what gives the developer the flexibility to use more than just numbers in an index: any type that is representable as an atom can be used in the index.

### Hashing (Part 1)
```
::  +sham (half sha-256) hash of +validated-portion
+$  hash  @ux
::
+$  signature   [p=@ux q=ship r=life]
+$  signatures  (set signature)
```

These types are used to cryptographically sign a given post, so that the host of some content cannot act as an imposter, and post content impersonating as someone else. `signature` represents a triple of signed message of hash, author, and author's life at time of posting. These can be used to cryptographically attest to a message. The implementation is a form of asymmetric/public-key encryption, where `q` and `r` are data necessary to look up a ship's public key on azimuth, which can be used to verify the validity of the message.

### Content Types
```
+$  content
  $%  [%text text=cord]
      [%mention =ship]
      [%url url=cord]
      [%code expression=cord output=(list tank)]
      [%reference =uid]
      ::  TODO: maybe use a cask?
      ::[%cage =cage]
  ==
--
```

`content` enumerates all the possible content types that a post can have. The possible content types can be:

- **Text** - representing plain text content
- **Url** - specific data type for urls
- **Mention** - mentioning another ship
- **Code** - a pair of a piece of code that was executed and its result (static data, no execution takes place inside of Graph Store)
- **Reference** - a reference to another post. Uses the `uid` type under the hood

Currently, these are the only content types supported by Graph Store, although there is potential for dynamic content support in the form of a `cage`.

### Post
```
+$  post
  $:  author=ship
      =index
      time-sent=time
      contents=(list content)
      hash=(unit hash)
      =signatures
  ==
::
+$  indexed-post  [a=atom p=post]
```

Post is a fundamental type that represents what we normally think of as a post on social media. Most of the rest of the types are self-explanatory. `hash` is the optional hash of the post, and `signatures` is the (potentially empty) set of `signature`s if the post is cryptographically signed.

An `indexed-post` is a post with an associated index fragment that can be used to validate a post's index with an index fragment that is expected at the end of the index list.

### Hashing (Part 2)
```
+$  validated-portion
  $:  parent-hash=(unit hash)
      author=ship
      time-sent=time
      contents=(list content)
  ==
::
```

The parts of a `post` that are actually hashed to obtain a value of type the earlier type `hash`.


## Graph Store

Here's `sur/graph-store.hoon`

```
+$  graph         ((mop atom node) gth)
+$  marked-graph  [p=graph q=(unit mark)]
::
+$  node          [=post children=internal-graph]
+$  graphs        (map resource marked-graph)
::
+$  internal-graph
  $~  [%empty ~]
  $%  [%graph p=graph]
      [%empty ~]
  ==
::
+$  tag-queries   (jug term resource)
::
::
+$  network
  $:  =graphs
      =tag-queries
      =update-logs
      archive=graphs
      validators=(set mark)
  ==
::
+$  update
  $%  [%0 p=time q=update-0]
  ==
::
+$  update-log    ((mop time logged-update) gth)
+$  update-logs   (map resource update-log)
::
+$  logged-update
  $%  [%0 p=time q=logged-update-0]
  ==
::
+$  logged-update-0
  $%  [%add-graph =resource =graph mark=(unit mark) overwrite=?]
      [%add-nodes =resource nodes=(map index node)]
      [%remove-nodes =resource indices=(set index)]
      [%add-signatures =uid =signatures]
      [%remove-signatures =uid =signatures]
  ==
::


+$  update-0
  $%  logged-update-0
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
--
+$  permissions  
  [admin=permission-level writer=permission-level reader=permission-level]
::
::  $permission-level:  levels of permissions in increasing order
::  
::    %no: May not add/remove node
::    %self: May only nodes beneath nodes that were added by
::      the same pilot, may remove nodes that the pilot 'owns'
::    %yes: May add a node or remove node
+$  permission-level
  ?(%no %self %yes)
```

### Graph, Node, and Related Objects
```
+$  graph         ((mop atom node) gth)
+$  marked-graph  [p=graph q=(unit mark)]
::
+$  node          [=post children=internal-graph]
+$  graphs        (map resource marked-graph)
::
+$  internal-graph
  $~  [%empty ~]
  $%  [%graph p=graph]
      [%empty ~]
  ==
::

+$  network
  $:  =graphs
      =tag-queries
      =update-logs
      archive=graphs
      validators=(set mark)
  ==
::
```
A graph is a loosely interconnected set of data which can reference each other and be arbitrarily nested and interconnected. This concept is based off of the mathematical concept of a graph: a collection of nodes, and connections between nodes called edges.

`graph` is a `mop`, a map which maintains ordering on its keys based on a sorting function also known as an ordered map. A graph's keys are `atom`s representing a node's index fragment and whose values are `node`s, where entries are sorted by largest valued keys first, using `gth` as the sorting function. This is the fundamental data structure used in Graph Store.

Here are some helpful Wikipedia pages for more info on what this data type represents:
- [Graph (abstract data type)](https://en.wikipedia.org/wiki/Graph_(abstract_data_type))
- [Graph database](https://en.wikipedia.org/wiki/Graph_database#Background)
- [Graph (discrete mathematics)](https://en.wikipedia.org/wiki/Graph_(discrete_mathematics))

`node` represents a pair of a `post` and all of its children, which is an `internal-graph`.

`internal-graph` is a tagged union representing the state that children can be in. Either a `node` has children in the form of a `graph`, or does not have any and is labeled as `%empty`. 

`marked-graph` is the pair of a `graph` and an optionally present `mark`, which is used by Graph Store to validate a graph against the provided validator.

`graphs` is a mapping between `resource`s and`marked-graph`s

`network` is the highest level data structure used by Graph Store to represent all the information that the agent is aware of.



### Tag Queries

```
+$  tag-queries   (jug term resource)
```

`tag-queries` is a mapping where the keys are `term`s and the values are a `set` of `resource`s (this pattern is called a `jug`). It is a simple tagging system that allows for various ad-hoc collections, similar to filesystem tags being used to sort different files/folders. While the type's name is `tag-queries`, there is no complex querying system as of now. Currently, you can add term/resources pairs into the tag queries, get a list of all terms in tag-queries, and get the whole `jug` out of Graph Store.

### Update (Part 1)
```
+$  update
  $%  [%0 p=time q=update-0]
  ==
::
+$  logged-update-0
  $%  [%add-graph =resource =graph mark=(unit mark) overwrite=?]
      [%add-nodes =resource nodes=(map index node)]
      [%remove-nodes =resource indices=(set index)]
      [%add-signatures =uid =signatures]
      [%remove-signatures =uid =signatures]
  ==
::
+$  update-0
  $%  logged-update-0
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
--
```

The `update` type is what is used to interact with Graph Store. It is used both to update subscribers with data (outgoing data) and to write to Graph Store itself (incoming data). The first six actions are sent as pokes to graph-store in the form of a `graph-update`, which is an alias for `update` above. All actions defined here allow you to create/read/update/delete various objects in a running Graph Store gall agent. An `update-0` encapsulates all `logged-update-0` (i.e. any `logged-update-0` is an `update-0` but not necessarily the other way around). The last three actions are scries which allow you to ask a Graph Store agent for its current state regarding the three entries.

If you want to check out a relevant code listing to see how graph store handles these pokes, see [`app/graph-store.hoon#L221-L227`](https://github.com/urbit/urbit/blob/e2ad6e3e9219c8bfad62f27f05c7cac94c9effa8/pkg/arvo/app/graph-store.hoon#L221-L227)

### Update (Part 2)
```
+$  update-log    ((mop time logged-update) gth)
+$  update-logs   (map resource update-log)
::
+$  logged-update
  $%  [%0 p=time q=logged-update-0]
  ==
::
```

`update-log` is an ordered map where the keys are a timestamp (time is an alias for `@da`, an absolute datetime) and the values are `logged-update`s, where entries are sorted with the most recent timestamp first. It represents a history of updates applied to a graph. `update-logs` is a mapping where keys are resources and values are `update-log`s. This is the data structure used by Graph Store to store the history of actions associated with all graphs that it knows about, where each graph has a unique resource that identifies it. A `logged-update` is a data structure that holds any `logged-update-0` along with a time identifying when the update happened. It follows a versioning pattern similar to the versioned state of a gall agent.

It is important to note that the source of truth is actually the `update-logs`, and not the `graphs`. Similar to the Urbit event log, Graph Store also stores all updates that it receives, so that it can rebuild its current state on demand. The current state of the database is more of a product of the event log, like a checkpoint, or a materialized db view, and is not the source of truth. As a result, the Graph Store database is immutable in nature, where all data is preserved and deleted data is only inaccessible in the current view or checkpoint, and is still present and recoverable by replaying the log.

The reason for having the main CRUD actions being `logged-update`s is so that Graph Store knows which order to process the log entries in when it is rebuilding its current state. The time associated with the `logged-update` is a way of specifying the canonical order to process operations. All other actions that aren't part of logged-update stand on their own and don't need a timestamp in order to properly apply them.

### Permissions
```
+$  permissions
  [admin=permission-level writer=permission-level reader=permission-level]
::
::  $permission-level:  levels of permissions in increasing order
::
::    %no: May not add/remove node
::    %self: May only nodes beneath nodes that were added by
::      the same pilot, may remove nodes that the pilot 'owns'
::    %yes: May add a node or remove node
+$  permission-level
  ?(%no %self %yes)
```

These are the types from the permissioning system explained earlier. `permissions` is just a length-3 cell of `permissions-level`s for Admins, Writers, and Readers respectively.

