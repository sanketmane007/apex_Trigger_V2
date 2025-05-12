trigger opportuityTrigger on Opportunity (before delete) {


    /*
Trigger 1
If an opportunity is closed then, no one should be able to delete it except user having 
System Administrator profile.

Once an opportunity is marked as closed won, send an email to the following users:
Opportunity Owner
Account Owner

*/
// Id profileId = UserInfo.getProfileId();

// Profile proName = [SELECT Id,Name FROM Profile WHERE Id =:profileId LIMIT 1];

// if(trigger.isbefore && trigger.isDelete){
  
//     for(Opportunity opp : trigger.old){
//         if (opp.StageName == 'Closed Won' && proName.Name != 'System Administrator') {
//             opp.addError('You Do not have Permission to Delete Record , Only SYstem Administartor have Permission');
//         }
//     }

// }






}

