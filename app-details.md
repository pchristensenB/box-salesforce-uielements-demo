## Whats in the application
The force app you have installed has a number of components that can be used to integrate Box and Salesforce Communities.
- **Ligtning Components:**
    These are Aura components and each represent a custom component that can be used in the Salesforce Digital Experience builder. Each component has a corresponding Apex controller class that manages the token generation.

    ![Components](/images/17-aura.png)


- **Apex Classes**: 
    The Apex classes are the controller classes for the above components and classes for the apex triggers to handle account and portal user creation.

    ![APEX](/images/18-apex.png)
 
- **CSP sites**: 
    The Content Security Policy defines how Salesforce manages web site security and prevent XSS. The CSP definitions allows the community site to communcate with Box API and other services

    ![CSP](/images/19-csp.png)

- **Static Resources**:
    The static resources are the javascript and stylesheet files that are required for UI elements. These must be added here as static resources as the Salesforce Community security posture doesn't allow loading of external libraries. These resources are referenced in the Component resource files (.cmp)

    ![STATIC](/images/20-static.png)

    ..in the CMP File

    ![CMP](/images/22-cmp.png)


- **Apex Triggers**:
    The Apex triggers included are
    - Account trigger. Creates a Box folder automatically when a new account is created. This is instead of the default Box behaviour of only creating the folder ondemand
    - Opportunity trigger. Creates a Box folder automatically when a new opportunity is created and moves under the account associated. This trigger will only work if the account trigger is enabled.
    - App user trigger. Creates a Box app user when a new portal user is registered. See [APP USERS](appuser.md) for more details on this as it requires more setup. 
  
  The triggers are set to "Inactive" by default. To use then, set them to "Active" in the trigger-meta.xml file for each trigger

    ![TRIGGER](/images/21-triggers.png)