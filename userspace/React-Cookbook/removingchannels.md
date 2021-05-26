# Removing Channels

## Local Function

Another simple example that just requires data sent in via `urb.thread()` on line 314:

```
  // React function to remove a channel(chat) from a group on our ship
  function removeChannelLocal(channel: Path) {
    if (!urb) return;
    const channelResource = resourceFromPath(channel);
    // Similar to removeGroupLocal we're converting the Path string to a Resource type
    // Notice below that we use the deSig function. Different API functions have different formatting processes
    // deSig will remove the ~ from the ship name because deleteGraph is instructed to add one. Without deSig we would
    // end up with "~~zod"
    urb.thread(deleteGraph(deSig(channelResource.ship), channelResource.name));
    window.confirm(`Removed channel ${channel}`);
    window.location.reload();
  }
```

We're passing the `thread` a formatting function called `deleteGraph` which lives in `@urbit/api/dist/graph/lib.d.ts`. By reading it's source we see that it only accepts `ship` names without leading `~`s so we import and implment the `deSig()` function from `@urbit/api` to remove the `~` from our `ship`.

## UI

Nothing new here but including the UI here for reference. Line 682:

```
    <form
        onSubmit={(e: React.SyntheticEvent) => {
            e.preventDefault();
            const target = e.target as typeof e.target & {
            chat: { value: Path };
            };
            const chat = target.chat.value;
            removeChannelLocal(chat);
        }}
        >
        <select id="chat" name="chat">
            <option>Select a Channel</option>
            {keys.map((chat) => (
            <option value={chat}>{chat}</option>
            ))}
        </select>
        <br />
        <input type="submit" value="Remove Channel" />
    </form>
```

Just a single input from a drop down which is rendered by maping our `keys` array from state.
