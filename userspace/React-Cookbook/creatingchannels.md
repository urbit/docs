# Creating Channels

Interestingly enough, before we start talking about creating channels we actually have to cover subscribing and storing `group`s. This is because a channel has to live inside of a `group` and in order for our users to specify which `group` they want their channels to live in, they need to know what `group`s exist in our ship. To accomplish this we need to introduce the `subscribe` method. We'll cover that before seeing the Local Function / UI pattern established in the previous example.

A brief note that under the hood the `subscribe` method leverages `eyre` to handle the json parsing. `Eyre` receives the data you're subscribed to, if that piece of data has a `mark` to transform to json, then `eyre` will handle that.

## Setting up State Variables

On line 49 we create a state variable that will store an array of Group Names:

`const [groups, setGroups] = useState<GroupWName[]>([]);`

Notice that we don't import `GroupWName` this is a custom type interface I made that will allow us to easily access the name of a group and alongside its details.

This is defined on line 119. It consists of a `name` `string` and a `group` `Group` which you can see in our imports from `@urbit/api"` at the top of `App.tsx` There are other ways you could store this data but I wanted to include this as a simple example of rolling your own interfaces should you need to.

```
  interface GroupWName {
    name: string;
    group: Group;
  }
```

## Setting up Subscriptions

Skipping down to line 156 we see:

```
  useEffect(() => {
    if (!urb || sub) return;
    urb
      .subscribe({
        app: "group-store",
        path: "/groups",
        event: handleGroups,
        err: console.log,
        quit: console.log,
      })
      .then((subscriptionId) => {
        setSub(subscriptionId);
      });
  }, [urb, sub, handleGroups]);
```

See the breakout lesson on Hooks for more details on `useEffect` (breakout lessons forthcoming), but for now you just need to know that `useEffect` will run actions after the initial render is complete. The initial render will create our state instance of `urb` described in the [Logging In](https://github.com/witfyl-ravped/urbit-react-cookbook/blob/main/logginging.md) lesson and now we can leverage `useEffect` to setup a subscription to it.

We confirm it was setup properly by running the `if(!urb)` check, then proceed to call `.subscribe()` directly on our `urb`. By digging into the types library in `@urbit/http` we see that `subscribe` takes a `SubscriptionRequestInterface` (defined in `@urbit/http-api/dist/types.d.ts` as an `app` and a `path` along with the ability to log `err` and `quit` return messages as well as take a callback function via `event`).

The `subscribe` parameters are pretty straightforward. We're creating a subscription to `group-store` on path `/groups`. Then we're passing in the function `handleGroups()` which we will look at in a moment, and `console.log`ing `err` and `quit` messages. Since `subscribe` returns data we can then use `.then()` to create a `Promise` for us to send our `sub` state variable the subscription id that we get back.

Finally we pass in an array as a second argument that will re-subscribe if any of it's contents change.

Now let's jump back up to line 125 where we define the `handleGroups()` callback function:

```
  const handleGroups = useCallback(
    (groups) => {
      const groupsArray: GroupWName[] = [];
      Object.keys(groups.groupUpdate.initial).forEach((key) => {
        groupsArray.push({ name: key, group: groups.groupUpdate.initial[key] });
      });
      setGroups(groupsArray);
    },
    [groups]
  );
```

Here we use the `useCallback` hook, structured very similarly to `useEffect`. We start by assigning `groups`to the data we get back from `subscribe`. Then we make an array to accept our custom interface `GroupWName`. We use the custom interface because the `groups` object returned by `subscribe` uses the group name as the key for the rest of the group data. So we push a custom object into `groupsArray` that extracts the `group` name and pairs it with the rest of the `group` object info. We'll see later that we now have easy access to each `groups`'s `name` and corresponding data.

We then set our state `groups` variable equal to our new array and then use the second argument of `useCallback` to re-render if `groups` changes.

## Local Function

Now let's move down to line 242. Just like we did for `group`s in the last lesson, here will make a `createChannelLocal()` function to format the data we collect from our user and send it to our ship as via `urb.thread()`:

```
  // Similar to createGroupLocal in last lesson, we use urb.thread() to create a channel via graph-store.
  function createChannelLocal(
    group: string,
    chat: string,
    description: string
  ) {
    if (!urb || !urb.ship) return;
    // Similar to stringToSymbol this is also a bit of formatting that will likely become a part of @urbit/api in the future. It is used to append
    // the random numbers the end of a channel names
    const resId: string =
      stringToSymbol(chat) + `-${Math.floor(Math.random() * 10000)}`;
    urb.thread(
      // Notice again we pass a formatting function into urb.thread this time it is createManagedGraph
      createManagedGraph(urb.ship, resId, chat, description, group, "chat")
    );
    window.confirm(`Created chat ${chat}`);
    window.location.reload();
  }
```

In this example we use the formatting function `createManagedGraph()` which lives in `@urbit/api/dist/graph/lib.d.ts`. You can read its source there and to see the name of each of the arguments we're passing in above. Also notice the `resId` which uses the `stringToSymbol()` function. That's a formatting function from Landscape that we won't go over here as it will likely become a part of `@urbit/api` in the future. Also notice that we append a random number to `resId`, you may have noticed that `channel` names include a random ID under the hood and this is where we provide one for our `channel`s.

## UI

Finally on line 506 we render a form that will look very similar to the one we made to create groups in the last lesson.

```
<form
  onSubmit={(e: React.SyntheticEvent) => {
    e.preventDefault();
    const target = e.target as typeof e.target & {
      group: { value: string };
      chat: { value: string };
      description: { value: string };
    };
    const group = target.group.value;
    const chat = target.chat.value;
    const description = target.description.value;
    createChannelLocal(group, chat, description);
  }}
>
  {/* Here we leverage our groups state variable to render a dropdown list of available groups to create channels(chats) in */}
  <select id="group" name="group">
    <option>Select a Group</option>
    {groups.map((group) => (
      <option value={group.name}>{group.name}</option>
    ))}
  </select>
  <br />
  <input type="chat" name="chat" placeholder="Chat Name" />
  <br />
  <input
    type="description"
    name="description"
    placeholder="Description"
  />
  <br />
  <input type="submit" value="Create Channel" />
</form>

```

The only new pattern here, which we will use later as well, is on line 521. We map over the `groups` variable in our state to allow our users to select the group in which they want to create a new channel. Refer back to the `createManagedGraph()` call that we made in the previous function. Now you can see how `createChannelLocal()` gets each of its arguments from the UI above and formats them into a `thread` to send into our ship.

Now you know how to setup `subscriptions` to your Urbit. It's the most complex communication pattern to setup in React since it continuously monitors data from `ship`s i.e. requires a callback function. Follow the pattern from this example to `subscribe` and handle data from any `app` and `path` on your `ship`.
