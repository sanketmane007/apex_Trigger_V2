trigger accountTrigger on Account (before Insert,before update,
                                    after Insert,after Update,before delete) {









/*
Trigger : 6

Write a trigger, to achieve the following:

Given: There is any associated Contact to an Account,

When: User tries to delete the Account,

Then: User should get the error that Account with associated Contact can not be deleted.

Solution 1:

if(trigger.isBefore && trigger.isDelete){
   
    Map<Id, Account> mapOfAccounts = new Map<Id, Account> ([Select Id, (Select Id From Contacts) 
                                                                From Account 
                                                                Where Id IN :Trigger.oldMap.keySet()]);

        // Condition to check if any Contact is associated for each account
        // If yes, then throw the error
        for(Account acc : Trigger.old) {
            if(!mapOfAccounts.get(acc.Id).Contacts.isEmpty()) {
                acc.addError('Account with associated Contact(s) can not be deleted.');
            }
        }
    }
*/

    
/*
Trigger 6

Write a trigger, to achieve the following:

Create a new Opportunity whenever an account is created/updated for Industry – Agriculture.
Opportunity should be set as below:
Stage = ‘Prospecting’, Amount = $0, CloseDate = ’90 days from today’.

Solution 1:
Map<Id,Account> accMap = new Map<Id,Account>();
List<Opportunity> oppList = new List<Opportunity>();
if(!trigger.new.isEmpty()){
    if(trigger.isUpdate && trigger.isAfter){
        for(Account acc : trigger.new){
            if(acc.Industry != trigger.oldMap.get(acc.Id).Industry && acc.Industry == 'Agriculture'){
                // accMap.put(acc.Id, acc);
                
                Opportunity opp = new Opportunity();
                opp.Name = acc.Name+' opp';
                opp.AccountId = acc.Id;
                opp.StageName = 'Prospecting';
                opp.Amount = 0;
                opp.CloseDate = System.today() + 90;
                oppList.add(opp);
            }
        }
        if(!oppList.isEmpty()){
            Insert oppList;
        }
    }

    if(trigger.isAfter && trigger.isInsert){
        for (Account accIn : trigger.new) {
            if(accIn.Industry != null && accIn.Industry == 'Agriculture'){
                Opportunity opp = new Opportunity();
                opp.Name = accIn.Name+' opp';
                opp.AccountId = accIn.Id;
                opp.StageName = 'Prospecting';
                opp.Amount = 0;
                opp.CloseDate = System.today() + 90;
                oppList.add(opp);
            }
        }
        if(!oppList.isEmpty()){
            Insert oppList;
        }
    }


}

*/


/*
Trigger 5  https://apexstepbystep.com/trigger-scenario-2/
    Write a trigger, if the owner of an account is changed then the owner for 
    the related contacts should also be updated.
Solution 1

Map<Id,Account> accMap = new Map<Id,Account>();
List<Contact> updateConList = new List<Contact>();
if(trigger.isUpdate && trigger.isAfter){
    if(!trigger.new.isEmpty()){
        for(Account acc : trigger.new){
           if(acc.OwnerId != trigger.oldMap.get(acc.Id).OwnerId){
                accMap.put(acc.Id, acc);
           }
        }
    }
   
    if(!accMap.isEmpty()){
        List<Contact> conList = [SELECT Id,OwnerId,AccountId FROM COntact WHERE AccountId IN: accMap.keySet()];

        if(!conList.isEmpty()){
            for (Contact con : conList) {
                Contact conUpdate = new Contact();
                conUpdate.Id = con.Id;
                conUpdate.OwnerId = accMap.get(con.AccountId).OwnerId; //way 1
                //con.OwnerId = Trigger.newMap.get(con.AccountId).OwnerId; Way 2
                updateConList.add(conUpdate);
            }
        }

        if(!updateConList.isEmpty()){
            update updateConList;
        }

    }
}



//Solution 2  

if(trigger.isInsert && trigger.isUpdate){
    if(!trigger.new.isEmpty()){
        accountTriggerHandler.changeAccountOwner(trigger.new,trigger.oldMap,trigger.newMap);
    }
}
*/

/*
Trigger 4
Write a trigger, when a new Account is created then create a contact related to that account.

Solution 1 =>
Map<Id,Account> accMap = new Map<Id,Account>();
List<Contact> conInsertList = new List<Contact>();
if(trigger.isInsert && trigger.isAfter){

    if(!trigger.new.isEmpty()){
        for(Account acc :  trigger.new){
            accMap.put(acc.Id, acc);
        }


    if(!accMap.isEmpty()){
        for(Id accids : accMap.keySet()){
            Contact con = new Contact();
            con.AccountId = accids;
            con.LastName = accMap.get(accids).Name;
            conInsertList.add(con);         
        }

        if(!conInsertList.isEmpty()){
            insert conInsertList;
        }
    }
}

Solution 2=>
if(trigger.isInsert && trigger.isAfter){
    if(!trigger.new.isEmpty()){
        accountTriggerHandler.createconFromAccount(trigger.new);
    }    
}
*/



/* Trigger 3
Suppose you are a sales manager for a company that sells products to other 
businesses. Your team uses Salesforce to manage customer accounts and contacts, 
and you want to ensure that all contacts associated with a particular account have 
the same phone number as the account.


Map<Id, Account> accMap = new Map <Id, Account>();
if(!trigger.new.isEmpty()){
    if(trigger.isAfter && trigger.isUpdate){
        for(Account acc : trigger.new){
            if(acc.Phone != trigger.oldMap.get(acc.Id).Phone){
                accMap.put(acc.Id, acc);
            }            
        }
    }

    List<Contact> conList = [SELECT Id, Name, Phone, AccountId
                            FROM Contact 
                            WHERE AccountId 
                            IN: accMap.keySet()];
     
    if(!conList.isEmpty()){
        for(Contact con : conList){
            con.Phone = accMap.get(con.AccountId).Phone;  
        }
    }

    update conList;
}


*/






/* Trigger 2
Your Company wants to ensure that the shipping address of 
an Account record is always in sync with the billing address.


if(!trigger.new.isEmpty()){    
    if((trigger.isBefore && trigger.isInsert)){
            for (Account accInsert : trigger.new) {
                    if(!String.isEmpty(accInsert.BillingStreet)){
                        accInsert.ShippingStreet = accInsert.BillingStreet;
                    }
            }
    }
    
    if(trigger.isBefore && trigger.isUpdate){
        for (Account accUpdate : trigger.new) {
            Account oldAcc = Trigger.oldMap.get(accUpdate.Id);

            System.debug('accUpdate.BillingStreet ==>>'+accUpdate.BillingStreet+'    '
            + oldAcc.ShippingStreet+' <<===oldAcc.ShippingStreet');

            if(accUpdate.BillingStreet != oldAcc.ShippingStreet){
                accUpdate.ShippingStreet = accUpdate.BillingStreet;                
            }
        }     
    }       
}
*/


/*Trigger 1
Your company wants to ensure that all new Account records have a 
valid phone number before they are inserted into the system. 
This could be important for organizations that rely heavily on phone 
communication with their customers or need to keep accurate contact 
information for compliance purposes.

if(trigger.isBefore && trigger.isInsert){
    if(!trigger.new.isEmpty()){
        for(Account ac : trigger.new){
            if(String.isBlank(ac.Phone)){
                ac.addError('Please fill ther proper Phone Number');
            }
        }
    }
}

*/
}