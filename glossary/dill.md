+++
title = "Dill"

template = "doc.html"
[extra]
category = "arvo"
+++

**Dill** is the terminal-driver [vane](../filesystem). You run your urbit in your Unix terminal, and Unix sends every event –⁠
such as a keystroke or a change in the dimensions of the terminal window –⁠ to be handled by Dill. Dill acts as an intermediary for anything that uses keyboard events, which results in a slight input lag in Urbit’s command-line interface.

A keyboard event's journey from Unix to Dojo, the Urbit shell, can be imagined as diagrammed below:

```
Keystroke in Unix -> Vere (virtual machine) -> Arvo -> Dill -> the Dojo
```

Dill is located at `/home/sys/vane/dill.hoon` within [Arvo](../arvo).

### Further Reading

- [The Dill tutorial](@/docs/arvo/dill/dill.md): A technical guide to the Dill vane.
