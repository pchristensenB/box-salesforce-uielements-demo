# Box Salesforce Communities demo with UI Elements
This sample is designed to give developers a head start in setting up a Salesforce Community that can use Box UI Elements to integrate with Box Content Services.

## Pre-Requisites
## Salesforce Setup

If you are working with other developers in a shared environment you can do the first two steps - if you are on your own developer instance you can skip to step 3

1. Setup your Salesforce DX environment: https://trailhead.salesforce.com/en/content/learn/projects/quick-start-salesforce-dx/set-up-your-salesforce-dx-environment
2. Enable Dev Hub in Salesforce. https://help.salesforce.com/s/articleView?id=sf.sfdx_setup_enable_devhub.htm&type=5
3. Install and Configure the Box for Salesforce Managed Package: https://community.box.com/t5/How-to-Guides-for-Integrations/Installing-and-Configuring-Box-For-Salesforce/ta-p/180). If you are on a new Salesforce Dev instance this will require you to setup a TrailHead account so just follow the steps. 
    > Note: Dont forget to add the Box VisualForce components to each of the record type layouts.

4. (Optional) Install the Box Salesforce SDK Unmanaged Package:
    
    * Production/Developer Org: https://cloud.box.com/Box-Apex-SDK
    * Sandbox Org: https://cloud.box.com/Box-Apex-SDK-Sandbox

5. Enable Digital Experiences in Salesforce. Go to Setup. Quick find: Digital Experiences->Settings to enable. You may be prompted to provide a custom domain name. This is required for the Box App user integration!

## VS Code setup
1. Clone this github repo.
2. Setup VS Code and Salesforce CLI: https://trailhead.salesforce.com/content/learn/projects/quick-start-lightning-web-components/set-up-visual-studio-code and https://developer.salesforce.com/tools/sfdxcli
3. Open the source from this repo in VS Code by adding the folder to your workspace.
4. In VS Code, use the cmd+shift+p shortcut and select SFDX: Authorize Org
5. Confirm you've successfully authorized your org by listing orgs and their associated status:
```
sfdx force:org:list
```
6. List the installed packaged for your org:
```
sfdx force:package:installed:list -u <username@domain.com>
```
Locate the Box for Salesforce package and copy the PACKAGE ID and VERSION into a new dependencies json element of the sfdx-project.json located at the root project directory.

It should looks something like this (at time of writing 3.75 was the latest version of the Salesforce integration package)
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
      "versionNumber": "3.75.0.7"
    },
    { 
      "package" : "0334P000000kKiUQAU",
      "versionNumber": "2.12.0.1"
    }
  ]
}
```
## Box Application setup

Next you need to create a Box JWT application using this guide: https://developer.box.com/guides/authentication/jwt/jwt-setup/
(as a minimum the app should Read/Write and "Generate tokens for users")

Once you have downloaded the json config file with your private key run the below command from the scripts directory
MAC: ./parse_box_config.py /path/to/your/config/json/file
Windows: python parse_box_config.py /path/to/your/config/json/file

This should output a correctly formatted private key in a file 'sfdc_box_config.json' in the scripts directory

Next, you need to copy the values from the json file into the BoxConnection Apex class
```
String publicKeyId = '';
String privateKey = '';
String enterpriseId = '';
String clientId = '';
String clientSecret = '';
```

## Deploying the app
Deploy you project source to either you scratch org or your own developer instance.

More detail on what is in the app - see [APP DETAILS](app-details.md) - if you already have triggers and other custom code in your org please check against this list to see if you will run into any conflicts.

Push to Developer/Production Org:
You can right click the "force-app" folder and select "SFDX: Deploy source to Org"

![Deploy](/images/23-deploy.png)

Or use the CLI as given below
```
sfdx force:source:deploy -p force-app -u username@company.com
```

Push to Scratch Org:
```
sfdx force:source:push
```

This will deploy the code to your Salesforce org and it will be ready to use. Any errors in your code will prevent the deployment from completing successfully.



## Setting up Box UI Elements with Community
Now you can build your community site and use the Box UI Elements in your Builder. For this sample there are four seperate elements exposed as Custom Lightning Components. Please note that by default the access to the Box folders is via the Service Account created in the JWT application step. Please add this service account to the folders you want to access in the community. 

![Preview Box Content Explorer](/images/12-components.png)

The Box Content Explorer component is related to a specific Salesforce record and will show the Box folder related to a record. To work this needs to be included on a record detail page

![Preview Box Content Explorer](/images/13-record.png)

The Box Content Explorer Standalone component takes a folder ID at design time and will show the contents of this folder or folder '0' if nothing is given. This can be included anywhere in your site

![Preview Box Content Explorer](/images/14-standalone.png)

The Box Content Uploader component can take a folder Id at design time and display an upload UI component for the given folder. This can be included anywhere in your site

![Preview Box Content Explorer](/images/15-uploader.png)

The Box Preview component can take a document ID at design time and display the preview of the document. This can be included anywhere in your site

![Box Preview](/images/16-preview.png)



Please note that the first time you load the UI element it will likely fail with a CORS error. You need to add the site of your community to the CORS exceptions in the Box application configuration and the URLs used by the builder. There are three sites you need to add

For the builder:
- https://<your sfdx sub domain>.builder.salesforce-communities.com
- https://<your sfdx sub domain>.livepreview.salesforce-communities.com

For when you have published. Open the digital experiences page in Salesforce and you should see URL(s) there
![Preview Box Content Explorer](/images/24-dt.png)

Add the CORS values to your Box JWT App

![Preview Box Content Explorer](/images/10-box-cors-configuration.png)



## License

The MIT License (MIT)

Copyright (c) 2021 Peter Christensen

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
