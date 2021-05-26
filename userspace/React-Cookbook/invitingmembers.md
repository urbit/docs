# Inviting Members

## Local Function

Another simple example that just requires us to send a `thread` into our ship. Line 375:

```
  function inviteLocal(group: string, ship: string, description: string) {
    if (!urb) return;

    const groupResource = resourceFromPath(group);
    const shipArray: string[] = [];
    shipArray.push(ship);
    urb.thread(
      invite(groupResource.ship, groupResource.name, shipArray, description)
    );

    window.confirm(`Invited ${ship} to ${group}`);
    window.location.reload();
  }
```

Here we're using `urb.thread()` again and passing it another formatting function that lives in `@urbit/api/dist/groups/lib.d.ts`, this time it is `invite()`. Again we'll need to turn our `group` name from a `Path` to a `Resource` since we're getting it as a string from a dropdown. And just like `addMembers()` it takes `ship`s as an array so we need to make one as well.

## UI

Nothing new here, just a dropdown menu to select the `group`, input field to enter a `ship` and another input field to write a nice message on line 630:

```
<form
    onSubmit={(e: React.SyntheticEvent) => {
        e.preventDefault();
        const target = e.target as typeof e.target & {
            group: { value: string };
            ship: { value: string };
            description: { value: string };
        };

        const group = target.group.value;
        const ship = target.ship.value;
        const description = target.description.value;
        inviteLocal(group, ship, description);
    }}>
    <select id="group" name="group">
        <option>Select a Group</option>
        {groups.map((group) => (
            <option value={group.name}>{group.name}</option>
        ))}
    </select>
    <br />
    <input type="ship" name="ship" placeholder="~sampel-palnet" />
    <br />
    <input
        type="description"
        name="description"
        placeholder="Invite Message"
    />
    <br />
    <input type="submit" value="Send Invite" />
</form>
```
