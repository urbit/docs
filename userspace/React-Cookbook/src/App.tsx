import React, { useCallback, useEffect, useState } from "react";
import _ from "lodash";
import Urbit, { UrbitInterface } from "@urbit/http-api";
import "./App.css";
import {
  Content,
  GraphNode,
  createGroup,
  createPost,
  addPost,
  createManagedGraph,
  dateToDa,
  deleteGroup,
  resourceFromPath,
  deleteGraph,
  Resource,
  resourceAsPath,
  Path,
  Scry,
  remove,
  deSig,
  addMembers,
  Group,
  removeMembers,
} from "@urbit/api";
import { invite } from "@urbit/api/dist/groups";

// This is how we establish a connection with out ship. We pass the port that our fake ship is running on along with
// its code into the Urbit object we imported above. Notice that we then manually assign the name of our ship by declaring 'urb.ship'
// This gets called when our user enters their host and code credentials via UI form below

const createApi = (host: string, code: string) =>
  _.memoize(
    (): UrbitInterface => {
      const urb = new Urbit(host, code);
      urb.ship = "zod";
      // urb
      //   .connect()
      //   .then((response) => alert("success").catch((err) => console.log(err)));
      try {
        urb.connect();
      } catch (err) {
        console.log(err);
      }
      urb.onError = (message) => console.log(message);
      return urb;
    }
  );

