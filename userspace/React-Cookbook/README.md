# Urbit React Cookbook

In this lesson you will learn how to build a React frontend that connects to your ship and interacts with it using the four basic forms of communication, namely: `poke`, `subscribe`, `thread`, `scry`. These examples will get you started building React apps for Urbit as well as familiarize you with the Urbit APIs required to get you writing your own custom functions.

This project was bootstrapped with [Create React App](https://github.com/facebook/create-react-app).

## Getting Started

First run `yarn install` to install project dependencies.

Then boot a fake `~zod` ship connected to localhost port 8080 (alternatively you can select a different port by editing `src/App.tsx`) For instructions on booting fake ships see [this guide](https://github.com/timlucmiptev/gall-guide/blob/62f4647b614dc201796204a0214629375a1a56bb/workflow.md).

Then run `yarn start` to boot the local React server which will run at `http://localhost:3000` by default.

In a separate browser tab connect to your fake `~zod`'s Landscape page which is `http://localhost:8080` or a custom port of you changed it

Back at the React app, enter your ships localhost address and code in the top right corner. In this example the host will be `http://localhost:8080`. Obtain your ship's code by enter `+code` in your ship's dojo. For `~zod` the code will be `lidlut-tabwed-pillex-ridrup`. Then press "Login."

Now we've almost got everything setup and talking to each other. Finally enter `+cors-registry` in your ship's dojo. You will likely see two URLs in the `requests` entry:

`~~http~3a.~2f.~2f.localhost~3a.3000`
and
`~~http~3a.~2f.~2f.localhost~3a.8080`

You'll need to add it to the approved list by running:

`|cors-approve ~~http~3a.~2f.~2f.localhost~3a.3000`
and<br>
`|cors-approve ~~http~3a.~2f.~2f.localhost~3a.8080`

Verfiy these commands worked by running `+cors-registry` again.

## Logging in

[Click here](https://github.com/witfyl-ravped/urbit-react-cookbook/blob/main/logginging.md) for a detailed walkthrough of the login flow you performed above

## Creating Groups

<i>How to call `threads`</i>

Start by adding a group using the form on the left of the React app. Enter a Group Name, Group Description and press "Create Group." Your browser will confirm the successful creation with an alert window.
After clicking OK in the alert window navigate to your Landscape tab to confirm that the group was created and it's tile added.

[Click here](https://github.com/witfyl-ravped/urbit-react-cookbook/blob/main/creatinggroups.md) for a detailed walkthrough of the Creating Groups functions and UI

## Creating Channels

<i>How to create and maintain `subscriptions`</i>

Back in the React app, fill in the middle "Create Channel" inputs. Select your newly created group from the drop-down and enter a Chat Name and Description and press "Create Channel". This should also be confirmed by a window alert upon success.

After clicking OK in the alert window navigate to your Landscape page to confirm that the channel was created within your previously created group.

[Click here](https://github.com/witfyl-ravped/urbit-react-cookbook/blob/main/creatingchannels.md) for a detailed walkthrough of the Creating Channels functions and UI

## Sending Messages

<i>Calling `thread`s and managing `subscriptions`</i>

<b>NOTE:</b> <i>We are still waiting on an update to `@urbit/http-api` that uses the new `group-update` versioning syntax. Until then the steps below will not work.</i>

Again back in the React app, select a chat from the drop-down menu under "Send Message" and enter some text. Upon clicking the "Send Message" button you should once again receive a confirmation alert.

Your message should now appear at the top of the React app. You can navigate back to your Landscape window to see the message you just sent from React displayed in the newly created channel.

Notice that you can send a message to the channel from Landscape and that it will also appear at the top of the React app.

[Click here](https://github.com/witfyl-ravped/urbit-react-cookbook/blob/main/sendingmessages.md) for a detailed walkthrough of the Sending Messages functions and UI

## Adding Members

<i>How to send a `poke`</i>

In this input select a Group that you have created from the dropdown menu and enter a ship with '~' prefix. Then press "Add Member"

Confirm that the member has been added via Group info in Landscape. You can find this information be clicking on the Group tile. Then the gear icon in the top left corner of the group. From there click on Participants and confirm the ship you added is listed

Try adding a few different ships

[Click here](https://github.com/witfyl-ravped/urbit-react-cookbook/blob/main/addingmembers.md) for a detailed walkthrough of the Adding Members functions and UI

## Removing Members

<i>Using `poke`s</i>

First select one of the groups you created from the "Select a Group" drop down in this section

After selecting a group the list of members will auto-populate in the "Select a Member" dropdown. Select a member from this list

Now click "Remove Member" and then confirm that this user was indeed removed via your Landscape interface

[Click here](https://github.com/witfyl-ravped/urbit-react-cookbook/blob/main/removingmembers.md) for a detailed walkthrough of the Removing Members functions and UI

## Inviting Members

<i>Using `thread`s</i>

To fully test this function we recommend booting another fake ship on your local network. Follow the instructions in the introduction to this guide for support in creating and booting fake ships. Call this second one `~mus`

After `~mus` is running, you should see `~zod is your neighbor` displayed in its terminal. Check which port it is running on by looking for a message similar to this: `http: web interface live on http://localhost:8081` in the startup text. Use that link to log into it's Landscape interface

Back in the React interface, select a group under the "Invite Members" heading

Enter the name of your new fake ship in the input below, `~mus` in my case

Then enter a message and press "Send Invite"

After clicking "Ok" in confirmation popup, navigate to the `~mus` Landscape interface. After a few moments you should receive a notification ontop of the Leap menu in the top left corner. Click on it to accept your invite and join the group.

Once inside the group you will have access the channel(chat) you created in the previous step. Notice that you can send a message in the chat from `~mus` and it will display at the top of our React interface

[Click here](https://github.com/witfyl-ravped/urbit-react-cookbook/blob/main/invitingmembers.md) for a detailed walkthrough of the Inviting Members functions and UI

## Removing Channels

<i>Using `thread`s</i>

To test this function start by adding a new channel under the Create Channel heading.

Verify that it has been added by checking in Landscape. You can also test it by selecting it from the "Select a Channel" dropdown selector under the "Remove Channels" header. Go ahead and select it from this menu and click "Remove Channel."

Confirm the pop and then verify the channel has been removed from both the drop down menus and your Landscape tab.

[Click here](https://github.com/witfyl-ravped/urbit-react-cookbook/blob/main/removingchannels.md) for a detailed walkthrough of the Inviting Members functions and UI

## Removing Groups

<i>Using `thread`s</i>

Choose your group from "Select a Group" dropdown under the "Remove Group" header and click "Remove Group".

Click OK and verify that the group and its tile has been removed from Landscape.

[Click here](https://github.com/witfyl-ravped/urbit-react-cookbook/blob/main/removinggroups.md) for a detailed walkthrough of the Inviting Members functions and UI

## Scrying Messages

<i>How to `scry`</i>

This function allows you to `scry` a variable number of recent messages from a given channel. To test this out go ahead and send a few messages to one of the channels you created. Bonus points if you send a few more from another ship that you added or invited

Now select this channel from the dropdown under "Scrying Messages"

In the "Count" input enter a number of messages to scry out of `graph-store`

Finally press "Scry Messages" and check the results in the console

[Click here](https://github.com/witfyl-ravped/urbit-react-cookbook/blob/main/scryingmessages.md) for a detailed walkthrough of the Scrying Messages functions and UI
