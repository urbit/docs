+++
title = "Using a Text Editor"
weight = 6
template = "doc.html"
+++

Writing code is typically done using a text editor, but common editors like Notepad, Microsoft Word, or OpenOffice Writer are not very well suited for programming. You'll want a text editor that is specifically designed for writing code. This will assist with things such as colorizing keywords, finding patterns, matching parentheses and brackets, etc. Text editors can be quite sophisticated, and some are integrated directly with tools for compiling and running programs - these are called IDEs (integrated development environment).

Which text editor you prefer to use is largely a matter of preference, your level of experience, what functionality you desire, and what operating system you run. This frequently means that asking five programmers what their preferred editor is will give you six different answers. If you are brand new to programming then you'll have a more difficult time determining which editor most suits you, and for now it is probably not worth the time to learn about all of the editors in any kind of depth. Any of the newbie-friendly editors listed below will suit you, just avoid the ones that are meant for more experience programmers.

## List of editors

Here we aim to maintain a complete list of text editors that have any amount of support for Hoon. The first section are editors known to be friendly to new users, while the second section are editors that are typically only recommended for experienced programmers.

For each of these editors, you'll need to download the editor and then you'll need to install some additional package or module that gives it support for Hoon. The process for adding Hoon support differs for every editor. For most newbie-friendly text editors, this is easily accomplished from within the editor itself and you'll learn how to do so following a newbie tutorial for that editor.

### Newbie-friendly text editors

These editors are easy to use for first time coders.

#### Atom
Atom is free and open source and runs on all major operating systems. It is available [here](https://atom.io/). A package for Hoon support is maintained by Tlon and may be obtained using the package manager within the editor by searching for `Hoon`.

#### Sublime
Sublime is closed source and not free, but may be downloaded for free and there is no enforced time limit for evaluation. It runs on all major operating systems. It is available [here](https://www.sublimetext.com/).

#### Visual Studio Code
Visual Studio Code is free and open source and runs on all major operating systems. It is available [here](https://code.visualstudio.com/). Hoon support may be acquired in the Extensions menu within the editor by searching for `Hoon`.

### Advanced text edtiors

These text editors have a high learning curve and are only recommended for experienced programmers.

#### Emacs

Emacs is free and open source and runs on all major operating systems. It is available [here](https://www.gnu.org/software/emacs/). Hoon support is available with [hoon-mode.el](https://github.com/urbit/hoon-mode.el).

##### Vim

Vim is free and open source and runs on all major operating systems. It is available [here](https://www.vim.org/). Hoon support is available with [hoon.vim](https://github.com/urbit/hoon.vim) and is maintained by Tlon.
