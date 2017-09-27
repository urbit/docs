---
navhome: /docs/
sort: 12
---

# `:tow  =~  "tissig"` 

`{$tow p/(list twig)}`: compose many twigs.

## Produces

The product of the chain composition. 

## Syntax

Regular: *running*.

## Examples

```
~zod:dojo> =foo :new  n/@
                :rap  :tow  increment
                            increment
                            increment
                            n
                      ==
                :core
                ++  increment
                  :loop  
                  ..increment(n +(n))
                --
~zod:dojo> foo
3
```

```
~zod:dojo> =foo =|  n/@ 
                =<  =~  increment
                        increment
                        increment
                        n
                    ==
                |%
                ++  increment
                  |-  
                  ..increment(n +(n))
                --
~zod:dojo> foo
3
```
