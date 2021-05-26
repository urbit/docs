# Removing Members

## Local Function

Similar to Adding Members we only need a local function for this examplem, line 290:

```
  // Our local function to remove members from a group. Requires the same formatting steps as addMembersLocal()
  function removeMembersLocal(group: Path, ship: string) {
    if (!urb) return;

    const shipArray: string[] = [];
    shipArray.push(`~${ship}`);
    const groupResource = resourceFromPath(group);
    urb.poke(removeMembers(groupResource, shipArray));

    window.confirm(`Removeed ${ship} from ${group}`);
    window.location.reload();
  }
```

It's almost exactly the same as `addMembersLocal()` except that we send `urb.poke` `removeMembers()` instead of `addMembers()`. The other difference is that `removeMembers()` requires that `ships` incude their `~` which we add when we push our `ship` into its array.

## UI

This is the most complex UI example in our example app so I'm taking it as an opportunity to address, albeit briefly, functional components. In a full blown app each piece of UI would likely be its own functional component, likely imported from its own separate file. This is a scaled down example, but enough to understand what functional components are and why we'd want to use them.

Starting on line 329 we see:

```
// We're using a functional component here to render the UI because removing members from groups requires a little extra logic
// We want the user to select between groups to render a list of each group's members. We need the extra steps since the member list is derived from the group Paths
// which a user can toggle between. Therefore lists will have to be rendered according to user input

  const RenderRemoveMembers = () => {
    // Making this a functional component gives us access to its own useState hook for free. We'll use this to populate lists of members from user input
    const [selectedGroup, setSelectedGroup] = useState("default");

```

First thing to notice is that we're able to use `useState()` in our function. This is because React gives us access to Hooks in functional components allowing them to be self contained, self updating, sovereign pieces of UI. We will use this functionality to keep track of which group our user has selected and use that selection to render out the list of members belonging to that group. Our user can then select from the list of members and choose one to remove.

Continuing on:

```
    return (
      <form
        onSubmit={(e: React.SyntheticEvent) => {
          e.preventDefault();
          const target = e.target as typeof e.target & {
            group: { value: string };
            member: { value: string };
          };
          const group = groups[parseInt(selectedGroup)].name;
          const member = target.member.value;
          removeMembersLocal(group, member);
        }}
      >
        <select
          value={selectedGroup}
          onChange={(e) => setSelectedGroup(e.target.value)}
        >
          <option key="default" value="default">
            Select a Group
          </option>
          {groups.map((group, index) => (
            <option key={group.name} value={index}>
              {group.name}
            </option>
          ))}
        </select>
        <br />
        {/* This is the extra step needed to create a member list based on which group our user selects*/}
        <select id="member" name="member">
          <option>Select a Member</option>
          {groups[0] && selectedGroup !== "default"
            ? groups[parseInt(selectedGroup)].group.members.map((member) => {
                return <option value={member}>{member}</option>;
              })
            : null}
        </select>
        <br />
        <input type="submit" value="Remove Member" />
      </form>
    );
  };
```

Two things are different from the UI we've seen so far. First notice that in the first `<select>` tag, which the users use to select a `group`, the `value` for each `option` is the `index` passed into the `map` function. We see that in the `onChange` prop of this `<select>` tag that we are storing the `index` in our state variable, not the `group` name. We'll see why in a second.

Let's look at the second `<select>` tag. Here we are rendering a second dropdown menu. Notice that we give it a "Select a Member" placeholder option and then use a ternary operation. We use `groups[0]` to confirm that the `groups` array is loaded before we continue. Also that `selectedGroup !== "default"`. Notice that in our state variable we set the default value of the `group` variable to "default" in `useState()`. This let's us check to make sure that the user has made a selection from the `groups` dropdown thus giving us an `index` that we can use to fetch the `members` out of.

This is why we're storing `index` in state, now we can render the rest of our `<options>` by mapping over the `member` array which is stored in `groups[index]`. This is what `groups[parseInt(selectedGroup)].group.members.map((member)` gives us.

Last thing to note here is that on line 626 where we want to render this form we just have to write `<RenderRemoveMembers />` and React takes care of the rest.
