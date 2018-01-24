/=  kids  /%  /tree-kids/
:-  :~  navhome/'/docs/'
        sort/'5'
    ==
;>

# `%eyre`

Our http server.

Unix sends http messages to `%eyre`, and `%eyre` produces http messages
in response. In general, apps and vanes do not call `%eyre`; rather,
`%eyre` calls apps and vanes. `%eyre` uses `%ford` and `%gall` to
functionally publish pages and facilitate communication with apps.

`%eyre` primarily parses web requests and handles them in a variety of
ways, depending on the control string. Nearly all of these are
essentially stateless, like functional publishing with `%ford`.
Additionally, there's a fairly significant component that handles
`%gall` messaging and subscriptions, which must be stateful.

;+  (kids %title datapath/'/docs/arvo/internals/eyre/' ~)
