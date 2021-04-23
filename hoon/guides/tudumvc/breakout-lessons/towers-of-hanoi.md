+++
title = "Towers of Hanoi generator"
weight = 2
template = "doc.html"
+++

You're going to add a simple generator to our /gen folder, let your shell script copy it into your pier, and then run it. In the process you'll learn about `|commit`-ing our files back into our %clay filesystem when we make changes to them in the *nix filesystem. Assuming you're running your copy shell script as described in the previous subsection, take the following steps:
   * Copy the [hanoi generator](supplemental/hanoi.hoon) to your /gen subdirectory of your development folder (`~/urbit/devops/gen` if you're following the guide exactingly)
     * Make sure your sync function is running, e.g.: `bash dev.sh ~/urbit/nus`
   * This generator solves a Towers of Hanoi game with any number of starting discs on any one of the three pegs. It takes two arguments:
      * See: `|=  [num-of-discs=@ud which-rod=?(%one %two %three)]`
      * Argument 1 - the number of discs in the game
      * Argument 2 - the starting rod
   * Call this generator using `+hanoi [3 %one]` or similar. Do this in your dojo.
   * You've just received the error:
      ```
      /gen/hanoi/hoon
      %generator-build-fail
      ```
   * Your urbit is not able to find the file yet, even though it's been copied into your pier (take a look for yourself to confirm - if it hasn't, you might have an issue with your shell script)
   * Enter `|commit %home` in dojo to _uptake_ the changes you've made in the Unix filesystem into our urbit's `%clay` filesystem.
   * You've just seen a message somewhat like the below:
      ```
      > |commit %home
      >=
      : /~nus/home/44/gen/hanoi/hoon
      ```
   * Try running our generator again, using `+hanoi [3 %one]`.
   * You should see the following:
      ```
     ~[
     [rod-one=~[2 3] rod-two=~ rod-three=~[1]]
     [rod-one=~[3] rod-two=~[2] rod-three=~[1]]
     [rod-one=~[3] rod-two=~[1 2] rod-three=~]
     [rod-one=~ rod-two=~[1 2] rod-three=~[3]]
     [rod-one=~[1] rod-two=~[2] rod-three=~[3]]
     [rod-one=~[1] rod-two=~ rod-three=~[2 3]]
     [rod-one=~ rod-two=~ rod-three=~[1 2 3]]
     ]
     ```
   * And just like that, you've confirmed that your dev environment is set up to house your development files, outside of your pier, with a replication system in place to automatically copy them _into_ your pier.