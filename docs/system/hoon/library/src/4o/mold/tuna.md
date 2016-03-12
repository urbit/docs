### `++tuna`

XML template tree

An XML template tree.

Source
------

        ++  tuna                                                ::  tagflow
                  [%d p=twig]                               ::  dynamic list
                  [%e p=twig q=(list tuna)]                 ::  element
                  [%f p=(list tuna)]                        ::  subflow
              ==                                            ::

Examples
--------

Leaf %a contains plain-text, %b an empty tag, %c a static list, %d a
dynamic list, %e a full node element containing a twig and a list of
tuna, and %f is a empty node.

See also: [`++sail`]()


