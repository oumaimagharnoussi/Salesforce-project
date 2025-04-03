public with sharing class inwiCGC_UserManagerController {
    @AuraEnabled(cacheable=true)
    public static List<User> getManagedUsers() {
        String currentUserId = UserInfo.getUserId();
        User currentUser = [SELECT Profile.Name FROM User WHERE Id = :currentUserId LIMIT 1];
        
        if (currentUser == null) {
            return new List<User>();
        }
        
        if (currentUser.Profile.Name == 'CGC_RVR') {
            List<User> managedUsers = [SELECT Id, Name, ManagerId, Profile.Name 
                                       FROM User 
                                       WHERE ManagerId = :currentUserId];
            
            if (!managedUsers.isEmpty()) {
                List<Id> subordinateIds = new List<Id>();
                for (User u : managedUsers) {
                    subordinateIds.add(u.Id);
                }
                
                List<User> subManagedUsers = [SELECT Id, Name, ManagerId, Profile.Name 
                                              FROM User 
                                              WHERE ManagerId IN :subordinateIds];
                
                managedUsers.addAll(subManagedUsers);
            }
            
            return managedUsers;
        } 
        else {
            return [SELECT Id, Name, Profile.Name 
                    FROM User 
                    WHERE ManagerId = :currentUserId];
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<RetailVisitKpi> getAssessmentValues(String filter) {
        String currentUserId = UserInfo.getUserId();
        Date startDate;
        
        switch on filter {
            when 'cette semaine' {
                startDate = Date.today().addDays(-7);
            }
            when 'ce mois' {
                startDate = Date.today().addMonths(-1);
            }
            when 'ce trimestre' {
                startDate = Date.today().addMonths(-3); 
            }
            when 'cette année' {
                startDate = Date.today().addYears(-1);
            }
            when 'All' {
                startDate = null;
            }
        }

        Set<Id> managedUserIds = getManagedUserIds(currentUserId);
        
        List<Visit> completedVisits;
        if (startDate != null) {
            completedVisits = [SELECT Id FROM Visit WHERE VisitorId IN :managedUserIds AND Status = 'Completed' AND CreatedDate >= :startDate];
        } else {
            completedVisits = [SELECT Id FROM Visit WHERE VisitorId IN :managedUserIds AND Status = 'Completed'];
        }

        Set<Id> visitIds = new Set<Id>();
        for (Visit visit : completedVisits) {
            visitIds.add(visit.Id);
        }

        return [SELECT ActualIntegerValue, AssessmentIndDefinition.Name FROM RetailVisitKpi WHERE VisitId IN :visitIds];
    }

    private static Set<Id> getManagedUserIds(String currentUserId) {
        User currentUser = [SELECT Id, Profile.Name FROM User WHERE Id = :currentUserId LIMIT 1];
        Set<Id> managedUserIds = new Set<Id>();

        if (currentUser.Profile.Name == 'CGC_RVR') {
            List<User> managedUsers = [SELECT Id, Profile.Name FROM User WHERE ManagerId = :currentUserId];
                        
            for (User u : managedUsers) {
                managedUserIds.add(u.Id);
            }

            List<User> subManagedUsers = [SELECT Id, Profile.Name FROM User WHERE ManagerId IN :managedUserIds];
                        
            for (User u : subManagedUsers) {
                managedUserIds.add(u.Id);
            }

        } else if (currentUser.Profile.Name == 'CGC_FDV_Manager') {
            List<User> managedUsers = [SELECT Id, Profile.Name FROM User WHERE ManagerId = :currentUserId];
                        
            for (User u : managedUsers) {
                managedUserIds.add(u.Id);
        
                if (u.Profile.Name == 'CGC_RVR') {
                    List<User> subManagedUsers = [SELECT Id, Profile.Name FROM User WHERE ManagerId = :u.Id];
                                        
                    for (User sub : subManagedUsers) {
                        managedUserIds.add(sub.Id);
        
                        if (sub.Profile.Name == 'CGC_User') {
                            List<User> secondLevelSubManagedUsers = [SELECT Id, Profile.Name FROM User WHERE ManagerId = :sub.Id];
                                                        
                            for (User secondSub : secondLevelSubManagedUsers) {
                                managedUserIds.add(secondSub.Id);
                            }
                        }
                    }
                } 
                if (u.Profile.Name == 'CGC_FDV_Manager') {
                    List<User> subordinates = [SELECT Id, Profile.Name FROM User WHERE ManagerId = :u.Id];
                    for (User sub : subordinates) {
                        managedUserIds.add(sub.Id);
                            List<User> secondLevelSubManagedUsers = [SELECT Id, Profile.Name FROM User WHERE ManagerId = :sub.Id];
                                                        
                            for (User secondSub : secondLevelSubManagedUsers) {
                            managedUserIds.add(secondSub.Id);
                            List<User> thirdLevelSubManagedUsers = [SELECT Id, Profile.Name FROM User WHERE ManagerId = :secondSub.Id];
                                                                
                            for (User thirdSub : thirdLevelSubManagedUsers) {
                                managedUserIds.add(thirdSub.Id);
                            }
                        }                        
                    }
                }
            }
        }
        
         else {
            managedUserIds.add(currentUserId);
        }

        return managedUserIds;
    }






}