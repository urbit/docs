+++
title = "Auras"
weight = 70
template = "doc.html"
+++

Auras are system of nested "soft types" on [atoms](@/docs/glossary/atom.md) that
are used to track metadata about how a particular atom is to be interpreted.
This is used for type checking as well as pretty printing.

A given aura nests under any aura whose name is a substring of the given aura,
i.e. `@ux` nests under `@u`, and all auras nest under the empty aura `@`. We
call auras "soft types" since this nesting behavior can be ignored - see
[below](#non-coercive).

You can learn more about auras in [Hoon school](@/docs/hoon/hoon-school/atoms-auras-and-simple-types.md).

```
Aura         Meaning                                 Example Literal Syntax
-------------------------------------------------------------------------
@            empty aura                             
@c           Unicode codepoint                       ~-~45fed
@d           date                                  
  @da        absolute date                           ~2018.5.14..22.31.46..1435
  @dr        relative date (ie, timespan)            ~h5.m30.s12
@f           Loobean (for compiler, not castable)    &
@i           Internet address
  @if        IPv4 address                            .195.198.143.90
  @is        IPv6 address                            .0.0.0.0.0.1c.c3c6.8f5a
@n           nil (for compiler, not castable)        ~
@p           phonemic base (ship name)               ~sorreg-namtyv
@q           phonemic base, unscrambled              .~litsyn-polbel
@r           IEEE-754 floating-point                
  @rh        half precision (16 bits)                .~~3.14
  @rs        single precision (32 bits)              .6.022141e23
  @rd        double precision (64 bits)              .~6.02214085774e23
  @rq        quad precision (128 bits)               .~~~6.02214085774e23
@s           signed integer, sign bit low          
  @sb        signed binary                           --0b11.1000
  @sd        signed decimal                          --1.000.056
  @sv        signed base32                           -0v1df64.49beg
  @sw        signed base64                           --0wbnC.8haTg
  @sx        signed hexadecimal                      -0x5f5.e138
@t           UTF-8 text (cord)                       'howdy'
  @ta        ASCII text (knot)                       ~.howdy
    @tas     ASCII text symbol (term)                %howdy
@u              unsigned integer                   
  @ub           unsigned binary                      0b11.1000
  @ud           unsigned decimal                     1.000.056
  @uv           unsigned base32                      0v1df64.49beg
  @uw           unsigned base64                      0wbnC.8haTg
  @ux           unsigned hexadecimal                 0x5f5.e138
```

Capital letters at the end of auras indicate the bitwidth in binary powers of
two, starting from A.

```
        @ubD    signed single-byte (8-bit) decimal
        @tD     8-bit ASCII text
        @rhE    half-precision (16-bit) floating-point number
        @uxG    unsigned 64-bit hexadecimal
        @uvJ    unsigned, 512-bit integer (frequently used for entropy)
```

### Non-coercive

Auras are non-coercive, but conversions may have to go via the empty aura, e.g.
```
> ^-(@ud ^-(@ 'foo'))
7.303.014
```
This is implicitly done by the irregular form of `^-`.
```
> `@ud`'foo'
7.303.014
```
