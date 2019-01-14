# Urbit docs

These are the urbit docs as they appear on [urbit.org](https://urbit.org/docs/).

We've found it helps to have a clone of the docs on hand in case urbit.org
experiences high traffic. Follow these steps to get these into your ship:

## Installation

First, you'll need a running urbit. Follow our urbit.org [install
instructions](https://urbit.org/docs/using/install/), then
[setup](https://urbit.org/docs/using/setup/) an urbit.

### Local install

In your urbit's Dojo:

    ~your-urbit:dojo> |mount /=home=

You can now find your home desk at the path `/path/to/your-urbit/home/`.

In Unix, clone this repo somewhere and copy in the `docs` files to your urbit's
mounted `%home` desk. You can run the following shell commands (*replacing your
urbit's home desk path as necessary*):

    $ git clone https://github.com/urbit/docs.git
    $ cd ./docs/
    $ cp -r ./docs* /path/to/your-urbit/home/web/

Your Clay filesystem should acknowledge the newly added files.

Lastly, if make sure you're serving your home desk's `web` directory to the web
by running the following Dojo command:

    ~your-urbit:dojo> |serve /=home=/web

## Get started!

And now your docs are live! View them at:

    http://localhost:8080/~~/docs

> If you're running multiple ships locally, your port number will be `8081`,
  `8082`, and so on. Check your Dojo output for the correct local port of
  your examples urbit, or view these at `https://your-urbit.urbit.org` over DNS
  instead for live-network ships. You can also replace `localhost` with the IP
  of your instance, if you're running your urbit in the cloud.

## Building the docs with |static

**note** This instructions are for use with the the [release-candidate branch](https://github.com/urbit/arvo/tree/release-candidate) 
of Arvo.

Arvo comes with a built-in static site generator, which is very useful for 
exporting sites and pages built with udon, sail, html, markdown or some 
combination of these. Combinations like these docs that you're reading!

In order to build the docs into a static site, do the following.

Make sure that you've mounted your ship to your filesystem, but running the following 
in your Dojo.

> ~ship:dojo>|mount /===

Then, copy these docs into the pier of a booted ship. It is very important that 
copy the docs into the exact directory indicated in your pier.

> $ cp -r . <ship-name>/home/web/static-site

Now, run the static site generator on your urbit ship.

> ~ship:dojo>|static

You can now navigate to the output director and run a webserver to view your built docs.

> $ cd <ship-name>/.urb/put/web/static-site
> $ python -m SimpleHTTPServer

Visit `localhost:8000` to see the built docs. Rerun `|static` to build docs and 
see changes.

## Learn a lot, and have fun!

People are always around on
[Talk](https://urbit.org/docs/using/setup#-messaging-talk) and
[Fora](https://fora.urbit.org/) to answer your questions. Help each other
out, and don't hesitate if you have an idea for a docs improvement. We'd love if
the docs themselves became an Urbit community project.

## Contributing / Feedback

Give us feedback [on Fora](https://fora.urbit.org/) on how we can make the
docs better. Let us know about your ideas, requests, and/or problems and we'll
try and get back to you quickly. Pull requests are more than welcome.
