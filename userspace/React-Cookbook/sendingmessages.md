# Sending Messages

## Setting up State Variables

We're using two state variables here as we want to keep track of two things while we send messages. First we want to store a list of channel names (called `keys` in `graph-store`), and then we want to store a `log` of incoming messages so that we can render them in our app.

```
  const [log, setLog] = useState<string>(""); // State object for the log we keep of incoming messages for display
  const [keys, setKeys] = useState<Path[]>([]); // Same as groups but for channels(chats). I'm keeping the variable name 'keys' as that is the term used in graph-store

```

It's worth noting that we are storing the list of `keys` as an array of `Path`s. A `Path` is a string, for example `/ship/~zod/chat-name-777` and below we'll see how we can parse a `Path` to retrieve the information we need to send a message to the channel it represents.

## Logging Messages

Let's skip down to line 136 to see the subscription we make to retrieve messages sent in our ship. It has a callback function that we will look at next:

```
  // Now we use useEffect to establish our subscriptions to our ship. Notice that subscriptions are called directly on our Urbit object using
  // urb.subscribe. This first one parses chat messages to add to our log
  useEffect(() => {
    if (!urb || sub) return;
    urb
      .subscribe({
        // Great boilerplate example for making subscriptions to graph-store
        app: "graph-store",
        path: "/updates",
        event: logHandler, // We'll explain this callback function next
        err: console.log,
        quit: console.log,
      })
      .then((subscriptionId) => {
        setSub(subscriptionId); // Same as useCallback Hook we see the pattern of setting the state object from the returned data
      });
    console.log(urb);
  }, [urb, sub, logHandler]); // And again here is what we're monitoring for changes
```

Generally this should look familiar to you as we used `subscribe` to generate a list of `groups` from `graph-store` in the last lesson. Same thing here but now we're subscribing on the `path` `/updates` and passing in a new function `logHandler` to parse the messages that come back.

`logHandler` is defined on line 79:

```
// Callback function that we will pass into our graph-store subscription that logs incoming messages to chats courtesy of ~radur-sivmus!
  const logHandler = useCallback(
    (message) => {
      if (!("add-nodes" in message["graph-update"])) return;
      const newNodes: Record<string, GraphNode> =
        message["graph-update"]["add-nodes"]["nodes"];
      let newMessage = "";
      Object.keys(newNodes).forEach((index) => {
        newNodes[index].post.contents.forEach((content: Content) => {
          if ("text" in content) {
            newMessage += content.text + " ";
          } else if ("url" in content) {
            newMessage += content.url + " ";
          } else if ("code" in content) {
            newMessage += content.code.expression;
          } else if ("mention" in content) {
            newMessage += "~" + content.mention + " ";
          }
        });
      });
      setLog(`${log}\n${newMessage}`); // This is the React Hooks pattern. The above code formats the message and then we use setLog to store it in state
    },
    [log] // Again part of the React Hooks pattern. This keeps track of whether the log has changed to know when there is new data to process
  );
```

Just like the last lesson we are using the `useCallback` Hook to pass in our handling function. Notice that we declare the variable `newNodes` with the type `Record` consisting of a `string` and the type `GraphNode` which is defined in `@urbit/api/dist/graph/types.d.ts`. We use `[""]` notation to select the `nodes` key in the `message` object.

We then create an array from the `keys` in `newNodes` by using `Object.keys` and pass an `index` variable into the `.forEach()` method. That allows us to to get the `contents` of the message from each entry in `newNodes`. Notice here that we type our `content` variable with the `Content` type which lives in the same file as `GraphNode`.

We then use a series of `if` statements to determine what type of data is in our message as Landscape allows `mentions` `code` snippets, `url`s, and of course plain `text`. We'll dive into each of these more in future lessons.

And then finally, set use our `setLog` function to store the `newMessage` data in our `useState` variable. Now whenever a message is sent to a channel in our ship we will see it displayed in our app.

## Sending Messages

We'll need to make another subscription to `graph-store` in order to send messages. This time on `path` `/keys`, we do this on line 171:

