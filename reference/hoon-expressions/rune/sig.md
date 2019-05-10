+++
title = "Hints"
weight = 14
template = "doc.html"
+++
Runes that use Nock `11` to pass non-semantic info to the interpreter.

## Runes

### ~> "sigban"

`[%sgbn p=$@(term [p=term q=hoon]) q=hoon]`: raw hint, applied
to computation.

##### Expands to

`q`.

##### Syntax

Regular: **2-fixed**.  For the dynamic form, write `%term.hoon`.

##### Discussion

Hoon has no way of telling what hints are used and what aren't.
Hints are all conventions at the interpreter level.

##### Examples

```
~zod:dojo> ~>(%a 42)
42
```

Running the compiler:

```
~zod:dojo> (make '~>(%a 42)')
[%10 p=97 q=[%1 p=42]]

~zod:dojo> (make '~>(%a.+(2) 42)')
[%10 p=[p=97 q=[%4 p=[%1 p=2]]] q=[%1 p=42]]
```

### ~| "sigbar"


`[%sgbr p=hoon q=hoon]`: tracing printf.

##### Expands to

`q`.

##### Convention

Prettyprints `p` in stack trace if `q` crashes.

##### Syntax

Regular: **2-fixed**.

##### Examples

```
~zod:dojo> ~|('sample error message' !!)
'sample error message'
ford: build failed

~zod:dojo> ~|  'sample error message'
           !!
'sample error message'
ford: build failed
```

### ~$ "sigbuc"

`[%sgbs p=term q=hoon]`: profiling hit counter.

##### Expands to

`q`.

##### Convention

If profiling is on, adds 1 to the hit counter for `p`.

##### Syntax

Regular: **2-fixed**.

##### Examples

```
~zod:dojo> ~$(%foo 3)
3
```

### ~_ "sigcab"

`[%sgcb p=hoon q=hoon]`: user-formatted tracing printf.

##### Expands to

`q`.

##### Convention

Shows `p` in stacktrace if `q` crashes.

##### Discussion

`p` must produce a `tank` (prettyprint source).

##### Examples

```
~zod:dojo> ~_([%leaf "sample error message"] !!)
"sample error message"
ford: build failed

~zod:dojo> ~_  [%leaf "sample error message"]
           !!
"sample error message"
ford: build failed
```

### ~% "sigcen"

`[%sgcn p=term q=wing r=(list [term hoon]) s=hoon]`: jet registration.

##### Expands to

`s`.

##### Convention

Register a core with name `p`, with parent at leg `q`, exporting
the named formulas `r`, constructed by `s`.

##### Syntax

Regular: **4-fixed**.  For `r`, use `~` if empty.  Otherwise, **jogging**
between opening and closing `==`.

##### Discussion

`~%` is for registering cores.  A registered core declares its
formal identity to the interpreter, which may or may not be able
to recognize and/or accelerate it.

Registered cores are organized in a containment hierarchy.
The parent core is at any leg within the child core.  When we
register a core, we state the leg to its parent, in the form of
wing `q`.  We assume the parent is already registered -- as it
must be, if (a) we registered it on creation, (b) the child was
created by an arm defined on the parent.

(Cores are actually managed by their formula/battery.  Any
function call will create a new core with a new sample, but
batteries are constant.  But it is not sufficient to match the
battery -- matching the semantics constrains the payload as well,
since the semantics of a battery may depend on any parent core
and/or payload constant.)

The purpose of registration is always performance-related.  It
may involve (a) a special-purpose optimizer or "jet", written
for a specific core and checked with a Merkle hash; (b) a
general-purpose hotspot optimizer or "JIT"; or (c) merely a
hotspot declaration for profiling.

As always with hints, the programmer has no idea which of (a),
(b), and (c) will be applied.  Use `~%`
indiscriminately on all hotspots, bottlenecks, etc, real or
suspected.

The list `r` is a way for the Hoon programmer to help jet
implementors with named Nock formulas that act on the core.
In complex systems, jet implementations are often partial and
want to call back into userspace.

The child core contains the parent, of course.  When we register
a core, we state the leg to its parent, in the form of wing `q`.
We assume that the parent -- any core within the payload -- is
already registered.

`p` is the name of this core within its parent; `q` is a the leg

Registers a jet in core `s` so that it can be called when that code is run.

Regular form: **4-fixed**

##### Examples

Here's the AES

```
    ++  aesc                                                ::  AES-256
      ~%  %aesc  +  ~
      |%
      ++  en                                                ::  ECB enc
        ~/  %en
        |=  [a=@I b=@H]  ^-  @uxH
        =+  ahem
        (be & (ex a) b)
      ++  de                                                ::  ECB dec
        ~/  %de
        |=  [a=@I b=@H]  ^-  @uxH
        =+  ahem
        (be | (ix (ex a)) b)
      --
```

