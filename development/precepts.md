+++
title = "Precepts"
weight = 40
template = "doc.html"
+++

<br>

<img class="ba" src="https://media.urbit.org/site/posts/essays/pre-01.jpg">

Urbit is a principled approach to system design and programming, but it's often not obvious what those principles are. We have many specific terms for the different parts of the project: Arvo is the OS, Hoon is the language, Tlon is the company, Azimuth is the identity system, Ames is the network. But the word most associated with the project is "Urbit", and it's not clear what technically it refers to. It's only a small stretch to say that "Urbit" *is* this set of principles, and that if anybody follows these principles strictly they will create a system that is isomorphic to the Urbit.

Some of these are commonly held among many software projects, and some are not. Some are only debatably better than the alternatives, but Urbit exclusively chooses them.

We’ll start with a brief description of many principles, then we’ll go into a long-form justification.



### A: General Design

1) Data is better than code.

      Store data in your state, send data over the wire, dispatch based
      on data.

2) Everything should be CQRS.

3) (Almost) Everything should be pubsub.

4) A subscriber shouldn't affect a publisher.

5) Communication between nodes should be communication between
   independent actors.

      Each message should do one complete thing, and there shouldn't
      need to be a sequence of coupled messages.

6) Represent your data as closely as possible to the essential structure
   of the problem.

7) A client's representation of data should be as close as possible to
   that of the server.

      This blurs the distinction between client and server. It allows
      offline-mode, reduces communication to syncing, and decentralizes.

8) When mating different paradigms, build one cleanly on top of the
   other.

      Never try to make them work on some of the same primitives. Never
      abuse one to make the other work. For example, ducts in
      themselves are very general - if you want to do pubsub, that can
      easily be built on top of ducts, but don't pretend that pubsub is
      a *part* of the duct system.

9) Never misuse an abstraction.

      An abstraction provides a certain set of tools; use them and only
      them.

10) Correctness is more important than performance.

11) Be simple and uncompromising in defining what's correct; go crazy
    with optimizations.

      Nock is a great example of this. It contains the character of the
      virtual machine, but its asymptotics are bad. Add jets to fix the
      asymptotics.

      Another example is the ACID nature of Arvo. Arvo is a pure
      function f(logs) of its event log, so formally Arvo is just a
      function run against an event log. A naive implementation has
      very bad asymptotics; processing each new event is O(n) in the
      number of historical events. Choose the function g(state,log)
      such that f(logs ++ log) = g(f(logs),log). Then, as long as you
      keep the state in memory, processing each new event is constant in
      the number of previous events. This still requires O(n) restart
      from disk, but you can also periodically (and non-blockingly)
      write a checkpoint of the state to disk, so that restart from disk
      is only linear in the number of events since the last checkpoint.

12) Correctness is more important than optimality.

13) If you don't completely understand your code and the semantics of
    all the code it depends on, your code is wrong.

14) Deterministic beats heuristic.

      Heuristics are evil and should only be used where determinism is
      infeasible, such as in cache reclamation.

15) Stateless is better than stateful.

16) Explicit state is better than implicit state.

17) Referential transparency is honesty and stability.

      Lack of referential transparency and other forms of
      disingenuousness are some of the world's big problems. Only
      deviate from referential transparency if absolutely necessary.

18) Responsibilities should be clearly separated.

      This applies from kernel modules through network citizens.

19) Dualities must be faced head-on and analyzed differently at
    different layers.

      Statically typed vs. dynamically typed, imperative vs. functional,
      code vs. data, and effectful vs. pure can all be a matter of
      perspective, and all relevant perspectives must have coherent
      answers.

20) One hundred lines of simplicity is better than twenty lines of
    complexity.

      It's not enough for an abstraction to reduce code duplication; it
      must actually make the code simpler.

21) Prefer mechanical simplicity to mathematical simplicity.

      Often mechanical simplicity and mathematical simplicity go
      together.

22) The Law of Leaky Abstractions is a lie; abstract airtightly.

      If your abstractions are leaking, it's not due to some law of the
      universe; you just suck at abstracting. Usually, you didn't
      specify the abstraction narrowly enough.

23) Some cliches are repeated because they are true; others must be
    repeated because they are not.

<br>

<img class="ba" src="https://media.urbit.org/site/posts/essays/pre-03.jpg">

### B: Specific Design

1) Always ack a dupe; never ack an ack.

    It's okay to ack a nack as long as you never nack a nack.

2) Never construct or deconstruct a duct.

3) Route on wire before sign, never sign before wire.

4) Only go from statically typed to dynamically typed if you must.

      Once you go into a dynamically typed world, it's hard to go back.
      Statically typed is better than dynamically typed, so if something
      can be made static, it should be.
      
      Each timeless data structure is a brick in the foundation of
      digital civilization.

