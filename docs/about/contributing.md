---
navhome: '/docs'
next: True
sort: 4
title: Contributing to Urbit
---

# Contributing to Urbit

It's always a good day for pull requests! We gladly accept submissions
for improving our [code](https://github.com/urbit/urbit/) and
[documentation](https://github.com/urbit/docs/) alike.

## Code guidelines

Refer to [Hoon Syntax](/hoon/syntax) for an in-depth guide to good Hoon.
Alternatively, [browse the
source](https://github.com/urbit/arvo/blob/master/arvo/hoon.hoon).

## Docs guidelines

For documentation pull requests, acquire [pandoc](http://pandoc.org) and
format your edited files with the following flags:

    $ pandoc --standalone \
        --from=markdown+yaml_metadata_block \
        --atx-headers \
        -o output.md \
        input.md

**Note:** Pandoc will convert the terminating `---` in YAML metadata to
`...`, which is grounds for termination. Run the following one-liner to
atone.

    $ sed '1,/^$/ s/^\.\.\./---/g' input.md > output.md
