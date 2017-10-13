---
navhome: /docs
next: true
sort: 5
title: Contributing to Urbit
---

# Contributing to Urbit

It's always a good day for pull requests! We gladly accept submissions
for improving our [code](https://github.com/urbit/urbit/) and
[documentation](https://github.com/urbit/docs/) alike.

## Code guidelines

Our official guide to contributing can be found
[here](https://github.com/urbit/urbit/blob/master/CONTRIBUTING.md),
which is most useful for large and low-level changes. For simpler
revisions, refer to [Hoon Syntax](../../hoon/syntax) for an in-depth guide to
good Hoon. Alternatively, [browse the
source](https://github.com/urbit/arvo/blob/master/arvo/hoon.hoon).

## Docs guidelines

For documentation pull requests, if you are making a brand new page, you'll want
it to conform to our general documentation standards. Acquire [pandoc](http://pandoc.org)
and make sure to format your edited files with the following flags:

    $ pandoc --standalone \
        --from=markdown+yaml_metadata_block \
        --atx-headers \
        -o output.md \
        input.md

If you are editing an existing page, reformatting the entire page with pandoc
will make the diff hard to read. Instead, just make sure that your edits generally
conform to the style of the existing docs around it. For example, you'll notice 
that the paragraphs mostly wrap at column 80.

**Note:** If you have an old version of Pandoc, it may convert the
terminating `---` in YAML metadata to `...`, which is grounds for termination.
Run the following one-liner to atone.

    $ sed '1,/^$/ s/^\.\.\./---/g' input.md > output.md

Newer versions of pandoc (1.19.2.1, for example) don't have this issue.
