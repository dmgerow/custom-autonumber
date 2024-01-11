public with sharing class AutoNumberService {
    public static void assignAutoNumbers(List<Lead> newLeads) {
        Set<String> companyNames = new Set<String>();
        for (Lead newLead : newLeads) {
            companyNames.add(newLead.Company);
        }
        Map<String, Decimal> maxNumberByCompany = new Map<String, Decimal>();
        for (AggregateResult ar : [
            SELECT Company, MAX(IncrementalNumber__c) maxNumber
            FROM Lead
            WHERE Company IN :companyNames AND IncrementalNumber__c != NULL
            GROUP BY Company
        ]) {
            maxNumberByCompany.put((String) ar.get('Company'), (Decimal) ar.get('maxNumber'));
        }
        for (Lead newLead : newLeads) {
            Decimal currentMax = -1;
            if (maxNumberByCompany.containsKey(newLead.Company)) {
                currentMax = maxNumberByCompany.get(newLead.Company);
            }
            newLead.IncrementalNumber__c = currentMax + 1;
            newLead.AutoNumber__c =
                newLead.Company +
                '-' +
                String.valueOf(Integer.valueOf(newLead.IncrementalNumber__c)).leftPad(6, '0');
            maxNumberByCompany.put(newLead.Company, newLead.IncrementalNumber__c);
        }
    }
}
