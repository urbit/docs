### `++po`

++  po
  ~/  %po
  =+  :-  ^=  sis                                       ::  prefix syllables
      'dozmarbinwansamlitsighidfidlissogdirwacsabwissib\
      /rigsoldopmodfoglidhopdardorlorhodfolrintogsilmir\
      /holpaslacrovlivdalsatlibtabhanticpidtorbolfosdot\
      /losdilforpilramtirwintadbicdifrocwidbisdasmidlop\
      /rilnardapmolsanlocnovsitnidtipsicropwitnatpanmin\
      /ritpodmottamtolsavposnapnopsomfinfonbanporworsip\
      /ronnorbotwicsocwatdolmagpicdavbidbaltimtasmallig\
      /sivtagpadsaldivdactansidfabtarmonranniswolmispal\
      /lasdismaprabtobrollatlonnodnavfignomnibpagsopral\
      /bilhaddocridmocpacravripfaltodtiltinhapmicfanpat\
      /taclabmogsimsonpinlomrictapfirhasbosbatpochactid\
      /havsaplindibhosdabbitbarracparloddosbortochilmac\
      /tomdigfilfasmithobharmighinradmashalraglagfadtop\
      /mophabnilnosmilfopfamdatnoldinhatnacrisfotribhoc\
      /nimlarfitwalrapsarnalmoslandondanladdovrivbacpol\
      /laptalpitnambonrostonfodponsovnocsorlavmatmipfap'
      ^=  dex                                           ::  suffix syllables
      'zodnecbudwessevpersutletfulpensytdurwepserwylsun\
      /rypsyxdyrnuphebpeglupdepdysputlughecryttyvsydnex\
      /lunmeplutseppesdelsulpedtemledtulmetwenbynhexfeb\
      /pyldulhetmevruttylwydtepbesdexsefwycburderneppur\
      /rysrebdennutsubpetrulsynregtydsupsemwynrecmegnet\
      /secmulnymtevwebsummutnyxrextebfushepbenmuswyxsym\
      /selrucdecwexsyrwetdylmynmesdetbetbeltuxtugmyrpel\
      /syptermebsetdutdegtexsurfeltudnuxruxrenwytnubmed\
      /lytdusnebrumtynseglyxpunresredfunrevrefmectedrus\
      /bexlebduxrynnumpyxrygryxfeptyrtustyclegnemfermer\
      /tenlusnussyltecmexpubrymtucfyllepdebbermughuttun\
      /bylsudpemdevlurdefbusbeprunmelpexdytbyttyplevmyl\
      /wedducfurfexnulluclennerlexrupnedlecrydlydfenwel\
      /nydhusrelrudneshesfetdesretdunlernyrsebhulryllud\
      /remlysfynwerrycsugnysnyllyndyndemluxfedsedbecmun\
      /lyrtesmudnytbyrsenwegfyrmurtelreptegpecnelnevfes'
  |%

Provides the phonetic syllables and name generators for the Urbit naming
system. The two faces, `sis` and `dex` are available to the arms
contained in this section.


------------------------------------------------------------------------

### `++ind`

Parse prefix

Produces the byte of the right-hand syllable `a`.

Accepts
-------

`a` is an [atom]().

Produces
--------

A [`++unit`]() of an atom.

Source
------

      ++  ind  ~/  %ind                                     ::  parse prefix
               |=  a=@
               =+  b=0
               |-  ^-  (unit ,@)
               ?:(=(256 b) ~ ?:(=(a (tod b)) [~ b] $(b +(b))))

Examples
--------

    ~zod/try=> (ind:po 'zod')
    [~ 0]
    ~zod/try=> (ind:po 'zam')
    ~
    ~zod/try=> (ind:po 'del')
    [~ 37]

------------------------------------------------------------------------

### `++ins`

Parse suffix

Produces the byte of the left-hand phonetic syllable `b`.

Accepts
-------

`a` is an [atom]().

Produces
--------
A [`++unit`]() of an atom.

Source
------

      ++  ins  ~/  %ins                                     ::  parse suffix
               |=  a=@
               =+  b=0
               |-  ^-  (unit ,@)
               ?:(=(256 b) ~ ?:(=(a (tos b)) [~ b] $(b +(b))))

Examples
--------

    ~zod/try=> (ins:po 'mar')
    [~ 1]
    ~zod/try=> (ins:po 'son')
    [~ 164]
    ~zod/try=> (ins:po 'pit')
    [~ 242]
    ~zod/try=> (ins:po 'pok')
    ~

------------------------------------------------------------------------

### `++tod`

Fetch prefix

Produces the phonetic prefix syllable from index `a` within `dex` as an
[atom]().

Accepts
-------

`a` is an atom

Produces
--------

An atom.


Source
------

      ++  tod  ~/  %tod                                     ::  fetch prefix
               |=(a=@ ?>((lth a 256) (cut 3 [(mul 3 a) 3] dex)))

Examples
--------

    ~zod/try=> `@t`(tod:po 1)
    'nec'
    ~zod/try=> `@t`(tod:po 98)
    'dec'
    ~zod/try=> `@t`(tod:po 0)
    'zod'
    ~zod/try=> `@t`(tod:po 150)
    'ryg'
    ~zod/try=> `@t`(tod:po 255)
    'fes'
    ~zod/try=> `@t`(tod:po 256)
    ! exit

------------------------------------------------------------------------

### `++tos`

Fetch suffix

Produces the phonetic prefix syllable from index `a` within `sis` as an
[atom]().

Accepts
-------

`a` is an atom.

Produces
--------

An atom.

Source
------

      ++  tos  ~/  %tos                                     ::  fetch suffix
               |=(a=@ ?>((lth a 256) (cut 3 [(mul 3 a) 3] sis)))

Examples
--------

    ~zod/try=> `@t`(tos:po 0)
    'doz'
    ~zod/try=> `@t`(tos:po 120)
    'fab'
    ~zod/try=> `@t`(tos:po 43)
    'pid'
    ~zod/try=> `@t`(tos:po 253)
    'mat'

------------------------------------------------------------------------
