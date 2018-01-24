/=  kids  /%  /tree-kids/
:-  :~  navhome/'/docs/'
        navuptwo/'true'
        sort/'8'
        title/'Web (Eyre)'
    ==
;>

# Web (Eyre)

Your Urbit runs its own webserver, Eyre, that handles all things HTTP.  Here we'll cover the features of Eyre that most resemble a traditional web server.

By default Eyre uses Tree, which is sort of like a combination of [Jekyll](https://jekyllrb.com/) or [Kirby](https://getkirby.com/) and Finder on OSX.  Tree is a simple ui for browsing the contents of the filesystem, statically publishing a blog or any kind of content and for running single-page apps.

Tree was built primarily to display both our documentation and the contents of `urbit.org`.  We provide a few simple examples [here](#-examples) of how to publish using Tree.  If you're interested in doing anything complex it's worth checking out the [docs source](https://github.com/urbit/docs) and the [urbit.org](https://github.com/urbit/urbit.org) source.

We ship `tree` as compiled JavaScript on your Urbit, but the source lives in its own repo [here](https://github.com/urbit/tree).

## Quickstart

Your Urbit runs a web server and can be found at either `http://localhost:8080/` (or `8081` if you're running other processes that might be occupying `8080`, you can determine which port your urbit is on by looking at your boot sequence — it's specified there), or `http://your-urbit.urbit.org/`.

;span.red
  (Make sure you have a desk mounted to unix, as covered in the [filesystem walkthrough](/docs/using/filesystem)).
==

To switch the desk you're serving from:

```
|serve %sandbox
```

To host a file on the web try putting the following in `/sandbox/web/test.md` (from Unix):

```
# Hello

This is a simple markdown file.
```

Create the directory `/sandbox/web/test/` and add two more markdown files in it.

NOTE: Due to a bug in Urbit you may have to create the directory and the file in it in rapid
succession using something like `mkdir sandbox/web/test && touch sandbox/web/test/first.md`.

Now modify `/sandbox/web/test.md` to list the children using the `<list/>` JSX:

```
# Hello

This is a simple markdown file.

<div><list /></div>
```

To view your file rendered using tree:

```
http://localhost:8080/test/
```

To view your file as raw `md`:

```
http://localhost:8080/test.md
```

To view your file as raw `html`:

```
http://localhost:8080/test.html
```

You may have noticed that we just created both `test.md` and `test/`. In Urbit, there is no distinction between a directory and a file. So, if you're adding files directly from unix, simply `mkdir test` and Urbit will treat the file and directory as the same entity.

You can use this feature to change your homepage at `your-urbit.urbit.org` with the page `/home/web.md`, where `home` is the current mounted desk. By default, `web.md` will display some info about your urbit, but you can customize it to your heart's content.

## Examples

We've created a few simple examples of how to get set up publishing content from your Urbit.  Feel free to ask questions in the comments.

;+  (kids %title datapath/'/docs/using/web/' ~)

## Manual

## `/web`

This is the equivalent of a `public_html` directory.  Your Urbit looks in this directory to serve content to the world.  You can change what desk you're serving from using `|serve`.

Switch to the `%sandbox` desk:

```
|serve %sandbox
```

Let's quickly step through the default contents of `web/`:

- `404.hoon` - The default 404 page.
- `dojo.hoon` - Page body that loads the `dojo` React module.
- `lib/css/bootstrap.css` - The Urbit-flavored bootstrap
- `lib/css/codemirror.css` - Syntax highlighting
- `lib/css/fonts.css` - The Urbit custom fonts
- `lib/js/hoon.js` - Hoon syntax highlighting
- `lib/js/sole.js` - `dojo` operational transformation JS
- `lib/js/urb.js` - Base Urbit JS library.  Handles AJAX and polling.
- `static.md` - Sample static file
- `talk/` - Talk compiled JS / CSS
- `talk.hoon` - Page body that loads the `talk` React module.
- `tree/` - Tree compiled JS / CSS
- `tree.hoon` - Page body that loads the `tree` React module.

## Tree

Tree is a simple publishing tool for files that live on your Urbit.  You're probably reading this file using Tree right now.  The main driving use-case for Tree has been for us to host our own documentation and the surrounding discussion.  Tree remains a pretty simple and flexible tool for getting content online.  We think it's pretty great.

Tree is a simple static publishing tool and the basic UI for browsing the filesystem.  We take it one step further and make it possible to write modules (tiny little apps), like Talk and Dojo, that can be run directly inside of Tree.  

In the browser Tree is a [React](https://facebook.github.io/react/) / [Flux](https://facebook.github.io/react/blog/2014/05/06/flux.html) app that uses a slightly modifed version of [Bootstrap](http://getbootstrap.com/).  On your Urbit Tree is a renderer that translates data in `%clay`, our filesystem, into JSON / JSX that can be read by the client.  

Your Urbit comes with a pre-built copy of the tree (as a single `.js` file).  If you're interested in helping to develop tree or learning about how it works, it has its own GitHub repo [here](https://github.com/urbit/tree).  We have our own fork of Bootstrap, which lives [here](https://github.com/urbit/bootstrap).

## `/web/pages`

To render content without the Tree put it in `/web/pages`.  Files in this directory aren't wrapped by Tree.  For some examples check out [`web/` in the examples repo](https://github.com/urbit/examples/tree/master/web).

## Publishing files

Publishing files in Tree is simple.  Try dropping a file in `/web` (as covered in the Quickstart) and navigating to it.

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

### `<list>`

Example: `<list src="/posts" titlesOnly="true" />`

Creates a list of children at a path.  Defaults to the current path.

Optional properties:

- `src`: Path to load kids from.  
- `titlesOnly`: Only show the 'title' which is either the filename or the first h1.
- `sortBy`: Can be `date` if items have a `date` YAML.
- `className`: Class to be assigned to the container.

### `<kids>`

Example: `<kids src="/posts" />`

Includes all the children at the specified path separated by `<hr>` tags.

Optional properties:

- `src`: Path to load kids from.
- `className`: Class to be assigned to the container.

### `<toc>`

Example: `<toc noHeader="true" />`

Creates a table of contents from the `h1` - `h6` tags on the page.

Optional properties:

- `match`: Tag name to match.  If you wanted to only match `h2` tags it could be `match="h2"`
- `noHeader`: By default we add a 'Table of Contents' header to the top.  Remove it with `noHeader="true"`.

## Implementation

On the frontend Tree is mostly just a standard Flux app: components generate actions that get dispatched to stores which are picked up by components.  If you're not familiar with Flux, [this overview](https://facebook.github.io/flux/docs/overview.html) is a good place to start.  

As a file browser Tree does a simple job: it fetches data and keeps a cache of what it has seen.  To do this simple job we do three fancy things:  `manx` to JSON encoding, the Async component and Modules.

### `manx` to JSON format

Since we want to use React to manage our DOM lifecycle we actually transfer the DOM structure of each page as JSON over the wire, and 'reactify' it on the client side.  

On the Urbit side we have a type for html: `++manx`.  Our wire format for sending HTML as JSON is really similar to a `++manx`.  If you're not interested here's what the json looks like:

```
"string" || {gn:"string", ga:{key:"string", [...]}, c:[...]}
```

To make this clearer let's look at some HTML and it's JSON representation:

```
<div class="blue">
    <h1>Title</h1>
</div>
```

```
{gn:"div", ga:{className:"blue"}, [
    {gn:"h1", ga:null, "Title"}
]}
```

To see the mechanics of how this is handled on the frontend, checkout `components/Reactify.coffee` in the `urbit/tree` repo.

### Async component

Each of our components (even those we fetched from the server) can depend on data that may not exist in our stores, so we wrap our components in a general-purpose Async component.  You can find the component in `components/Async.coffee` in the `urbit/tree` repo.

When we say that we just fetch HTML as JSON it's actually slightly more complicated.  When we fetch a node in the filesystem we might not want to fetch its entire contents.  Sometimes we just get the title as a part of a list of children, sometimes we might get a snippet (in a list with previews), and sometimes we get the whole thing.  On the Urbit side these results are provided by `ren/tree/json`.  

From the perspective of the frontend we just send queries on a path that obey a simple API.  To see this in action, here's our `BodyComponent`:

```
query {
  body:'r'
  name:'t'
  path:'t'
  meta:'j'
  sein:'t'
}
```

Here we're asking for the body, name, path, metadata and parent of the current path.  When it loads that data gets passed to our component as props.

### Module basics

A module is a special component that can kind of 'take over' the page.  It can change properties of the nav bar as well as load custom scripts / css.

Talk, for example, looks like this:

```
<module nav_title="Talk" nav_no-dpad="" nav_no-sibs="" nav_subnav="talk-station">
    <script src="/~~/~/at/lib/js/urb.js" />
    <script src="/talk/main.js" />
    <link href="/talk/main.css" rel="stylesheet" />
    <talk />
</module>
```

A module will first download all the scripts and styles that it specifies before trying to load any contained components.  This means that you can define React components in external scripts and a module can be entirely self contained.  The `<talk>` component isn't a part of Tree — it's loaded first before it's executed.

If you're interested in seeing how a module works you can check out the source for Talk [here](https://github.com/urbit/talk).  Dojo also ships on your Urbit, its source is [here](https://github.com/urbit/sole).

## `urb.js`

The most basic interface between your browser and your Urbit is `urb.js`.  This small library provides the basic utilities for sending and receiving messages from an Urbit.  

### `window.urb.appl`

Each JSON message sent to your Urbit needs an app endpoint.  Can be set as a global `window.urb.appl` or set on a per-request basis in the payload to `send()`.

### `window.urb.oryx`

CSRF token.  Written to the page by Eyre, our webserver, when logged in.  Required part of any authenticated request and included by default.

### `window.urb.req(method,url,params,json,cb)`

Our basic request wrapper.  You can see here how a request needs to be packaged to be properly understood by your Urbit.

### `window.urb.subscribe({path:"string"})`

Subscribe to an endpoint.  Subscription data is returned through the continuous long poll.  

### `window.urb.unsubscribe({path:"string"})`

Close subscription on specified path.

### `window.urb.poll()`

Mechanics of the continuous long poll.  Used mostly internally.  

### `window.urb.util`

Library of utility and helper functions.

