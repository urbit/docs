# Creating Groups

We're about to walkthrough the process of collecting user input via React UI, formatting it with JS functions in our app (we're calling these local functions to distinguish them from the JS functions in `@urbit/api`), and then leverage the `@urbit/api` functions to send it into our Urbit via the `urb` object we created in the last lesson. All the examples in our demo app will be a variation on process below.

## Local Function

Let's start by looking at how we will parse our users' input in order to create a `group` on our ship, and then we'll look at the UI we use to collect said data.

On line 197 we make a function to create a `group` from the user input which we will collect below. We're calling it `createGroupLocal` to distinguish it from the `@urbit/api` function `createGroup`:

```
  function createGroupLocal(groupName: string, description: string) {
  if (!urb) return;
  urb.thread(
    // Notice that unlike subscriptions, we pass a formatting function into our thread function. In this case it is createGroup
    // I'm using default values for the 'open' object but you can create a UI to allow users to input custom values.
    createGroup(
      // The name variable stays under the hood and we use our helper format function to create it from the groupName
      formatGroupName(groupName),
      {
        open: {
          banRanks: [],
          banned: [],
        },
      },
      groupName,
      description
    )
  );
  window.confirm(`Created group ${groupName}`);
  window.location.reload();
}
```

First we make sure `urb` is set up by running `if(!urb) return`, TypeScript forces us to check this as well, otherwise it returns an error that `urb` might be null. Conveniently we can call `.thread()` directly on our `urb` object to send a `thread` into our ship. However, we need to add an additional formatting function `createGroup` which we import from `@urbit/api`. It is exported from `@urbit/api/dist/groups/lib.d.ts`, check it out there to see which parameters it accepts.

The first argument we pass uses the kebab formatting function which we'll cover below. Then for simplicity I'm leaving the default policy values but of course you can customize those as well. We also pass in `groupName` and `description` collected from the UI we'll go over below.

Finally we add a little pop-up to `confirm` that the group was created, and then a reload function to populate the rest of the UI. If we were using functional components this re-render would happen automatically, or perhaps I'm missing a way to update the `urb` object to cause a re-render. Please let me know if so.

Line 188 has the kebab format function we mentioned:

```
  function formatGroupName(name: string) {
    return name
      .replace(/([a-z])([A-Z])/g, "$1-$2")
      .replace(/\s+/g, "-")
      .toLowerCase();
  }
```

Landscape coerces group names into kebab format so this is just us rolling our own function here.

## UI

Now we're ready to render the UI that will allow users to name their groups and add a description on line 468:

```
<form
    onSubmit={(e: React.SyntheticEvent) => {
        e.preventDefault();
        const target = e.target as typeof e.target & {
        groupName: { value: string };
        description: { value: string };
    };
        {/* We're just creating variables from the input fields defined below, createGroupLocal handles the formatting */}

        const groupName = target.groupName.value;
        const description = target.description.value;
        createGroupLocal(groupName, description);
    }}>
    <input
        type="groupName"
        name="groupName"
        placeholder="Group Name"
    />
    <br />
    <input
        type="description"
        name="description"
        placeholder="Description"
    />
    <br />
    <input type="submit" value="Create Group" />
    </form>
```

You'll notice this is the same pattern as we saw in the [Logging In](https://github.com/witfyl-ravped/urbit-react-cookbook/blob/main/logginging.md) lesson. Namely we use the `onSubmit` prop to create an object from our two input fields (in this case `groupName` and `description`), and then we destructure those values into variables that we pass into our `createGroupLocal()` function described above.
