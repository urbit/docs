# Scrying Messages

## Local Function

Finally we introduce a new concept to see a fourth way we can interact with our ship from React, namely `scry`ing. These are useful to make calls for specific pieces of information for which you don't want to setup a `subscription`. A `Scry` takes an `app` and a `path` and returns the data as a `Promise` similar to a `subscription`. But unlike a `subscription` we don't receive any subsequent data from our `scry` so we don't need to manage it.

Beginning on line 389:

```
  function scryLocal(key: Path, count: string) {
    if (!urb) return;

    const keyResource = resourceFromPath(key);
    const scry: Scry = {
      app: "graph-store",
      path: `/newest/${keyResource.ship}/${keyResource.name}/${count}`,
    };

    urb.scry(scry).then((messages) => {
      const nodes = messages["graph-update"]["add-nodes"]["nodes"];
      Object.keys(nodes).forEach((index) => {
        console.log(
          `${nodes[index].post.author}:`,
          nodes[index].post.contents[0].text
        );
      });
    });
  }
```

First we format our `Scry` by giving it the app `graph-store` and destructuring our `keyResource` to give it the `path` given to us by our user in the UI below. Our user also gives us the number of previous messages to return via the `count` argument which we add to the end of our `path`.

Then we call `urb.scry()` passing it the `scry` variable we just made and append `.then()` to create a `Promise` to handle the returned data. Notice that we're parsing this very similarly to the `logHandler` callback we used on our `subscription` earlier in our app. In this example we are just `console.log`ing the authoring `ship` and text from each message, but of course you can do whatever you'd like from within the `Promise`.

## UI

While the local function contains a new element, the UI is what we're used to seeing and can be found on line 724:

```
    <form
        onSubmit={(e: React.SyntheticEvent) => {
            e.preventDefault();
            const target = e.target as typeof e.target & {
            chat: { value: Path };
            count: { value: string };
            };
            const chat = target.chat.value;
            const count = target.count.value;
            scryLocal(chat, count);
        }}
        >
        <select id="chat" name="chat">
            <option>Select a Channel</option>
            {keys.map((chat) => (
            <option value={chat}>{chat}</option>
            ))}
        </select>
        <br />
        <input type="count" name="count" placeholder="Count" />
        <br />
        <input type="submit" value="Scry Messages" />
    </form>
```

We just need to collet a `channel` to `scry` and a `count` to determine the number of messages we're requesting. This gets passed into `scryLocal()` which `console.log`s the results.
