---
navhome: /developer/docs/
next: true
sort: 16
title: Marks
---

# Marks

We've used predefined marks already, but we haven't yet created our own marks. 
Let's write a sample mark of our own, then chain it together with some 
preexisting ones to have fun with type conversions.

Let's make a small "cord" mark. "Cord" is a name we use for `@t`
text, but there's no predefined mark for it.  Let's put the following code in:
`/examples/mar/cord.hoon`:

```
/?  314                                                 ::  1
|_  cod/@t                                              ::  2
++  grab                                                ::  3
  |%                                                    ::  4
  ++  atom  |=(arg/@ `@t`(scot %ud arg))                ::  5
  --                                                    ::  6
++  grow                                                ::  7
  |%                                                    ::  8
  ++  atom  `@`cod                                      ::  9
  --                                                    ::  10
--                                                      ::  11
```

`/?  314` is the required version number, just like in apps. After that 
everything's in a `|_`, which is a `|%` core, but with input arguments. In our 
case, the argument is the marked data.

There are three possible top-level arms in the `|_` core, `++grab`, `++grow`, 
and `++grad` (which is used for revision control, covered elsewhere). `++grab` 
specifies functions to convert from another mark to the current mark. `++grow` 
specifies how to convert from the current mark to another one.

In our case, we only define one arm in `++grab`, namely `++atom`. This allows 
us to convert any atom to a cord. `++scot` is a standard library function in 
`hoon.hoon` which pretty-prints atoms of various types. We want to treat the 
atom as an unsigned decimal number, so we give `%ud` and the given argument 
to `++scot`. Thus, the form of an arm in `++grab` is
`|=(other-mark-type this-mark-value)`.

In `++grow`, we need to write an arm that specifies how to convert from the 
current mark to another one. To do this, we simply cast our cord to an atom 
and return it directly.

Let's play around a bit with this mark. First, let's take a marked atom and 
convert it to our new mark.

```
~fintud-macrep:dojo/examples> &atom 9
9
~fintud-macrep:dojo/examples> &cord &atom 9
'9'
~fintud-macrep:dojo/examples> &cord &atom &cord &atom 9
'57'
```

ASCII 9 is '57'. There's no requirement, implicit or otherwise, that conversions 
back and forth between marks be inverses of each other. These are semantic 
conversions, in that they refer to the same concept. They're not isomorphisms.

We can add as many arms as we'd like to both `++grab` and `++grow`. Let's add 
an arm to `++grow` which allows us to convert cords to markdown. Our 
`cord.hoon` file should now look like this:

```
/?  314                                                 ::  1
|_  cod/@t                                              ::  2
++  grab                                                ::  3
  |%                                                    ::  4
  ++  atom  |=(arg/@ `@t`(scot %ud arg))                ::  5
  --                                                    ::  6
++  grow                                                ::  7
  |%                                                    ::  8
  ++  atom  `@`cod                                      ::  9
  ++  md  cod                                           ::  10
  --                                                    ::  11
--                                                      ::  12
```

We've added a new arm `++md` to our `++grow` arm. It simply converts our 
cord to markdown by returning `cod` directly. The reason this works is because, 
if you check out `mar/md.hoon`, we can see that both `md` and our `cord` marks 
deal with `@t` data. Why cast a `@t` to a `@t`? It's redundant! Perfect, then.
What we should be able to do now is convert from `cord` to `md`.

Let's play around a little more, having added our new `++md` arm:

```
~fintud-macrep:dojo/examples> &md &cord &atom 17
'17'
~fintud-macrep:dojo/examples> &hymn &md &cord &atom 17
[ [%html ~]
  [[%head ~] [[%title ~] [[%~. [%~. "Untitled"] ~] ~] ~] ~]
  [ [%body ~]
    [i=[g=[n=%$ a=~[[n=%$ v=""]]] c=~] t=[i=[g=[n=%p a=~] c=~[[g=[n=%$ a=~[[n=%$ v="17"]]] c=~]]] ~]]
  ]
  ~
]
```

That was exciting. Check it out! If you squint at that, it looks an awful lot 
like html, doesn't it? Our value `17` is still in there, in the body. `urb` is 
the mark we render most web pages to. It makes sure you have a complete 
skeleton of a web page. Of course, by the time this gets to the web page, it's 
plain html. If you're curious, make sure to check out `mar/hymn.hoon` and try 
to deduce what's going on. Let's do the final step in the conversion, and 
produce some real html code.

```
~fintud-macrep:dojo/examples> &mime &hymn &md &cord &atom 17
[[%text %html ~] p=71 q='<html><head><title>Untitled</title></head><body><p>17</p></body></html>']
```

This is a mime-typed octet stream with type `/text/html`, length 121 bytes, 
and our lowly number `17` rendered to a web page. `cord` was just one 
step in the chain.

Notice that we must be _explicit_ with our mark conversions. Why won't this work, for 
example?

```
~fintud-macrep:dojo/examples> &cord 17
```

Using marks, we've been able to convert, step-by-step, a lowly atom of `17` 
into a complete plain-text html blob. We started with the atom, passed it to 
our `&cord` (which we defined in `/examples/mar/cord.hoon`), 
converted that to `&md`, then to `&hymn` and finally to `&mime`, resulting 
in plain-text html.
