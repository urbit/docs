+++
title = "Graph Store Overview"
weight = 1
sort_by = "weight"
template = "doc.html"
insert_anchor_links = "right"
+++


## Intro
Graph store is a non-relational database suitable for use in building social media applications. It is primarily designed for storing text-based content and data that is generally threaded and nested. It is not suitable as a general purpose database for highly structured or pure binary data.

<p align="center">
  <img src="images/1_graph_store_overview.png"/>
</p>

Graph Store is mainly in charge of two things: data storage and retrieval, and schema validation. There are two related tools: Graph Push Hook, which provides permissioning support to Graph Store and acts as a proxy layer to Graph Store for outside ships to access, and Graph Pull Hook, which can be used to request Graph Store data from other ships. Importantly, Graph Store itself does not have a built-in permissions system (or rather, is permissions-agnostic), and acts in a purely trusted manner, and assumes that all inputs are trusted. However, it only allows local, authenticated connections to communicate with it, meaning that by default, no one else on the network may modify the state of your Graph Store agent. This is why Graph Push Hook exists: to mediate untrusted requests from outside ships to your instance of Graph Store, rejecting invalid ones where a ship should not be able to modify the data.

## Data Structures
### Posts

<p align="center">
  <img src="images/2_post_explanation_diagram.png"/>
</p>

Above, we can see a representation of a post on the left, along with its table form on the right.
A post is the most basic building block of a graph.
Every post is made up of an:
- **Author** - who created the post
- **Index** - the unique path/identifier of the post on the graph (more on this later)
- **Time Sent** - when the post was created
- **Contents** - data that the user intended to post

Currently, Graph Store supports 5 data types for content that is to be stored within a graph:
- **Text** - plain text data
- **Url** - specific data type for urls
- **Mention** - mentioning another ship
- **Code** - a pair of a piece of code that was executed and its result (this is static data, and is not used to execute code on other's ships)
- **Reference** - a reference to another post


### Graphs and Nodes

<p align="center">
  <img src="images/3_graph_node_diagram_a.png"/>
</p>

<p align="center">
  <img src="images/4_graph_node_diagram_b.png"/>
</p>

A graph is a flat, ordered map of nodes, where each node can have a child graph, which is itself a flat ordered map of nodes. Nodes contain a post and a child graph. In the above diagram, we can see an example of a basic graph on the top, along with the underlying structure of the data in table form underneath.

A few vocab terms:
- **Root graph** refers to the outermost graph, G in this case
- **Top level** is a loose term usually used to refer to a node that exists in the root graph. **A** and **D** would be considered nodes at the top level, but **B** and all its descendants would not qualify.
- **Sibling nodes** are two nodes that reside next to each other, meaning that they reside in the same `graph`. **A** and **D** are an example of sibling nodes.
- We say a node is a **child** of another node if it directly resides within the child graph of that node
- A node is a **parent** to another node if it directly contains the node within its children. An example is the relationship between **B** and **C**: **C** is a child of **B**, while **B** is the parent of **C**
- Another way of saying a node is a child is by saying that node **B** is nested within node **A** Strictly speaking, **C** is not a child of **A**, but we do say that **A** is an **ancestor** of **C**, while **C** is a **descendant** of **A**.
- **Leaf nodes** refer to nodes that do not have children. **C** and **D** are both examples of leaf nodes

### Index

<p align="center">
  <img src="images/5_index_diagram.png"/>
</p>

Indexes are a way of uniquely identifying a node within a graph. You can think of `index`es as similar to file paths, although they aren't exactly the same. Roughly, a file path is a unique reference to a file or folder located in the filesystem. Similarly, an index is a unique reference to a node nested within a graph. The written syntax for a full index is very similar to file paths. It consists of every index fragment in order separated by a slash. A node's **level of nesting** refers to how deeply it is nested within the context of the root graph. The level of nesting directly corresponds to the number of items in the index. An index fragment is the atom by which a node is uniquely identified within it's graph, and roughly corresponds to a specific name of a directory along a path. In the diagrams that follow, we'll use the index fragment instead of the index to avoid repeating redundant information, but please note that internally graph-store still store the full index in every node's post.

In the above diagram, we would say that nodes **A** and **D** are nested 1 level deep, while **B** would be at the 2nd level of nesting, and **C** would be nested 3 levels deep.

Indexes are usually numbers and are stored as such in the database. Most commonly, they can represent:
- Date or time of posting
- A sequence of numbers starting from 1 increasing
- Structural/constant value: values which are associated with a specific meaning in the context of the schema of an application.

However, there is no strict requirement for them to be numbers; they can be cords as well as other data types. As we'll see in the later sections, it is up to the app developer to decide this when creating their application.


### Structural Nodes vs. Content-Centric Nodes

<p align="center">
  <img src="images/6_structural_vs_content_centric_diagram.png"/>
</p>

When using Graph Store, there is a notion of **structural nodes** vs. **content-centric nodes**. In the example diagram, we've color coded the different nodes based on what type of node they are. **Content-centric nodes** represent data created or consumed directly by the user. **Structural nodes**, on the other hand do not directly represent user data, and instead represent a higher level relationship between different user data. Structural nodes are used to implement the structure of the schema that is being implemented. In other words, they exist away from the eyes of the user, solely for organizational purposes.

Note that this differentiation between content-centric vs. structural nodes is purely developer-facing, and not encoded within the actual system. Although these patterns aren't hard or fast rules, we'll see how they can be used in practice in the validator walkthrough section.

## Validator Overview - Schema and Permissions

Every social application has a minimum amount of information it needs to function along with the structure that the information must follow. We'll call this the application's schema. This is enforced by a **validator**. Given a schema, a validator's primary function is to encode its constraints and validate arbitrary data against it. Graph Store uses clay marks to represent validators. Validators are a special case of a mark, so the terms will be used interchangeably.

In addition, validators can also encode structural permissions. **Structural permissions** govern who is allowed to add or remove a given node (and by extension modify its children) based on the node's characteristics.

There are 3 different classes of users:
- **Admin** - An owner of a resource or someone who's been delegated similar privileges
- **Writer** - Someone who can create and modify their own content but cannot modify others'
- **Reader** - Someone who is only given permission to access but not create or modify, except in special cases

There are two different types of privileges:
- **Add privileges** - permission to create a given node and create any child nodes
- **Remove privileges** - permission to remove a given node and remove any of its children

There are also three different levels of access a given permission level can have:
- **%no** - user does not have add or remove privileges for this node
- **%yes** - user has add or remove privileges for this node, whether or not they authored the parent node
- **%self** - user has add or remove privileges for child nodes only if they authored the parent node (determined by `author` of post, i.e., they are the author of the post)

