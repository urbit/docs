/=  kids  /%  /tree-kids/
:-  :~  navhome/'/docs/'
        next/'true'
        sort/'20'
        title/'Limbs and wings'
    ==
;>

# Limbs and wings

One feature Hoon lacks: a context that isn't a first-class value.
Hoon has no concept of scope, environment, etc.  A hoon has one
data source, the _subject_, a noun like any other.

In most languages "variable" and "attribute" are different
things.  They are both symbols, but a variable is in "the
environment" and a attribute is on "an object."  In Hoon, "the
environment" is "an object" -- the subject.

`%limb` and `%wing` are two basic hoon stems that extract
information from the subject.  A `limb` is an attribute; a `wing`
is an attribute path, ie, a list of limbs.

## Stems

;+  (kids %title datapath/'/docs/hoon/limb/' ~)
