# Box for Salesforce Community example code
Box for Salesforce Blueprints is an examples designed to demonstrate how to load Box content related to a Salesforce record into a Box UI ELement in Salesforce Communities


## Pre-Requisites

1. Clone this github repo.
2. Setup your Salesforce DX environment: https://trailhead.salesforce.com/en/content/learn/projects/quick-start-salesforce-dx/set-up-your-salesforce-dx-environment
3. Setup VS Code: https://trailhead.salesforce.com/content/learn/projects/quick-start-lightning-web-components/set-up-visual-studio-code
4. Enable Dev Hub in Salesforce.
5. Install and Configure the Box for Salesforce Managed Package: https://community.box.com/t5/How-to-Guides-for-Integrations/Installing-and-Configuring-Box-For-Salesforce/ta-p/180
    > Note: Dont forget to add the Box VisualForce components to each of the record type layouts.

6. Install the Box Salesforce SDK Unmanaged Package:
    
    * Production/Developer Org: https://cloud.box.com/Box-Apex-SDK
    * Sandbox Org: https://cloud.box.com/Box-Apex-SDK-Sandbox

7. Open the source from this repo in VS Code.
8. In VS Code, use the cmd+shift+p shortcut and select SFDX: Authorize Org
9. Confirm you've successfully authorized your org by listing orgs and their associated status:
```
sfdx force:org:list
```
10. List the installed packaged for your org:
```
sfdx force:package:installed:list -u <username@domain.com>
```
11. Locate the Box for Salesforce package and copy the PACKAGE ID and VERSION into a new dependencies json element of the sfdx-project.json located at the root project directory.

It should looks something like this:
```
{
  "packageDirectories": [
    {
      "path": "force-app",
      "default": true
    }
  ],
  "namespace": "",
  "sfdcLoginUrl": "https://login.salesforce.com",
  "sourceApiVersion": "45.0",
  "dependencies": [
    { 
      "package" : "033700000004yvWAAQ",
      "versionNumber": "3.63.0.1"
    },
    { 
      "package" : "0334P000000kKiUQAU",
      "versionNumber": "2.12.0.1"
    }
  ]
}
```
13. Deploy you project source to either you scratch org or developer org in the next section.

## Deploy to your Org
Push to Scratch Org:
```
sfdx force:source:push
```


Deploy to Developer/Production Org:
```
sfdx force:source:deploy -p force-app -u username@company.com
```

## Create a Box JWT App
https://developer.box.com/guides/authentication/jwt/jwt-setup/

Once you have downloaded the json config file with your private key run the below command from the scripts directory
./parse_box_config.py /path/to/your/config/json/file

This should output a correctly formatted private key in a file 'sfdc_box_config.json' in the scripts directory

Next, you need to copy the values from the json file into the BoxConnection class
```
String publicKeyId = '';
String privateKey = '';
String enterpriseId = '';
String clientId = '';
String clientSecret = '';
```

## Setting up Box with Community
Now you can setup your community and use the Box UI Components in your Builder

![Preview Box Content Explorer](/images/12-components.png)



Please note that the first time you load the UI element it will likely fail with a CORS error. You need to add the site of your community to the CORS exceptions in the Box application configuration and the URLs used by the builder. 

![Preview Box Content Explorer](/images/10-box-cors-configuration.png)