Here we label the entire `++aesc` core for optimization. You can see the
jet in `jets/e/aesc.c`.


### ~< "sigled"


`[%sgld p=$@(term [p=term q=hoon]) q=hoon]`: raw hint, applied to
product.

##### Expands to

`q`.

##### Syntax

Regular: **2-fixed**.  For the dynamic form, write `%term.hoon`.

##### Discussion

`~<` is only used for jet hints ([`~/`](#sigfas)
and [`~%`](#sigcen)) at the moment; we are not telling the
interpreter something about the computation we're about to perform, but
rather about its product.

##### Examples

```
~zod:dojo> (make '~<(%a 42)')
[%7 p=[%1 p=42] q=[%10 p=97 q=[%0 p=1]]]
~zod:dojo> (make '~<(%a.+(.) 42)')
[%7 p=[%1 p=42] q=[%10 p=[p=97 q=[%4 p=[%0 p=1]]] q=[%0 p=1]]]
```

### ~+ "siglus"

`[%sgls p=hoon]`: cache a computation.

##### Expands to

`p`.

##### Convention

Caches the formula and subject of `p` in a local cache (generally
transient in the current event).

##### Syntax

Regular: **1-fixed**.

##### Examples

This may pause for a second:

```
~zod:dojo> %.(25 |=(a=@ ?:((lth a 2) 1 (add $(a (sub a 2)) $(a (dec a))))))
121.393
```

This may make you want to press `ctrl-c`:

```
~zod:dojo> %.(30 |=(a=@ ?:((lth a 2) 1 (add $(a (sub a 2)) $(a (dec a))))))
1.346.269
```

This should work fine:

```
~zod:dojo> %.(100 |=(a=@ ~+(?:((lth a 2) 1 (add $(a (sub a 2)) $(a (dec a)))))))
573.147.844.013.817.084.101
```

### ~/ "signet"

`[%sgnt p=term q=hoon]`: jet registration for gate with
registered context.

##### Expands to

```
~%(p +7 ~ q)
```

##### Syntax

Regular: **2-fixed**.

##### Examples

From the kernel:
```
++  add
  ~/  %add
  |=  [a=@ b=@]
  ^-  @
  ?:  =(0 a)  b
  $(a (dec a), b +(b))
```

### ~& "sigpad"

`[%sgpd p=hoon q=hoon]`: debugging printf.

##### Expands to

`q`.

##### Product

Pretty-prints `p` on the console before computing `q`.

##### Discussion

This rune has no semantic effect beyond the Hoon expression `q`.  It's used solely to create a side-effect: printing the value of `p` to the console.

It's most useful for debugging programs.

##### Syntax

Regular: **2-fixed**.

##### Examples

```
~zod:dojo> ~&('halp' ~)
'halp'
~

~zod:dojo> ~&  'halp'
           ~
'halp'
~
```

### ~= "sigtis"

`[%sgts p=hoon q=hoon]`: detect duplicate.

##### Expands to

`q`.

##### Convention

If `p` equals `q`, produce `p` instead of `q`.

##### Discussion

Duplicate nouns are especially bad news in Hoon, because comparing them
takes O(n) time.  Use `~=` to avoid this inefficiency.

##### Examples

This code traverses a tree and replaces all instances of `32` with
`320`:

```
~zod:dojo> =foo |=  a=(tree)
                ?~(a ~ ~=(a [?:(=(n.a 32) 320 n.a) $(a l.a) $(a r.a)]))

~zod:dojo> (foo 32 ~ ~)
[320 ~ ~]
```

Without `~=`, it would build a copy of a completely unchanged tree.  Sad!

### ~? "sigwut"

`[%sgwt p=hoon q=hoon r=hoon]`: conditional debug printf.

##### Expands to

`r`.

##### Convention

If `p` is true, prettyprints `q` on the console before computing `r`.

##### Syntax

Regular: **4-fixed**.

##### Examples

```
~zod:dojo> ~?((gth 1 2) 'oops' ~)
~

~zod:dojo> ~?((gth 1 0) 'oops' ~)
'oops'
~

~zod:dojo> ~?  (gth 1 2)
             'oops'
           ~
~

~zod:dojo> ~?  (gth 1 0)
             'oops'
           ~
'oops'
~
```

### ~! "sigzap"

`[%sgzp p=hoon q=hoon]`: print type on compilation fail.

##### Expands to

`q`.

##### Convention

If compilation of `q` fails, prints the type of `p` in the trace.

##### Syntax

Regular: **2-fixed**.

##### Examples

```
~zod:dojo> a
! -find.a

~zod:dojo> ~!('foo' a)
! @t
! find.a

~zod:dojo> ~!  'foo'
           a
! @t
! find.a
```