```
  // Another graph-store subscription pattern this time to pull the list of channels(chats) that our ship belongs to. Again I'm leaving the varialbe
  // names that refer to chats as 'keys' to match the terminology of graph-store
  useEffect(() => {
    if (!urb || sub) return;
    urb
      .subscribe({
        app: "graph-store",
        path: "/keys",
        event: handleKeys,
        err: console.log,
        quit: console.log,
      })
      .then((subscriptionId) => {
        setSub(subscriptionId);
      });
  }, [urb, sub, handleKeys]);
```

Pretty much the same as the first one, but now our callback function is `handleKeys`. Let's look at it on line 104:

```
  // Callback function that we pass into the graph-store subscription to grab all of our ships keys i.e. chat names
  const handleKeys = useCallback(
    (keys) => {
      let keyArray: Path[] = [];
      keys["graph-update"]["keys"].forEach((key: Resource) => {
        keyArray.push(resourceAsPath(key));
      });
      setKeys(keyArray);
    },
    [keys]
  );
```

It's much simpler than `logHandler` since we are just pushing `keys` into an array of `Path`s. Note that a `key` is typed as a `Resource` which is defined as an object consisting of a `name` and a `ship`. We're going to import and use the function `resrouceAsPath` so that we can store this as a single `Path` string. This is a UI decision I made to easily render a `key` as an item in a dropdown menu(we'll see this below). You may not need to do this depending on what you're building.

Finally we use `setKeys` to store our array of `keys` in our state variable.

## Local Function

Now let's look at how we format user input (collected in the UI described in the next section) to send a message from our `ship`:

```
  // Our function to send messages to a channel(chat) by the user in our React UI
  function sendMessageLocal(message: string, key: Path) {
    if (!urb || !urb.ship) return;

    // Notice that this requires an extra formatting functions. First we use createPost to format the message from the browser
    const post = createPost(urb.ship, [{ text: message }]);
    // Then we wrap our newly formatted post in the addPost() function and pass that into urb.thread(). Notice we'll have to translate our
    // key name (Path) back to a Resource in order for us to grab the name for the addPost() function
    const keyResource = resourceFromPath(key);
    // We've now formatted our user message properly for graph-store to parse via urb.thread()
    urb.thread(addPost(`~${urb.ship}`, keyResource.name, post));
    alert("Message sent");
  }
```

We take a `message` and `key` as arguments, but then we need to do some extra formatting that we haven't seen yet. Messages in Urbit are typed as `Post`s, so we import the format function `createPost` and pass it our `ship` name as well as an object with our `message` assigned to a `text` key.

Remember that we wanted our key typed as a `string` to include as an item in a drop down menu, so now we coerce it back into a `Resource` by importing and using the `resourceFromPath()` function.

We then create a `thread` and need one more formatting function, this time `addPost`. If you look at the source of this function in `@urbit/api/dist/graph/lib.d.ts`, you can see that we will need to add a `~` to our ship name which we do here manually. Now that our `Path` is a `Resource` again we can derive our `channel` name by using `keyResource.name`, and finally we pass in our newly created `post` variable.

## UI

Finally on line 542 we can see the UI we render in order to collect this data from our user:

```
    {/* Here we do the same as the channel input but for messages. This looks the same
    as chat creation since all of the formatting is done in our local functions above.
    We just need to present the user with a list of channels(chats) to choose and then an input field
    for their message */}
    <form
    onSubmit={(e: React.SyntheticEvent) => {
        e.preventDefault();
        const target = e.target as typeof e.target & {
        message: { value: string };
        chat: { value: Path };
        };
        const message = target.message.value;
        const chat = target.chat.value;
        sendMessageLocal(message, chat);
    }}
    >
    <select id="chat" name="chat">
        <option>Select a Channel</option>
        {keys.map((chat) => (
        <option value={chat}>{chat}</option>
        ))}
    </select>
    <br />
    <input type="message" name="message" placeholder="Message" />
    <br />
    <input type="submit" value="Send Message" />
    </form>
```

We've seen this UI pattern in the previous lesson. It's worth noting that we can `map` over our `key` array and render each `key` as a string since we converted the `key` from a `Resource` to a `Path` in our callback function. So users select a chat from the drop down, enter their message and when they press "Send Message" the variables are sent to `sendMessageLocal()` where they are formatted to a `thread` and sent to the proper chat. Our `logHandler` function above then renders these new messages to our app's UI as it receives them via the first subscription we set up in this section.
