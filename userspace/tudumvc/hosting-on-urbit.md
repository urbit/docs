+++
title = "Hosting Files on Urbit"
weight = 4
template = "doc.html"
+++

# Introduction - TodoMVC on Urbit (sort of) {#introduction}
The goal here is to get a fully integrated version of TodoMVC, back-ended by Urbit, to run entirely from an Urbit. To start off, we'll host the default React.js + Hooks implementation of TodoMVC on a ship. From there, we can work on building a backend for the app, using a %gall agent.

## Required Files {#required-files}
* The /src-lesson2/react-hooks folder copied to your local environment.

## Learning Checklist {#learning-checklist}
* Interacting with TodoMVC using `yarn`, including
    * How to use yarn to run JavaScript apps in a _dev_ environment.
    * How to use yarn to package JavaScript apps for hosting.
    * **NOTE:** We're not really tutorializing yarn here, but we will cover its use for this very basic application.
    * **NOTE:** npm can be used in the alternative, but one shouldn't switch between the two - stick with one.
* How to host Earth web files from Urbit.
* What `%file-server` does.
* What file types Urbit can recognize.
* How, generally, new file type recognition could be added to Urbit. 
* What pokes are and what purpose they serve.

## Goals {#goals}
* Prepare a minified version of TodoMVC from the source code.
* Host the minified version of TodoMVC (or some other Earth web file) from our Urbit.
* Briefly describe the use of /mar files in Urbit.
* poke an app from the `dojo`.

