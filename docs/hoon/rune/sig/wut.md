---
navhome: /docs/
next: true
sort: 2
title: ~? "sigwut"
---

# `~? "sigwut"`

`[%sgwt p=hoon q=hoon r=hoon]`: conditional debug printf.

## Expands to

`r`.

## Convention 

If `p` is true, prettyprints `q` on the console before computing `r`.

## Syntax

Regular: *4-fixed*.

## Examples

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
