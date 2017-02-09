---
navhome: /docs/
sort: 3
title: A static site
---

# A static site

Hosting a static tree of content is easy.  Let's put together a really
simple site for an imaginary Urbit meetup group.

We assume you have at least followed the beginning of [our first
example](./blog) and created a desk called `site` and mounted it to
unix.

In `site/web/meet.md` put:

    ---
    navdpad: false
    navmode: navbar
    navpath: /meet
    navhome: /meet
    ---

    # Neo-Tokyo Urbit meetup

    <img src="https://ofheroesandcliches.files.wordpress.com/2014/06/neo-tokyo.png" width="100%"/>

    Hi there! We meet once a week at The Chat to work on Urbit projects
    together.

    You can find out more about the group on the [about](about) page and
    follow our projects in [projects](projects).

This is our landing page.  Here we're using a few new bits of YAML:
`navdpad`, `navmode` and `navpath`.  `navdpad` just turns off the nav
arrows. `navmode` can be set to 'navbar' to switch to a horizontal top
nav instead of a left bar. `navpath` sets the path to load the nav
items from.  

Let's create `about.md` and `projects.md`.  From Unix use the
technique from before to create a new directory: `mkdir
your-urbit/site/web/meet/; touch your-urbit/site/web/meet/about.md`.
Then put the following in `site/web/about.md`:

    ---
    navdpad: false
    navmode: navbar
    navpath: /meet
    navhome: /meet
    title: About
    ---

    # About

    ## Mission statement

    The existing framework cannot subdue the new human force that is increasing day by day alongside the irresistible development of technology and the dissatisfaction of its possible uses in our senseless social life.

    ## Members

    Membership is open to anyone.  Just send a message to `~talsur-todres`.

    - Shōtarō Kaneda
    - Motoko Kusanagi
    - Ishikawa
    - Faye Valentine
    - Spike Spiegel

And `site/web/projects.md`:

    ---
    navdpad: false
    navmode: navbar
    navpath: /meet
    navhome: /meet
    title: Projects
    ---

    # Projects

    ## Active

    <list />

    ## Discussion

    <div class="mini-module">
        <script src="/~/at/lib/js/urb.js"/>
        <script src="https://cdn.rawgit.com/seatgeek/react-infinite/0.8.0/dist/react-infinite.js"/>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.11.2/moment-with-locales.js"/>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/moment-timezone/0.5.1/moment-timezone.js"/>
        <script src="/talk/main.js"/>
        <link href="/talk/main.css" rel="stylesheet" />
        <talk readonly="" chrono="reverse" station="comments" />
    </div>

This page introduces a new thing: the `:talk` module.  Inside of the
`mini-module` div we load the scripts needed by the `<talk>`
component.  The `<talk>` component is a static component for
displaying a feed from a talk channel inline.  Here we're going to
display the discussion from our active projects inline.

We'll need a few active projects though.  From unix: `mkdir
your-urbit/site/web/meet/projects; touch
your-urbit/site/web/meet/projects/bike.md`.

In `site/web/meet/projects/bike.md`:

    ---
    navdpad: false
    navmode: navbar
    navpath: /meet
    navhome: /meet
    title: Kaneda's Bike
    comments: true
    ---

    # Urbit on a Motorcycle

    Discussion on getting urbit to power Kaneda's motorcycle.

Here we just use the `comments` YAML to enable comments on the page.
Adding other imaginary projects is left to the reader.  

Building a static site takes only a few minutes and a few markdown
files.  Have fun!
