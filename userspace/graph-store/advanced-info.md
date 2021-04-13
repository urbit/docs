+++
title = "Advanced Info"
weight = 50
sort_by = "weight"
template = "doc.html"
insert_anchor_links = "right"
+++

This section is not required, but does shed light on some implicit assumptions that Graph Store makes.


### Miscellaneous
- Only nodes that successfully typecheck under the validator will be added to the graph
- Graphs are validated recursively (see [`app/graph-store.hoon#L598-L616`](https://github.com/urbit/urbit/blob/5cb6af0433a65fb28b4bc957be10cb436781392d/pkg/arvo/app/graph-store.hoon#L598-L616))
  - First, validate all top level nodes of a graph.
  - Then, recursively validate all children nodes of those nodes.
  - Base case: empty children is always valid
- Nodes are also validated against the graph's mark when inserted individually (see [`app/graph-store.hoon#L380`](https://github.com/urbit/urbit/blob/e2ad6e3e9219c8bfad62f27f05c7cac94c9effa8/pkg/arvo/app/graph-store.hoon#L380))
- Only the root level graphs get validated with marks. There is only one mark / validator per graph. All child graphs get validated with the same mark as the root/top-level one.
- The way in which Graph Store works is by mirroring all data from a given social media channel. Thus, anything you see is your copy of it, and anything you do is sent as a request to the hosting ship.
- Unmanaged graphs (a graph that isn't associated to a group) actually still have a unmanaged / hidden group. If you want to construct a `reference` to content in an unmanaged graph, it is still possible; the group in that case is then the same resource id as the graph itself



### What happens when you add or remove a node?

When adding nodes, Graph Store takes in a `(map index node)`. That is, a map of `node`s to add keyed by an `index` representing where in the graph the node should be inserted. However, there are some limitations. For instance, Graph Store does not allow for a `node` which has non-existent ancestors to be added, meaning that missing ancestor nodes are not automatically created. Graph Store requires that every node up until the 2nd to last level of nesting is created, meaning that every ancestor except the parent must be created before being added. The ancestors must either already exist in Graph Store or must be included in the `graph-update`. To ensure consistent behavior, all nodes are added shallowest-index first, which ensures that no child is added before it's parent (if it exists). This is why any non-leaf node must have its parent exist, either already within the graph or in the update. 

Also, Graph Store merges the flat list of nodes from an `%add-nodes` update into the fully connected graph structure. This means that when sending an update to `graph-store`, children nodes do not have to be nested within the parent's data structure in the update. They simply have to exist somewhere in the update.

Another constraint to be aware of is that in a map of indexed nodes: for each node, the index in map entry has to be the same index as the in that `node`'s post index.

To see how Graph Store handles add-nodes, take a look at [`app/graph-store.hoon#L370-L417`](https://github.com/urbit/urbit/blob/e2ad6e3e9219c8bfad62f27f05c7cac94c9effa8/pkg/arvo/app/graph-store.hoon#L370-L417).


### Permissions internals
Internally, the permissions part of a mark (the grow arm) are built and then watched for changes by Graph Store. See [`app/graph-push-hook.hoon#L154`](https://github.com/urbit/urbit/blob/ac096d85ae847fcfe8786b51039c92c69abc006e/pkg/arvo/app/graph-push-hook.hoon#L154) for more info.

It is important to note that the push hook and permissions system is bespoke, and doesn't necessarily fit all permissions schemes out there. In addition, the permissions structure is likely to change, so it can make sense to implement your own permissioning structure (if you are not using `graph-push-hook`), especially in the case where you are making your own resource control system.
The `graph-push-hook` permissions system is not the definite way to implement permissions, and is simply one pre-existing way to do it.
The validator mark doesn't need any permissions to compile; it just needs a grow arm with at least `noun`.
The way to implement your own permissioning structure is in the form of your own grow arm definitions in the validator.
There's nothing special about the `graph-permission-add` arms; they are just constants, arms which are known to push-hook.
As stated before, Graph Store proper (`app/graph-store.hoon`) doesn't know anything about the permissions.




### Push Hook Details

As a result of the hook architecture, all hooks have the ability to transform incoming data before it is accepted and trusted as a local input.
Graph Push Hook is no exception. This is why the `transform-add-nodes` is required for every validator; Graph Store calls this function before adding any nodes to itself.
Right now, the only thing that `transform-add-nodes` is used for is to replace untrusted foreign timestamps with trusted local timestamps.

Here is a stubbed out example of a `transform-add-nodes` to show its inputs and outputs:

```hoon
|=  [=index =post =atom was-parent-modified=?]
^-  [^index ^post]
!!
```

The simplest transformer can simply return the exact same indexed post, which would mean that it would trust all foreign `index`es and `post`s by default.
The atom is always `now.bowl`, i.e. what the datetime on us, the receiving side is.
