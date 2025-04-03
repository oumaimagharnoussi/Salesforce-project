public class CaseTreatementHandler {

    static public void calculateTreatementTime(List<Case> oldCases, List<Case> newCases){
        
        Integer nbrDays;
        Integer hrSpent;
        Integer minSpent;
        Integer secSpent;
        double totalTimeSpent;
        List<String> oldTimeSpent = new List<String>();
        
        List<Id> agentIds = new List<Id>();
        List<User> agentTitle = new List<User>();
        
        for(Case newCase: newCases){
            agentIds.add(newCase.Agent_en_charge__c);
        }   
        
        for(Id id_agent: agentIds){
            
        }
        
        for(Case newCase: newCases){
            for(Case oldCase: oldCases){
                if(newCase.Id == oldCase.Id && newCase.Agent_en_charge__c != oldCase.Agent_en_charge__c && newCase.Agent_en_charge__c =='0054K000005pt5oQAA' ){
                       
                    newCase.time_assigned__c = system.now();
                    
                }
                
                else if(newCase.Id == oldCase.Id && newCase.Agent_en_charge__c != oldCase.Agent_en_charge__c && newCase.Agent_en_charge__c !='0054K000005pt5oQAA' ){
					
                   	
                    totalTimeSpent = system.now().getTime() - newCase.time_assigned__c.getTime();
                                
                    nbrDays = system.now().day() - newCase.time_assigned__c.day();
                    
                    hrSpent = system.now().hour() - newCase.time_assigned__c.hour();
                    if(system.now().minute() - newCase.time_assigned__c.minute() <0)
						minSpent = (system.now().minute() - newCase.time_assigned__c.minute()*(-1))/2;
                    
                    else
                        minSpent = system.now().minute() - newCase.time_assigned__c.minute();
                    
                    if(system.now().second() - newCase.time_assigned__c.second() <0)
                    	secSpent = (system.now().second() - newCase.time_assigned__c.second()*(-1))/2;
                    else
                    	secSpent = system.now().second() - newCase.time_assigned__c.second();
                    
                    system.debug('hours : ' +hrSpent +'Minutes: ' + minSpent);
                    if(!string.isBlank(oldCase.Last_Time_Spent__c)){
                        oldTimeSpent = oldCase.Last_Time_Spent__c.split(',');
                    
                        system.debug('oldTime Spent:' + oldTimeSpent[0]);
                        system.debug('oldTime Spent:' + oldTimeSpent[1]);
                        system.debug('oldTime Spent:' + oldTimeSpent[2]);
                        system.debug('oldTime Spent:' + oldTimeSpent[3]);
                                        
                        nbrDays += Integer.ValueOf(oldTimeSpent[0]);
                        hrSpent += Integer.ValueOf(oldTimeSpent[1]);
                        minSpent += Integer.ValueOf(oldTimeSpent[2]);
                        secSpent += Integer.ValueOf(oldTimeSpent[3]);
                    }
                    
                    if(secSpent > 60){
                        
                    }
                    
                    newCase.Time_spent__c = nbrDays + ' Jrs ' + hrSpent +' hr ' + minSpent + ' min '+ secSpent +' sec';
                    newCase.Last_Time_Spent__c = nbrDays+ ',' +hrSpent+ ',' +minSpent+ ',' +secSpent;
                   	newCase.time_assigned__c = null;
                }
            }
        }
        
    }
    
    
}