5) Anything with business logic speaks one paradigm; anything that
   translates paradigms has no business logic.

6) Functionally enforced semantic rules are better security primitives
   than memory access restrictions.

      A compiler can use type safety as an effective tool to enforce
      some classes of security guarantees.


### C: Attitude

1) Code courageously.

      If you avoid changing a section of code for fear of awakening the
      demons therein, you are living in fear. If you stay in the
      comfortable confines of the small section of the code you wrote or
      know well, you will never write legendary code. All code was
      written by humans and can be mastered by humans.

      It's natural to feel fear of code; however, you must act as though
      you are able to master and change any part of it. To code
      courageously is to walk into any abyss, bring light, and make it
      right.

2) No time for lazy people.

      If there's clearly a right way to do something and a wrong way, do
      it the right way. Coding requires incredible discipline. Always
      follow conventions, and fire anyone who won't. Anything that can
      be solved by discipline is not a real problem.

      > "To him who knows to do good and does not do it, to him it is
      sin."

3) When a smart person makes an obviously stupid suggestion, before
   responding take a full 60 seconds to envision how you would implement
   it and what the effects would be.


### D: Theory

1) Academia is a succubus.

      Academia has a really high ratio of smart people to useful
      products. Academia has many genuinely smart and interesting
      ideas, but always remember that pursuing them whole-heartedly will
      never result in a useful product.

2) Never fear math.

      Academia is inefficient, but it's also correct. Those people
      wasted a lot of time finding the right answer, but now that
      they've done it, you must exploit it. If you don't know the
      theory, learn it. No excuse for being "bad at math". Most who
      are "bad at math" are simply lazy or fearful. Be strong and of
      good courage. If you're truly so bad at math that you cannot
      learn it, you should not design systems.

3) Not being qualified to solve a problem is no reason not to solve it.

      If you don't know how to do it, do it anyway. "We are too young
      to realize that certain things are impossible. So, we will do
      them anyway."

4) The best way to get the right answer is to try it the wrong way.

      You cannot design a good system without spending most of your time
      in contact with the problem. The bad parts about systems are
      rarely obvious in theory, but often in practice.

5) Practice tells you that things are good or bad; theory tells you why.

      Never use theory to design a good system from scratch; only
      practice can tell whether the system is good.

6) Everyone must regularly alternate between theory and practice.

      There is an eternal wheel of system design. Given a system, use
      practice to discover what is bad, missing, or unnecessary. Then,
      use theory to fix the bad, add the missing, and remove the
      unnecessary. Repeat.


### E: Text Style

1) No code should extend beyond 80 characters, most within 55.

2) Tabs aren't real.

3) A text file is a series of lines, each ending with a newline
   character.

      Corollary: all non-empty text files end with a newline (often
      hidden by editors). An empty text file does not end with a
      newline.

4) One block comment is better than interleaved comments on every line.

5) Don't name anything you don't have to.

      This includes conventional names for variables of particular
      types. For example, the conventional name for a variable of type
      `path` is `pax`. You should have a good reason for using any
      other name for a `path`.

      A more recent convention that follows the same principle is to
      give the variable the same name as its type.

6) If it's the same thing, give it the same name.

7) Humans are good at memorizing.

8) Abbreviations aren't worth it.


### F: Real Software

1) If it's not deterministic, it isn't real.

2) If it's centralized, it isn't real.

3) If it's owned by someone else, it isn't yours.

4) If it's managed by someone else and you can't change who that is, it
   isn't yours.

5) If it's not yours, it isn't permanent.

6) If it's not permanent, it isn't real.

7) The way it is isn't always the way it ought to be.

      If you can make it the way it ought to be, do so.

8) The way it ought to be isn't always the way it is.

      Some things can't be made more elegant.

      For every ailment under the sun
      There is a remedy, or there is none;
      If there be one, try to find it;
      If there be none, never mind it.

9) Timeless software is good software.

10) System modules should be designed to be frozen permanently;
    conversely, Urbit consists of that system software which admits of a
    Kelvin version.

11) The two procedures for achieving timelessness are distillation and
    generalization.

      Every temporary or contingent feature in a system module should
      eventually either be removed (distillation) or relaxed into
      timelessness (generalization). For an example of the result of
      both procedures, consider the abstraction of the core in Nock and
      Hoon.

12) Standardization is better than perfection.

      Kelvin versioning stops when we run out of versions, not when
      every defect has been rectified.

13) That which cannot be Kelvin-versioned should update fluidly and
    automatically.

      All incompatible upgrades should provide permanent and automatic
      upgrade paths. This is principled permanent backward
      compatibility.

14) Humans are interactive and temporal; technology is permanent and
    exhaustive.

15) Communities are autonomous.

16) Sovereignty necessitates understanding.

      If you don't understand a system you're using, you don't control
      it. If nobody understands the system, the system is in control.
