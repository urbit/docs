---
navhome: /docs/
sort: 8
title: From Unix
---

<div class="row">
<div class="col-md-8">

# Using Urbit from Unix

With `urb` at your Unix command line, you can execute hoon, run
dojo commands, and more.  Additionally, with `fuse`, you can
inspect the urbit namespace.

</div>
</div>

## Installation

These commands are in the a [separate
repo](https://github.com/urbit/urb).  Clone this repo to get the
commands.

You'll also need the `requests` and `fuse` libraries for python.
If you have `pip`, you can just run:

```
pip install requests fuse-python
```

Otherwise, on Ubuntu, run:

```
apt-get install python-requests python-fuse
```

Then you can either run the python commands from the git repo, or
put them somewhere in your path.

## `urb`

`urb` transfers data from a source to a sink.  Examples of data
sources include literal data, a file, a URL, or some
tranformation of another source.  Examples of data sinks are
stdout, output file, POST request, or dojo command.

Here are some examples.  This takes the literal data "hello
world" and sends it to stdout (the default sink).

    urb --data 'hello world'

Let's run some hoon code at the dojo.

    urb --dojo '(add 2 2)'

Let's convert a markdown file to html.

    urb --data @@file.md -m md -m html

Mount the `%home` desk.  This syncs the `home` desk into the pier
directory.

    urb --dojo '+hood/mount /=home=' --app hood

### Sources

Sources can be any of the following:

- `-d, --dojo command` runs a dojo command.  This is commonly
  naked hoon code, but it can also be a generator, or any of the
  other ways the dojo gets data.

- `-D, --data text` is literal text data, as a cord.

- `-c, --clay path` pulls data from Urbit's filesystem.

- `-u, --url url` pulls data from a URL.

- `-m, --mark mark source` converts the output from another source to
  a new 'mark' (datatype).

- `-H, --hoon code source` transforms the output of another
  source by running it through some hoon code.

- `[source-0 source-1 ...]`.  Sources can be combined into tuples
  of different sources.

Any of the arguments to a source (except in the "compound
sources" `--mark` and `--hoon`) can be replaced by `-` to
represent stdin or `@@filename` to pull data in from a Unix file.
Thus, `urb [-D @@file1 -D - -D @@file2]` is equivalent to Unix's
`cat file1 - file2`.

Additionally, if no source is specified, `--data -` (stdin as
literal text data) is assumed.

### Sinks

- `-s, --stdout` outputs to stdout.  This is the default.

- `-f, --output-file path` writes to a unix file.

- `-C, --output-clay path` writes to Urbit's filesystem.

- `-U, --output-url url` sends a POST request with the data to
  the URL.

- `-p, --app app` sends the data to an urbit app.

- `-x, --command` outputs to a literal dojo command.

## `fuse`

Urbit's namespace is accessible through the `fuse` command.
`fuse` takes all the normal FUSE arguments, which you can see
with `fuse -h`.  Generally, you just run `fuse MOUNT-POINT`.

When accessing the namespace through `fuse`, everything is
read-only.  If you want to write to Clay, mount a desk, as
described above.

Let's look first in the Clay portion of the Urbit namespace.
Assume we've mounted to `./pt`.

    $ ls ./pt/c/=/=/=
    app  arvo  gen  lib  mar  ren  sec  sur  web
    $ ls ./pt/c/=/=/=/arvo
    ames  behn  clay  dill  eyre  ford  gall  hoon  zuse

Those `=`s aren't decorative.  The first `=` means "current
ship", the second "current desk", and the third "current
revision".  Let's try something a little more exciting.

This runs the Unix `diff` command on the first and current
versions of the `app/gh/hoon` file, showing all the changes we've
made to the file.

```
$ diff pt/c/=/=/{1,=}/app/gh/hoon                
73c73,75
<         (malt (turn issues |=(issue:gh [(rsh 3 2 (scot %ui number)) ~])))
---
>         %-  malt  ^-  (list {@ta $~})
>         :-  [%gh-list-issues ~]
>         (turn issues |=(issue:gh [(rsh 3 2 (scot %ui number)) ~]))
92c94,101
<           read-y=(read-get /issues)
---
>           read-y=(read-static %gh-list-issues ~)
>           sigh-x=sigh-list-issues-x
>           sigh-y=sigh-list-issues-y
>       ==
>       ^-  place                       ::  /issues/mine/<mark>
>       :*  guard={$issues $mine @t $~}
>           read-x=read-null
>           read-y=|=(pax/path [ost %diff %arch `0vsen.tinel ~])
126c135
<       ^-  place                       ::  /issues/by-repo/<user>/<repo>
---
>       ^-  place                       ::  /issues/by-repo/<user>/<repo>/<number>
131c140,146
<           read-y=(read-static ~)
---
>           ^=  read-y
>           |=  pax/path
>           %.  pax
>           ?:  ((sane %tas) -.+>+>.pax)
>             (read-static ~)
>           (read-static %gh-issue ~)
>         ::
137a153,159
>           sigh-y=sigh-strange
>       ==
>       ^-  place                       ::  /issues/by-repo/<u>/<r>/<n>/<mark>
>       :*  guard={$issues $by-repo @t @t @t @t $~}
>           read-x=read-null
>           read-y=|=(pax/path [ost %diff %arch `0vsen.tinel ~])
>           sigh-x=sigh-strange
```

Urbit's namespace is not just revisioned, but global.  Here's a
diff of our version of `arvo/gall/hoon` compared to the one on
the `~bud` urbit.

```
$ diff pt/c/{~bud,=}/=/=/arvo/gall/hoon
2d1
< 
640a640,644
>       =+  ?.  ?=($x ren)
>             [mar=%$ tyl=tyl]
>           =+  `path`(flop tyl)
>           ?>  ?=(^ -)
>           [mar=i tyl=(flop t)]
643c647
<         ((slog leaf+"peek find fail" >tyl< ~) [~ ~])
---
>         ((slog leaf+"peek find fail" >tyl< >mar< ~) [~ ~])
654a659,660
>           ?.  =(mar p.q.caz)
>             [~ ~]
1308a1315,1316
>   ?.  ?=(^ tyl)
>     ~
```

Besides Clay, the namespace contains Gall apps.  One common usage
of the app namespace is to expose APIs.  For example, if you
start the `%gh` app (`|start %gh`), you can do things like `cat`
an issue from a repository.

```
$ cat pt/g/=/gh/=/issues/by-repo/philipcmonktest/testing/7/txt
title: big news! (#7)
state: open
creator: philipcmonktest
created-at: 2016-03-24T22:27:33Z
assignee: philipcmonktest
labels: invalid, wontfix, help wanted
comments: 0
url: https://api.github.com/repos/philipcmonktest/testing/issues/7

Yup, that's it. i mean, maybe it's a bit longer than that.

But you get the point, right?

Code `is` cool!
```

Or all open issues for a repository.

```
$ cat pt/g/=/gh/=/issues/by-repo/philipcmonktest/testing/txt
title: i found a bug! (#11)
state: open
creator: philipcmonktest
created-at: 2016-04-14T23:14:49Z
assignee: none
labels: 
comments: 1
url: https://api.github.com/repos/philipcmonktest/testing/issues/11


----------------------------------------
title: more newz (#8)
state: open
creator: philipcmonktest
created-at: 2016-03-24T22:29:16Z
assignee: none
labels: 
comments: 4
url: https://api.github.com/repos/philipcmonktest/testing/issues/8

Yup, that's it. i mean, maybe it's a bit longer than that.

But you get the point, right?

Code `is` cool!
----------------------------------------
title: big news! (#7)
state: open
creator: philipcmonktest
created-at: 2016-03-24T22:27:33Z
assignee: philipcmonktest
labels: invalid, wontfix, help wanted
comments: 0
url: https://api.github.com/repos/philipcmonktest/testing/issues/7

Yup, that's it. i mean, maybe it's a bit longer than that.

But you get the point, right?

Code `is` cool!
----------------------------------------
title: something different (#4)
state: open
creator: philipcmonktest
created-at: 2016-01-26T21:45:08Z
assignee: philipcmonktest
labels: duplicate, help wanted, question, bug
comments: 1
url: https://api.github.com/repos/philipcmonktest/testing/issues/4
```

Don't like the textual format?  How about we get the raw JSON
(and prettyprint it).

```
$ cat pt/g/=/gh/=/issues/by-repo/philipcmonktest/testing/7/json | python -m json.tool
{
    "assignee": {
        "avatar_url": "https://avatars.githubusercontent.com/u/16787461?v=3",
        "events_url": "https://api.github.com/users/philipcmonktest/events{/privacy}",
        "followers_url": "https://api.github.com/users/philipcmonktest/followers",
        "following_url": "https://api.github.com/users/philipcmonktest/following{/other_user}",
        "gists_url": "https://api.github.com/users/philipcmonktest/gists{/gist_id}",
        "gravatar_id": "",
        "html_url": "https://github.com/philipcmonktest",
        "id": 16787461,
        "login": "philipcmonktest",
        "organizations_url": "https://api.github.com/users/philipcmonktest/orgs",
        "received_events_url": "https://api.github.com/users/philipcmonktest/received_events",
        "repos_url": "https://api.github.com/users/philipcmonktest/repos",
        "site_admin": false,
        "starred_url": "https://api.github.com/users/philipcmonktest/starred{/owner}{/repo}",
        "subscriptions_url": "https://api.github.com/users/philipcmonktest/subscriptions",
        "type": "User",
        "url": "https://api.github.com/users/philipcmonktest"
    },
    "body": "Yup, that's it. i mean, maybe it's a bit longer than that.\r\n\r\nBut you get the point, right?\r\n\r\nCode `is` cool!",
    "closed_at": null,
    "closed_by": null,
    "comments": 0,
    "comments_url": "https://api.github.com/repos/philipcmonktest/testing/issues/7/comments",
    "created_at": "2016-03-24T22:27:33Z",
    "events_url": "https://api.github.com/repos/philipcmonktest/testing/issues/7/events",
    "html_url": "https://github.com/philipcmonktest/testing/issues/7",
    "id": 143377108,
    "labels": [
        {
            "color": "ffffff",
            "name": "wontfix",
            "url": "https://api.github.com/repos/philipcmonktest/testing/labels/wontfix"
        }
    ],
    "labels_url": "https://api.github.com/repos/philipcmonktest/testing/issues/7/labels{/name}",
    "locked": false,
    "milestone": null,
    "number": 7,
    "repository_url": "https://api.github.com/repos/philipcmonktest/testing",
    "state": "open",
    "title": "big news!",
    "updated_at": "2016-03-24T22:27:33Z",
    "url": "https://api.github.com/repos/philipcmonktest/testing/issues/7",
    "user": {
        "avatar_url": "https://avatars.githubusercontent.com/u/16787461?v=3",
        "events_url": "https://api.github.com/users/philipcmonktest/events{/privacy}",
        "followers_url": "https://api.github.com/users/philipcmonktest/followers",
        "following_url": "https://api.github.com/users/philipcmonktest/following{/other_user}",
        "gists_url": "https://api.github.com/users/philipcmonktest/gists{/gist_id}",
        "gravatar_id": "",
        "html_url": "https://github.com/philipcmonktest",
        "id": 16787461,
        "login": "philipcmonktest",
        "organizations_url": "https://api.github.com/users/philipcmonktest/orgs",
        "received_events_url": "https://api.github.com/users/philipcmonktest/received_events",
        "repos_url": "https://api.github.com/users/philipcmonktest/repos",
        "site_admin": false,
        "starred_url": "https://api.github.com/users/philipcmonktest/starred{/owner}{/repo}",
        "subscriptions_url": "https://api.github.com/users/philipcmonktest/subscriptions",
        "type": "User",
        "url": "https://api.github.com/users/philipcmonktest"
    }
}
```