## Prerequisites {#prerequisites}
* A development environment as created in the previous chapter.
* The [Chapter 2 files](https://github.com/rabsef-bicrym/tudumvc/tree/main/src-lesson2) from the git repository that you cloned in the last chapter.
  * If you haven't done this yet, in a folder that isn't your home directory of your ship, run `git clone https://github.com/rabsef-bicrym/tudumvc.git`.
  * **NOTE:** You could alternatively follow along with this chapter by cloning the TodoMVC repository and working in the react-hooks example therein, but we've packaged just that example in the files prepared for this chapter.

## Chapter Text {#chapter-text}
[TodoMVC](https://github.com/tastejs/todomvc) is a basic todo list that has been replicated in a variety of JavaScript frameworks to help teach how those JavaScript frameworks differ. This tutorial works with the [React.js + Hooks](https://github.com/tastejs/todomvc/tree/master/examples/react-hooks) implementation of TodoMVC for two main reasons:

The first is the ubiquity of React.js for web app development. TodoMVC's React.js + Hooks implementation also incorporates the most modern usage of React.js (Hooks). The React + Hooks framework is a great choice for building modern front ends and is fairly easy to learn and well documented online (in addition to its ubiquity), allowing this tutorial to focus on the Urbit side of things, mostly.

The second is the way in which Urbit and React compliment each other. Urbit is sometimes described as an _operating function_ rather than an operating system because it is a fully deterministic, stateful and "subject-oriented" computing environment that is fully [referentially transparent](https://en.wikipedia.org/wiki/Referential_transparency). This means two things:
* Every input that Urbit receives is processed as an event which changes (or at least can change) the state, or currently available data of the Urbit.
* The resulting state of an Urbit post event-processing is indistinguishable from an Urbit that had that (resulting) state to start with (generally speaking).

In other words, given some starting state and some expected input, an Urbit will predictably arrive at some resulting state, and that resulting state is effectively indistinguishable from some other Urbit that simply started with that resulting state. The events themselves aren't particularly relevant (generally), only the state matters in determining what our Urbit is doing or displaying at any given time.

Similarly, React.js is a Javascript framework that renders a DOM (or, effectively, a webpage) based on the current state. Changes are managed by changing the state which React automatically interprets into a re-rendered DOM. It doesn't matter to React.js how or why the state has changed, only that it has. When the state changes, the DOM re-renders.

Urbit and React.js are similarly stateful and Urbit is a great candidate for managing a React.js app's state and returning a changed state for React.js to re-render into a DOM.

We'll start by preparing our TodoMVC app for hosting:

### Preparing TodoMVC {#preparing-earth-app}
The /react-hooks example of TodoMVC can be found here [/tudumvc/src-lesson2/react-hooks](https://github.com/rabsef-bicrym/tudumvc/tree/main/src-lesson2/react-hooks). The files in this folder are all still basic JavaScript (and other non-urbit native) files. There are two basic ways we could interact with these files:
* As a dev environment run directly from the files.
  * This method allows us to run the app directly from the files and have changes made to the JavaScript automatically cause the page to re-render.
* As a minified "build" of the files.
  * Minifying is generally done once the app is finished, to prepare it for deployment.

#### `yarn install`
First, we've installed the relevant node_modules by running `yarn install` in the /react-hooks folder. `yarn install` looks at all the dependencies required to run TodoMVC and downloads the relevant packages. `yarn` is outside the scope of this tutorial, but if you want to know more about how this works, take a look [here](https://classic.yarnpkg.com/en/docs/cli/install/). In any event, it completes with some output that looks like this:
```
[4/4] Building fresh packages...
success Saved lockfile.
Done in 40.09s.
```
That prepares us to either:

#### Run a Dev Version of the App
Using yarn to run TodoMVC without minifying it allows us to make changes to the underlying JavaScript files while the app is running. The app will automatically recompile and display any changes on screen.

Running `yarn run dev` in the same /react-hooks folder will start the development server. The app will then load at some local address and port:
```
Compiled successfully!

You can now view hooks-todo in the browser.

  http://localhost:3000/

Note that the development build is not optimized.
To create a production build, use yarn build.
```

Any changes we might want to make will cause the site to rerender as the development server rebuilds the project. For instance, if we changed line 66 of `/react-hooks/containers/TodoList.js` to:
```
<h1>tudus on Urbit</h1>
```
And save the changes, the app will recompile with the new header text.

The dev build can be shut down using `CTRL+C` in the terminal window in which it's running.

#### Compiling a Minified Version of an App
Today, we just want to host the existing app from our Urbit with no other changes. To do that, we'll create a minified 'build' using `yarn build` in the `/react-hooks` folder. This generates some output like this:
```
yarn run v1.22.10
$ react-scripts build
Creating an optimized production build...
Compiled successfully.

File sizes after gzip:

  56.32 KB  build/static/js/2.1ff61cb7.chunk.js
  2.5 KB    build/static/js/main.fd6ebb66.chunk.js
  1.74 KB   build/static/css/2.8e2a78c7.chunk.css
  771 B     build/static/js/runtime~main.60127afb.js
  72 B      build/static/css/main.be9cd952.chunk.css

The project was built assuming it is hosted at /hooks-todo/.
You can control this with the homepage field in your package.json.

The build folder is ready to be deployed.
```
`yarn build` creates a /build sub-folder in the /react-hooks folder, to house the minified version of the app. If we copy the contents of the /build sub-folder somewhere on our Urbit, we can host it using the existing `%file-server` functionality. Conventionally, web content hosted by a %gall agent (which is where we're going with this tutorial) should be stored in the /app folder of an Urbit, in a sub-directory with the same name as the %gall agent. Since we're not using a gall agent yet, we'll create an /app/hooks-todo folder to mirror the name of the app as set in the [`package.json` file](https://github.com/rabsef-bicrym/tudumvc/blob/ea4f7ab12a4e33de15da7e2c1083fddbc9d44bdd/src-lesson2/react-hooks/package.json#L2).

Using our sync routine (from /devops, `bash dev.sh ~/your/path/home`) to sync the new folder and contents to the Fake Ship we can then uptake the files into the urbit using `|commit %home` in the Fake Ship's dojo.

If you're following along on your own ship, you probably (`.ico` file type support coming soon) received an error message terminating in something like:
```hoon
[%error-validating /app/todomvc/favicon/ico]
[%validate-page-fail /app/todomvc/favicon/ico %from %mime]
[%error-building-cast %mime %ico]
[%no-file %mar %ico]
```
Urbit is currently unable to interpret the file type .ico (or the favicon icon for TodoMVC). The error message ends by saying that there is `%no-file %mar %ico`. The /mar folder on Urbit consists of files that help interpret non-hoon file types into hoon-legible files. To date, no one has written an `%ico` interpreting file ([not true, but not merged yet](https://github.com/urbit/urbit/pull/4833)). Take a look at `/mar/png.hoon` if you'd like and consider how you might build an `ico.hoon` file (or take a look at the linked pull request in the prior sentence).

This tutorial isn't intended to cover /mar files, though, so we'll just avoid the issue by:
1. Stopping the sync process, if it's still running (`CTRL-C` in the terminal running the sync process).
2. Deleting favicon.ico from the `/devops/app/hooks-todo` folder.
3. Replacing the Fake Ship with the backup - 
    * `CTRL+D` to shut down the ship
    * `rm -r nus` to delete the current version
    * `cp -r nus-bak nus` to replace our Fake Ship
    * `./urbit nus` to run it again
4. Restarting the sync process (`bash dev.sh ~/urbit/nus/home` from /devops).
5. `|commit %home` again.

Everything should complete this time. Now to to host these files to the Earth web using our Urbit.

### Hosting Earth Web Files from Urbit {#hosting-files-from-urbit}
Urbit has a %gall agent prebuilt for hosting Earth web data, called `%file-server`, though we could theoretically work with %eyre directly.

#### %gall agent Communications
Urbit's %gall services (also known as agents) are programs with a rigorously defined structure of a core with 10 arms. %gall agents are basically [microservices](https://en.wikipedia.org/wiki/Microservices) with a built-in database structure for managing their own data. 

%gall agents' standardization of style is complimented by a standardization of handling by the agent management vane (or kernel module) of Urbit, called %gall. The benefit of these standards is that it effectively makes all agents and vanes interoperable through a rigorously defined protocol. These methods take two forms:
* pokes
* quips of cards
  * **NOTE:** A poke is, itself, a sub-type of card that can be passed to an agent. Nonetheless, common parlance distinguishes them, at least nominally.

This tutorial spends more time later talking about pokes and cards, but for now we can suffice to say that a poke is an input of data and instructions to a specific %gall agent and a card is a communication of data and instructions to a %gall agent or %arvo vane from another %gall agent or %arvo vane. pokes are handled in the `++  on-poke` arm of a given %gall agent; it just makes sense.

To get the default version of TodoMVC running off of our Urbit, we're going to use a poke from the dojo to tell `%file-server` to start serving the files from /app/hooks-todo.

#### `/sur/file-server.hoon` {#sur-file-server}
%gall agents are frequently accompanied by a /sur file that specifies a few types that the agent can recognize. Chief amongst these types, for our understanding, is the action type. It's completely unnecessary for an agent to even have an action type, but by convention most agents with complex poke structures have a type called action (at least), and perhaps some others as well. These will commonly be accompanied by a /mar file that can help mold nouns of various types (JSON for instance) into the correct structure for the action (or other) poke type.

The action type specification in a /sur file effectively specifies what kind of (action) pokes, or what kind of input can be provided to that specific agent. The file `/sur/file-server.hoon` contains the following type:
```hoon
+$  action
  $%  [%serve-dir url-base=path clay-base=path public=? spa=?]
      [%serve-glob url-base=path =glob:glob public=?]
      [%unserve-dir url-base=path]
      [%toggle-permission url-base=path]
      [%set-landscape-homepage-prefix prefix=(unit term)]
  ==
```
The rune [`+$`](https://urbit.org/docs/reference/hoon-expressions/rune/lus/#lusbuc) (pronounced "lusbuc"; find more rune use information [here](https://storage.googleapis.com/media.urbit.org/docs/hoon-cheat-sheet-2020-07-24.pdf)) defines a type. The first argument following `+$` is the name of the type and the second argument is the specification of the type. Here, the specification of the type is actually, itself, defined by a rune, [`$%` ("buccen")](https://urbit.org/docs/reference/hoon-expressions/rune/buc/#buccen).

`$%` is a [tagged union](https://en.wikipedia.org/wiki/Tagged_union), or list of types with different expected structure that our Urbit recognizes by the head atom (if you need more instruction on atoms and cells before proceeding, we recommend that you [read this](https://urbit.org/docs/tutorials/hoon/hoon-school/nouns/)). Above, `%serve-dir` (the head atom of that sub-structure) creates an expectation of four other nouns in that cell: (1) An `url-base` that is a path, (2) A `clay-base` that is also a path, (3) A `public` switch that is a boolean and (4) A `spa` switch that is also a boolean.

Thankfully, `/sur/file-server.hoon` file is well commented, (as is the [version on the Urbit GitHub](https://github.com/urbit/urbit/blob/50d45b0703eb08a5b46a8ff31818b3a6f170b9f8/pkg/arvo/sur/file-server.hoon#L6)):
```hoon
::    url-base   site path to route from
::    clay-base  clay path to route to
::    public     if false, require login
::    spa        if true, `404` becomes `clay-base/index.html`
```
The comments make clear what each noun does - `url-base` will set the url `%file-server` will serve the to, `clay-base` will tell `%file-server` what files to serve at that URL, `public` will switch whether user login is required to access the page (this will use the same login `+code` as Landscape), and lastly `spa` sets the 404 Error page.

Here, we want to serve our files from /app/hooks-todo (`clay-base` - recall that %clay is the filesystem of Urbit) to `http://localhost:8080/hooks-todo` (`url-base`) and make them `public` (`%.y`), while keeping the 404 Error page as the default 404 Error page (`%.n`). So, our `%file-server` poke will look like this:
```hoon
[%serve-dir /'~todomvc' /app/todomvc %.y %.n]
```

#### poke-ing `%file-server` {#poke-file-server}
Sending a poke to a %gall agent from the dojo follows this format:
```hoon
:<gall agent> &<gall agent>-action <poke action>
```
Three things are going on here:
* Specify the agent to poke (`:file-server`, for instance),
* Specify the mark of the poke (`&file-server-action`), so Urbit knows how to interpret it (see the [Breakout Lesson](@/docs/userspace/tudumvc/breakout-lessons/quip-card-and-poke.md) for more information on this),
* Specify the poke type (`%serve-dir`) and supply the expected arguments for that poke.

In dojo, we'd enter:
```hoon
:file-server &file-server-action [%serve-dir /'hooks-todo' /app/hooks-todo %.y %.n]
```

If we navigate to our ship's URL + `/hooks-todo`, like `https://localhost:8080/hooks-todo`, we'll be presented with our Earth web app, as hosted from our Urbit!

## Additional Materials {#homework}
* Read through the rest of the commented version of [`/sur/file-server.hoon`](https://github.com/urbit/urbit/blob/master/pkg/arvo/sur/file-server.hoon).
* Read the [`+on-poke` arm](https://github.com/urbit/urbit/blob/50d45b0703eb08a5b46a8ff31818b3a6f170b9f8/pkg/arvo/app/file-server.hoon#L105) of `/app/file-server.hoon` and try and figure out what's going on there - how is the poke from above being handled?
* Read _just_ the introduction/overview of [`~timluc-miptev`'s Gall Guide](https://github.com/timlucmiptev/gall-guide/blob/master/overview#what-is-gall)

## Exercises {#exercises}
* Identify how you might switch our current TodoMVC hosting to private, requiring a login.
* Host a static HTML file from your test ship that says "Hello World!" or something else, if you're feeling daring.

## Summary and Addenda {#summary}
You now know how to host Earth web files from Mars - and there's way less latency than you might imagine (eat your heart out, NASA)! While we'll discuss it later in more detail, you might want to have a better understanding of:
* [cards and pokes](@/docs/userspace/tudumvc/breakout-lessons/quip-card-and-poke.md)

That breakout is optional, and not necessary to continue. However, by now you should generally:
* Know how to use `yarn` to run a _dev_ version of TodoMVC straight from the non-minified files
* Know how to use `yarn` to package a production build of TodoMVC when you're ready.
* Know how to poke `%file-server` to ask it to host Earth web content for you
* Know what a /mar file does, very generally.
* Know what a /sur file does, very generally.
* Know at least one limitation of file types Urbit is immediately able to serve.