// Here we create out app's functional component. We begin by using useState to create state objects for all of the data we're calling out of our ship
// Also notice that we create a state object for urb that gets set when we call the createApi function
const App = () => {
  const [loggedIn, setLoggedIn] = useState<boolean>(); // Keeps track of whether our user is logged in for use throughout our app
  const [urb, setUrb] = useState<UrbitInterface | undefined>(); // Stores our Urbit connection. Notice we declare the type as UrbitInterface
  const [sub, setSub] = useState<number | undefined>(); // Currently managing all subscriptions with one state object. This will most likely change with future api fixes
  const [log, setLog] = useState<string>(""); // State object for the log we keep of incoming messages for display
  const [groups, setGroups] = useState<GroupWName[] | any>([]); // State object to keep track of the list of groups our ship belongs to
  const [keys, setKeys] = useState<Path[]>([]); // Same as above but for channels(chats). I'm keeping the variable name 'keys' as that is the term used in graph-store

  // We use useEffect to check if the user already has log in credentials stored in localStorage from a previous session. If so then we set our loggedIn
  // state variable to true and then run our createApi() function with the credentials from localStorage
  useEffect(() => {
    if (localStorage.getItem("host") && localStorage.getItem("code")) {
      setLoggedIn(true);
      const _urb = createApi(
        localStorage.getItem("host")!,
        localStorage.getItem("code")!
      );
      setUrb(_urb);
      return () => {};
    }
  }, []);

  // This is the function that stores the credentials our user enters into localStorage and then uses them to call the createApi function we defined above to
  // establish connection to our ship
  const login = (host: string, code: string) => {
    localStorage.setItem("host", host);
    localStorage.setItem("code", code);
    const _urb = createApi(host, code);
    setUrb(_urb);
    setLoggedIn(true);
    return () => {};
  };

  // Callback function that we will pass into our graph-store subscription that logs incoming messages to chats courtesy of ~radur-sivmus!
  const logHandler = useCallback(
    (message) => {
      if (!("add-nodes" in message["graph-update"])) return;
      const newNodes: Record<string, GraphNode> =
        message["graph-update"]["add-nodes"]["nodes"];
      let newMessage = "";
      Object.keys(newNodes).forEach((index) => {
        console.log(newNodes[index]);
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

  // Callback function that we pass into the group-store (not graph-store!) subscription to grab all of the groups that our ship is a member of
  // GroupWName is a custom TypeScript interface I created so we can pass the name of a group along with it's contents. This may get integrated into the API in the future
  // For now it serves as a demo should you want to create your own for specific uses
  interface GroupWName {
    name: string;
    group: Group;
  }

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

  // Now we use useEffect to establish our subscriptions to our ship. Notice that subscriptions are called directly on our Urbit object using
  // urb.subscribe. This first one parses chat messages to add to our log
  useEffect(() => {
    if (!urb || sub) return;
    urb
      .subscribe({
        // Great boilerplate example for making subscriptions to graph-store
        app: "graph-store",
        path: "/updates",
        event: logHandler, // Refer to our logHandler function above to see how messages are parsed for display
        err: console.log,
        quit: console.log,
      })
      .then((subscriptionId) => {
        setSub(subscriptionId); // Same as useCallback Hook we see the pattern of setting the state object from the returned data
      });
    console.log(urb);
  }, [urb, sub, logHandler]); // And again here is what we're monitoring for changes

  // Almost the same as above but this time we're subscribing to group-store in order to get the names of the groups that our ship belongs to
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

  // This is a simple kebab formatting function that will most likely be built into @urbit/api in future versions
  function formatGroupName(name: string) {
    return name
      .replace(/([a-z])([A-Z])/g, "$1-$2")
      .replace(/\s+/g, "-")
      .toLowerCase();
  }

  // Now we start defining graph-store actions that are called directly on our Urbit object using urb.thread(). Threads are the main way that we send
  // commands to graph-store. This example uses them to create groups/chats and send messages. This first function is used to create a group
  function createGroupLocal(groupName: string, description: string) {
    if (!urb) return;
    urb.thread(
      // Notice that unlike subscriptions above, we pass a formatting function into our thread function. In this case it is createGroup
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

  // Another helper function from landscape that will eventually be built into @urbit/api used here to format chat names
  function stringToSymbol(str: string) {
    const ascii = str;
    let result = "";
    for (let i = 0; i < ascii.length; i++) {
      const n = ascii.charCodeAt(i);
      if ((n >= 97 && n <= 122) || (n >= 48 && n <= 57)) {
        result += ascii[i];
      } else if (n >= 65 && n <= 90) {
        result += String.fromCharCode(n + 32);
      } else {
        result += "-";
      }
    }
    result = result.replace(/^[\-\d]+|\-+/g, "-");
    result = result.replace(/^\-+|\-+$/g, "");
    if (result === "") {
      return dateToDa(new Date());
    }
    return result;
  }

  // Similar to createGroupLocal above, we use urb.thread() to create a channel via graph-store.
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

  // Local function to remove a group from our ship
  function removeGroupLocal(group: string) {
    if (!urb) return;
    const groupResource = resourceFromPath(group);
    // Here we're passing a thread the deleteGroup function from the groups library and destructuring the ship and name from
    // the group resource we created above
    urb.thread(deleteGroup(groupResource.ship, groupResource.name));
    window.confirm(`Removed group ${group}`);
    window.location.reload();
  }

  // Local function to remove a channel(chat) from a group on our ship
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

  // We're using a functional component here to render the UI because removing members from groups requires a little extra logic
  // We want the user to select between groups to render a list of each group's members. We need the extra steps since the member list is derived from the group Paths
  // which a user can toggle between. Therefore lists will have to be rendered according to user input
  const RenderRemoveMembers = () => {
    // Making this a functional component gives us access to its own useState hook for free. We'll use this to populate lists of members from user input
    const [selectedGroup, setSelectedGroup] = useState("default");
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
          {groups.map((group: any, index: any) => (
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
            ? groups[parseInt(selectedGroup)].group.members.map((member: any) => {
                return <option value={member}>{member}</option>;
              })
            : null}
        </select>
        <br />
        <input type="submit" value="Remove Member" />
      </form>
    );
  };

  // Local function to populate the @urbit/api invite() function which we send to our ship via thread
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

  return (
    <div className="App">
      <header className="App-header">
        <table width="100%">
          <tr>
            <td>
              <pre>
                {/* Very simple UI to render our log from the state variable*/}
                Latest Message:
                <br /> {log}
              </pre>
            </td>
            <td>
              {/* This is the template we'll use for forms that allow users to send data to our ship. We're using minimal code to keep track of the two
              text inputs for host address and code and then send them to our login() function*/}
              <pre>Login:</pre>
              <form
                onSubmit={(e: React.SyntheticEvent) => {
                  e.preventDefault();
                  const target = e.target as typeof e.target & {
                    host: { value: string };
                    code: { value: string };
                  };
                  const host = target.host.value;
                  const code = target.code.value;
                  login(host, code);
                }}
              >
                {/* We are using ternary operators to get if the use already has login info in localStorage. If so we render that info as a placeholder
                for each input form. Otherwise we use 'Host' or 'Code' as the placeholder*/}
                <input
                  type="host"
                  name="host"
                  placeholder={
                    loggedIn ? localStorage.getItem("host")! : "Host"
                  }
                />
                <br />
                <input
                  type="code"
                  name="code"
                  placeholder={
                    loggedIn ? localStorage.getItem("code")! : "Code"
                  }
                />
                <br />
                <input type="submit" value="Login" />
              </form>
            </td>
          </tr>
        </table>
        <table width="100%">
          <tr>
            <td>
              <div style={{ justifyContent: "center" }}>
                <pre>Create Group</pre>
              </div>
            </td>
            <td>
              <div style={{ justifyContent: "center" }}>
                <pre>Create Channel</pre>
              </div>
            </td>
            <td>
              <div style={{ justifyContent: "center" }}>
                <pre>Send Message</pre>
              </div>
            </td>
          </tr>
          <tr>
            <td>
              {/* Here's an example of how to collect data from a user to pass into our createGroupLocal function*/}
              <form
                onSubmit={(e: React.SyntheticEvent) => {
                  e.preventDefault();
                  const target = e.target as typeof e.target & {
                    groupName: { value: string };
                    description: { value: string };
                  };
                  {
                    /* We're just creating variables from the input fields defined below, createGroupLocal handles the formatting*/
                  }
                  const groupName = target.groupName.value;
                  const description = target.description.value;
                  createGroupLocal(groupName, description);
                }}
              >
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
            </td>
            <td>
              {/* Same as group input for channel(chat) input. Only difference is we present the user's groups as dropdown options*/}
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
                  {groups.map((group: any) => (
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
            </td>
            <td>
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
            </td>
          </tr>
          <tr>
            <td>
              <div style={{ justifyContent: "center" }}>
                <pre>Add Members</pre>
              </div>
            </td>
            <td>
              <div style={{ justifyContent: "center" }}>
                <pre>Remove Members</pre>
              </div>
            </td>
            <td>
              <div style={{ justifyContent: "center" }}>
                <pre>Invite Members</pre>
              </div>
            </td>
          </tr>
          <tr>
            <td>
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
                  {groups.map((group: any) => (
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
            </td>
            <td>
              {/* Here we render our functional component to allow users to remove members from groups*/}
              <RenderRemoveMembers />
            </td>
            <td>
              {/* Same pattern as the simple functions above to format user input, this time for the invite() function*/}
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
                }}
              >
                <select id="group" name="group">
                  <option>Select a Group</option>
                  {groups.map((group: any) => (
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
            </td>
          </tr>
          <tr>
            <td>
              <div style={{ justifyContent: "center" }}>
                <pre>Remove Channel</pre>
              </div>
            </td>
            <td>
              <div style={{ justifyContent: "center" }}>
                <pre>Remove Group</pre>
              </div>
            </td>
            <td>
              <div style={{ justifyContent: "center" }}>
                <pre>Scrying Messages</pre>
              </div>
            </td>
          </tr>
          <tr>
            <td>
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
            </td>
            <td>
              <form
                onSubmit={(e: React.SyntheticEvent) => {
                  e.preventDefault();
                  const target = e.target as typeof e.target & {
                    group: { value: string };
                  };
                  const group = target.group.value;
                  removeGroupLocal(group);
                }}
              >
                <select id="group" name="group">
                  <option>Select a Group</option>
                  {groups.map((group: any) => (
                    <option value={group.name}>{group.name}</option>
                  ))}
                </select>
                <br />
                <input type="submit" value="Remove Group" />
              </form>
            </td>
            <td>
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
            </td>
          </tr>
        </table>
      </header>
    </div>
  );
};

export default App;
