---
navhome: /docs/
next: true
sort: 1
title: ~& "sigpam"
---

# `~& "sigpam"`

`[%sgpm p=hoon q=hoon]`: debugging printf.

## Expands to

`q`.

## Convention

Prettyprints `p` on the console before computing `q`. 

## Syntax

Regular: *2-fixed*.

## Examples

```
~zod:dojo> ~&('halp' ~)
'halp'
~

~zod:dojo> ~&  'halp' 
           ~
'halp'
~
```
