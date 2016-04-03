# `:fast`, `~%` "sigcen", `{$fast p/chum q/twig r/tyre s/twig}`

General jet hint.

Registers a jet in core `s` so that it can be called when that code is run.

Regularm form: *4-fixed*

Examples:

    ++  aesc                                                ::  AES-256
      ~%  %aesc  +  ~
      |%
      ++  en                                                ::  ECB enc
        ~/  %en
        |=  {a/@I b/@H}  ^-  @uxH
        =+  ahem
        (be & (ex a) b)
      ++  de                                                ::  ECB dec
        ~/  %de
        |=  {a/@I b/@H}  ^-  @uxH
        =+  ahem
        (be | (ix (ex a)) b)
      --

Here we label the entire `++aesc` core for optimization. You can see the
jet in `jets/e/aesc.c`.
