---
navhome: /docs/
next: true
sort: 10
title: ~% "sigcen"
---

# `~% "sigcen"`

`[%sgcn p=term q=wing r=(list [term hoon]) s=hoon]`: jet registration.

## Expands to

`s`.

## Convention

Register a core with name `p`, with parent at leg `q`, exporting
the named formulas `r`, constructed by `s`.

## Syntax

Regular: *4-fixed*.  For `r`, use `~` if empty.  Otherwise, *jogging* 
between opening and closing `==`.

## Discussion

`~%` ("sigcen" is for registering cores.  A registered core declares its
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
(b), and (c) will be applied.  She should use `~%`
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

must already be registered.
The interpreter can thus 

`p` is the name of this core within its parent; `q` is a the leg 

Registers a jet in core `s` so that it can be called when that code is run.

Regularm form: *4-fixed*

## Examples

Here's the AES 

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

Here we label the entire `++aesc` core for optimization. You can see the
jet in `jets/e/aesc.c`.
