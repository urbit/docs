---
navhome: /docs/
next: true
sort: 6
title: ~+ "siglus"
---

# `~+ "siglus"`

`[%sgls p=hoon]`: cache a computation.

## Expands to

`p`.

## Convention

Caches the formula and subject of `p` in a local cache (generally 
transient in the current event).

## Syntax

Regular: *1-fixed*.

## Examples

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
