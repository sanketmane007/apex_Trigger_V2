trigger conatctTrigger on Contact (after insert,after Update,after delete,after undelete) {    



    /*
   Trigger 2 
Suppose you are a developer in company XYZ now your company wants to 
keep track of the number of contacts associated with each account in 
their Salesforce database.


Count the total number of contacts associated to an Account whenever a Contact is, 

Inserted, Updated or Deleted related to the Account.
Field Total_Contacts_Count__c should get updated with the latest count.
*/

Set<Id> accids = new Set<Id>();
if(trigger.isAfter && (trigger.isinsert || trigger.isUndelete)){   
        for(Contact con :  trigger.new){
            accids.add(con.AccountId);
    }
}
if(trigger.isAfter && trigger.isUpdate){

    for(Contact con : trigger.new){
        if(con.AccountId != trigger.oldMap.get(con.Id).AccountId){
            if(con.AccountId != null){
                accids.add(con.AccountId);
            }
           if(trigger.oldMap.get(con.Id).AccountId != null){
            accids.add(trigger.oldMap.get(con.Id).AccountId);
           }
            
            
        }else {
            accids.add(con.AccountId);
        }
    }
}
if(trigger.isBefore && trigger.isDelete){
    for(Contact con : trigger.old){
        if(con.AccountId != null){
            accids.add(con.AccountId);
        }
    }
}

if(!accids.isEmpty()){

    List<Account> accUpdateList = new List<Account>();
    
    List<AggregateResult> lstAgg = [SELECT AccountId, count(Id) counts FROM Contact 
                                        WHERE AccountId IN:accids GROUP BY AccountId];

    for(AggregateResult agg : lstAgg) {
        Account accUpdate = new Account();
        accUpdate.Id = (Id)agg.get('AccountId');
        accUpdate.Total_Contacts_Count__c = String.valueOf(agg.get('counts'));
        accUpdateList.add(accUpdate);
    }
    
    if(!accUpdateList.isEmpty()){
        update accUpdateList;
    }
}

/*




Trigger 1
Suppose you are managing a team of sales reps in a company that sells software 
solutions to businesses. Your team uses Salesforce to manage customer contacts and 
associated accounts. You want to ensure that any changes made to a contact’s Description 
field are automatically reflected in the associated account’s Description field.Code

Map<Id,String> accountPhoneMap = new Map<Id,String>(); 
if(!trigger.new.isEmpty()){
    if(trigger.isUpdate && trigger.isAfter){
        for(Contact con : trigger.new){

            if(con.AccountId != null || con.AccountId !=''){
                if(con.Description != trigger.oldMap.get(con.Id).Description){
                    accountPhoneMap.put(con.AccountId,con.Description);
                }
            }           
        }
        if(!accountPhoneMap.isEmpty()){
            List<Account> lstAcc = [SELECT id,Description FROM Account WHERE Id IN : accountPhoneMap.keySet()];
            if(!lstAcc.isEmpty()){
                    for(Account acc : lstAcc){
                        acc.Description = accountPhoneMap.get(acc.Id);
                    }
            }
            Update lstAcc;
        }
    }
}
*/



}