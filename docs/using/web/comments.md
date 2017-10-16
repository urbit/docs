---
navhome: /docs/
sort: 2
title: Blog comments
next: true
---

# Blog comments

If you followed [our previous example](./blog) you should have a
simple blog accessible at `your-urbit.urbit.org/blog`.  Here we'll
enable comments on a post.

First, turn comments on by editing the YAML in `post-1.md`.  Your YAML
should look like this:

    ---
    date: ~2016.4.20
    title: My first post!
    type: post
    navhome: /blog
    comments: true
    ---

Now try loading your post here: `your-urbit.urbit.org/blog/post-1`.
You should see a comments box at the bottom of the page.  

Try posting a comment!  When you do you should see the following in
your console:

    + /~your-urbit/home/55/web/blog/post-1/comments/~2016.4.20..23.20.54..0b88/md
    ------------[0]
              ~your-urbit[tree]: receiving comments, ;join %comments for details

Comments are written into the filesystem in the `comments/` folder
relative to the page they're enabled on.  When a new comment is posted
a notification is also posted to the `/comments` `:talk` channel.

Use `;join` to keep up with comments as they get posted:

    ;join ~your-urbit/comments

That's it!  Easy.
