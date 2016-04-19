# `:need`, `!?`, "zapwut", `{$need p/$@(p/@ {p/@ q/@}) q/twig}`

Restrict version.

Enforces a Hoon version restriction. XX help

Regular form: *2-fixed*

Examples: XX help

    ~zod:dojo> !?(264 (add 2 2))
    4
    ~zod:dojo> !?(164 (add 2 2))
    4
    ~zod:dojo> !?(163 (add 2 2))
    ! exit
