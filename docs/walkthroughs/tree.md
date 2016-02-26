---
next: true
sort: 5
title: Tree
---

# Tree

Tree is a simple publishing platform for files that live on your Urbit.  You're probably reading this file using Tree right now.  The main driving use-case for Tree has been for us to host our own documentation and the surrounding discussion.  Tree remains a pretty simple and flexible tool for getting content online.  We think it's pretty great.

In spirit Tree is sort of like a combination of Jekyll and Finder: a simple static publishing tool and the basic UI for browsing the filesystem.  We take it one step further and make it possible to write modules (tiny little apps), like Talk and Dojo, that can be run directly inside of Tree.  

In the browser Tree is a [React](https://facebook.github.io/react/) / [Flux](https://facebook.github.io/react/blog/2014/05/06/flux.html) app that uses a slightly modifed version of [Bootstrap](http://getbootstrap.com/).  On your Urbit Tree is a set of renderers that translate data in `%clay`, our filesystem, into JSON / JSX that can be read by the client.  

Your Urbit comes with a pre-built copy of the tree (as a single `.js` file).  If you're interested in helping to develop tree or learning about how it works, it has its own GitHub repo [here](https://github.com/urbit/tree).  We have our own fork of Bootstrap, which lives [here](https://github.com/urbit/bootstrap).

You don't need to know anything about the tree implementation to use it, so we'll start with that and get further into the technical details as we get down the page. 

## Publishing files

Assuming you have an Urbit desk mounted (if not see the [Filesystem Handbook](/walkthroughs/clay)), try opeing up `/web/static.md` in an editor and `http://localhost:8080/static` side by side. 

It should be pretty obvious what's going on here.  Drop a markdown file anywhere in `/web` and we'll do the rest.

### Simple blog

From unix

### Going further

The best example of more complicated usage of Tree is covered by the Urbit docs themselves.  See anything while perusing the docs that you'd like to use yourself?  The docs are all on GitHub [here](https://github.com/urbit/docs).

## YAML

We use [YAML](http://yaml.org/)-style frontmatter to do odds and ends like override the title.  A YAML block looks something like this:

```
---
next: true
sort: 5
title: Tree
---
```

and appears at the top of a file.  YAML values can't contain newlines but can contain spaces.  Here are the fields we support:

### `title`

String.  Example: `title: Tree manual`.

This sets the title in the nav or in lists as distinct from the filename. 

### `next`

Boolean.  Example: `next: true`

Adds a 'next' link at the bottom of the page that links to the next item as decided by the sort order.

### `sort`

Integer.  Example: `sort: 7`

User-defined sort. Indicates the sort order as distinct from alphabetical sort.  These numbers should not be overlapping.

### `hide`

Boolean.  Example: `hide: true`

Whether or not to hide the item from the tree.  

### `date`

Urbit date.  Example: `~2016.2.22`

Used for sorting posts by date.

## Using components

Tree is built using React with a small library of components that you can add to your pages using [JSX](https://facebook.github.io/jsx/) tags.  

If you don't know anything about JSX that's okay: basically we just give you a few custom HTML tags that you can use to create components on the page.  

For those familiar with React / Flux each JSX tag corresponds to a component in [the source](https://github.com/urbit/tree/tree/master/js/components).  

### <list>

Example: `<list dataPath="/posts" titlesOnly="true"></list>`

Creates a list of children at a path.  Defaults to the current path. 

Optional properties:

- `dataPath`: Path to load kids from.  
- `titlesOnly`: Only show the 'title' which is either the filename or the first h1.
- `sortBy`: Can be `date` if items have a `date` YAML.
- `className`: Class to be assigned to the container.

### <kids>

Example: `<kids dataPath="/posts"></kids>`

Includes all the children at the specified path separated by `<hr>` tags.

Optional properties:

- `dataPath`: Path to load kids from.
- `className`: Class to be assigned to the container.

### <toc>

Example: `<toc noHeader="true"></toc>`

Creates a table of contents from the `h1` - `h6` tags on the page.

Optional properties:

- `match`: Tag name to match.  If you wanted to only match `h2` tags it could be `match="h2"`
- `noHeader`: By default we add a 'Table of Contents' header to the top.  Remove it with `noHeader="true"`.

## Module basics

A module is a 

## Implementation



### Async component

### manx JSON format

## `urb.js`



