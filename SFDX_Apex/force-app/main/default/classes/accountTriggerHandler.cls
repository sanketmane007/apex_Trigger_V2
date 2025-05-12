public with sharing class accountTriggerHandler {
  
//Trigger 4
public static void createconFromAccount(List<Account> accList){
    List<Contact> conList = new List<Contact>();
    if(!accList.isEmpty()){
        for (Account acc : accList) {
            Contact con = new Contact();
            con.LastName = acc.Name;
            con.AccountId = acc.Id;
            conList.add(con);
        }
        if(!conList.isEmpty()){
            insert conList;
        }
    }
}

public static void changeAccountOwner(List<Account> accList, Map<Id,Account> oldAccMap,Map<Id,Account> newAccMap){
    Set<Id> accIds = new Set<Id>();
    List<Contact> conUpdateList = new List<Contact>();
    if(!accList.isEmpty()){
        for (Account acc : accList) {
            if(acc.OwnerId != oldAccMap.get(acc.Id).OwnerId){
                accIds.add(acc.Id);
            }
        }

        List<Contact> conList = [SELECT Id, AccountId,OwnerId FROM Contact WHERE AccountId IN: accIds];

        for(Contact con : conList){
            Contact conUpdate = new Contact();
            conUpdate.Id = con.Id;
            conUpdate.OwnerId =  newAccMap.get(con.AccountId).OwnerId;
            conUpdateList.add(conUpdate);
        }

        if(!conUpdateList.isEmpty()){
            update conUpdateList;
        }
        

    }
}

}