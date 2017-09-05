# `%ford` user manual

## ford runes

One of the most common ways to use ford is through ford's runes, all of which begin with `/` ("fas"). A ford rune runs a step of a ford build and places the result in the subject. There are various kinds of build steps, some of which take other build steps as parameters. The most common pattern is to have a sequence of ford runes at the top of a hoon source file that import the results of evaluating other hoon files. This is how we "import a library" in urbit: we add the result of compiling another hoon file into the current subject, possibly renaming it by wrapping a face around it.

Another common use case is assembling and rendering markdown templates into a single HTML file, to be sent as an HTTP response in urbit's web server `%eyre`. It's important to keep in mind that %ford is quite flexible and generic, and is used in other parts of urbit -- such as the dojo -- that would not traditionally fall under the auspices of a build system.

### `/~` twig by hand

`/~  <twig>` produces a horn that evaluates a twig and places the product
in the subject. Arbitrary hoon can be in the twig.

Example:
```
/~  [a=0 b=1]
[a b]
```
produces:
`[0 1]`

### `//` include a file by relative path

`// <rel-path>` parses `rel-path` as a hoon twig, and then adds the resulting
twig to the subject. It's similar to `#include` in C. Note that the result type
of this rune is not a horn, but just a hoon twig, so its result can't be used
as an argument to other runes that expect a horn.

Example:
```
//  %/file-to-include
::
(frobnicate:file-to-include %.n)

::  contents of file-to-include.hoon
|%
++  frobnicate
  |=  a/?  ^+  a
  !a
--
```
produces: `%.y`

_Note: `%` means current directory, which in a hoon file will resolve to the
"directory" containing that file. Also, %clay doesn't have first-class
directories the way unix filesystems do. Whereas in unix, a directory is a
special kind of file, in %clay it's just a path prefix, and there is no file
stored at that path._

### `/=` wrap a face around an included horn

`/=` runs a horn (usually produced by another ford rune), takes the result of
that horn, and wraps a face around it.

Example:
```
/=  foo  /~  [a=0 b=1]
[a.foo b.foo]
```
produces: `[0 1]`

### `/_` run a horn on each file in the current directory

`/_` takes a horn as an argument. It produces a new horn representing the
result of mapping the supplied horn over the list of files in the current
directory. The keys in the resulting map are the basenames of the files in the
directory, and each value is the result of running that horn on the contents of
the file.

Example:
```
/=  kids  /_  /hoon/
`(map term cord)`kids
```

produces a value of type `(map term cord)`, where each key is the basename (the
filename without the prefix), and each value is the result of running the
contents of the file through the `%hoon` mark, which validates that it's valid
hoon code and returns it unmodified. So, the resulting map associates basenames
with file contents. For more information on marks, see the docs for the
`/<mark>/` syntax.

### `/:` evaluate at path

`/:` takes a path and a horn, and evaluates the horn with the current path set to the supplied path.

Example:
```
/=  hoo-source  /:  /path/to/hoon-file  /hoon/
`@t`hoo-source
```

produces the text of the hoon file at "/path/to/hoon-file/hoon".
