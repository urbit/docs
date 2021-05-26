# Adding Members

## Local Function

This is a simple example since we don't need any information from our ship in order to add members to a group. We just need to format ship names and send them as a `poke`. We do this with the function on line 275:

```
  // This is our local function to add members to a group
  function addMembersLocal(group: Path, ship: string) {
    if (!urb) return;

    // Since addMembers() accepts multiple ships, we'll have to create an array out of our ship even though we are only sending in one at a time in our example
    const shipArray: string[] = [];
    shipArray.push(ship);
    // We also need to coerce our group Path into a Resource to accommodate addMembers() data types
    const groupResource = resourceFromPath(group);
    urb.poke(addMembers(groupResource, shipArray));

    window.confirm(`Added ${ship} to ${group}`);
    window.location.reload();
  }
```

Notice that we're creating an array since the `addMembers()` function is capable of adding multiple `ship`s at a time and so its input requires an array. See for yourself at `@urbit/api/dist/groupStoreAction.lib.d.ts`. So we push our single `ship` into this array and send it into `addMembers()` along with the name of the `group` we're adding members to. Like in previous examples our users are selecting the `group` from a dropdown menu, and for that we need the `group` to be a string i.e. `Path`. This means that we will once again need `resourceFromPath()` to change it back into a `Resource` since that is the data type `addMembers()` expects.

## UI

Now we just need the UI to collect data from our user which we see on line 595:

```
    <form
        onSubmit={(e: React.SyntheticEvent) => {
            e.preventDefault();
            const target = e.target as typeof e.target & {
            group: { value: string };
            member: { value: string };
            };
            const group = target.group.value;
            const member = target.member.value;
            addMembersLocal(group, member);
        }}
        >
        {/* Here we leverage our groups state variable to render a dropdown list of available groups that the user can add members to */}
        <select id="group" name="group">
            <option>Select a Group</option>
            {groups.map((group) => (
            <option value={group.name}>{group.name}</option>
            ))}
        </select>
        <br />
        <input
            type="member"
            name="member"
            placeholder="~sampel-palnet"
        />
        <br />
        <input type="submit" value="Add Member" />
    </form>
```

These are all functions we've already seen. A dropdown menu of `groups` and then an input field for our users to enter a `ship` to add.
