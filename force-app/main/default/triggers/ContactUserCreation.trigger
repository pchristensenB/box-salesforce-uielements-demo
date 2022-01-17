trigger ContactUserCreation on Contact (After insert) {

    if(Trigger.isInsert){
         for(Contact co : trigger.new){
            Contact con = [select id,email,firstName,lastname,accountId from Contact where Id =:co.Id];         

            Database.DMLOptions dmo = new Database.DMLOptions();
            dmo.EmailHeader.triggerUserEmail = false;       
            dmo.EmailHeader.triggerOtherEmail = false;
            dmo.EmailHeader.triggerAutoResponseEmail = false;       
            dmo.optAllOrNone = false;

            // create portal user
            String nick = con.email!=null?con.email.substring(0, con.email.indexOf('@')):'';
            nick += Datetime.now().getTime();


            //CHANGE NAME TO THE PROFILE NAME YOU HAVE SETUP IN SALESFORCE 
            String profileName='Box Demo Community User';

            
            Id profileId = [select id from profile where name=:profileName limit 1][0].id;
            User myNewUser = new User(
                                alias = con.firstName, 
                                email = con.email, 
                                emailencodingkey = 'UTF-8', 
                                firstname = con.firstName, 
                                lastname = con.lastname, 
                                languagelocalekey = 'en_GB', 
                                localesidkey = 'en_GB', 
                                contactId = con.Id,
                                timezonesidkey = 'Europe/London', 
                                username = con.email,
                                CommunityNickname = nick,
                                ProfileId = profileId,
                                IsActive = true);

            myNewUser.setOptions(dmo);
            insert myNewUser;
         }
    }
    }