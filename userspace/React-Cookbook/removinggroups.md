# Removing Groups

## Local Function

Similar to `removeChannelLocal()` we only need a very simple `thread` to remove a `group` from our `ship` and we see it on line 303:

```
  function removeGroupLocal(group: string) {
    if (!urb) return;
    const groupResource = resourceFromPath(group);

    // Here we're passing a thread the deleteGroup function from the groups library and destructuring the ship and name from
    // the group resource we created above

    urb.thread(deleteGroup(groupResource.ship, groupResource.name));
    window.confirm(`Removed group ${group}`);
    window.location.reload();
  }
```

We're following the pattern of turning our `group` back into a `Resource` using `resourceFromPath()` and then passing a `thread` its `ship` and `name` via the `deleteGroup()` formatting function.

## UI

No surprises in the UI starting on line 703:

```
    <form
        onSubmit={(e: React.SyntheticEvent) => {
            e.preventDefault();
            const target = e.target as typeof e.target & {
            group: { value: string };
            };
            const group = target.group.value;
            removeGroupLocal(group);
        }}>
        <select id="group" name="group">
            <option>Select a Group</option>
            {groups.map((group) => (
            <option value={group.name}>{group.name}</option>
            ))}
        </select>
        <br />
        <input type="submit" value="Remove Group" />
    </form>
```

We leverage our `group` array from state in order to `map` its contents into a dropdown menu that our users and select from and then remove.
