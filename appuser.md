# Enable app users on your Salesforce Community demo
The Salesforce Community demo can be setup to work with app users. In this demo we use the contact object on an account to create a Salesforce portal user and a Box App user. 

The process for enabling this process in this demo is as follows :

In Salesforce:

1. Enable a custom profile for your Community users
    - Go to Setup->Users->Profiles
    - Find 'Customer Community User' and click 'Clone'

        <img src="/images/28-clone.png" width="50%" height="50%">

    - Name the new profile 'Box Demo Community User' 
    - Open the profile, scroll down to Enabled Apex classes and add the classes related to UI Elements
    
        <img src="/images/26-apexclasses.png" width="50%" height="50%">

2. Goto the administration of your Community Site
    - Go to Feature Settings->Digital Experiences->All Sites-> Workspaces (for your site)
    - Go to Administration->Members and add 'Box Demo Community User' to selected profiles

         <img src="/images/27-memberssite.png" width="50%" height="50%">

In VS Code

1. Enable the ContactUserCreation and AppUserCreation triggers
    - Open the .trigger-meta.xml for each trigger and set status to Active
2. Edit the Apex class 'BoxAppUserHandler'. Read the description (find 'READ THIS FOR SETTING UP APP USER ACCESS TO FOLDER') for instructions on how to setup the stand alone folder

    <img src="/images/29-appuserapex.png" width="50%" height="50%">

3. Edit the 'BoxContentExplorerController' and 'BoxContentExplorerStandaloneController'. Find 'UNCOMMENT FOR USING APP USER' and uncomment the following line. This will enforce the components to use an app user token rather than a service account token.

    <img src="/images/30-token.png" width="50%" height="50%">

After making the changes, deploy your project

To demonstrate

1. Create a new contact for an account that has a Box Folder associated - add first name, last name and email address (use an email address you can access). This will create a Salesforce Portal user and an app user in Box and collaborate this user on the account folder in Box.
2. An email will be sent to the registered email address for you to confirm the user. Once confirmed, the user can login to the Community Site and interact with content via both the record based Box Content Explorer and the standalone Box Content Explorer.